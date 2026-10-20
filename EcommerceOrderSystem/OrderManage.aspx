<%@ Page Title="订单管理" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="OrderManage.aspx.cs" Inherits="EcommerceOrderSystem.OrderManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showProcessModal() { new bootstrap.Modal(document.getElementById('orderProcessModal')).show(); }
    </script>
    <style>
        /* Page Header */
        .order-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2rem;
            padding: 3rem 2.5rem;
            color: white;
            margin-bottom: 3rem;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: 0 12px 32px rgba(118, 75, 162, 0.25);
        }
        
        .order-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 60%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        }
        
        .order-header-content {
            position: relative;
            z-index: 2;
        }
        
        /* Filter Pills */
        .filter-pill {
            padding: 0.75rem 1.5rem;
            border-radius: 50px;
            border: 1px solid rgba(229, 231, 235, 0.8);
            background: rgba(255,255,255,0.9);
            color: #6b7280;
            font-weight: 600;
            transition: all 0.3s ease;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        
        .filter-pill:hover {
            border-color: #667eea;
            color: #667eea;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
        }
        
        .filter-pill.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.3);
        }
        
        /* Table Container */
        .table-container {
            background: rgba(255,255,255,0.85);
            border-radius: 1.5rem;
            overflow: hidden;
            border: 1px solid rgba(243, 244, 246, 0.85);
            box-shadow: 0 12px 30px rgba(31, 38, 135, 0.12);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }
        
        .table thead {
            background: linear-gradient(135deg, #f9fafb 0%, #f3f4f6 100%);
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        
        .table thead th {
            padding: 1.25rem 1.5rem;
            font-size: 0.8125rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: #6b7280;
            border: none;
        }
        
        .table tbody tr {
            transition: all 0.2s ease;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .table tbody tr:hover {
            background: #f9fafb;
        }
        
        .table tbody td {
            padding: 1.25rem 1.5rem;
            vertical-align: middle;
            border: none;
        }
        
        /* Order ID Badge */
        .order-id {
            font-family: 'Courier New', monospace;
            font-weight: 700;
            color: #111827;
            font-size: 0.875rem;
        }
        
        /* Action Button */
        .btn-action {
            padding: 0.5rem 1.25rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        
        .btn-action:hover {
            transform: translateX(4px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }
        
        /* Modal Styles */
        .modal-header-custom {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 1.5rem 1.5rem 0 0;
            padding: 2rem;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }
        
        .info-box {
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            border: 2px solid #e5e7eb;
            border-radius: 1rem;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .info-row {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 0;
        }
        
        .info-icon {
            width: 35px;
            height: 35px;
            border-radius: 0.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 0.875rem;
        }
        
        /* Product Item in Modal */
        .product-item-modal {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border-radius: 0.75rem;
            background: #f9fafb;
            margin-bottom: 0.75rem;
            transition: all 0.2s ease;
        }
        
        .product-item-modal:hover {
            background: #f3f4f6;
        }
        
        .product-icon-modal {
            width: 50px;
            height: 50px;
            border-radius: 0.75rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 1.5rem;
        }
        
        /* 分类图标渐变色 */
        .icon-box-electronics { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .icon-box-home { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .icon-box-fashion { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .icon-box-books { background: linear-gradient(135deg, #30cfd0 0%, #330867 100%); }
        .icon-box-food { background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%); }
        .icon-box-sports { background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%); }
        .icon-box-beauty { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .icon-box-toys { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }
        .icon-box-default { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }
        /* 微动效工具 */
        .fade-in { animation: fadeIn 0.4s ease both; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px);} to { opacity: 1; transform: none; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
<!-- Order Header -->
<div class="order-header fade-in">
    <div class="order-header-content">
        <div class="d-flex align-items-center justify-content-between">
            <div>
                <h1 class="fw-bold mb-2">
                    <i class="fas fa-shopping-cart me-3"></i>
                    订单管理
                </h1>
                <p class="mb-0 opacity-90">管理所有订单状态和发货信息</p>
            </div>
                
            <!-- 统计数字 -->
            <div class="d-flex gap-3 text-white opacity-90 small">
                <div>
                    <i class="fas fa-list-ul me-1"></i>
                    总计: <span class="fw-bold"><asp:Label ID="lblTotalCount" runat="server" Text="0"></asp:Label></span>
                </div>
                <div>
                    <i class="fas fa-clock me-1"></i>
                    待发货: <span class="fw-bold"><asp:Label ID="lblPendingCount" runat="server" Text="0"></asp:Label></span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 状态筛选 & 批量操作 -->
<div class="d-flex justify-content-between align-items-center mb-4 fade-in">
    <!-- 左侧：状态筛选 -->
    <div class="d-flex gap-2 flex-wrap">
        <asp:LinkButton ID="btnFilterAll" runat="server" CssClass="filter-pill active" OnClick="btnFilter_Click" CommandArgument="All">
            <i class="fas fa-th-large me-1"></i>全部订单
        </asp:LinkButton>
        <asp:LinkButton ID="btnFilterPending" runat="server" CssClass="filter-pill" OnClick="btnFilter_Click" CommandArgument="待付款">
            <i class="fas fa-credit-card me-1"></i>待付款
        </asp:LinkButton>
        <asp:LinkButton ID="btnFilterWait" runat="server" CssClass="filter-pill" OnClick="btnFilter_Click" CommandArgument="待发货">
            <i class="fas fa-box me-1"></i>待发货
        </asp:LinkButton>
        <asp:LinkButton ID="btnFilterShipped" runat="server" CssClass="filter-pill" OnClick="btnFilter_Click" CommandArgument="已发货">
            <i class="fas fa-shipping-fast me-1"></i>已发货
        </asp:LinkButton>
        <asp:LinkButton ID="btnFilterDone" runat="server" CssClass="filter-pill" OnClick="btnFilter_Click" CommandArgument="已完成">
            <i class="fas fa-check-circle me-1"></i>已完成
        </asp:LinkButton>
        <asp:LinkButton ID="btnFilterCancelled" runat="server" CssClass="filter-pill" OnClick="btnFilter_Click" CommandArgument="已取消">
            <i class="fas fa-times-circle me-1"></i>已取消
        </asp:LinkButton>
    </div>
    
    <!-- 右侧：批量操作 -->
    <div>
        <asp:Button ID="btnBatchShip" runat="server" Text="⚡ 一键发货" CssClass="btn btn-primary rounded-pill px-4 fw-bold shadow-sm" OnClick="btnBatchShip_Click" />
        <small class="text-muted ms-2">批量处理待发货订单</small>
    </div>
</div>

    <!-- Orders Table -->
    <asp:UpdatePanel ID="upList" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <div class="table-container fade-in">
                <asp:GridView ID="gvOrders" runat="server" AutoGenerateColumns="False" 
                    CssClass="table mb-0" GridLines="None"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvOrders_PageIndexChanging" OnRowCommand="gvOrders_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="订单编号">
                            <ItemTemplate>
                                <div class="order-id">#<%# Eval("业务订单编码") %></div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="客户">
                            <ItemTemplate>
                                <div class="d-flex align-items-center gap-2">
                                    <i class="fas fa-user-circle text-muted"></i>
                                    <span class="fw-600"><%# Eval("顾客姓名") %></span>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="下单时间">
                            <ItemTemplate>
                                <div class="text-muted">
                                    <i class="fas fa-clock me-1"></i>
                                    <%# Eval("订单创建时间", "{0:MM-dd HH:mm}") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="金额">
                            <ItemTemplate>
                                <div class="fw-bold fs-5" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                    <%# Eval("订单总金额", "¥{0:F2}") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="状态">
                            <ItemTemplate>
                                <span class='badge rounded-pill px-3 py-2 fw-bold <%# GetStatusClass(Eval("订单流转状态").ToString()) %>'>
                                    <%# GetStatusIcon(Eval("订单流转状态").ToString()) %>
                                    <%# Eval("订单流转状态") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="操作">
                            <ItemTemplate>
                                <asp:LinkButton ID="btnProcess" runat="server" CssClass="btn btn-sm btn-outline-primary btn-action" CommandName="ProcessOrder" CommandArgument='<%# Eval("订单流水号") %>'>
                                    <i class="fas fa-cog me-1"></i>
                                    处理
                                </asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="grid-pager" />
                    <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="5" />
                </asp:GridView>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- 处理订单弹窗 (Modal) -->
    <div class="modal fade" id="orderProcessModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 rounded-4 shadow-lg fade-in">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        
                        <div class="modal-header border-0 pb-0">
                            <div>
                                <h5 class="modal-title fw-bold">订单处理</h5>
                                <div class="text-muted small">单号: <asp:Label ID="lblModalCode" runat="server" CssClass="fw-bold text-dark"></asp:Label></div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>

                        <div class="modal-body">
                            <!-- 1. 收货信息 -->
                            <div class="bg-light rounded-3 p-3 mb-4">
                                <h6 class="fw-bold small text-uppercase text-muted mb-2">配送信息</h6>
                                <div class="d-flex">
                                    <div class="me-4"><i class="fas fa-user me-2 text-secondary"></i><asp:Label ID="lblModalName" runat="server"></asp:Label></div>
                                    <div class="me-4"><i class="fas fa-phone me-2 text-secondary"></i><asp:Label ID="lblModalPhone" runat="server"></asp:Label></div>
                                </div>
                                <div class="mt-2"><i class="fas fa-map-marker-alt me-2 text-secondary"></i><asp:Label ID="lblModalAddress" runat="server"></asp:Label></div>
                            </div>

                            <!-- 2. 商品列表 -->
                            <h6 class="fw-bold small text-uppercase text-muted mb-3">
                                <i class="fas fa-box-open me-2"></i>商品清单
                            </h6>
                            <asp:GridView ID="gvItems" runat="server" AutoGenerateColumns="False" GridLines="None" ShowHeader="False" CssClass="w-100">
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <div class="product-item-modal">
                                                <div class='product-icon-modal <%# GetCategoryColorClass(Eval("类别名称")?.ToString()) %>'>
                                                    <i class='<%# GetCategoryIcon(Eval("类别名称")?.ToString()) %>'></i>
                                                </div>
                                                <div class="flex-grow-1">
                                                    <div class="fw-bold"><%# Eval("商品标准名称") %></div>
                                                    <small class="text-muted"><%# Eval("类别名称") %> × <%# Eval("购买数量") %></small>
                                                </div>
                                                <div class="fw-bold" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                                    <%# Eval("成交单价", "¥{0:F2}") %>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            
                            <hr class="opacity-10 my-4">
                            
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold text-dark">当前状态: <asp:Label ID="lblModalStatus" runat="server" CssClass="text-primary"></asp:Label></span>
                                <span class="h4 fw-bold text-primary m-0"><asp:Label ID="lblModalTotal" runat="server"></asp:Label></span>
                            </div>
                        </div>

                        <div class="modal-footer border-0 pt-0">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">关闭</button>
                            
                            <!-- 只有“待发货”状态才显示发货按钮 -->
                            <asp:Button ID="btnShip" runat="server" Text="确认发货" CssClass="btn btn-primary rounded-pill px-4 fw-bold shadow-sm" OnClick="btnShip_Click" Visible="false" />
                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>