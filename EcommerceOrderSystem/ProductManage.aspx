<%@ Page Title="商品档案" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductManage.aspx.cs" Inherits="EcommerceOrderSystem.ProductManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showProdModal() {
            // 清空表单
            document.querySelector('[id$="txtName"]').value = '';
            document.querySelector('[id$="txtPrice"]').value = '';
            document.querySelector('[id$="txtCost"]').value = '';
            document.querySelector('[id$="hfProdId"]').value = '';
            
            // 重置标题
            var titleLabel = document.querySelector('[id$="lblModalTitle"]');
            if (titleLabel) titleLabel.textContent = '录入新商品';
            
            // 显示模态框
            new bootstrap.Modal(document.getElementById('prodModal')).show();
        }

        // 打开编辑弹窗的辅助方法（供服务端触发）
        function showEditModal() {
            var titleLabel = document.querySelector('[id$="lblModalTitle"]');
            if (titleLabel) titleLabel.textContent = '编辑商品信息';
            new bootstrap.Modal(document.getElementById('prodModal')).show();
        }
    </script>
    <style>
        /* 全局柔和过渡与动效工具 */
        .soft-transition { transition: all 0.3s ease; }
        .lift-hover:hover { transform: translateY(-2px); box-shadow: 0 8px 28px rgba(0,0,0,0.08); }
        .fade-in { animation: fadeIn 0.4s ease both; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px);} to { opacity: 1; transform: none; } }

        /* 玻璃质感卡片（增强版） */
        .glass-card {
            background: rgba(255, 255, 255, 0.55);
            border: 1px solid rgba(255, 255, 255, 0.18);
            box-shadow: 0 8px 32px rgba(31, 38, 135, 0.12);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 1rem;
        }

        /* 表格样式微调与悬停玻璃效果 */
        .table tr { transition: background 0.25s ease; }
        .table tbody tr:hover { background: rgba(255,255,255,0.6); }
        .table thead tr { backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px); }

        /* 按钮与徽章的细节优化 */
        .btn { transition: all 0.25s ease; }
        .btn:active { transform: scale(0.98); }
        .badge { backdrop-filter: blur(4px); -webkit-backdrop-filter: blur(4px); }

        /* 搜索栏与筛选区域优化 */
        .glass-toolbar {
            background: rgba(255, 255, 255, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 6px 24px rgba(31, 38, 135, 0.12);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            border-radius: 1rem;
        }

        /* 商品图标样式 */
        .product-icon-box {
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
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .product-icon-box:hover {
            transform: scale(1.08) rotate(3deg);
            box-shadow: 0 10px 24px rgba(0,0,0,0.15);
        }
        
        /* 分类渐变色 */
        .icon-box-electronics { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .icon-box-home { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .icon-box-fashion { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .icon-box-books { background: linear-gradient(135deg, #30cfd0 0%, #330867 100%); }
        .icon-box-food { background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%); }
        .icon-box-sports { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .icon-box-beauty { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .icon-box-toys { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }
        .icon-box-default { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }
        
        /* 模态框输入框focus样式 */
        #prodModal .form-control:focus,
        #prodModal .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            outline: none;
        }
        
        #prodModal .input-group-text {
            font-weight: 600;
            color: #6b7280;
        }

        /* 模态框玻璃主体与进入动画 */
        #prodModal .modal-content {
            background: rgba(255,255,255,0.7);
            backdrop-filter: blur(14px);
            -webkit-backdrop-filter: blur(14px);
            border: 1px solid rgba(255,255,255,0.2);
            animation: fadeIn 0.35s ease both;
        }

        /* 网格分页器与头部玻璃效果 */
        .grid-pager { backdrop-filter: blur(6px); -webkit-backdrop-filter: blur(6px); }
        .bg-light { background-color: rgba(248,249,250,0.75) !important; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold m-0 text-dark">商品档案中心</h4>
        <button type="button" class="btn btn-success rounded-pill fw-bold shadow-sm" onclick="showProdModal()">
            <i class="fas fa-plus me-2"></i>录入商品
        </button>
    </div>

    <!-- 搜索与筛选栏 -->
    <div class="glass-toolbar p-3 mb-4 d-flex align-items-center gap-3 flex-wrap fade-in">
        <div class="input-group" style="max-width: 360px;">
            <asp:TextBox ID="txtSearchProd" runat="server" CssClass="form-control border-0 bg-transparent soft-transition" placeholder="商品名称/编号..."></asp:TextBox>
            <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-light border lift-hover" OnClick="btnSearch_Click" />
        </div>
        <div class="d-flex align-items-center gap-2">
            <span class="text-muted small">按分类筛选</span>
            <asp:DropDownList ID="ddlFilterCategory" runat="server" CssClass="form-select soft-transition" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterCategory_SelectedIndexChanged" style="min-width: 200px;"></asp:DropDownList>
        </div>
    </div>

    <asp:UpdatePanel ID="upProdList" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="glass-card overflow-hidden fade-in">
                <asp:GridView ID="gvProducts" runat="server" AutoGenerateColumns="False" 
                    CssClass="table align-middle mb-0" GridLines="None"
                    AllowPaging="True" PageSize="8" OnPageIndexChanging="gvProducts_PageIndexChanging" OnRowCommand="gvProducts_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="商品信息" ItemStyle-CssClass="ps-4">
                            <ItemTemplate>
                                <div class="d-flex align-items-center">
                                    <div class='product-icon-box <%# GetCategoryColorClass(Eval("类别名称")?.ToString()) %>'>
                                        <i class='<%# GetCategoryIcon(Eval("类别名称")?.ToString()) %>'></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold text-dark"><%# Eval("商品标准名称") %></div>
                                        <div class="small text-muted">
                                            <i class="fas fa-hashtag me-1"></i><%# Eval("商品编号") %>
                                            <span class="mx-2">·</span>
                                            <i class="fas fa-tag me-1"></i><%# Eval("类别名称") %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="分类">
                            <ItemTemplate>
                                <span class="badge bg-light text-dark border px-3 py-2">
                                    <i class="fas fa-folder me-1"></i>
                                    <%# Eval("类别名称") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="售价">
                            <ItemTemplate>
                                <span class="fw-bold text-primary"><%# Eval("商品销售单价", "{0:C}") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="成本">
                            <ItemTemplate>
                                <span class="text-muted"><%# Eval("商品进货成本价", "{0:C}") %></span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="状态">
                            <ItemTemplate>
                                <span class='badge rounded-pill fw-normal <%# Convert.ToBoolean(Eval("商品是否上架")) ? "bg-success bg-opacity-10 text-success" : "bg-secondary bg-opacity-10 text-secondary" %>'>
                                    <%# Convert.ToBoolean(Eval("商品是否上架")) ? "上架中" : "已下架" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="管理" HeaderStyle-CssClass="text-end pe-4" ItemStyle-CssClass="text-end pe-4" ItemStyle-Width="220px">
                            <ItemTemplate>
                                <div class="d-flex justify-content-end gap-2">
                                    <asp:LinkButton ID="btnToggle" runat="server" 
                                        CssClass='<%# "btn btn-sm rounded-pill fw-bold lift-hover " + (Convert.ToBoolean(Eval("商品是否上架")) ? "btn-outline-warning" : "btn-outline-success") %>' 
                                        CommandName="ToggleStatus" CommandArgument='<%# Eval("商品编号") %>'
                                        ToolTip='<%# Convert.ToBoolean(Eval("商品是否上架")) ? "下架商品" : "上架商品" %>'
                                        style="min-width: 80px;">
                                        <i class='<%# "fas " + (Convert.ToBoolean(Eval("商品是否上架")) ? "fa-eye-slash" : "fa-eye") + " me-1" %>'></i>
                                        <%# Convert.ToBoolean(Eval("商品是否上架")) ? "下架" : "上架" %>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnEdit" runat="server" 
                                        CssClass="btn btn-sm btn-outline-primary rounded-circle lift-hover" 
                                        CommandName="EditProd" CommandArgument='<%# Eval("商品编号") %>'
                                        ToolTip="编辑商品"
                                        style="width: 32px; height: 32px;">
                                        <i class="fas fa-pen"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" 
                                        CssClass="btn btn-sm btn-outline-danger rounded-circle lift-hover" 
                                        CommandName="DeleteProd" CommandArgument='<%# Eval("商品编号") %>'
                                        OnClientClick="return confirm('确定要删除这个商品吗？此操作不可恢复！');"
                                        ToolTip="删除商品"
                                        style="width: 32px; height: 32px;">
                                        <i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="p-3 text-center" />
                    <HeaderStyle CssClass="bg-light text-muted small fw-bold border-bottom" Height="50px" />
                    <PagerStyle CssClass="grid-pager" />
                    <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="5" />
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- 商品编辑弹窗 (Modal) - 优化版 -->
    <div class="modal fade" id="prodModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 1.5rem; overflow: hidden;">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- 渐变色头部 -->
                        <div class="modal-header border-0" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 2rem;">
                            <div>
                                <h4 class="fw-bold text-white mb-1">
                                    <i class="fas fa-box me-2"></i>
                                    <asp:Label ID="lblModalTitle" runat="server" Text="录入新商品"></asp:Label>
                                </h4>
                                <p class="text-white mb-0 opacity-75" style="font-size: 0.875rem;">Product Information</p>
                            </div>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        
                        <div class="modal-body p-4 fade-in">
                            <asp:HiddenField ID="hfProdId" runat="server" />
                            
                            <!-- 商品名称 -->
                            <div class="mb-4 fade-in">
                                <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                    <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                        <i class="fas fa-tag"></i>
                                    </div>
                                    <span>商品名称</span>
                                </label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-lg" 
                                    placeholder="请输入商品标准名称..." 
                                    style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem; transition: all 0.3s;"></asp:TextBox>
                            </div>
                            
                            <!-- 分类和供应商 -->
                            <div class="row g-4 mb-4 fade-in">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                        <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #10b981 0%, #059669 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                            <i class="fas fa-folder"></i>
                                        </div>
                                        <span>所属分类</span>
                                    </label>
                                    <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select form-select-lg"
                                        style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:DropDownList>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                        <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                            <i class="fas fa-truck"></i>
                                        </div>
                                        <span>供应商</span>
                                    </label>
                                    <asp:DropDownList ID="ddlSupplier" runat="server" CssClass="form-select form-select-lg"
                                        style="border: 2px solid #e5e7eb; border-radius: 0.75rem; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:DropDownList>
                                </div>
                            </div>

                            <!-- 价格信息 -->
                            <div class="row g-4 mb-3 fade-in">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                        <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #3b82f6 0%, #2563eb 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                            <i class="fas fa-dollar-sign"></i>
                                        </div>
                                        <span>销售价格</span>
                                    </label>
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text" style="background: #f3f4f6; border: 2px solid #e5e7eb; border-right: none; border-radius: 0.75rem 0 0 0.75rem;">¥</span>
                                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" TextMode="Number" step="0.01"
                                            placeholder="0.00"
                                            style="border: 2px solid #e5e7eb; border-left: none; border-radius: 0 0.75rem 0.75rem 0; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold mb-2 d-flex align-items-center">
                                        <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                            <i class="fas fa-coins"></i>
                                        </div>
                                        <span>成本价格</span>
                                    </label>
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text" style="background: #f3f4f6; border: 2px solid #e5e7eb; border-right: none; border-radius: 0.75rem 0 0 0.75rem;">¥</span>
                                        <asp:TextBox ID="txtCost" runat="server" CssClass="form-control" TextMode="Number" step="0.01"
                                            placeholder="0.00"
                                            style="border: 2px solid #e5e7eb; border-left: none; border-radius: 0 0.75rem 0.75rem 0; padding: 0.875rem 1.25rem; font-size: 1rem;"></asp:TextBox>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 提示信息 -->
                            <div class="alert alert-info mb-0" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); border-radius: 0.75rem;">
                                <i class="fas fa-info-circle me-2"></i>
                                <small>请确保所有信息填写完整且准确</small>
                            </div>
                        </div>
                        
                        <div class="modal-footer border-0 p-4 bg-light fade-in">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal" style="font-weight: 600;">
                                <i class="fas fa-times me-2"></i>取消
                            </button>
                            <asp:Button ID="btnSave" runat="server" Text="✓ 保存商品" CssClass="btn rounded-pill px-4 py-2" 
                                OnClick="btnSave_Click" 
                                style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; border: none; font-weight: 600;" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>