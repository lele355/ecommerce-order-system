using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class SupplierManage : Page
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
                BindSuppliers();
            }
        }

        private void BindSuppliers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Supplier] ORDER BY [供应商编号] DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvSuppliers.DataSource = dt;
                gvSuppliers.DataBind();
            }
        }

        protected void gvSuppliers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            long supplierId = Convert.ToInt64(e.CommandArgument);

            if (e.CommandName == "EditSupplier")
            {
                LoadSupplierForEdit(supplierId);
                hfSupplierId.Value = supplierId.ToString();
                lblModalTitle.Text = "编辑供应商";
                upModal.Update();
                
                string script = @"
                    setTimeout(function(){
                        var modalEl = document.getElementById('supplierModal');
                        if(!modalEl) return;
                        var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                        if (modalEl.parentElement !== formEl) { formEl.appendChild(modalEl); }
                        var modal = bootstrap.Modal.getOrCreateInstance(modalEl, { backdrop:true, keyboard:true, focus:true });
                        modal.show();
                    }, 50);
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "modal", script, true);
            }
            else if (e.CommandName == "DeleteSupplier")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        
                        // 检查是否有商品使用此供应商
                        string checkSql = "SELECT COUNT(*) FROM [dbo].[Product] WHERE [主供应商编号] = @sid";
                        SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                        checkCmd.Parameters.AddWithValue("@sid", supplierId);
                        int productCount = (int)checkCmd.ExecuteScalar();
                        
                        if (productCount > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                                "toastr.error('该供应商有 " + productCount + " 个商品在供货，无法删除！');", true);
                            return;
                        }
                        
                        // 删除供应商
                        string deleteSql = "DELETE FROM [dbo].[Supplier] WHERE [供应商编号] = @sid";
                        SqlCommand deleteCmd = new SqlCommand(deleteSql, conn);
                        deleteCmd.Parameters.AddWithValue("@sid", supplierId);
                        deleteCmd.ExecuteNonQuery();
                        
                        BindSuppliers();
                        upSupplierList.Update();
                        ScriptManager.RegisterStartupScript(this, GetType(), "success", 
                            "toastr.success('供应商删除成功');", true);
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                        "toastr.error('删除失败：" + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        private void LoadSupplierForEdit(long supplierId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Supplier] WHERE [供应商编号] = @sid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@sid", supplierId);
                
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtCompanyName.Text = reader["供应商企业名称"].ToString();
                    txtContact.Text = reader["供方联系人"].ToString();
                    txtPhone.Text = reader["供方联系电话"].ToString();
                    txtAddress.Text = reader["供应商所在地址"].ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string companyName = txtCompanyName.Text.Trim();
            string contact = txtContact.Text.Trim();
            string phone = txtPhone.Text.Trim();
            string address = txtAddress.Text.Trim();

            if (string.IsNullOrEmpty(companyName))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                    "toastr.error('企业名称不能为空');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql;
                if (string.IsNullOrEmpty(hfSupplierId.Value)) // 新增
                {
                    sql = @"INSERT INTO [Supplier] 
                            ([供应商企业名称], [供方联系人], [供方联系电话], [供应商所在地址]) 
                            VALUES (@name, @contact, @phone, @address)";
                }
                else // 编辑
                {
                    sql = @"UPDATE [Supplier]
                            SET [供应商企业名称]=@name, [供方联系人]=@contact, 
                                [供方联系电话]=@phone, [供应商所在地址]=@address
                            WHERE [供应商编号]=@sid";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@name", companyName);
                cmd.Parameters.AddWithValue("@contact", string.IsNullOrEmpty(contact) ? (object)DBNull.Value : contact);
                cmd.Parameters.AddWithValue("@phone", string.IsNullOrEmpty(phone) ? (object)DBNull.Value : phone);
                cmd.Parameters.AddWithValue("@address", string.IsNullOrEmpty(address) ? (object)DBNull.Value : address);
                if (!string.IsNullOrEmpty(hfSupplierId.Value)) 
                    cmd.Parameters.AddWithValue("@sid", Convert.ToInt64(hfSupplierId.Value));

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            string hideScript = @"
                (function(){
                    var el = document.getElementById('supplierModal');
                    if (el){ var m = bootstrap.Modal.getOrCreateInstance(el); m.hide(); }
                    if (window.toastr) toastr.success('保存成功');
                })();
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "hide", hideScript, true);
            BindSuppliers();
            upSupplierList.Update();
        }

        protected void gvSuppliers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvSuppliers.PageIndex = e.NewPageIndex;
            BindSuppliers();
        }
    }
}
