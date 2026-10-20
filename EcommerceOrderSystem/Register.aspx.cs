using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace EcommerceOrderSystem
{
    public partial class Register : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 清空任何会话
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // 隐藏之前的消息
            pnlSuccess.Visible = false;
            pnlError.Visible = false;

            // 获取输入
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string realName = txtRealName.Text.Trim();

            // 验证输入
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password) || string.IsNullOrEmpty(realName))
            {
                ShowError("请填写完整的注册信息");
                return;
            }

            if (username.Length < 3)
            {
                ShowError("用户名长度至少3个字符");
                return;
            }

            if (password.Length < 6)
            {
                ShowError("密码长度至少6个字符");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    // 检查用户名是否已存在
                    string checkSql = "SELECT COUNT(1) FROM [UserInfo] WHERE [顾客登录名] = @username";
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@username", username);
                        int count = Convert.ToInt32(checkCmd.ExecuteScalar());
                        
                        if (count > 0)
                        {
                            ShowError("用户名已存在，请使用其他用户名");
                            return;
                        }
                    }

                    // 插入新用户
                    string insertSql = "INSERT INTO [UserInfo] ([顾客登录名], [顾客密码], [顾客姓名]) VALUES (@username, @password, @realName)";
                    using (SqlCommand insertCmd = new SqlCommand(insertSql, conn))
                    {
                        insertCmd.Parameters.AddWithValue("@username", username);
                        insertCmd.Parameters.AddWithValue("@password", password);
                        insertCmd.Parameters.AddWithValue("@realName", realName);
                        
                        int result = insertCmd.ExecuteNonQuery();
                        
                        if (result > 0)
                        {
                            // 注册成功
                            ShowSuccess("注册成功！3秒后自动跳转到登录页面...");
                            
                            // 清空输入框
                            txtUsername.Text = "";
                            txtPassword.Text = "";
                            txtRealName.Text = "";
                            
                            // 禁用注册按钮
                            btnRegister.Enabled = false;
                            
                            // 3秒后跳转到登录页
                            string script = "setTimeout(function(){ window.location='Login.aspx'; }, 3000);";
                            ScriptManager.RegisterStartupScript(this, GetType(), "redirect", script, true);
                        }
                        else
                        {
                            ShowError("注册失败，请稍后重试");
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowError("系统错误：" + ex.Message);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx");
        }

        private void ShowError(string message)
        {
            pnlError.Visible = true;
            lblError.Text = message;
        }

        private void ShowSuccess(string message)
        {
            pnlSuccess.Visible = true;
            lblSuccess.Text = message;
        }
    }
}
