using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace EcommerceOrderSystem
{
    public partial class Login : System.Web.UI.Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Session.Clear();
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            if (CheckCustomer(username, password))
            {
                Response.Redirect("Default.aspx");
            }
            else if (CheckEmployee(username, password))
            {
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                pnlError.Visible = true;
                lblMessage.Text = "账号或密码错误";
            }
        }

        private bool CheckCustomer(string user, string pwd)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT [顾客会员号], [顾客姓名] FROM [UserInfo] WHERE [顾客登录名] = @u AND [顾客密码] = @p";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@u", user);
                cmd.Parameters.AddWithValue("@p", pwd);
                conn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    Session["UserID"] = r["顾客会员号"];
                    Session["UserName"] = r["顾客姓名"];
                    Session["UserRole"] = "Customer";
                    return true;
                }
                return false;
            }
        }

        private bool CheckEmployee(string user, string pwd)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 根据数据库结构：员工登录账号、员工登录密码、员工系统角色、员工真实姓名、员工工号、所属仓库编号
                string sql = "SELECT [员工工号], [员工真实姓名], [员工系统角色], [所属仓库编号] FROM [AdminInfo] WHERE [员工登录账号] = @u AND [员工登录密码] = @p";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@u", user);
                cmd.Parameters.AddWithValue("@p", pwd);
                conn.Open();
                SqlDataReader r = cmd.ExecuteReader();
                if (r.Read())
                {
                    Session["UserID"] = r["员工工号"];
                    Session["UserName"] = r["员工真实姓名"];
                    // 标准化角色值：Admin/Employee（以“系统管理员”为Admin依据）
                    var roleRaw = r["员工系统角色"].ToString();
                    var role = string.Equals(roleRaw, "系统管理员", StringComparison.OrdinalIgnoreCase) ? "Admin" : "Employee";
                    Session["UserRole"] = role;
                    // 可选：记录所属仓库编号，供库存、发货等页面使用
                    Session["WarehouseID"] = r["所属仓库编号"] == DBNull.Value ? null : r["所属仓库编号"].ToString();
                    return true;
                }
                return false;
            }
        }
    }
}