using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class MyOrders : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindOrders();
            }
        }

        protected void btnConfirmReceive_Click(object sender, EventArgs e)
        {
            // 根据隐藏域或当前弹窗的订单号进行更新
            long orderId;
            if (!long.TryParse(hfCurrentOrderId.Value, out orderId)) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string sql = @"UPDATE [OrderMaster]
                                SET [订单流转状态] = N'已完成'
                                WHERE [订单流水号] = @oid AND [订单流转状态] = N'已发货'";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@oid", orderId);
                    cmd.ExecuteNonQuery();
                }
            }

            // 刷新列表与详情
            BindOrders();
            LoadOrderDetail(orderId);
            upOrders.Update();

            // 保持弹窗显示
            string script = @"
                setTimeout(function(){
                    var modalEl = document.getElementById('orderDetailModal');
                    if (modalEl) {
                        var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                        if (modalEl.parentElement !== formEl) { formEl.appendChild(modalEl); }
                        var modal = bootstrap.Modal.getOrCreateInstance(modalEl, {backdrop:true, keyboard:true, focus:true});
                        modal.show();
                    }
                }, 50);
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "showModalAfterReceive", script, true);
        }
        private void BindOrders()
        {
            if (Session["UserID"] == null) return;
            long uid = Convert.ToInt64(Session["UserID"]);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [OrderMaster] WHERE [下单顾客编号] = @uid ORDER BY [订单创建时间] DESC";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", uid);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();
            }
        }

        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "待付款": return "bg-secondary";
                case "待发货": return "bg-warning text-dark";
                case "已发货": return "bg-info text-dark";
                case "已完成": return "bg-success";
                default: return "bg-light text-dark";
            }
        }

        // 根据分类名称返回对应图标
        public string GetCategoryIcon(string categoryName)
        {
            if (string.IsNullOrEmpty(categoryName)) return "fas fa-box";

            string cat = categoryName.Trim();
            if (cat.Contains("电子") || cat.Contains("数码") || cat.Contains("手机") || cat.Contains("电脑"))
                return "fas fa-laptop";
            else if (cat.Contains("家居") || cat.Contains("家具") || cat.Contains("装饰"))
                return "fas fa-couch";
            else if (cat.Contains("服装") || cat.Contains("时尚") || cat.Contains("衣"))
                return "fas fa-tshirt";
            else if (cat.Contains("图书") || cat.Contains("书籍") || cat.Contains("阅读"))
                return "fas fa-book";
            else if (cat.Contains("食品") || cat.Contains("零食") || cat.Contains("饮料"))
                return "fas fa-utensils";
            else if (cat.Contains("运动") || cat.Contains("健身") || cat.Contains("户外"))
                return "fas fa-dumbbell";
            else if (cat.Contains("美妆") || cat.Contains("化妆") || cat.Contains("护肤"))
                return "fas fa-spray-can";
            else if (cat.Contains("玩具") || cat.Contains("儿童") || cat.Contains("游戏"))
                return "fas fa-gamepad";
            else
                return "fas fa-cube";
        }

        // 根据分类名称返回渐变色类
        public string GetCategoryColorClass(string categoryName)
        {
            if (string.IsNullOrEmpty(categoryName)) return "icon-box-default";

            string cat = categoryName.Trim();
            if (cat.Contains("电子") || cat.Contains("数码") || cat.Contains("手机") || cat.Contains("电脑"))
                return "icon-box-electronics";
            else if (cat.Contains("家居") || cat.Contains("家具") || cat.Contains("装饰"))
                return "icon-box-home";
            else if (cat.Contains("服装") || cat.Contains("时尚") || cat.Contains("衣"))
                return "icon-box-fashion";
            else if (cat.Contains("图书") || cat.Contains("书籍") || cat.Contains("阅读"))
                return "icon-box-books";
            else if (cat.Contains("食品") || cat.Contains("零食") || cat.Contains("饮料"))
                return "icon-box-food";
            else
                return "icon-box-default";
        }

        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            BindOrders();
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewDetail")
            {
                long orderId = Convert.ToInt64(e.CommandArgument);
                LoadOrderDetail(orderId);
                
                // 修复模态框显示问题 - 将模态框移到body底部并正确显示
                string script = @"
                    setTimeout(function() {
                        var modalEl = document.getElementById('orderDetailModal');
                        if (modalEl) {
                            // 将模态框移动到服务器表单内，避免脱离<form>导致事件失效
                            var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                            if (modalEl.parentElement !== formEl) {
                                formEl.appendChild(modalEl);
                            }
                            
                            // 移除所有可能的pointer-events限制
                            document.body.style.pointerEvents = 'auto';
                            modalEl.style.pointerEvents = 'auto';
                            
                            // 初始化并显示模态框
                            var modal = new bootstrap.Modal(modalEl, {
                                backdrop: true,
                                keyboard: true,
                                focus: true
                            });
                            modal.show();
                            
                            // 修复所有元素的点击事件
                            setTimeout(function() {
                                var allElements = modalEl.querySelectorAll('*');
                                allElements.forEach(function(el) {
                                    el.style.pointerEvents = 'auto';
                                });
                                
                                // 修复backdrop
                                var backdrop = document.querySelector('.modal-backdrop');
                                if (backdrop) {
                                    backdrop.style.zIndex = '1050';
                                    backdrop.style.pointerEvents = 'auto';
                                }
                                
                                // 确保模态框在最上层
                                modalEl.style.zIndex = '1055';
                                modalEl.style.display = 'block';
                                
                                // 确保dialog和content可点击
                                var dialog = modalEl.querySelector('.modal-dialog');
                                if (dialog) {
                                    dialog.style.pointerEvents = 'auto';
                                    dialog.style.zIndex = '1056';
                                }
                                
                                var content = modalEl.querySelector('.modal-content');
                                if (content) {
                                    content.style.pointerEvents = 'auto';
                                    content.style.zIndex = '1057';
                                }
                            }, 100);
                        }
                    }, 150);
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "showModal", script, true);
            }
        }

        private void LoadOrderDetail(long orderId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                
                // 加载订单主信息
                string sqlMaster = @"SELECT * FROM [OrderMaster] WHERE [订单流水号] = @oid";
                SqlCommand cmdMaster = new SqlCommand(sqlMaster, conn);
                cmdMaster.Parameters.AddWithValue("@oid", orderId);
                SqlDataReader reader = cmdMaster.ExecuteReader();
                
                if (reader.Read())
                {
                    lblModalOrderCode.Text = reader["业务订单编码"].ToString();
                    lblModalTime.Text = Convert.ToDateTime(reader["订单创建时间"]).ToString("yyyy-MM-dd HH:mm:ss");
                    lblModalAddress.Text = reader["订单收货地址快照"].ToString();
                    lblModalPhone.Text = reader["订单联系电话快照"].ToString();
                    lblModalStatus.Text = reader["订单流转状态"].ToString();
                    lblModalTotal.Text = Convert.ToDecimal(reader["订单总金额"]).ToString("C");
                    
                    // 设置状态徽章样式
                    lblModalStatus.CssClass = "badge " + GetStatusClass(reader["订单流转状态"].ToString());

                    // 保存订单号到隐藏域，并根据状态显示付款/收货按钮
                    hfCurrentOrderId.Value = orderId.ToString();
                    string status = reader["订单流转状态"].ToString().Trim();
                    btnPay.Visible = string.Equals(status, "待付款", StringComparison.Ordinal);
                    btnConfirmReceive.Visible = string.Equals(status, "已发货", StringComparison.Ordinal);
                }
                reader.Close();
                
                // 加载订单明细（包含分类信息）
                string sqlDetail = @"
                    SELECT OD.*, P.商品标准名称, C.类别名称
                    FROM [OrderDetail] OD 
                    JOIN [Product] P ON OD.购买商品编号 = P.商品编号 
                    LEFT JOIN [Category] C ON P.所属类别编号 = C.类别编号
                    WHERE OD.归属订单流水号 = @oid";
                SqlCommand cmdDetail = new SqlCommand(sqlDetail, conn);
                cmdDetail.Parameters.AddWithValue("@oid", orderId);
                SqlDataAdapter da = new SqlDataAdapter(cmdDetail);
                DataTable dt = new DataTable();
                da.Fill(dt);
                
                gvDetail.DataSource = dt;
                gvDetail.DataBind();
            }
            
            upModal.Update();
        }

        protected void btnPay_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(hfCurrentOrderId.Value)) return;

            long orderId;
            if (!long.TryParse(hfCurrentOrderId.Value, out orderId)) return;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 仅当状态为“待付款”时允许更新为“待发货”
                string sql = @"UPDATE [OrderMaster]
                                SET [订单流转状态] = N'待发货'
                                WHERE [订单流水号] = @oid AND [订单流转状态] = N'待付款'";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@oid", orderId);
                    cmd.ExecuteNonQuery();
                }
            }

            // 刷新列表与详情
            BindOrders();
            LoadOrderDetail(orderId);
            upOrders.Update();

            // 再次显示模态框
            string script = @"
                setTimeout(function() {
                    var modalEl = document.getElementById('orderDetailModal');
                    if (modalEl) {
                        var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                        if (modalEl.parentElement !== formEl) {
                            formEl.appendChild(modalEl);
                        }
                        var modal = bootstrap.Modal.getOrCreateInstance(modalEl, {backdrop:true, keyboard:true, focus:true});
                        modal.show();
                    }
                }, 50);
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "showModalAfterPay", script, true);
        }
    }
}