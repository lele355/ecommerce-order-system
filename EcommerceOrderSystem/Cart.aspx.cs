using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class Cart : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) BindCart();
        }

        private void BindCart()
        {
            List<CartItem> cart = Session["Cart"] as List<CartItem> ?? new List<CartItem>();
            gvCart.DataSource = cart;
            gvCart.DataBind();
            
            decimal total = cart.Sum(x => x.SubTotal);
            int count = cart.Sum(x => x.Quantity);
            
            lblFinalTotal.Text = total.ToString("C");
            lblFinalTotal2.Text = total.ToString("C");
            lblTitleCount.Text = count.ToString();
            btnCheckout.Enabled = cart.Count > 0;
            
            ((Site)this.Master).UpdateCartCount();
        }

        protected void gvCart_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            long pid = Convert.ToInt64(e.CommandArgument);
            List<CartItem> cart = Session["Cart"] as List<CartItem>;
            var item = cart.Find(x => x.ProductId == pid);

            if (item != null)
            {
                if (e.CommandName == "Plus" && item.Quantity < item.Stock) item.Quantity++;
                else if (e.CommandName == "Minus" && item.Quantity > 1) item.Quantity--;
                else if (e.CommandName == "RemoveItem") cart.Remove(item);

                Session["Cart"] = cart;
                BindCart();
            }
        }

        protected void btnCheckout_Click(object sender, EventArgs e)
        {
            Response.Redirect("Checkout.aspx");
        }

        protected void btnClearCart_Click(object sender, EventArgs e)
        {
            Session["Cart"] = new List<CartItem>();
            BindCart();
            ScriptManager.RegisterStartupScript(this, GetType(), "clearCart", "toastr.success('购物车已清空');", true);
        }

        // 辅助方法：根据索引返回购物车图标
        protected string GetCartItemIcon(int index)
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
                "fas fa-mouse",
                "fas fa-tablet-alt",
                "fas fa-microchip"
            };
            return icons[index % icons.Length];
        }

        // 辅助方法：根据索引返回颜色类
        protected string GetCartItemColorClass(int index)
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