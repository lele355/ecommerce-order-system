using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class OrderManage : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        // 保存当前处理的订单ID
        private long CurrentOrderId
        {
            get { return (long)(ViewState["CurrentOrderId"] ?? 0L); }
            set { ViewState["CurrentOrderId"] = value; }
        }

        private string CurrentFilter
        {
            get { return (string)(ViewState["CurrentFilter"] ?? "All"); }
            set { ViewState["CurrentFilter"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserRole"] == null || Session["UserRole"].ToString() == "Customer")
                {
                    Response.Redirect("Default.aspx");
                    return;
                }
                // 默认筛选：管理员与员工均为“全部”（可切换）
                CurrentFilter = "All";
                BindOrders();
            }
        }

        private void BindOrders()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                
                // 1. 查询订单数据
                string sql = @"
                    SELECT O.*, U.顾客姓名 
                    FROM [OrderMaster] O 
                    JOIN [UserInfo] U ON O.下单顾客编号 = U.顾客会员号 
                    WHERE 1=1 ";

                // 根据筛选条件添加 WHERE 子句
                if (CurrentFilter != "All")
                {
                    sql += " AND O.订单流转状态 = @status";
                }

                sql += " ORDER BY O.订单创建时间 DESC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (CurrentFilter != "All")
                {
                    cmd.Parameters.AddWithValue("@status", CurrentFilter);
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvOrders.DataSource = dt;
                gvOrders.DataBind();
                
                // 2. 更新统计数据
                UpdateStatistics(conn);
            }
        }
        
        // 更新统计数据
        private void UpdateStatistics(SqlConnection conn)
        {
            // 总订单数
            string sqlTotal = "SELECT COUNT(*) FROM [OrderMaster]";
            SqlCommand cmdTotal = new SqlCommand(sqlTotal, conn);
            lblTotalCount.Text = cmdTotal.ExecuteScalar().ToString();
            
            // 待发货订单数
            string sqlPending = "SELECT COUNT(*) FROM [OrderMaster] WHERE [订单流转状态] = '待发货'";
            SqlCommand cmdPending = new SqlCommand(sqlPending, conn);
            lblPendingCount.Text = cmdPending.ExecuteScalar().ToString();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            CurrentFilter = btn.CommandArgument;

            // 更新按钮样式
            UpdateFilterButtonStyles();

            BindOrders();
            upList.Update();
        }
        
        // 更新筛选按钮样式
        private void UpdateFilterButtonStyles()
        {
            btnFilterAll.CssClass = CurrentFilter == "All" ? "filter-pill active" : "filter-pill";
            btnFilterPending.CssClass = CurrentFilter == "待付款" ? "filter-pill active" : "filter-pill";
            btnFilterWait.CssClass = CurrentFilter == "待发货" ? "filter-pill active" : "filter-pill";
            btnFilterShipped.CssClass = CurrentFilter == "已发货" ? "filter-pill active" : "filter-pill";
            btnFilterDone.CssClass = CurrentFilter == "已完成" ? "filter-pill active" : "filter-pill";
            btnFilterCancelled.CssClass = CurrentFilter == "已取消" ? "filter-pill active" : "filter-pill";
        }

        protected void gvOrders_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ProcessOrder")
            {
                long oid = Convert.ToInt64(e.CommandArgument);
                CurrentOrderId = oid;
                LoadModal(oid);
                
                // 使用 Site.Master 中的通用修复函数
                ScriptManager.RegisterStartupScript(this, GetType(), "showModal", 
                    "fixModalPointerEvents('orderProcessModal');", true);
            }
        }

        private void LoadModal(long oid)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                // 1. 加载主表信息
                string sqlM = "SELECT * FROM [OrderMaster] WHERE [订单流水号]=@oid";
                SqlCommand cmdM = new SqlCommand(sqlM, conn);
                cmdM.Parameters.AddWithValue("@oid", oid);
                SqlDataReader r = cmdM.ExecuteReader();
                if (r.Read())
                {
                    lblModalCode.Text = r["业务订单编码"].ToString();
                    lblModalAddress.Text = r["订单收货地址快照"].ToString();
                    lblModalPhone.Text = r["订单联系电话快照"].ToString();
                    // 这里可以再查用户表获取姓名，或者直接存快照
                    lblModalStatus.Text = r["订单流转状态"].ToString();
                    lblModalTotal.Text = Convert.ToDecimal(r["订单总金额"]).ToString("C");

                    // 控制发货按钮显示
                    btnShip.Visible = (lblModalStatus.Text == "待发货");
                }
                r.Close();

                // 2. 加载明细（包含分类信息）
                string sqlD = @"SELECT OD.*, P.商品标准名称, C.类别名称 
                    FROM [OrderDetail] OD 
                    JOIN [Product] P ON OD.购买商品编号=P.商品编号 
                    LEFT JOIN [Category] C ON P.所属类别编号 = C.类别编号
                    WHERE OD.归属订单流水号=@oid";
                SqlDataAdapter da = new SqlDataAdapter(sqlD, conn);
                da.SelectCommand.Parameters.AddWithValue("@oid", oid);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvItems.DataSource = dt;
                gvItems.DataBind();
            }
            upModal.Update();
        }

        // 单个订单发货
        protected void btnShip_Click(object sender, EventArgs e)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE [OrderMaster] SET [订单流转状态] = '已发货' WHERE [订单流转状态] = '待发货' AND [订单流水号] = @oid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@oid", CurrentOrderId);

                conn.Open();
                int rows = cmd.ExecuteNonQuery();
                
                if (rows > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "ship", "bootstrap.Modal.getInstance(document.getElementById('orderProcessModal')).hide(); toastr.success('订单已发货！');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "shipError", "toastr.error('订单状态已变更，无法发货');", true);
                }
            }

            // 更新界面
            BindOrders();
            upList.Update();
        }
        
        // 一键批量发货
        protected void btnBatchShip_Click(object sender, EventArgs e)
        {
            int count = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "UPDATE [OrderMaster] SET [订单流转状态] = '已发货' WHERE [订单流转状态] = '待发货'";
                SqlCommand cmd = new SqlCommand(sql, conn);

                conn.Open();
                count = cmd.ExecuteNonQuery();
            }

            // 更新界面
            BindOrders();
            upList.Update();

            // 显示结果
            if (count > 0)
            {
                string script = $"toastr.success('批量发货成功！共处理 {count} 个订单', '成功', {{ timeOut: 3000, progressBar: true }});";
                ScriptManager.RegisterStartupScript(this, GetType(), "batchShip", script, true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "batchShipEmpty", "toastr.info('暂无待发货订单');", true);
            }
        }

        protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvOrders.PageIndex = e.NewPageIndex;
            BindOrders();
        }

        public string GetStatusClass(string status)
        {
            switch (status)
            {
                case "待付款": return "bg-secondary bg-opacity-10 text-secondary border border-secondary";
                case "待发货": return "bg-warning bg-opacity-10 text-warning border border-warning";
                case "已发货": return "bg-info bg-opacity-10 text-info border border-info";
                case "已完成": return "bg-success bg-opacity-10 text-success border border-success";
                case "已取消": return "bg-danger bg-opacity-10 text-danger border border-danger";
                default: return "bg-light text-muted border";
            }
        }
        
        // 获取状态图标
        public string GetStatusIcon(string status)
        {
            switch (status)
            {
                case "待付款": return "<i class='fas fa-credit-card me-1'></i>";
                case "待发货": return "<i class='fas fa-box me-1'></i>";
                case "已发货": return "<i class='fas fa-shipping-fast me-1'></i>";
                case "已完成": return "<i class='fas fa-check-circle me-1'></i>";
                case "已取消": return "<i class='fas fa-times-circle me-1'></i>";
                default: return "<i class='fas fa-question-circle me-1'></i>";
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
    }
}