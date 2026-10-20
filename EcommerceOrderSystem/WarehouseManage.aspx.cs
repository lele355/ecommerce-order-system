using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class WarehouseManage : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                {
                    Response.Redirect("Dashboard.aspx");
                    return;
                }
                BindWarehouses();
            }
        }

        private void BindWarehouses()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Warehouse] ORDER BY [仓库内部编号] DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvWarehouses.DataSource = dt;
                gvWarehouses.DataBind();
            }
        }

        // 获取仓库员工数量
        public int GetEmployeeCount(object warehouseId)
        {
            if (warehouseId == null) return 0;
            
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT COUNT(*) FROM [dbo].[AdminInfo] WHERE [所属仓库编号] = @wid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@wid", warehouseId);
                
                conn.Open();
                return (int)cmd.ExecuteScalar();
            }
        }

        protected void gvWarehouses_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            long warehouseId = Convert.ToInt64(e.CommandArgument);

            if (e.CommandName == "EditWarehouse")
            {
                LoadWarehouseForEdit(warehouseId);
                hfWarehouseId.Value = warehouseId.ToString();
                lblModalTitle.Text = "编辑仓库";
                upModal.Update();
                
                string script = @"
                    setTimeout(function(){
                        var modalEl = document.getElementById('warehouseModal');
                        if(!modalEl) return;
                        var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                        if (modalEl.parentElement !== formEl) { formEl.appendChild(modalEl); }
                        var modal = bootstrap.Modal.getOrCreateInstance(modalEl, { backdrop:true, keyboard:true, focus:true });
                        modal.show();
                    }, 50);
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "modal", script, true);
            }
            else if (e.CommandName == "DeleteWarehouse")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        
                        // 检查是否有员工属于此仓库
                        string checkSql = "SELECT COUNT(*) FROM [dbo].[AdminInfo] WHERE [所属仓库编号] = @wid";
                        SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                        checkCmd.Parameters.AddWithValue("@wid", warehouseId);
                        int employeeCount = (int)checkCmd.ExecuteScalar();
                        
                        if (employeeCount > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                                "toastr.error('该仓库有 " + employeeCount + " 名员工，无法删除！');", true);
                            return;
                        }
                        
                        // 删除仓库
                        string deleteSql = "DELETE FROM [dbo].[Warehouse] WHERE [仓库内部编号] = @wid";
                        SqlCommand deleteCmd = new SqlCommand(deleteSql, conn);
                        deleteCmd.Parameters.AddWithValue("@wid", warehouseId);
                        deleteCmd.ExecuteNonQuery();
                        
                        BindWarehouses();
                        upWarehouseList.Update();
                        ScriptManager.RegisterStartupScript(this, GetType(), "success", 
                            "toastr.success('仓库删除成功');", true);
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                        "toastr.error('删除失败：" + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        private void LoadWarehouseForEdit(long warehouseId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Warehouse] WHERE [仓库内部编号] = @wid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@wid", warehouseId);
                
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtWarehouseName.Text = reader["仓库名称"].ToString();
                    txtLocation.Text = reader["仓库物理位置"].ToString();
                    txtManager.Text = reader["仓库负责人姓名"].ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string name = txtWarehouseName.Text.Trim();
            string location = txtLocation.Text.Trim();
            string manager = txtManager.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                    "toastr.error('仓库名称不能为空');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql;
                if (string.IsNullOrEmpty(hfWarehouseId.Value)) // 新增
                {
                    sql = @"INSERT INTO [Warehouse] 
                            ([仓库名称], [仓库物理位置], [仓库负责人姓名]) 
                            VALUES (@name, @location, @manager)";
                }
                else // 编辑
                {
                    sql = @"UPDATE [Warehouse]
                            SET [仓库名称]=@name, [仓库物理位置]=@location, [仓库负责人姓名]=@manager
                            WHERE [仓库内部编号]=@wid";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@location", string.IsNullOrEmpty(location) ? (object)DBNull.Value : location);
                cmd.Parameters.AddWithValue("@manager", string.IsNullOrEmpty(manager) ? (object)DBNull.Value : manager);
                if (!string.IsNullOrEmpty(hfWarehouseId.Value)) 
                    cmd.Parameters.AddWithValue("@wid", Convert.ToInt64(hfWarehouseId.Value));

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            string hideScript = @"
                (function(){
                    var el = document.getElementById('warehouseModal');
                    if (el){ var m = bootstrap.Modal.getOrCreateInstance(el); m.hide(); }
                    if (window.toastr) toastr.success('保存成功');
                })();
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "hide", hideScript, true);
            BindWarehouses();
            upWarehouseList.Update();
        }

        protected void gvWarehouses_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvWarehouses.PageIndex = e.NewPageIndex;
            BindWarehouses();
        }
    }
}
