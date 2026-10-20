using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class ProductManage : Page
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
                BindDropdowns();
                BindProducts();
            }
        }

        private void BindDropdowns()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                SqlDataAdapter da1 = new SqlDataAdapter("SELECT [类别编号], [类别名称] FROM [dbo].[Category]", conn);
                DataTable dt1 = new DataTable(); da1.Fill(dt1);
                ddlCategory.DataSource = dt1;
                ddlCategory.DataTextField = "类别名称"; ddlCategory.DataValueField = "类别编号";
                ddlCategory.DataBind();

                // 绑定筛选分类下拉（含“全部”）
                ddlFilterCategory.DataSource = dt1;
                ddlFilterCategory.DataTextField = "类别名称"; ddlFilterCategory.DataValueField = "类别编号";
                ddlFilterCategory.DataBind();
                ddlFilterCategory.Items.Insert(0, new ListItem("全部分类", ""));

                SqlDataAdapter da2 = new SqlDataAdapter("SELECT [供应商编号], [供应商企业名称] FROM [dbo].[Supplier]", conn);
                DataTable dt2 = new DataTable(); da2.Fill(dt2);
                ddlSupplier.DataSource = dt2;
                ddlSupplier.DataTextField = "供应商企业名称"; ddlSupplier.DataValueField = "供应商编号";
                ddlSupplier.DataBind();
            }
        }

        private void BindProducts()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string baseSql = "SELECT P.*, C.[类别名称] FROM [dbo].[Product] P JOIN [dbo].[Category] C ON P.[所属类别编号] = C.[类别编号] WHERE P.[商品标准名称] LIKE @kw";
                // 分类筛选条件
                bool hasCat = !string.IsNullOrEmpty(ddlFilterCategory.SelectedValue);
                if (hasCat)
                {
                    baseSql += " AND P.[所属类别编号] = @cid";
                }
                baseSql += " ORDER BY P.[商品编号] DESC";

                SqlCommand cmd = new SqlCommand(baseSql, conn);
                cmd.Parameters.AddWithValue("@kw", "%" + txtSearchProd.Text.Trim() + "%");
                if (hasCat)
                {
                    cmd.Parameters.AddWithValue("@cid", Convert.ToInt32(ddlFilterCategory.SelectedValue));
                }

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvProducts.DataSource = dt;
                gvProducts.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e) { BindProducts(); }

        protected void ddlFilterCategory_SelectedIndexChanged(object sender, EventArgs e)
        {
            gvProducts.PageIndex = 0; // 重置分页到第一页
            BindProducts();
        }

        protected void gvProducts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            long pid = Convert.ToInt64(e.CommandArgument);

            if (e.CommandName == "ToggleStatus")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    // 状态取反：上架变下架，下架变上架
                    string sql = "UPDATE [dbo].[Product] SET [商品是否上架] = CASE WHEN [商品是否上架]=1 THEN 0 ELSE 1 END WHERE [商品编号]=@pid";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@pid", pid);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                BindProducts();
                upProdList.Update();
                ScriptManager.RegisterStartupScript(this, GetType(), "toast", "toastr.success('商品状态已更新');", true);
            }
            else if (e.CommandName == "EditProd")
            {
                // 加载商品数据到 Modal
                LoadProductForEdit(pid);
                hfProdId.Value = pid.ToString();
                lblModalTitle.Text = "编辑商品";
                upModal.Update();
                
                string script = @"
                    setTimeout(function(){
                        var modalEl = document.getElementById('prodModal');
                        if(!modalEl) return;
                        var formEl = document.forms && document.forms[0] ? document.forms[0] : document.body;
                        if (modalEl.parentElement !== formEl) { formEl.appendChild(modalEl); }
                        var modal = bootstrap.Modal.getOrCreateInstance(modalEl, { backdrop:true, keyboard:true, focus:true });
                        modal.show();
                    }, 50);
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "modal", script, true);
            }
            else if (e.CommandName == "DeleteProd")
            {
                try
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        conn.Open();
                        SqlTransaction transaction = conn.BeginTransaction();
                        
                        try
                        {
                            // 检查商品是否有订单明细
                            string checkSql = "SELECT COUNT(*) FROM [dbo].[OrderDetail] WHERE [购买商品编号] = @pid";
                            SqlCommand checkCmd = new SqlCommand(checkSql, conn, transaction);
                            checkCmd.Parameters.AddWithValue("@pid", pid);
                            int orderCount = (int)checkCmd.ExecuteScalar();
                            
                            if (orderCount > 0)
                            {
                                transaction.Rollback();
                                ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                                    "toastr.error('该商品已有订单记录，无法删除！建议下架商品。');", true);
                                return;
                            }
                            
                            // 检查是否有入库记录
                            string checkStockSql = "SELECT COUNT(*) FROM [dbo].[StockInLog] WHERE [入库商品编号] = @pid";
                            SqlCommand checkStockCmd = new SqlCommand(checkStockSql, conn, transaction);
                            checkStockCmd.Parameters.AddWithValue("@pid", pid);
                            int stockCount = (int)checkStockCmd.ExecuteScalar();
                            
                            if (stockCount > 0)
                            {
                                // 删除入库记录
                                string deleteStockSql = "DELETE FROM [dbo].[StockInLog] WHERE [入库商品编号] = @pid";
                                SqlCommand deleteStockCmd = new SqlCommand(deleteStockSql, conn, transaction);
                                deleteStockCmd.Parameters.AddWithValue("@pid", pid);
                                deleteStockCmd.ExecuteNonQuery();
                            }
                            
                            // 删除商品
                            string deleteSql = "DELETE FROM [dbo].[Product] WHERE [商品编号] = @pid";
                            SqlCommand deleteCmd = new SqlCommand(deleteSql, conn, transaction);
                            deleteCmd.Parameters.AddWithValue("@pid", pid);
                            deleteCmd.ExecuteNonQuery();
                            
                            transaction.Commit();
                            
                            BindProducts();
                            upProdList.Update();
                            ScriptManager.RegisterStartupScript(this, GetType(), "success", 
                                "toastr.success('商品删除成功');", true);
                        }
                        catch (Exception ex)
                        {
                            transaction.Rollback();
                            ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                                "toastr.error('删除失败：" + ex.Message.Replace("'", "\\'") + "');", true);
                        }
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", 
                        "toastr.error('操作失败：" + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
        }

        private void LoadProductForEdit(long pid)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [dbo].[Product] WHERE [商品编号] = @pid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@pid", pid);
                
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    txtName.Text = reader["商品标准名称"].ToString();
                    txtPrice.Text = reader["商品销售单价"].ToString();
                    txtCost.Text = reader["商品进货成本价"].ToString();
                    ddlCategory.SelectedValue = reader["所属类别编号"].ToString();
                    ddlSupplier.SelectedValue = reader["主供应商编号"].ToString();
                }
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            // 简单的保存/新增逻辑
            string name = txtName.Text.Trim();
            decimal price = Convert.ToDecimal(txtPrice.Text);
            decimal cost = Convert.ToDecimal(txtCost.Text);
            int catId = Convert.ToInt32(ddlCategory.SelectedValue);
            int suppId = Convert.ToInt32(ddlSupplier.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql;
                if (string.IsNullOrEmpty(hfProdId.Value)) // 新增
                {
                    sql = @"INSERT INTO [Product] (
                                [所属类别编号], [主供应商编号], [商品标准名称],
                                [商品销售单价], [商品进货成本价], [商品当前库存量],
                                [商品是否上架]
                              ) VALUES (@cid, @sid, @name, @price, @cost, 0, 1)";
                }
                else // 编辑（可后续补充完整更新逻辑）
                {
                    sql = @"UPDATE [Product]
                            SET [所属类别编号]=@cid,
                                [主供应商编号]=@sid,
                                [商品标准名称]=@name,
                                [商品销售单价]=@price,
                                [商品进货成本价]=@cost
                            WHERE [商品编号]=@pid";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@cid", catId);
                cmd.Parameters.AddWithValue("@sid", suppId);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@price", price);
                cmd.Parameters.AddWithValue("@cost", cost);
                if (!string.IsNullOrEmpty(hfProdId.Value)) cmd.Parameters.AddWithValue("@pid", Convert.ToInt64(hfProdId.Value));

                conn.Open();
                cmd.ExecuteNonQuery();
            }

            string hideScript = @"
                (function(){
                    var el = document.getElementById('prodModal');
                    if (el){ var m = bootstrap.Modal.getOrCreateInstance(el); m.hide(); }
                    if (window.toastr) toastr.success('保存成功');
                })();
            ";
            ScriptManager.RegisterStartupScript(this, GetType(), "hide", hideScript, true);
            BindProducts();
            upProdList.Update();
        }

        protected void gvProducts_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvProducts.PageIndex = e.NewPageIndex;
            BindProducts();
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
            else if (cat.Contains("运动") || cat.Contains("健身") || cat.Contains("户外"))
                return "icon-box-sports";
            else if (cat.Contains("美妆") || cat.Contains("化妆") || cat.Contains("护肤"))
                return "icon-box-beauty";
            else if (cat.Contains("玩具") || cat.Contains("儿童") || cat.Contains("游戏"))
                return "icon-box-toys";
            else
                return "icon-box-default";
        }
    }
}