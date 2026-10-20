<%@ Page Title="分类管理" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CategoryManage.aspx.cs" Inherits="EcommerceOrderSystem.CategoryManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showCategoryModal() {
            // 清空表单
            document.querySelector('[id$="txtCategoryName"]').value = '';
            document.querySelector('[id$="txtDescription"]').value = '';
            document.querySelector('[id$="hfCategoryId"]').value = '';
            
            // 重置标题
            var titleLabel = document.querySelector('[id$="lblModalTitle"]');
            if (titleLabel) titleLabel.textContent = '新增分类';
            
            // 显示模态框
            new bootstrap.Modal(document.getElementById('categoryModal')).show();
        }
    </script>
    <style>
        /* 分类图标样式 */
        .category-icon-box {
            width: 60px;
            height: 60px;
            border-radius: 0.875rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: white;
            flex-shrink: 0;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }
        
        .category-icon-box:hover {
            transform: scale(1.1) rotate(5deg);
        }
        
        /* 模态框输入框focus样式 */
        #categoryModal .form-control:focus,
        #categoryModal .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            outline: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold m-0 text-dark">
            <i class="fas fa-tags me-2"></i>分类管理
        </h4>
        <button type="button" class="btn btn-success rounded-pill fw-bold shadow-sm" onclick="showCategoryModal()">
            <i class="fas fa-plus me-2"></i>新增分类
        </button>
    </div>

    <asp:UpdatePanel ID="upCategoryList" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="glass-card overflow-hidden">
                <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" 
                    CssClass="table align-middle mb-0" GridLines="None"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvCategories_PageIndexChanging" OnRowCommand="gvCategories_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="分类信息" ItemStyle-CssClass="ps-4">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class="category-icon-box" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                                        <i class="fas fa-folder"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark fs-5"><%# Eval("类别名称") %></div>
                                        <div class="small text-muted">
                                            <i class="fas fa-hashtag me-1"></i>ID: <%# Eval("类别编号") %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="描述">
                            <ItemTemplate>
                                <div class="text-muted">
                                    <i class="fas fa-align-left me-2"></i>
                                    <%# string.IsNullOrEmpty(Eval("类别描述")?.ToString()) ? "暂无描述" : Eval("类别描述") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="管理" ItemStyle-CssClass="text-end pe-4" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <div class="d-flex justify-content-end gap-2">
                                    <asp:LinkButton ID="btnEdit" runat="server" 
                                        CssClass="btn btn-sm btn-outline-primary rounded-circle" 
                                        CommandName="EditCategory" CommandArgument='<%# Eval("类别编号") %>'
                                        ToolTip="编辑分类"
                                        style="width: 32px; height: 32px;">
                                        <i class="fas fa-pen"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" 
                                        CssClass="btn btn-sm btn-outline-danger rounded-circle" 
                                        CommandName="DeleteCategory" CommandArgument='<%# Eval("类别编号") %>'
                                        OnClientClick="return confirm('确定要删除这个分类吗？删除后关联的商品也将受影响！');"
                                        ToolTip="删除分类"
                                        style="width: 32px; height: 32px;">
                                        <i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="grid-pager" />
                    <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="5" />
                    <HeaderStyle CssClass="bg-light text-muted small fw-bold border-bottom" Height="50px" />
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- 分类编辑弹窗 -->
    <div class="modal fade" id="categoryModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem; overflow: hidden;">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- 渐变色头部 -->
                        <div class="modal-header border-0" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 2rem;">
                            <div>
                                <h4 class="fw-bold text-white mb-1">
                                    <i class="fas fa-tags me-2"></i>
                                    <asp:Label ID="lblModalTitle" runat="server" Text="新增分类"></asp:Label>
                                </h4>
                                <p class="text-white mb-0 opacity-75" style="font-size: 0.875rem;">Category Information</p>
                            </div>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        
                        <div class="modal-body p-4">
                            <asp:HiddenField ID="hfCategoryId" runat="server" />
                            
                            <!-- 分类名称 -->
                            <div class="mb-4">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-tag"></i>
                                    </div>
                                    <span>分类名称</span>
                                </label>
                                <asp:TextBox ID="txtCategoryName" runat="server" CssClass="form-control form-control-lg" 
                                    placeholder="请输入分类名称..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 分类描述 -->
                            <div class="mb-3">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #10b981 0%, #059669 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-align-left"></i>
                                    </div>
                                    <span>分类描述</span>
                                </label>
                                <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" 
                                    TextMode="MultiLine" Rows="3"
                                    placeholder="请输入分类描述（可选）..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 提示信息 -->
                            <div class="alert alert-info mb-0" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); border-radius: 0.75rem;">
                                <i class="fas fa-info-circle me-2"></i>
                                <small>分类名称将用于商品归类和筛选</small>
                            </div>
                        </div>
                        
                        <div class="modal-footer border-0 p-4 bg-light">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal" style="font-weight: 600;">
                                <i class="fas fa-times me-2"></i>取消
                            </button>
                            <asp:Button ID="btnSave" runat="server" Text="? 保存分类" CssClass="btn rounded-pill px-4 py-2" 
                                OnClick="btnSave_Click" 
                                style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; border: none; font-weight: 600;" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
