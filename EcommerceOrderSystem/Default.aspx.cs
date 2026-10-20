using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class _Default : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        // 使用 ViewState 保存当前筛选状态
        public int CurrentCategoryId
        {
            get { return ViewState["CurrentCategoryId"] != null ? (int)ViewState["CurrentCategoryId"] : 0; }
            set { ViewState["CurrentCategoryId"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindCategories();
                BindProducts();
            }
            
            // 设置"全部"按钮的样式
            UpdateAllButtonStyle();
        }
        
        private void UpdateAllButtonStyle()
        {
            if (CurrentCategoryId == 0)
            {
                btnAllCats.CssClass = "cat-pill active";
            }
            else
            {
                btnAllCats.CssClass = "cat-pill";
            }
        }

        // 1. 绑定左侧分类列表 (带数量统计)
        private void BindCategories()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 左连接查询，统计每个分类下的上架商品数
                string sql = @"
                    SELECT C.类别编号, C.类别名称, COUNT(P.商品编号) as Count
                    FROM Category C
                    LEFT JOIN Product P ON C.类别编号 = P.所属类别编号 AND P.商品是否上架 = 1
                    GROUP BY C.类别编号, C.类别名称
                    ORDER BY C.类别编号";

                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptCategories.DataSource = dt;
                rptCategories.DataBind();
            }
        }

        // 2. 绑定商品列表
        private void BindProducts(string keyword = "")
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT * FROM [Product] WHERE [商品是否上架] = 1";

                // 筛选条件：关键字
                if (!string.IsNullOrEmpty(keyword))
                {
                    sql += " AND [商品标准名称] LIKE @kw";
                }

                // 筛选条件：分类
                if (CurrentCategoryId > 0)
                {
                    sql += " AND [所属类别编号] = @catId";
                }

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(keyword)) cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                if (CurrentCategoryId > 0) cmd.Parameters.AddWithValue("@catId", CurrentCategoryId);

                conn.Open();
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptProducts.DataSource = dt;
                rptProducts.DataBind();

                lblCount.Text = dt.Rows.Count.ToString();
                pnlNoData.Visible = dt.Rows.Count == 0;
            }
        }

        // 3. 点击分类筛选
        protected void FilterCategory_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            int catId = Convert.ToInt32(btn.CommandArgument);

            CurrentCategoryId = catId; // 更新状态

            // 更新标题显示
            if (catId == 0)
            {
                lblCurrentCatName.Text = "全部商品";
            }
            else
            {
                // 获取分类名称
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT [类别名称] FROM [Category] WHERE [类别编号] = @catId";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@catId", catId);
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null)
                    {
                        lblCurrentCatName.Text = result.ToString();
                    }
                }
            }

            UpdateAllButtonStyle(); // 更新"全部"按钮样式
            BindCategories(); // 重新绑定分类以更新 Active 样式
            BindProducts();   // 刷新商品列表

            // 重点：手动触发 UpdatePanel 更新
            upProducts.Update();
        }

        // 4. 搜索
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            CurrentCategoryId = 0; // 搜索时重置分类
            lblCurrentCatName.Text = "搜索结果";
            UpdateAllButtonStyle();
            BindCategories();
            BindProducts(txtSearch.Text.Trim());
            upProducts.Update();
        }

        // 5. 加入购物车 (核心交互 - 纯AJAX，不刷新页面)
        protected void rptProducts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "AddToCart")
            {
                // 检查登录状态
                if (Session["UserID"] == null)
                {
                    string redirectScript = @"
                        toastr.warning('请先登录', '提示', {
                            timeOut: 2000,
                            onHidden: function() { window.location.href='Login.aspx'; }
                        });
                    ";
                    ScriptManager.RegisterStartupScript(this, GetType(), "redirect", redirectScript, true);
                    return;
                }

                long pid = Convert.ToInt64(e.CommandArgument);
                string productName = AddToCart(pid);

                // 更新 Master Page 的购物车角标
                if (this.Master is Site masterPage)
                {
                    masterPage.UpdateCartCount();
                }

                // 成功提示 + 购物车图标动画（不刷新页面）
                string successScript = $@"
                    // 显示成功提示
                    toastr.success('已加入购物车：{productName.Replace("'", "\\'")}', '添加成功', {{
                        timeOut: 2000,
                        progressBar: true
                    }});
                    
                    // 购物车图标跳动动画
                    var cartIcon = document.querySelector('.nav-link[href*=""Cart""] i');
                    if (cartIcon) {{
                        cartIcon.style.animation = 'cartBounce 0.6s ease';
                        setTimeout(function() {{
                            cartIcon.style.animation = '';
                        }}, 600);
                    }}
                    
                    // 购物车数量徽章动画
                    var badge = document.querySelector('.badge');
                    if (badge) {{
                        badge.style.animation = 'badgePulse 0.5s ease';
                        setTimeout(function() {{
                            badge.style.animation = '';
                        }}, 500);
                    }}
                ";
                ScriptManager.RegisterStartupScript(this, GetType(), "addToCartSuccess", successScript, true);
            }
        }

        private string AddToCart(long pid)
        {
            List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();
            string productName = "";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT [商品标准名称], [商品销售单价], [商品当前库存量] FROM [Product] WHERE [商品编号] = @pid";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@pid", pid);
                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    productName = reader["商品标准名称"].ToString();
                    CartItem existingItem = cart.Find(x => x.ProductId == pid);
                    if (existingItem != null)
                    {
                        // 简单库存检查（内存级，非严格）
                        if (existingItem.Quantity < Convert.ToInt32(reader["商品当前库存量"]))
                            existingItem.Quantity++;
                    }
                    else
                    {
                        cart.Add(new CartItem
                        {
                            ProductId = pid,
                            ProductName = productName,
                            Price = Convert.ToDecimal(reader["商品销售单价"]),
                            Stock = Convert.ToInt32(reader["商品当前库存量"]),
                            Quantity = 1
                        });
                    }
                }
            }
            Session["Cart"] = cart;
            return productName;
        }

        // 辅助方法：根据分类名称返回图标
        protected string GetCategoryIcon(string categoryName)
        {
            var iconMap = new Dictionary<string, string>
            {
                { "电子产品", "fas fa-laptop" },
                { "家居用品", "fas fa-couch" },
                { "服装鞋帽", "fas fa-tshirt" },
                { "图书音像", "fas fa-book" },
                { "食品饮料", "fas fa-utensils" },
                { "运动户外", "fas fa-bicycle" },
                { "美妆护肤", "fas fa-spa" },
                { "数码配件", "fas fa-mobile-alt" }
            };

            return iconMap.ContainsKey(categoryName) ? iconMap[categoryName] : "fas fa-box";
        }

        // 辅助方法：根据索引返回产品图标（循环）
        protected string GetProductIcon(int index)
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
                "fas fa-mouse"
            };
            return icons[index % icons.Length];
        }

        // 辅助方法：根据索引返回颜色类（循环）
        protected string GetCategoryColorClass(int index)
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