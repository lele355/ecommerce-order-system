using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.UI;

namespace EcommerceOrderSystem
{
    public partial class Checkout : Page
    {
        // 从 Web.config 读取连接字符串
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. 安全检查：未登录拦截
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo(); // 加载收货人信息
                LoadCartInfo(); // 加载商品清单和金额
            }
        }

        // 加载当前登录用户的收货信息
        private void LoadUserInfo()
        {
            long userId = Convert.ToInt64(Session["UserID"]);
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT [顾客姓名], [顾客手机号], [顾客默认收货地址] FROM [UserInfo] WHERE [顾客会员号] = @uid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", userId);
                conn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    txtName.Text = r["顾客姓名"].ToString();
                    txtPhone.Text = r["顾客手机号"].ToString();
                    // 地址允许修改，所以放在 TextBox 中
                    txtAddress.Text = r["顾客默认收货地址"].ToString();
                }
            }
        }

        // 加载购物车数据到前端卡片
        private void LoadCartInfo()
        {
            List<CartItem> cart = Session["Cart"] as List<CartItem>;

            // 购物车为空则踢回
            if (cart == null || cart.Count == 0)
            {
                Response.Redirect("Cart.aspx");
                return;
            }

            // 1. 绑定左侧商品清单 GridView
            gvCheckout.DataSource = cart;
            gvCheckout.DataBind();

            // 2. 计算并更新右侧吸附栏的金额
            decimal totalAmount = cart.Sum(x => x.SubTotal);
            int totalCount = cart.Sum(x => x.Quantity);

            // 更新 UI 控件
            lblCount.Text = totalCount.ToString();
            lblTotal.Text = totalAmount.ToString("C");      // 费用明细里的小字
            lblFinalTotal.Text = totalAmount.ToString("C"); // 右侧醒目的大字实付款
        }

        // 提交订单按钮点击事件（核心事务处理）
        protected void btnSubmitOrder_Click(object sender, EventArgs e)
        {
            var cart = Session["Cart"] as List<CartItem>;
            if (cart == null || cart.Count == 0) return;

            long userId = Convert.ToInt64(Session["UserID"]);
            // 生成唯一订单号：ORD + 时间戳 + 3位随机数
            string orderCode = "ORD-" + DateTime.Now.ToString("yyyyMMddHHmmss") + "-" + new Random().Next(100, 999);
            decimal totalAmount = cart.Sum(x => x.SubTotal);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // 开启数据库事务：保证 订单创建、明细写入、库存扣减 要么全成功，要么全失败
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    // ==========================================
                    // 第一步：插入订单主表 (OrderMaster)
                    // ==========================================
                    // 注意：状态直接设为 '待发货'，模拟用户点击“立即支付”后支付成功的场景
                    string sqlMaster = @"INSERT INTO [OrderMaster] 
                        ([下单顾客编号], [业务订单编码], [订单总金额], [订单收货地址快照], [订单联系电话快照], [订单流转状态]) 
                        VALUES (@uid, @code, @total, @addr, @phone, '待发货'); 
                        SELECT SCOPE_IDENTITY();"; // 获取刚插入的自增ID

                    SqlCommand cmdMaster = new SqlCommand(sqlMaster, conn, trans);
                    cmdMaster.Parameters.AddWithValue("@uid", userId);
                    cmdMaster.Parameters.AddWithValue("@code", orderCode);
                    cmdMaster.Parameters.AddWithValue("@total", totalAmount);
                    cmdMaster.Parameters.AddWithValue("@addr", txtAddress.Text.Trim()); // 使用用户当前编辑的地址
                    cmdMaster.Parameters.AddWithValue("@phone", txtPhone.Text.Trim());

                    // 获取新生成的 OrderID
                    long newOrderId = Convert.ToInt64(cmdMaster.ExecuteScalar());

                    // ==========================================
                    // 第二步：循环处理购物车每一项
                    // ==========================================
                    foreach (var item in cart)
                    {
                        // 2.1 插入订单明细 (OrderDetail)
                        string sqlDetail = @"INSERT INTO [OrderDetail] 
                            ([归属订单流水号], [购买商品编号], [购买数量], [成交单价]) 
                            VALUES (@oid, @pid, @qty, @price)";

                        SqlCommand cmdDetail = new SqlCommand(sqlDetail, conn, trans);
                        cmdDetail.Parameters.AddWithValue("@oid", newOrderId);
                        cmdDetail.Parameters.AddWithValue("@pid", item.ProductId);
                        cmdDetail.Parameters.AddWithValue("@qty", item.Quantity);
                        cmdDetail.Parameters.AddWithValue("@price", item.Price);
                        cmdDetail.ExecuteNonQuery();

                        // 2.2 扣减库存 (Product)
                        // 关键逻辑：WHERE 子句中增加库存判断，利用数据库原子性防止超卖
                        string sqlStock = @"UPDATE [Product] 
                                            SET [商品当前库存量] = [商品当前库存量] - @qty 
                                            WHERE [商品编号] = @pid AND [商品当前库存量] >= @qty";

                        SqlCommand cmdStock = new SqlCommand(sqlStock, conn, trans);
                        cmdStock.Parameters.AddWithValue("@qty", item.Quantity);
                        cmdStock.Parameters.AddWithValue("@pid", item.ProductId);

                        int rowsAffected = cmdStock.ExecuteNonQuery();

                        // 如果受影响行数为0，说明库存不足（WHERE条件不满足）
                        if (rowsAffected == 0)
                        {
                            throw new Exception($"商品【{item.ProductName}】库存不足，无法完成交易！");
                        }
                    }

                    // ==========================================
                    // 第三步：提交事务并收尾
                    // ==========================================
                    trans.Commit(); // 只有运行到这里没有报错，数据才会真正写入数据库

                    // 清空购物车 Session
                    Session["Cart"] = null;

                    // 弹出成功提示并跳转到“我的订单”
                    // 使用 string interpolation ($"") 方便拼接订单号
                    string script = $"alert('支付成功！我们将尽快为您发货。\\n订单号：{orderCode}'); window.location='MyOrders.aspx';";
                    ScriptManager.RegisterStartupScript(this, GetType(), "success", script, true);
                }
                catch (Exception ex)
                {
                    // 发生任何错误（如库存不足、数据库连接断开），回滚事务，撤销所有操作
                    trans.Rollback();

                    // 显示错误信息到页面底部的红色 Panel
                    pnlError.Visible = true;
                    lblMsg.Text = "交易失败：" + ex.Message;
                }
            }
        }

        // 辅助方法：根据索引返回结账商品图标
        protected string GetCheckoutItemIcon(int index)
        {
            var icons = new[]
            {
                "fas fa-laptop",
                "fas fa-mobile-alt",
                "fas fa-headphones",
                "fas fa-gamepad",
                "fas fa-camera",
                "fas fa-tv",
                "fas fa-keyboard",
                "fas fa-mouse",
                "fas fa-tablet-alt",
                "fas fa-microchip"
            };
            return icons[index % icons.Length];
        }

        // 辅助方法：根据索引返回颜色类
        protected string GetCheckoutItemColorClass(int index)
        {
            var colors = new[]
            {
                "icon-box-electronics",
                "icon-box-home",
                "icon-box-fashion",
                "icon-box-books",
                "icon-box-food",
                "icon-box-default"
            };
            return colors[index % colors.Length];
        }
    }
}