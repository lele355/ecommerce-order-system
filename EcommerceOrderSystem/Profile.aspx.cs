using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace EcommerceOrderSystem
{
    public partial class Profile : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. 权限检查：必须登录
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
            }
        }

        private void LoadProfile()
        {
            long uid = Convert.ToInt64(Session["UserID"]);
            
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                
                // 加载用户基本信息 - 根据 UserInfo 表结构
                string sql = @"SELECT [顾客登录名], [顾客姓名], [顾客手机号], 
                                      [顾客默认收货地址], [顾客注册时间] 
                               FROM [UserInfo] 
                               WHERE [顾客会员号] = @uid";
                
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@uid", uid);
                SqlDataReader r = cmd.ExecuteReader();
                
                if (r.Read())
                {
                    // 填充基本信息
                    txtAccount.Text = r["顾客登录名"].ToString();
                    txtName.Text = r["顾客姓名"].ToString();
                    txtPhone.Text = r["顾客手机号"].ToString();
                    txtAddress.Text = r["顾客默认收货地址"].ToString();
                    
                    // 注册时间
                    if (r["顾客注册时间"] != DBNull.Value)
                    {
                        txtRegisterTime.Text = Convert.ToDateTime(r["顾客注册时间"]).ToString("yyyy-MM-dd HH:mm");
                    }
                    
                    // 设置头部显示信息
                    string userName = r["顾客姓名"].ToString();
                    lblUserName.Text = string.IsNullOrEmpty(userName) ? r["顾客登录名"].ToString() : userName;
                }
                r.Close();
                
                // 加载统计数据 - 总订单数
                string sqlTotal = "SELECT COUNT(*) FROM [OrderMaster] WHERE [下单顾客编号] = @uid";
                SqlCommand cmdTotal = new SqlCommand(sqlTotal, conn);
                cmdTotal.Parameters.AddWithValue("@uid", uid);
                lblTotalOrders.Text = cmdTotal.ExecuteScalar().ToString();
                
                // 加载统计数据 - 待处理订单（待付款+待发货+已发货）
                string sqlPending = @"SELECT COUNT(*) FROM [OrderMaster] 
                                     WHERE [下单顾客编号] = @uid 
                                     AND [订单流转状态] IN (N'待付款', N'待发货', N'已发货')";
                SqlCommand cmdPending = new SqlCommand(sqlPending, conn);
                cmdPending.Parameters.AddWithValue("@uid", uid);
                lblPendingOrders.Text = cmdPending.ExecuteScalar().ToString();
                
                // 加载统计数据 - 累计消费（已完成订单）
                string sqlSpent = @"SELECT ISNULL(SUM([订单总金额]), 0) 
                                   FROM [OrderMaster] 
                                   WHERE [下单顾客编号] = @uid 
                                   AND [订单流转状态] = N'已完成'";
                SqlCommand cmdSpent = new SqlCommand(sqlSpent, conn);
                cmdSpent.Parameters.AddWithValue("@uid", uid);
                decimal totalSpent = Convert.ToDecimal(cmdSpent.ExecuteScalar());
                lblTotalSpent.Text = totalSpent.ToString("C");
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            long uid = Convert.ToInt64(Session["UserID"]);
            
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();
                    
                    // 1. 验证输入
                    string newAccount = txtAccount.Text.Trim();
                    string newName = txtName.Text.Trim();
                    string newPhone = txtPhone.Text.Trim();
                    string newAddress = txtAddress.Text.Trim();
                    string newPassword = txtNewPassword.Text.Trim();
                    string confirmPassword = txtConfirmPassword.Text.Trim();
                    
                    // 基本验证
                    if (string.IsNullOrEmpty(newAccount) || string.IsNullOrEmpty(newName))
                    {
                        pnlError.Visible = true;
                        ltError.Text = "账号和姓名不能为空！";
                        pnlSuccess.Visible = false;
                        return;
                    }
                    
                    // 2. 检查账号是否被占用
                    string sqlCheck = "SELECT COUNT(1) FROM [UserInfo] WHERE [顾客登录名] = @acc AND [顾客会员号] <> @uid";
                    using (SqlCommand cmdCheck = new SqlCommand(sqlCheck, conn))
                    {
                        cmdCheck.Parameters.AddWithValue("@acc", newAccount);
                        cmdCheck.Parameters.AddWithValue("@uid", uid);
                        int exists = Convert.ToInt32(cmdCheck.ExecuteScalar() ?? 0);
                        if (exists > 0)
                        {
                            pnlError.Visible = true;
                            ltError.Text = "该账号已被其他用户占用，请更换！";
                            pnlSuccess.Visible = false;
                            return;
                        }
                    }
                    
                    // 3. 处理密码修改
                    bool updatePassword = false;
                    if (!string.IsNullOrEmpty(newPassword))
                    {
                        // 验证密码
                        if (newPassword.Length < 6)
                        {
                            pnlError.Visible = true;
                            ltError.Text = "密码长度至少6位！";
                            pnlSuccess.Visible = false;
                            return;
                        }
                        
                        if (newPassword != confirmPassword)
                        {
                            pnlError.Visible = true;
                            ltError.Text = "两次输入的密码不一致！";
                            pnlSuccess.Visible = false;
                            return;
                        }
                        
                        updatePassword = true;
                    }
                    
                    // 4. 更新用户信息
                    string sqlUpdate;
                    if (updatePassword)
                    {
                        // 更新包括密码
                        sqlUpdate = @"UPDATE [UserInfo] 
                                     SET [顾客登录名]=@acc, 
                                         [顾客姓名]=@name, 
                                         [顾客手机号]=@phone, 
                                         [顾客默认收货地址]=@addr,
                                         [顾客密码]=@pwd
                                     WHERE [顾客会员号]=@uid";
                    }
                    else
                    {
                        // 不更新密码
                        sqlUpdate = @"UPDATE [UserInfo] 
                                     SET [顾客登录名]=@acc, 
                                         [顾客姓名]=@name, 
                                         [顾客手机号]=@phone, 
                                         [顾客默认收货地址]=@addr
                                     WHERE [顾客会员号]=@uid";
                    }

                    using (SqlCommand cmd = new SqlCommand(sqlUpdate, conn))
                    {
                        cmd.Parameters.AddWithValue("@acc", newAccount);
                        cmd.Parameters.AddWithValue("@name", newName);
                        cmd.Parameters.AddWithValue("@phone", string.IsNullOrEmpty(newPhone) ? (object)DBNull.Value : newPhone);
                        cmd.Parameters.AddWithValue("@addr", string.IsNullOrEmpty(newAddress) ? (object)DBNull.Value : newAddress);
                        cmd.Parameters.AddWithValue("@uid", uid);
                        
                        if (updatePassword)
                        {
                            cmd.Parameters.AddWithValue("@pwd", newPassword);
                        }
                        
                        int rowsAffected = cmd.ExecuteNonQuery();
                        
                        if (rowsAffected > 0)
                        {
                            // 5. 更新 Session
                            Session["UserName"] = newName;
                            Session["UserAccount"] = newAccount;
                            
                            // 6. 重新加载数据
                            LoadProfile();
                            
                            // 7. 显示成功消息
                            pnlError.Visible = false;
                            pnlSuccess.Visible = true;
                            
                            // 8. 清空密码框
                            txtNewPassword.Text = "";
                            txtConfirmPassword.Text = "";
                            
                            // 9. 如果修改了密码，添加额外提示
                            if (updatePassword)
                            {
                                ScriptManager.RegisterStartupScript(this, GetType(), "success", 
                                    "if(window.toastr) toastr.success('个人信息和密码已更新成功！');", true);
                            }
                        }
                        else
                        {
                            pnlError.Visible = true;
                            ltError.Text = "更新失败，请稍后重试！";
                            pnlSuccess.Visible = false;
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                pnlError.Visible = true;
                ltError.Text = "保存失败：" + ex.Message;
                pnlSuccess.Visible = false;
            }
        }
    }
}