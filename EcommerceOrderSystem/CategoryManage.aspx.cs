using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class CategoryManage : Page
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
                BindCategories();
            }
        }

        private void BindCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Category] ORDER BY [类别编号] DESC";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvCategories.DataSource = dt;
                gvCategories.DataBind();
            }
        }

        protected void gvCategories_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int categoryId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditCategory")
            {
                LoadCategoryForEdit(categoryId);
                hfCategoryId.Value = categoryId.ToString();
                lblModalTitle.Text = "编辑分类";
                upModal.Update();
                
                // 使用通用修复函数
                ScriptManager.RegisterStartupScript(this, GetType(), "showModal", 
                    "fixModalPointerEvents('categoryModal');", true);
            }
            else if (e.CommandName == "DeleteCategory")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        
                        // 检查是否有商品使用此分类
                        string checkSql = "SELECT COUNT(*) FROM [dbo].[Product] WHERE [所属类别编号] = @cid";
                        SqlCommand checkCmd = new SqlCommand(checkSql, conn);
                        checkCmd.Parameters.AddWithValue("@cid", categoryId);
                        int productCount = (int)checkCmd.ExecuteScalar();
                        
                        if (productCount > 0)
                        {
                            ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                                "toastr.error('该分类下有 " + productCount + " 个商品，无法删除！');", true);
                            return;
                        }
                        
                        // 删除分类
                        string deleteSql = "DELETE FROM [dbo].[Category] WHERE [类别编号] = @cid";
                        SqlCommand deleteCmd = new SqlCommand(deleteSql, conn);
                        deleteCmd.Parameters.AddWithValue("@cid", categoryId);
                        deleteCmd.ExecuteNonQuery();
                        
                        BindCategories();
                        upCategoryList.Update();
                        ScriptManager.RegisterStartupScript(this, GetType(), "success", 
                            "toastr.success('分类删除成功');", true);
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                        "toastr.error('删除失败：" + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        private void LoadCategoryForEdit(int categoryId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Category] WHERE [类别编号] = @cid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", categoryId);
                
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtCategoryName.Text = reader["类别名称"].ToString();
                    txtDescription.Text = reader["类别描述"].ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string name = txtCategoryName.Text.Trim();
            string description = txtDescription.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                    "toastr.error('分类名称不能为空');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql;
                if (string.IsNullOrEmpty(hfCategoryId.Value)) // 新增
                {
                    sql = @"INSERT INTO [Category] ([类别名称], [类别描述]) 
                            VALUES (@name, @desc)";
                }
                else // 编辑
                {
                    sql = @"UPDATE [Category]
                            SET [类别名称]=@name, [类别描述]=@desc
                            WHERE [类别编号]=@cid";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@desc", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                if (!string.IsNullOrEmpty(hfCategoryId.Value)) 
                    cmd.Parameters.AddWithValue("@cid", Convert.ToInt32(hfCategoryId.Value));

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            string hideScript = @"
                (function(){
                    var el = document.getElementById('categoryModal');
                    if (el){ var m = bootstrap.Modal.getOrCreateInstance(el); m.hide(); }
                    if (window.toastr) toastr.success('保存成功');
                })();
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "hide", hideScript, true);
            BindCategories();
            upCategoryList.Update();
        }

        protected void gvCategories_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvCategories.PageIndex = e.NewPageIndex;
            BindCategories();
        }
    }
}
