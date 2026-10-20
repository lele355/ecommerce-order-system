using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EcommerceOrderSystem
{
    public partial class UserManage : Page
    {
        string connStr = ConfigurationManager.ConnectionStrings["EcommerceDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 权限检查（Admin源自员工系统角色=系统管理员）
                if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                {
                    Response.Redirect("Dashboard.aspx"); // 非管理员踢回仪表盘
                    return;
                }
                BindWarehouses();
                BindUsers();
            }
        }

        private void BindWarehouses()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT [仓库内部编号], [仓库名称] FROM [Warehouse]";
                SqlDataAdapter da = new SqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ddlModalWarehouse.DataSource = dt;
                ddlModalWarehouse.DataTextField = "仓库名称";
                ddlModalWarehouse.DataValueField = "仓库内部编号";
                ddlModalWarehouse.DataBind();
                ddlModalWarehouse.Items.Insert(0, new ListItem("无/总部", "0"));
            }
        }

        private void BindUsers()
        {
            string keyword = txtSearchUser.Text.Trim();
            string roleFilter = ddlRoleFilter.SelectedValue;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 仅员工数据
                string sql = @"
                    SELECT CAST(A.[员工工号] AS VARCHAR) AS ID,
                           A.[员工登录账号] AS 账号,
                           A.[员工真实姓名] AS 姓名,
                           A.[员工系统角色] AS 角色,
                           W.[仓库名称] AS 所属仓库
                    FROM [AdminInfo] A
                    LEFT JOIN [Warehouse] W ON A.[所属仓库编号] = W.[仓库内部编号]
                    WHERE 1=1";

                if (!string.IsNullOrEmpty(keyword)) sql += " AND (A.[员工登录账号] LIKE @kw OR A.[员工真实姓名] LIKE @kw)";
                if (roleFilter != "All") sql += " AND A.[员工系统角色] = @role";

                sql += " ORDER BY A.[员工工号] ASC";

                SqlCommand cmd = new SqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(keyword)) cmd.Parameters.AddWithValue("@kw", "%" + keyword + "%");
                if (roleFilter != "All") cmd.Parameters.AddWithValue("@role", roleFilter);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e) { BindUsers(); }
        protected void ddlRoleFilter_SelectedIndexChanged(object sender, EventArgs e) { BindUsers(); }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            // 简单实现：新增员工（暂不支持编辑已有员工的复杂逻辑，为了演示方便）
            string account = txtModalAccount.Text.Trim();
            string name = txtModalName.Text.Trim();
            string role = ddlModalRole.SelectedValue;
            int whId = Convert.ToInt32(ddlModalWarehouse.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 默认密码 123456
                string sql = "INSERT INTO [AdminInfo] ([所属仓库编号], [员工登录账号], [员工登录密码], [员工真实姓名], [员工系统角色]) VALUES (@wh, @acc, '123456', @name, @role)";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@wh", whId == 0 ? 1 : whId); // 默认仓1
                cmd.Parameters.AddWithValue("@acc", account);
                cmd.Parameters.AddWithValue("@name", name);
                cmd.Parameters.AddWithValue("@role", role);

                conn.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                    ScriptManager.RegisterStartupScript(this, GetType(), "hide", "bootstrap.Modal.getInstance(document.getElementById('userModal')).hide(); toastr.success('员工添加成功');", true);
                    BindUsers();
                    upUserList.Update();
                }
                catch
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "err", "toastr.error('账号可能已存在');", true);
                }
            }
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            string id = e.CommandArgument.ToString();

            if (e.CommandName == "ResetPwd")
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "UPDATE AdminInfo SET 员工登录密码='123456' WHERE 员工工号=@id";
                    SqlCommand cmd = new SqlCommand(sql, conn);
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "toast", "toastr.success('密码已重置为 123456');", true);
            }
        }

        protected void gvUsers_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            gvUsers.PageIndex = e.NewPageIndex;
            BindUsers();
        }

        public string GetRoleClass(string role)
        {
            switch (role)
            {
                case "Customer": return "bg-info bg-opacity-10 text-info";
                case "系统管理员": return "bg-primary text-white";
                case "拣货员": return "bg-warning bg-opacity-25 text-warning";
                default: return "bg-secondary bg-opacity-10 text-secondary";
            }
        }
    }
}