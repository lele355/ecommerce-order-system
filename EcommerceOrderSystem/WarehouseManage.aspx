<%@ Page Title="仓库管理" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="WarehouseManage.aspx.cs" Inherits="EcommerceOrderSystem.WarehouseManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showWarehouseModal() {
            // 清空表单
            document.querySelector('[id$="txtWarehouseName"]').value = '';
            document.querySelector('[id$="txtLocation"]').value = '';
            document.querySelector('[id$="txtManager"]').value = '';
            document.querySelector('[id$="hfWarehouseId"]').value = '';
            
            // 重置标题
            var titleLabel = document.querySelector('[id$="lblModalTitle"]');
            if (titleLabel) titleLabel.textContent = '新增仓库';
            
            // 显示模态框
            new bootstrap.Modal(document.getElementById('warehouseModal')).show();
        }
    </script>
    <style>
        /* 仓库图标样式 */
        .warehouse-icon-box {
            width: 60px;
            height: 60px;
            border-radius: 0.875rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: white;
            background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%);
            flex-shrink: 0;
            margin-right: 1rem;
            transition: all 0.3s ease;
        }
        
        .warehouse-icon-box:hover {
            transform: scale(1.1) rotate(5deg);
            box-shadow: 0 10px 24px rgba(59, 130, 246, 0.2);
        }
        
        /* 模态框输入框focus样式 */
        #warehouseModal .form-control:focus,
        #warehouseModal .form-select:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.1);
            outline: none;
        }
        
        /* 模态框玻璃效果 */
        #warehouseModal .modal-content {
            background: rgba(255,255,255,0.85);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border: 1px solid rgba(255,255,255,0.35);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold m-0 text-dark">
            <i class="fas fa-warehouse me-2"></i>仓库管理
        </h4>
        <button type="button" class="btn btn-primary rounded-pill fw-bold shadow-sm" onclick="showWarehouseModal()">
            <i class="fas fa-plus me-2"></i>新增仓库
        </button>
    </div>

    <asp:UpdatePanel ID="upWarehouseList" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="glass-card overflow-hidden fade-in">
                <asp:GridView ID="gvWarehouses" runat="server" AutoGenerateColumns="False" 
                    CssClass="table align-middle mb-0" GridLines="None"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvWarehouses_PageIndexChanging" OnRowCommand="gvWarehouses_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="仓库信息" ItemStyle-CssClass="ps-4">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class="warehouse-icon-box">
                                        <i class="fas fa-warehouse"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark fs-5"><%# Eval("仓库名称") %></div>
                                        <div class="small text-muted">
                                            <i class="fas fa-hashtag me-1"></i>ID: <%# Eval("仓库内部编号") %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="物理位置">
                            <ItemTemplate>
                                <div class="text-muted">
                                    <i class="fas fa-map-marker-alt me-2"></i>
                                    <%# string.IsNullOrEmpty(Eval("仓库物理位置")?.ToString()) ? "未设置" : Eval("仓库物理位置") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="负责人">
                            <ItemTemplate>
                                <div>
                                    <i class="fas fa-user-tie me-2 text-primary"></i>
                                    <span class="fw-600"><%# string.IsNullOrEmpty(Eval("仓库负责人姓名")?.ToString()) ? "未设置" : Eval("仓库负责人姓名") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="员工数量" HeaderStyle-CssClass="text-center">
                            <ItemTemplate>
                                <div class="text-center">
                                    <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-2">
                                        <i class="fas fa-users me-1"></i>
                                        <%# GetEmployeeCount(Eval("仓库内部编号")) %> 人
                                    </span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="管理" HeaderStyle-CssClass="text-end pe-4" ItemStyle-CssClass="text-end pe-4" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <div class="d-flex justify-content-end gap-2">
                                    <asp:LinkButton ID="btnEdit" runat="server" 
                                        CssClass="btn btn-sm btn-outline-primary rounded-circle lift-hover" 
                                        CommandName="EditWarehouse" CommandArgument='<%# Eval("仓库内部编号") %>'
                                        ToolTip="编辑仓库"
                                        style="width: 32px; height: 32px;">
                                        <i class="fas fa-pen"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" 
                                        CssClass="btn btn-sm btn-outline-danger rounded-circle lift-hover" 
                                        CommandName="DeleteWarehouse" CommandArgument='<%# Eval("仓库内部编号") %>'
                                        OnClientClick="return confirm('确定要删除这个仓库吗？删除后关联的员工也将受影响！');"
                                        ToolTip="删除仓库"
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

    <!-- 仓库编辑弹窗 -->
    <div class="modal fade" id="warehouseModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem; overflow: hidden;">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- 渐变色头部 -->
                        <div class="modal-header border-0" style="background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); padding: 2rem;">
                            <div>
                                <h4 class="fw-bold text-white mb-1">
                                    <i class="fas fa-warehouse me-2"></i>
                                    <asp:Label ID="lblModalTitle" runat="server" Text="新增仓库"></asp:Label>
                                </h4>
                                <p class="text-white mb-0 opacity-75" style="font-size: 0.875rem;">Warehouse Information</p>
                            </div>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        
                        <div class="modal-body p-4">
                            <asp:HiddenField ID="hfWarehouseId" runat="server" />
                            
                            <!-- 仓库名称 -->
                            <div class="mb-4">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-warehouse"></i>
                                    </div>
                                    <span>仓库名称</span>
                                </label>
                                <asp:TextBox ID="txtWarehouseName" runat="server" CssClass="form-control form-control-lg" 
                                    placeholder="请输入仓库名称..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 物理位置 -->
                            <div class="mb-4">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-map-marker-alt"></i>
                                    </div>
                                    <span>物理位置</span>
                                </label>
                                <asp:TextBox ID="txtLocation" runat="server" CssClass="form-control" 
                                    TextMode="MultiLine" Rows="2"
                                    placeholder="请输入仓库详细地址..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 负责人 -->
                            <div class="mb-3">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #10b981 0%, #059669 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-user-tie"></i>
                                    </div>
                                    <span>负责人姓名</span>
                                </label>
                                <asp:TextBox ID="txtManager" runat="server" CssClass="form-control form-control-lg" 
                                    placeholder="负责人姓名..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                            </div>
                            
                            <!-- 提示信息 -->
                            <div class="alert alert-info mb-0" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); border-radius: 0.75rem;">
                                <i class="fas fa-info-circle me-2"></i>
                                <small>仓库名称为必填项，其他信息可选填</small>
                            </div>
                        </div>
                        
                        <div class="modal-footer border-0 p-4 bg-light">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal" style="font-weight: 600;">
                                <i class="fas fa-times me-2"></i>取消
                            </button>
                            <asp:Button ID="btnSave" runat="server" Text="? 保存仓库" CssClass="btn rounded-pill px-4 py-2" 
                                OnClick="btnSave_Click" 
                                style="background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); color: white; border: none; font-weight: 600;" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>
