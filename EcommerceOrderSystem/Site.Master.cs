using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;

namespace EcommerceOrderSystem
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                lblUserName.Text = Session["UserName"]?.ToString();
                string role = Session["UserRole"]?.ToString();

                phCustomerMenu.Visible = (role == "Customer");
                phEmployeeMenu.Visible = (role == "Employee" || role == "Admin");
            phAdminConfig.Visible = (role == "Admin" || role == "System Administrator");
                phCartBtn.Visible = (role == "Customer");
                phLogoCustomer.Visible = (role == "Customer");
                phLogoAdmin.Visible = (role != "Customer");
                phExploreCustomer.Visible = (role == "Customer");

                UpdateCartCount();
            }
        }

        public void UpdateCartCount()
        {
            if (Session["Cart"] != null)
            {
                var cart = Session["Cart"] as List<CartItem>;
                int count = cart.Sum(x => x.Quantity);
                lblCartBadge.Text = count.ToString();
                lblCartBadge.Visible = count > 0;
            }
            upCartBadge.Update();
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }
    }
}