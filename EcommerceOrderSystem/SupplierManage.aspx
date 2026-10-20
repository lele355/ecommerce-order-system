<%@ Page Title="供应商管理" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="SupplierManage.aspx.cs" Inherits="EcommerceOrderSystem.SupplierManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showSupplierModal() {
            // 清空表单
            document.querySelector('[id$="txtCompanyName"]').value = '';
            document.querySelector('[id$="txtContact"]').value = '';
            document.querySelector('[id$="txtPhone"]').value = '';
            document.querySelector('[id$="txtAddress"]').value = '';
            document.querySelector('[id$="hfSupplierId"]').value = '';
            
            // 重置标题
            var titleLabel = document.querySelector('[id$="lblModalTitle"]');
            if (titleLabel) titleLabel.textContent = '新增供应商';
            
            // 显示模态框
            new bootstrap.Modal(document.getElementById('supplierModal')).show();
        }
    </script>
    <style>
        /* 供应商图标样式 */
        .supplier-icon-box {
            width: 60px;
            height: 60px;
            border-radius: 0.875rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: white;
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            flex-shrink: 0;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }
        
        .supplier-icon-box:hover {
            transform: scale(1.1) rotate(5deg);
        }
        
        /* 模态框输入框focus样式 */
        #supplierModal .form-control:focus,
        #supplierModal .form-select:focus {
            border-color: #f59e0b;
            box-shadow: 0 0 0 4px rgba(245, 158, 11, 0.1);
            outline: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold m-0 text-dark">
            <i class="fas fa-truck me-2"></i>供应商管理
        </h4>
        <button type="button" class="btn btn-warning rounded-pill fw-bold shadow-sm" onclick="showSupplierModal()">
            <i class="fas fa-plus me-2"></i>新增供应商
        </button>
    </div>

    <asp:UpdatePanel ID="upSupplierList" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="glass-card overflow-hidden">
                <asp:GridView ID="gvSuppliers" runat="server" AutoGenerateColumns="False" 
                    CssClass="table align-middle mb-0" GridLines="None"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvSuppliers_PageIndexChanging" OnRowCommand="gvSuppliers_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="供应商信息" ItemStyle-CssClass="ps-4">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class="supplier-icon-box">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark fs-5"><%# Eval("供应商企业名称") %></div>
                                        <div class="small text-muted">
                                            <i class="fas fa-hashtag me-1"></i>ID: <%# Eval("供应商编号") %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="联系人">
                            <ItemTemplate>
                                <div>
                                    <i class="fas fa-user me-2 text-muted"></i>
                                    <span class="fw-600"><%# string.IsNullOrEmpty(Eval("供方联系人")?.ToString()) ? "未设置" : Eval("供方联系人") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="联系电话">
                            <ItemTemplate>
                                <div>
                                    <i class="fas fa-phone me-2 text-muted"></i>
                                    <span class="fw-600"><%# string.IsNullOrEmpty(Eval("供方联系电话")?.ToString()) ? "未设置" : Eval("供方联系电话") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="地址">
                            <ItemTemplate>
                                <div class="text-muted">
                                    <i class="fas fa-map-marker-alt me-2"></i>
                                    <%# string.IsNullOrEmpty(Eval("供应商所在地址")?.ToString()) ? "未设置" : Eval("供应商所在地址") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="管理" ItemStyle-CssClass="text-end pe-4" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <div class="d-flex justify-content-end gap-2">
                                    <asp:LinkButton ID="btnEdit" runat="server" 
                                        CssClass="btn btn-sm btn-outline-primary rounded-circle" 
                                        CommandName="EditSupplier" CommandArgument='<%# Eval("供应商编号") %>'
                                        ToolTip="编辑供应商"
                                        style="width: 32px; height: 32px;">
                                        <i class="fas fa-pen"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" 
                                        CssClass="btn btn-sm btn-outline-danger rounded-circle" 
                                        CommandName="DeleteSupplier" CommandArgument='<%# Eval("供应商编号") %>'
                                        OnClientClick="return confirm('确定要删除这个供应商吗？删除后关联的商品也将受影响！');"
                                        ToolTip="删除供应商"
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

    <!-- 供应商编辑弹窗 -->
    <div class="modal fade" id="supplierModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem; overflow: hidden;">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- 渐变色头部 -->
                        <div class="modal-header border-0" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); padding: 2rem;">
                            <div>
                                <h4 class="fw-bold text-white mb-1">
                                    <i class="fas fa-truck me-2"></i>
                                    <asp:Label ID="lblModalTitle" runat="server" Text="新增供应商"></asp:Label>
                                </h4>
                                <p class="text-white mb-0 opacity-75" style="font-size: 0.875rem;">Supplier Information</p>
                            </div>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        
                        <div class="modal-body p-4">
                            <asp:HiddenField ID="hfSupplierId" runat="server" />
                            
                            <!-- 企业名称 -->
                            <div class="mb-4">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-building"></i>
                                    </div>
                                    <span>企业名称</span>
                                </label>
                                <asp:TextBox ID="txtCompanyName" runat="server" CssClass="form-control form-control-lg" 
                                    placeholder="请输入供应商企业名称..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 联系人和电话 -->
                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                        <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <span>联系人</span>
                                    </label>
                                    <asp:TextBox ID="txtContact" runat="server" CssClass="form-control form-control-lg" 
                                        placeholder="联系人姓名..." 
                                        style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                        <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #10b981 0%, #059669 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                            <i class="fas fa-phone"></i>
                                        </div>
                                        <span>联系电话</span>
                                    </label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-lg" 
                                        placeholder="联系电话..." 
                                        style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                                </div>
                            </div>
                            
                            <!-- 地址 -->
                            <div class="mb-3">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <span>供应商地址</span>
                                </label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control" 
                                    TextMode="MultiLine" Rows="2"
                                    placeholder="请输入供应商详细地址..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 提示信息 -->
                            <div class="alert alert-warning mb-0" style="background: rgba(245, 158, 11, 0.1); border: 1px solid rgba(245, 158, 11, 0.2); border-radius: 0.75rem;">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <small>企业名称为必填项，其他信息可选填</small>
                            </div>
                        </div>
                        
                        <div class="modal-footer border-0 p-4 bg-light">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal" style="font-weight: 600;">
                                <i class="fas fa-times me-2"></i>取消
                            </button>
                            <asp:Button ID="btnSave" runat="server" Text="? 保存供应商" CssClass="btn rounded-pill px-4 py-2" 
                                OnClick="btnSave_Click" 
                                style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); color: white; border: none; font-weight: 600;" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
