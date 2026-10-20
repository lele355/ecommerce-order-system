using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class StockManage : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        private long CurrentProdId
        {
            get { return (long)(ViewState["CurrentProdId"] ?? 0L); }
            set { ViewState["CurrentProdId"] = value; }
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
                BindStock();
            }
        }

        private void BindStock()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT P.[商品编号], P.[商品标准名称], P.[商品当前库存量], 
                              P.[商品销售单价], P.[商品进货成本价], C.[类别名称], P.[商品是否上架]
                              FROM [dbo].[Product] P 
                              LEFT JOIN [dbo].[Category] C ON P.[所属类别编号] = C.[类别编号] 
                              ORDER BY P.[商品当前库存量] ASC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvStock.DataSource = dt;
                gvStock.DataBind();
            }
        }

        protected void gvStock_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "StockIn")
            {
                long pid = Convert.ToInt64(e.CommandArgument);
                CurrentProdId = pid;

                // 加载 Modal 信息
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT [商品标准名称], [商品当前库存量] FROM [dbo].[Product] WHERE [商品编号] = @pid";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@pid", pid);
                    conn.Open();
                    SqlDataReader r = cmd.ExecuteReader();
                    if (r.Read())
                    {
                        lblModalProdName.Text = r["商品标准名称"].ToString();
                        lblModalCurrentStock.Text = r["商品当前库存量"].ToString();
                        lblModalCurrentStock2.Text = r["商品当前库存量"].ToString();
                        lblModalCurrentStock3.Text = r["商品当前库存量"].ToString();
                    }
                    r.Close();
                    
                    // 加载经办人信息
                    if (Session["UserRole"] != null && Session["UserRole"].ToString() != "Customer")
                    {
                        if (Session["UserID"] != null)
                        {
                            string sqlUser = @"SELECT [员工真实姓名] FROM [dbo].[AdminInfo] WHERE [员工工号] = @uid";
                            SqlCommand cmdUser = new SqlCommand(sqlUser, conn);
                            cmdUser.Parameters.AddWithValue("@uid", Session["UserID"]);
                            object result = cmdUser.ExecuteScalar();
                            lblOperator.Text = result != null ? result.ToString() : "未知";
                        }
                        else
                        {
                            lblOperator.Text = "系统";
                        }
                    }
                }
                txtAddQty.Text = "10";
                upModal.Update();
                string script = @"
                    setTimeout(function(){
                        var modalEl = document.getElementById('stockInModal');
                        if(!modalEl) return;
                        var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                        if (modalEl.parentElement !== formEl) { formEl.appendChild(modalEl); }
                        document.body.style.pointerEvents = 'auto';
                        modalEl.style.pointerEvents = 'auto';
                        var modal = bootstrap.Modal.getOrCreateInstance(modalEl, { backdrop:true, keyboard:true, focus:true });
                        modal.show();
                    }, 50);
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "modal", script, true);
            }
        }

        protected void btnConfirmStockIn_Click(object sender, EventArgs e)
        {
            int qty;
            if (!int.TryParse(txtAddQty.Text, out qty) || qty <= 0)
            {
                // 简单错误处理，实际可加 Label 提示
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction transaction = conn.BeginTransaction();
                
                try
                {
                    // 1. 更新商品库存
                    string sqlUpdate = "UPDATE [dbo].[Product] SET [商品当前库存量] = [商品当前库存量] + @qty WHERE [商品编号] = @pid";
                    SqlCommand cmd = new SqlCommand(sqlUpdate, conn, transaction);
                    cmd.Parameters.AddWithValue("@qty", qty);
                    cmd.Parameters.AddWithValue("@pid", CurrentProdId);
                    cmd.ExecuteNonQuery();

                    // 2. 插入入库记录（入库操作时间自动设置为当前时间）
                    string sqlLog = @"INSERT INTO [dbo].[StockInLog] 
                                     ([入库商品编号], [经办员工工号], [入库数量], [入库操作时间]) 
                                     VALUES (@pid, @uid, @qty, GETDATE())";
                    SqlCommand cmdLog = new SqlCommand(sqlLog, conn, transaction);
                    cmdLog.Parameters.AddWithValue("@pid", CurrentProdId);
                    cmdLog.Parameters.AddWithValue("@uid", Session["UserID"] ?? (object)DBNull.Value);
                    cmdLog.Parameters.AddWithValue("@qty", qty);
                    cmdLog.ExecuteNonQuery();
                    
                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    transaction.Rollback();
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                        "toastr.error('入库失败：" + ex.Message.Replace("'", "\\'") + "');", true);
                    return;
                }
            }

            BindStock();
            upStock.Update();
            string hideScript = @"
                (function(){
                    var el = document.getElementById('stockInModal');
                    if (el){ var m = bootstrap.Modal.getOrCreateInstance(el); m.hide(); }
                    if (window.toastr) toastr.success('入库成功');
                })();
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "hide", hideScript, true);
        }

        protected void gvStock_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvStock.PageIndex = e.NewPageIndex;
            BindStock();
        }

        protected void btnViewHistory_Click(object sender, EventArgs e)
        {
            BindStockHistory();
            upHistory.Update();
            
            string script = @"
                setTimeout(function(){
                    var modalEl = document.getElementById('historyModal');
                    if(!modalEl) return;
                    var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                    if (modalEl.parentElement !== formEl) { formEl.appendChild(modalEl); }
                    document.body.style.pointerEvents = 'auto';
                    modalEl.style.pointerEvents = 'auto';
                    var modal = bootstrap.Modal.getOrCreateInstance(modalEl, { backdrop:true, keyboard:true, focus:true });
                    modal.show();
                }, 50);
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "historyModal", script, true);
        }

        private void BindStockHistory()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"SELECT TOP 100 
                              L.[入库记录号],
                              L.[入库操作时间],
                              P.[商品标准名称],
                              L.[入库数量],
                              A.[员工真实姓名] AS [经办人姓名]
                              FROM [dbo].[StockInLog] L
                              INNER JOIN [dbo].[Product] P ON L.[入库商品编号] = P.[商品编号]
                              LEFT JOIN [dbo].[AdminInfo] A ON L.[经办员工工号] = A.[员工工号]
                              ORDER BY L.[入库操作时间] DESC";
                
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvHistory.DataSource = dt;
                gvHistory.DataBind();
            }
        }

        protected void gvHistory_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvHistory.PageIndex = e.NewPageIndex;
            BindStockHistory();
        }
    }
}