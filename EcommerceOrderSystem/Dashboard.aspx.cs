using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace EcommerceOrderSystem
{
    public partial class Dashboard : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 仅允许 Admin/Employee 访问；Admin源自员工系统角色=系统管理员
                if (Session["UserRole"] == null || (Session["UserRole"].ToString() != "Admin" && Session["UserRole"].ToString() != "Employee"))
                {
                    Response.Redirect("Login.aspx");
                    return;
                }
                phAdminShortcuts.Visible = (Session["UserRole"].ToString() == "Admin");
                LoadStats();
            }
        }

        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. 待发货数量
                SqlCommand cmd1 = new SqlCommand("SELECT COUNT(*) FROM [OrderMaster] WHERE [订单流转状态] = '待发货'", conn);
                lblToShip.Text = cmd1.ExecuteScalar().ToString();

                // 2. 库存预警数量
                SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM [Product] WHERE [商品当前库存量] <= [库存预警阈值]", conn);
                lblLowStock.Text = cmd2.ExecuteScalar().ToString();

                // 3. 总销售额 (已完成/已发货)
                SqlCommand cmd3 = new SqlCommand("SELECT ISNULL(SUM([订单总金额]), 0) FROM [OrderMaster] WHERE [订单流转状态] IN ('已发货', '已完成')", conn);
                lblTotalSales.Text = Convert.ToDecimal(cmd3.ExecuteScalar()).ToString("C0"); // C0不显示小数位，简洁

                // 4. 用户总数
                SqlCommand cmd4 = new SqlCommand("SELECT COUNT(*) FROM [UserInfo]", conn);
                lblTotalUsers.Text = cmd4.ExecuteScalar().ToString();

                // 5. 最近5条待发货订单
                string sqlRecent = @"
                    SELECT TOP 5 O.[业务订单编码], O.[订单总金额], O.[订单创建时间], U.[顾客姓名]
                    FROM [OrderMaster] O
                    JOIN [UserInfo] U ON O.[下单顾客编号] = U.[顾客会员号]
                    WHERE O.[订单流转状态] = '待发货'
                    ORDER BY O.[订单创建时间] ASC"; // 按时间正序，优先处理旧订单

                SqlDataAdapter da = new SqlDataAdapter(sqlRecent, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptRecentTasks.DataSource = dt;
                rptRecentTasks.DataBind();
                pnlNoTasks.Visible = dt.Rows.Count == 0;

                // 6. 低库存列表（<=阈值，最多10条）
                string sqlLow = @"SELECT TOP 10 [商品标准名称],[商品当前库存量]
                                   FROM [Product]
                                   WHERE [商品当前库存量] <= [库存预警阈值]
                                   ORDER BY [商品当前库存量] ASC";
                SqlDataAdapter daLow = new SqlDataAdapter(sqlLow, conn);
                DataTable dtLow = new DataTable();
                daLow.Fill(dtLow);
                rptLowStock.DataSource = dtLow;
                rptLowStock.DataBind();
                pnlNoLowStock.Visible = dtLow.Rows.Count == 0;
            }
        }
    }
}