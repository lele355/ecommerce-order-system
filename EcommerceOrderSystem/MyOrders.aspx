<%@ Page Title="我的订单" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyOrders.aspx.cs" Inherits="EcommerceOrderSystem.MyOrders" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <style>
        .order-card {
            background: white;
            border-radius: 18px;
            padding: 24px;
            margin-bottom: 18px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
        }
        .order-card:hover {
            border-color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
        }
        
        /* Grid布局确保列对齐 */
        .order-grid {
            display: grid;
            grid-template-columns: 200px 140px 1fr 130px 110px 50px;
            gap: 20px;
            align-items: center;
        }
        
        @media (max-width: 992px) {
            .order-grid {
                grid-template-columns: 1fr;
                gap: 12px;
            }
        }
        
        .order-field-label {
            font-size: 0.75rem;
            color: #a0aec0;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 0.5px;
            margin-bottom: 4px;
        }
        
        .order-field-value {
            color: #2d3748;
            font-weight: 600;
        }
        
        .status-badge {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 700;
            display: inline-block;
            white-space: nowrap;
        }
        
        .btn-expand {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 2px solid #e2e8f0;
            background: white;
            color: #718096;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s;
            cursor: pointer;
            text-decoration: none;
        }
        
        .btn-expand:hover {
            border-color: #667eea;
            color: #667eea;
            background: #f7fafc;
            transform: scale(1.1);
        }
        
        /* 修复模态框层级和交互问题 */
        .modal-backdrop {
            z-index: 1050 !important;
            pointer-events: auto !important;
        }
        
        .modal.show {
            z-index: 1055 !important;
        }
        
        #orderDetailModal {
            z-index: 1055 !important;
        }
        
        #orderDetailModal .modal-dialog {
            z-index: 1056 !important;
            pointer-events: auto !important;
            position: relative;
        }
        
        #orderDetailModal .modal-content {
            pointer-events: auto !important;
            position: relative;
            z-index: 1057 !important;
        }
        
        /* 确保模态框内的所有元素都可点击 */
        #orderDetailModal * {
            pointer-events: auto !important;
        }
        
        /* 确保body没有pointer-events限制 */
        body.modal-open {
            overflow: hidden;
        }
        
        /* ========== 模态框优化样式 ========== */
        
        /* 信息卡片样式 */
        .info-card {
            display: flex;
            align-items: flex-start;
            padding: 1rem;
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            transition: all 0.3s;
            height: 100%;
        }
        
        .info-card:hover {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
            transform: translateY(-2px);
        }
        
        .info-card.highlight {
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border: 2px solid #667eea;
        }
        
        .info-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.1rem;
            flex-shrink: 0;
            margin-right: 0.75rem;
        }
        
        .info-content {
            flex: 1;
            min-width: 0;
        }
        
        .info-label {
            font-size: 0.75rem;
            color: #a0aec0;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 0.25rem;
        }
        
        .info-value {
            font-size: 0.95rem;
            color: #2d3748;
            font-weight: 600;
            word-wrap: break-word;
        }
        
        /* 区域图标 */
        .section-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.95rem;
        }
        
        /* 商品明细表格优化 */
        .detail-table-wrapper {
            background: white;
            border-radius: 12px;
            padding: 0.5rem;
            border: 1px solid #e2e8f0;
        }
        
        .detail-table {
            margin-bottom: 0;
        }
        
        .detail-table-header {
            background: #f7fafc;
            color: #4a5568;
            font-weight: 700;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            padding: 0.75rem 1rem !important;
        }
        
        .detail-table-row {
            border-bottom: 1px solid #f0f2f5;
            transition: all 0.2s;
        }
        
        .detail-table-row:hover {
            background: #f7fafc;
        }
        
        .detail-table-row td {
            padding: 1rem !important;
            vertical-align: middle;
        }
        
        .product-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: linear-gradient(135deg, #f7fafc 0%, #edf2f7 100%);
            border: 1px solid #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #667eea;
            font-size: 0.9rem;
        }
        
        /* 商品图标渐变样式 */
        .product-icon-gradient {
            width: 50px;
            height: 50px;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            flex-shrink: 0;
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
        
        .subtotal-badge {
            display: inline-block;
            padding: 6px 16px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            font-weight: 700;
            font-size: 0.95rem;
        }
        
        /* 模态框动画优化 */
        .modal.fade .modal-dialog {
            transition: transform 0.3s ease-out, opacity 0.3s ease-out;
        }
        
        .modal.show .modal-dialog {
            transform: scale(1);
        }
        
        /* 关闭按钮hover效果 */
        .btn-close-white:hover {
            opacity: 1;
            transform: rotate(90deg);
            transition: all 0.3s;
        }
        
        /* 底部按钮优化 */
        .modal-footer .btn {
            transition: all 0.3s;
        }
        
        .modal-footer .btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
        }
        
        /* 响应式优化 */
        @media (max-width: 768px) {
            .info-card {
                padding: 0.75rem;
            }
            
            .info-icon {
                width: 36px;
                height: 36px;
                font-size: 1rem;
            }
            
            .info-value {
                font-size: 0.85rem;
            }
            
            .modal-header {
                padding: 1.25rem 1.5rem !important;
            }
            
            .modal-body .p-4 {
                padding: 1.5rem !important;
            }
        }

        /* ========== 弹窗内部滚动条设置，避免影响外层UI ========== */
        .modal-dialog.modal-dialog-scrollable .modal-content {
            max-height: 85vh; /* 限制弹窗整体高度 */
        }
        /* 覆盖内联 overflow:hidden，允许内容区滚动 */
        #orderDetailModal .modal-content {
            overflow: visible !important;
        }
        .modal-dialog.modal-dialog-scrollable #orderDetailModal .modal-body,
        #orderDetailModal .modal-body {
            overflow-y: auto !important; /* 只在内容区滚动 */
            max-height: calc(85vh - 140px); /* 预留头部+底部高度，保证内部滚动 */
        }
        /* 可选：美化内部滚动条 */
        .modal-dialog.modal-dialog-scrollable .modal-body::-webkit-scrollbar {
            width: 8px;
        }
        .modal-dialog.modal-dialog-scrollable .modal-body::-webkit-scrollbar-thumb {
            background: rgba(102, 126, 234, 0.5);
            border-radius: 8px;
        }
        .modal-dialog.modal-dialog-scrollable .modal-body::-webkit-scrollbar-track {
            background: rgba(0,0,0,0.05);
            border-radius: 8px;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <h4 class="fw-bold mb-4">历史订单</h4>

    <asp:UpdatePanel ID="upOrders" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" GridLines="None" ShowHeader="False" CssClass="w-100" 
                EmptyDataText="暂无数据" AllowPaging="True" PageSize="5" OnPageIndexChanging="gvOrders_PageIndexChanging"
                OnRowCommand="gvOrders_RowCommand">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <div class="order-card">
                                <div class="order-grid">
                                    <!-- 订单号 -->
                                    <div>
                                        <div class="order-field-label">订单号</div>
                                        <div class="order-field-value">#<%# Eval("业务订单编码") %></div>
                                    </div>
                                    
                                    <!-- 时间 -->
                                    <div>
                                        <div class="order-field-label">时间</div>
                                        <div class="order-field-value"><%# Eval("订单创建时间", "{0:MM-dd HH:mm}") %></div>
                                    </div>
                                    
                                    <!-- 收货地址 -->
                                    <div>
                                        <div class="order-field-label">收货地址</div>
                                        <div class="order-field-value text-truncate"><%# Eval("订单收货地址快照") %></div>
                                    </div>
                                    
                                    <!-- 金额 -->
                                    <div class="text-end">
                                        <div class="order-field-label">金额</div>
                                        <div class="order-field-value text-primary fs-5"><%# Eval("订单总金额", "{0:C}") %></div>
                                    </div>
                                    
                                    <!-- 状态 -->
                                    <div>
                                        <span class='status-badge <%# GetStatusClass(Eval("订单流转状态").ToString()) %>'>
                                            <%# Eval("订单流转状态") %>
                                        </span>
                                    </div>
                                    
                                    <!-- 展开按钮 -->
                                    <div class="text-center">
                                        <asp:LinkButton ID="btnView" runat="server" 
                                            CssClass="btn-expand" 
                                            CommandName="ViewDetail" 
                                            CommandArgument='<%# Eval("订单流水号") %>'
                                            ToolTip="查看详情">
                                            <i class="fas fa-chevron-right"></i>
                                        </asp:LinkButton>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="grid-pager" />
                <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="5" />
                <EmptyDataTemplate>
                    <div class="text-center py-5">
                        <i class="fas fa-shopping-bag fa-3x text-muted opacity-25 mb-3"></i>
                        <p class="text-muted">暂无历史订单</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- 订单详情模态框 - 优化版 -->
    <div class="modal fade" id="orderDetailModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
            <div class="modal-content border-0 shadow-lg" style="border-radius: 20px; overflow: hidden;">
                <!-- 渐变色头部 -->
                <div class="modal-header border-0" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 1.5rem 2rem;">
                    <div>
                        <h5 class="modal-title fw-bold text-white mb-1">
                            <i class="fas fa-receipt me-2"></i>订单详情
                        </h5>
                        <p class="text-white mb-0 opacity-75" style="font-size: 0.85rem;">Order Details</p>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="关闭"></button>
                </div>
                
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:HiddenField ID="hfCurrentOrderId" runat="server" />
                        <div class="modal-body p-0">
                            <!-- 订单基本信息卡片 -->
                            <div class="p-4 bg-light">
                                <div class="row g-4">
                                    <!-- 订单编号 -->
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-icon">
                                                <i class="fas fa-hashtag"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">订单编号</div>
                                                <div class="info-value"><asp:Label ID="lblModalOrderCode" runat="server"></asp:Label></div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- 创建时间 -->
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-icon">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">创建时间</div>
                                                <div class="info-value"><asp:Label ID="lblModalTime" runat="server"></asp:Label></div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- 收货地址 -->
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-icon">
                                                <i class="fas fa-map-marker-alt"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">收货地址</div>
                                                <div class="info-value"><asp:Label ID="lblModalAddress" runat="server"></asp:Label></div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- 联系电话 -->
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-icon">
                                                <i class="fas fa-phone"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">联系电话</div>
                                                <div class="info-value"><asp:Label ID="lblModalPhone" runat="server"></asp:Label></div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- 订单状态 -->
                                    <div class="col-md-6">
                                        <div class="info-card">
                                            <div class="info-icon">
                                                <i class="fas fa-info-circle"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">订单状态</div>
                                                <div class="info-value">
                                                    <asp:Label ID="lblModalStatus" runat="server" CssClass="badge" style="font-size: 0.9rem; padding: 6px 14px;"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <!-- 订单总额 -->
                                    <div class="col-md-6">
                                        <div class="info-card highlight">
                                            <div class="info-icon">
                                                <i class="fas fa-money-bill-wave"></i>
                                            </div>
                                            <div class="info-content">
                                                <div class="info-label">订单总额</div>
                                                <div class="info-value text-primary fw-bold fs-4">
                                                    <asp:Label ID="lblModalTotal" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 商品明细区域 -->
                            <div class="p-4">
                                <div class="d-flex align-items-center mb-3">
                                    <div class="section-icon me-2">
                                        <i class="fas fa-box-open"></i>
                                    </div>
                                    <h6 class="fw-bold mb-0">商品明细</h6>
                                </div>
                                
                                <div class="detail-table-wrapper">
                                    <asp:GridView ID="gvDetail" runat="server" AutoGenerateColumns="False" 
                                        CssClass="table table-borderless detail-table" 
                                        GridLines="None">
                                        <HeaderStyle CssClass="detail-table-header" />
                                        <RowStyle CssClass="detail-table-row" />
                                        <Columns>
                                            <asp:TemplateField HeaderText="商品名称">
                                                <ItemTemplate>
                                                    <div class="d-flex align-items-center">
                                                        <div class='product-icon-gradient me-3 <%# GetCategoryColorClass(Eval("类别名称")?.ToString()) %>'>
                                                            <i class='<%# GetCategoryIcon(Eval("类别名称")?.ToString()) %>'></i>
                                                        </div>
                                                        <div>
                                                            <div class="fw-600"><%# Eval("商品标准名称") %></div>
                                                            <small class="text-muted"><%# Eval("类别名称") %></small>
                                                        </div>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="成交单价" HeaderText="单价" DataFormatString="{0:C}" 
                                                ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                                            <asp:BoundField DataField="购买数量" HeaderText="数量" 
                                                ItemStyle-CssClass="text-center" HeaderStyle-CssClass="text-center" />
                                            <asp:TemplateField HeaderText="小计">
                                                <ItemTemplate>
                                                    <div class="text-end">
                                                        <span class="subtotal-badge">
                                                            <%# (Convert.ToDecimal(Eval("成交单价")) * Convert.ToInt32(Eval("购买数量"))).ToString("C") %>
                                                        </span>
                                                    </div>
                                                </ItemTemplate>
                                            </asp:TemplateField>
                                        </Columns>
                                    </asp:GridView>
                                </div>
                            </div>
                        </div>

                        <!-- 底部按钮区（移入UpdatePanel以便局部刷新） -->
                        <div class="modal-footer border-0 bg-light" style="padding: 1.25rem 2rem;">
                            <asp:Button ID="btnConfirmReceive" runat="server" Text="确认收货" CssClass="btn btn-success px-4 me-auto" Style="border-radius: 50px; font-weight: 600;" OnClick="btnConfirmReceive_Click" Visible="false" />
                            <asp:Button ID="btnPay" runat="server" Text="立即付款" CssClass="btn btn-primary px-4 me-auto" Style="border-radius: 50px; font-weight: 600;" OnClick="btnPay_Click" Visible="false" />
                            <button type="button" class="btn btn-light px-4" data-bs-dismiss="modal" style="border-radius: 50px; font-weight: 600;">
                                <i class="fas fa-times me-2"></i>关闭
                            </button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>
</asp:Content>