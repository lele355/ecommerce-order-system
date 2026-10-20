using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class IncomeAnalysis : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;
        public string RevenueChartData { get; set; }
        public string CostPieData { get; set; }
        private int selectedDays = 7;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 权限检查：仅管理员可访问
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadAnalysisData();
            }
        }

        private void LoadAnalysisData()
        {
            LoadSummaryStats();
            LoadRevenueChartData();
            LoadCostPieData();
            LoadTopProducts();
        }

        // 加载汇总统计数据
        private void LoadSummaryStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 计算总收入、总成本、净利润
                string sql = @"
                    SELECT 
                        ISNULL(SUM(od.成交单价 * od.购买数量), 0) AS 总收入,
                        ISNULL(SUM(p.商品进货成本价 * od.购买数量), 0) AS 总成本,
                        ISNULL(SUM((od.成交单价 - p.商品进货成本价) * od.购买数量), 0) AS 净利润
                    FROM OrderDetail od
                    INNER JOIN OrderMaster o ON od.归属订单流水号 = o.订单流水号
                    INNER JOIN Product p ON od.购买商品编号 = p.商品编号
                    WHERE o.订单流转状态 IN ('已完成', '已发货')
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();

                if (reader.Read())
                {
                    decimal totalRevenue = Convert.ToDecimal(reader["总收入"]);
                    decimal totalCost = Convert.ToDecimal(reader["总成本"]);
                    decimal netProfit = Convert.ToDecimal(reader["净利润"]);
                    decimal profitMargin = totalRevenue > 0 ? (netProfit / totalRevenue) * 100 : 0;

                    lblTotalRevenue.Text = totalRevenue.ToString("C2");
                    lblTotalCost.Text = totalCost.ToString("C2");
                    lblNetProfit.Text = netProfit.ToString("C2");
                    lblProfitMargin.Text = profitMargin.ToString("F1") + "%";
                }

                reader.Close();
            }
        }

        // 加载收入趋势图表数据
        private void LoadRevenueChartData()
        {
            List<string> labels = new List<string>();
            List<decimal> revenues = new List<decimal>();
            List<decimal> costs = new List<decimal>();
            List<decimal> profits = new List<decimal>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
                    SELECT 
                        CONVERT(DATE, o.订单创建时间) AS 日期,
                        ISNULL(SUM(od.成交单价 * od.购买数量), 0) AS 收入,
                        ISNULL(SUM(p.商品进货成本价 * od.购买数量), 0) AS 成本,
                        ISNULL(SUM((od.成交单价 - p.商品进货成本价) * od.购买数量), 0) AS 利润
                    FROM OrderMaster o
                    INNER JOIN OrderDetail od ON o.订单流水号 = od.归属订单流水号
                    INNER JOIN Product p ON od.购买商品编号 = p.商品编号
                    WHERE o.订单流转状态 IN ('已完成', '已发货')
                        AND o.订单创建时间 >= DATEADD(DAY, -@Days, GETDATE())
                    GROUP BY CONVERT(DATE, o.订单创建时间)
                    ORDER BY CONVERT(DATE, o.订单创建时间)
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@Days", selectedDays);

                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    labels.Add(Convert.ToDateTime(reader["日期"]).ToString("MM/dd"));
                    revenues.Add(Convert.ToDecimal(reader["收入"]));
                    costs.Add(Convert.ToDecimal(reader["成本"]));
                    profits.Add(Convert.ToDecimal(reader["利润"]));
                }

                reader.Close();
            }

            // 构建 JSON 数据
            RevenueChartData = $@"{{
                labels: {ToJsonArray(labels)},
                revenue: {ToJsonArray(revenues)},
                cost: {ToJsonArray(costs)},
                profit: {ToJsonArray(profits)}
            }}";
        }

        // 加载成本饼图数据
        private void LoadCostPieData()
        {
            List<string> labels = new List<string>();
            List<decimal> values = new List<decimal>();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = @"
                    SELECT TOP 5
                        c.类别名称,
                        ISNULL(SUM(p.商品进货成本价 * od.购买数量), 0) AS 成本
                    FROM OrderDetail od
                    INNER JOIN OrderMaster o ON od.归属订单流水号 = o.订单流水号
                    INNER JOIN Product p ON od.购买商品编号 = p.商品编号
                    INNER JOIN Category c ON p.所属类别编号 = c.类别编号
                    WHERE o.订单流转状态 IN ('已完成', '已发货')
                    GROUP BY c.类别名称
                    ORDER BY 成本 DESC
                ";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataReader reader = cmd.ExecuteReader();

                while (reader.Read())
                {
                    labels.Add(reader["类别名称"].ToString());
                    values.Add(Convert.ToDecimal(reader["成本"]));
                }

                reader.Close();
            }

            // 构建 JSON 数据
            CostPieData = $@"{{
                labels: {ToJsonArray(labels)},
                values: {ToJsonArray(values)}
            }}";
        }

        // 加载商品销售排行
        private void LoadTopProducts()
        {
            int topCount = int.Parse(ddlTopCount.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                string sql = $@"
                    SELECT TOP {topCount}
                        p.商品编号,
                        p.商品标准名称,
                        SUM(od.购买数量) AS 销售数量,
                        SUM(od.成交单价 * od.购买数量) AS 销售收入,
                        SUM(p.商品进货成本价 * od.购买数量) AS 总成本,
                        SUM((od.成交单价 - p.商品进货成本价) * od.购买数量) AS 利润
                    FROM OrderDetail od
                    INNER JOIN OrderMaster o ON od.归属订单流水号 = o.订单流水号
                    INNER JOIN Product p ON od.购买商品编号 = p.商品编号
                    WHERE o.订单流转状态 IN ('已完成', '已发货')
                    GROUP BY p.商品编号, p.商品标准名称
                    ORDER BY 销售收入 DESC
                ";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // 添加占比列
                dt.Columns.Add("占比", typeof(decimal));

                // 计算占比
                decimal totalRevenue = 0;
                foreach (DataRow row in dt.Rows)
                {
                    totalRevenue += Convert.ToDecimal(row["销售收入"]);
                }

                foreach (DataRow row in dt.Rows)
                {
                    decimal revenue = Convert.ToDecimal(row["销售收入"]);
                    row["占比"] = totalRevenue > 0 ? revenue / totalRevenue : 0;
                }

                gvTopProducts.DataSource = dt;
                gvTopProducts.DataBind();
            }
        }

        // 辅助方法：转换为 JSON 数组
        private string ToJsonArray(List<string> list)
        {
            return "[" + string.Join(",", list.Select(s => $"\"{s}\"")) + "]";
        }

        private string ToJsonArray(List<decimal> list)
        {
            return "[" + string.Join(",", list.Select(d => d.ToString("F2"))) + "]";
        }

        // 筛选时间段
        protected void FilterPeriod_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            selectedDays = int.Parse(btn.CommandArgument);

            // 更新按钮状态
            btnFilter7Days.CssClass = "filter-btn";
            btnFilter30Days.CssClass = "filter-btn";
            btnFilter90Days.CssClass = "filter-btn";
            btn.CssClass = "filter-btn active";

            LoadAnalysisData();
        }

        // 更改排行数量
        protected void ddlTopCount_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTopProducts();
        }
    }
}