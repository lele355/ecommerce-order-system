<%@ Page Title="工作台" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="EcommerceOrderSystem.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <style>
        /* Dashboard Header */
        .dashboard-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1.5rem;
            padding: 2rem 2rem;
            color: white;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 32px rgba(118, 75, 162, 0.25);
        }
        
        .dashboard-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 60%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        }
        
        .dashboard-header-content {
            position: relative;
            z-index: 2;
        }
        
        /* Stat Card */
        .stat-card {
            background: rgba(255,255,255,0.82);
            border-radius: 1.25rem;
            padding: 1.5rem;
            border: 1px solid rgba(255,255,255,0.6);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: 0 10px 26px rgba(31, 38, 135, 0.12);
        }
        
        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
            background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.18);
            border-color: #667eea;
        }
        
        .stat-card:hover::before {
            transform: scaleX(1);
        }
        
        .stat-icon {
            width: 55px;
            height: 55px;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
            margin-bottom: 1rem;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.25rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .stat-label {
            font-size: 0.8125rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Gradient Backgrounds */
        .bg-gradient-primary { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .bg-gradient-warning { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
        .bg-gradient-danger { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%); }
        .bg-gradient-success { background: linear-gradient(135deg, #10b981 0%, #059669 100%); }
        
        /* Section Card */
        .section-card {
            background: rgba(255,255,255,0.85);
            border-radius: 1.25rem;
            padding: 1.5rem;
            border: 1px solid rgba(255,255,255,0.6);
            transition: all 0.3s ease;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: 0 12px 30px rgba(31, 38, 135, 0.12);
        }
        
        .section-card:hover {
            border-color: #667eea;
            box-shadow: 0 16px 36px rgba(102, 126, 234, 0.15);
            transform: translateY(-4px);
        }
        
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
            padding-bottom: 0.75rem;
            border-bottom: 2px solid #f3f4f6;
        }
        
        .section-title {
            display: flex;
            align-items: center;
            gap: 0.625rem;
            font-size: 1.125rem;
            font-weight: 700;
            color: #111827;
            margin: 0;
        }
        
        .section-title-icon {
            width: 38px;
            height: 38px;
            border-radius: 0.625rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.125rem;
            color: white;
        }
        
        /* Task Item */
        .task-item {
            display: flex;
            align-items: center;
            gap: 0.875rem;
            padding: 0.875rem;
            border-radius: 0.625rem;
            transition: all 0.2s ease;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .task-item:last-child {
            border-bottom: none;
        }
        
        .task-item:hover {
            background: #f9fafb;
        }
        
        /* Quick Link Button */
        .quick-link-btn {
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 0.875rem;
            padding: 1rem;
            text-align: center;
            transition: all 0.3s ease;
            text-decoration: none;
            color: #374151;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.625rem;
        }
        
        .quick-link-btn:hover {
            border-color: #667eea;
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            transform: translateY(-4px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.15);
            color: #667eea;
        }
        
        .quick-link-icon {
            width: 42px;
            height: 42px;
            border-radius: 0.625rem;
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: #6b7280;
            transition: all 0.3s ease;
        }
        
        .quick-link-btn:hover .quick-link-icon {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            transform: scale(1.1);
        }
        /* 微动效通用工具 */
        .fade-in { animation: fadeIn 0.4s ease both; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(6px);} to { opacity: 1; transform: none; } }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
<!-- Dashboard Header -->
<div class="dashboard-header fade-in">
    <div class="dashboard-header-content">
        <h1 class="fw-bold mb-2">
            <i class="fas fa-tachometer-alt me-3"></i>
            工作台
        </h1>
        <p class="mb-0 opacity-90">欢迎回来！这里是您的管理中心</p>
    </div>
</div>
    
<!-- KPI Statistics -->
<div class="row g-4 mb-4 fade-in">
    <!-- To Ship -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon bg-gradient-warning">
                <i class="fas fa-shipping-fast"></i>
            </div>
            <div class="stat-number"><asp:Label ID="lblToShip" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">待发货订单</div>
        </div>
    </div>

    <!-- Low Stock -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon bg-gradient-danger">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <div class="stat-number"><asp:Label ID="lblLowStock" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">库存预警</div>
        </div>
    </div>

    <!-- Total Sales -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon bg-gradient-success">
                <i class="fas fa-dollar-sign"></i>
            </div>
            <div class="stat-number"><asp:Label ID="lblTotalSales" runat="server" Text="¥0"></asp:Label></div>
            <div class="stat-label">总销售额</div>
        </div>
    </div>

    <!-- Total Users -->
    <div class="col-md-6 col-xl-3">
        <div class="stat-card">
            <div class="stat-icon bg-gradient-primary">
                <i class="fas fa-users"></i>
            </div>
            <div class="stat-number"><asp:Label ID="lblTotalUsers" runat="server" Text="0"></asp:Label></div>
            <div class="stat-label">注册客户</div>
        </div>
    </div>
</div>

    <!-- Main Content -->
    <div class="row g-4">
        <!-- Recent Orders -->
        <div class="col-xl-6">
            <div class="section-card fade-in">
                <div class="section-header">
                    <div class="section-title">
                        <div class="section-title-icon bg-gradient-primary">
                            <i class="fas fa-clipboard-list"></i>
                        </div>
                        <span>待处理订单</span>
                    </div>
                    <a href="OrderManage.aspx" class="btn btn-sm btn-outline-primary rounded-pill px-3 lift-hover">
                        查看全部 <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <asp:Repeater ID="rptRecentTasks" runat="server">
                    <ItemTemplate>
                        <div class="task-item">
                            <span class="badge rounded-pill bg-warning text-dark">待发货</span>
                            <div class="flex-grow-1">
                                <div class="fw-bold"><%# Eval("业务订单编码") %></div>
                                <div class="small text-muted">
                                    <i class="fas fa-user me-1"></i><%# Eval("顾客姓名") %>
                                    <span class="mx-2">·</span>
                                    <i class="fas fa-clock me-1"></i><%# Eval("订单创建时间", "{0:MM-dd HH:mm}") %>
                                </div>
                            </div>
                            <div class="fw-bold fs-5" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                <%# Eval("订单总金额", "¥{0:F2}") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoTasks" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                    <i class="fas fa-check-circle fa-3x mb-3 opacity-25"></i>
                    <p>暂无待处理订单</p>
                </asp:Panel>
            </div>
        </div>

        <!-- Low Stock Alert -->
        <div class="col-xl-6">
            <div class="section-card fade-in">
                <div class="section-header">
                    <div class="section-title">
                        <div class="section-title-icon bg-gradient-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <span>库存预警</span>
                    </div>
                    <a href="StockManage.aspx" class="btn btn-sm btn-outline-danger rounded-pill px-3 lift-hover">
                        去补货 <i class="fas fa-arrow-right ms-1"></i>
                    </a>
                </div>
                
                <asp:Repeater ID="rptLowStock" runat="server">
                    <ItemTemplate>
                        <div class="task-item">
                            <div class="flex-grow-1">
                                <div class="fw-bold"><%# Eval("商品标准名称") %></div>
                                <div class="small text-muted">
                                    <i class="fas fa-box me-1"></i>当前库存较低，建议尽快补货
                                </div>
                            </div>
                            <span class="badge bg-danger px-3 py-2">
                                仅剩 <%# Eval("商品当前库存量") %> 件
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Panel ID="pnlNoLowStock" runat="server" Visible="false" CssClass="text-center py-5 text-muted">
                    <i class="fas fa-check-circle fa-3x mb-3 opacity-25"></i>
                    <p>库存充足，无需补货</p>
                </asp:Panel>
            </div>
        </div>

        <!-- Quick Links (Admin Only) -->
        <asp:PlaceHolder ID="phAdminShortcuts" runat="server" Visible="false">
            <div class="col-12">
                <div class="section-card fade-in">
                    <div class="section-header">
                        <div class="section-title">
                            <div class="section-title-icon bg-gradient-success">
                                <i class="fas fa-cog"></i>
                            </div>
                            <span>快捷入口</span>
                        </div>
                    </div>
                    
                    <div class="row g-3">
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="ProductManage.aspx" class="quick-link-btn">
                                <div class="quick-link-icon">
                                    <i class="fas fa-box"></i>
                                </div>
                                <span class="fw-600">商品管理</span>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="CategoryManage.aspx" class="quick-link-btn">
                                <div class="quick-link-icon">
                                    <i class="fas fa-tags"></i>
                                </div>
                                <span class="fw-600">分类管理</span>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="SupplierManage.aspx" class="quick-link-btn">
                                <div class="quick-link-icon">
                                    <i class="fas fa-truck"></i>
                                </div>
                                <span class="fw-600">供应商</span>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="WarehouseManage.aspx" class="quick-link-btn">
                                <div class="quick-link-icon">
                                    <i class="fas fa-warehouse"></i>
                                </div>
                                <span class="fw-600">仓库</span>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="UserManage.aspx" class="quick-link-btn">
                                <div class="quick-link-icon">
                                    <i class="fas fa-users-cog"></i>
                                </div>
                                <span class="fw-600">用户管理</span>
                            </a>
                        </div>
                        <div class="col-6 col-md-4 col-lg-2">
                            <a href="OrderManage.aspx" class="quick-link-btn">
                                <div class="quick-link-icon">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                                <span class="fw-600">订单管理</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </asp:PlaceHolder>
    </div>

</asp:Content>