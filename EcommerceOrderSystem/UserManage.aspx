<%@ Page Title="员工管理" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserManage.aspx.cs" Inherits="EcommerceOrderSystem.UserManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showUserModal() { new bootstrap.Modal(document.getElementById('userModal')).show(); }
    </script>
    <style>
        .btn-modern { transition: all 0.25s ease; }
        .btn-modern:active { transform: scale(0.98); }
        .btn-primary-gradient { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; border: none; }
        .btn-primary-gradient:hover { transform: translateY(-2px) scale(1.02); box-shadow: 0 8px 20px rgba(118, 75, 162, 0.4); }
        .glass-toolbar { background: rgba(255,255,255,0.6); border: 1px solid rgba(255,255,255,0.35); box-shadow: 0 12px 30px rgba(31, 38, 135, 0.12); backdrop-filter: blur(12px); -webkit-backdrop-filter: blur(12px); border-radius: 1rem; }
        .modal-content { background: rgba(255,255,255,0.85); backdrop-filter: blur(14px); -webkit-backdrop-filter: blur(14px); border: 1px solid rgba(255,255,255,0.35); box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold m-0 text-dark">员工管理</h4>
        <button type="button" class="btn btn-primary-gradient btn-modern shadow-lg" onclick="showUserModal()">
            <i class="fas fa-user-plus me-2"></i>新增员工
        </button>
    </div>

    <!-- 筛选工具栏 -->
    <div class="glass-toolbar p-3 mb-4 d-flex align-items-center gap-3">
        <div class="input-group" style="max-width: 300px;">
            <span class="input-group-text bg-transparent border-0"><i class="fas fa-search text-muted"></i></span>
            <asp:TextBox ID="txtSearchUser" runat="server" CssClass="form-control border-0 bg-transparent" placeholder="搜索账号/姓名..."></asp:TextBox>
        </div>
        <div class="vr opacity-25"></div>
        <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="form-select border-0 bg-transparent w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlRoleFilter_SelectedIndexChanged">
            <asp:ListItem Text="所有角色" Value="All"></asp:ListItem>
            <asp:ListItem Text="系统管理员" Value="系统管理员"></asp:ListItem>
            <asp:ListItem Text="拣货员" Value="拣货员"></asp:ListItem>
            <asp:ListItem Text="客服" Value="客服"></asp:ListItem>
        </asp:DropDownList>
        <asp:Button ID="btnSearch" runat="server" Text="查询" CssClass="btn btn-sm btn-light rounded-pill px-3 ms-auto fw-bold" OnClick="btnSearch_Click" />
    </div>

    <asp:UpdatePanel ID="upUserList" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="glass-card overflow-hidden fade-in">
                <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" 
                    CssClass="table align-middle mb-0" GridLines="None"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvUsers_PageIndexChanging" OnRowCommand="gvUsers_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="员工详情" ItemStyle-CssClass="ps-4">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class="bg-light rounded-circle p-2 me-3 text-center" style="width:45px;height:45px;">
                                        <i class="fas fa-user text-secondary mt-1"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark"><%# Eval("姓名") %></div>
                                        <div class="small text-muted">账号: <%# Eval("账号") %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="角色">
                            <ItemTemplate>
                                <span class='badge rounded-pill fw-bold px-3 <%# GetRoleClass(Eval("角色").ToString()) %>'>
                                    <%# Eval("角色") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:BoundField DataField="所属仓库" HeaderText="所属仓库" NullDisplayText="-" />

                        <asp:TemplateField HeaderText="操作" HeaderStyle-CssClass="text-end pe-4" ItemStyle-CssClass="text-end pe-4">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnEdit" runat="server" CssClass="btn btn-sm btn-light border rounded-pill me-2 lift-hover" CommandName="EditUser" CommandArgument='<%# Eval("ID") %>' ToolTip="编辑">
                                    <i class="fas fa-edit text-primary"></i>
                                </asp:LinkButton>
                                <asp:LinkButton ID="btnResetPwd" runat="server" CssClass="btn btn-sm btn-light border rounded-pill lift-hover" CommandName="ResetPwd" CommandArgument='<%# Eval("ID") %>' OnClientClick="return confirm('确定重置密码为 123456 吗？');" ToolTip="重置密码">
                                    <i class="fas fa-key text-warning"></i>
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="p-3 text-center" />
                    <HeaderStyle CssClass="bg-light text-uppercase small fw-bold text-muted border-bottom" Height="50px" />
                    <PagerStyle CssClass="grid-pager" />
                    <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="5" />
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- 新增/编辑用户 Modal -->
    <div class="modal fade" id="userModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg rounded-4 fade-in">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="modal-header border-0 pb-0">
                            <h5 class="modal-title fw-bold">员工信息维护</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <asp:HiddenField ID="hfEditId" runat="server" />
                            
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">登录账号</label>
                                <asp:TextBox ID="txtModalAccount" runat="server" CssClass="form-control form-control-lg bg-light border-0"></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">真实姓名</label>
                                <asp:TextBox ID="txtModalName" runat="server" CssClass="form-control form-control-lg bg-light border-0"></asp:TextBox>
                            </div>
                            
                            <div class="row">
                                <div class="col-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">系统角色</label>
                                    <asp:DropDownList ID="ddlModalRole" runat="server" CssClass="form-select form-select-lg bg-light border-0">
                                        <asp:ListItem Text="系统管理员" Value="系统管理员"></asp:ListItem>
                                        <asp:ListItem Text="拣货员" Value="拣货员"></asp:ListItem>
                                        <asp:ListItem Text="客服" Value="客服"></asp:ListItem>
                                        <asp:ListItem Text="仓库经理" Value="仓库经理"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">所属仓库</label>
                                    <asp:DropDownList ID="ddlModalWarehouse" runat="server" CssClass="form-select form-select-lg bg-light border-0"></asp:DropDownList>
                                </div>
                            </div>
                            
                            <div class="alert alert-info border-0 d-flex align-items-center small">
                                <i class="fas fa-info-circle me-2"></i> 新增员工的默认密码为 123456
                            </div>
                        </div>
                        <div class="modal-footer border-0 pt-0">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">取消</button>
                            <asp:Button ID="btnSaveUser" runat="server" Text="保存信息" CssClass="btn btn-primary rounded-pill px-4 fw-bold" OnClick="btnSaveUser_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>