<%@ Page Title="商城首页" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="EcommerceOrderSystem._Default" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <style>
        /* Hero Banner */
        .hero-banner {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2rem;
            padding: 4rem 3rem;
            color: white;
            position: relative;
            overflow: hidden;
            margin-bottom: 3rem;
            box-shadow: 0 20px 60px rgba(102, 126, 234, 0.3);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }
        
        .hero-banner::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -20%;
            width: 80%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
            animation: float 20s ease-in-out infinite;
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0) rotate(0deg); }
            50% { transform: translate(-20px, 20px) rotate(5deg); }
        }
        
        /* 购物车动画 */
        @keyframes cartBounce {
            0%, 100% { transform: scale(1) translateY(0); }
            10%, 30%, 50%, 70%, 90% { transform: scale(1.3) translateY(-10px); }
            20%, 40%, 60%, 80% { transform: scale(1.1) translateY(-5px); }
        }
        
        @keyframes badgePulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.3); }
        }
        
        .hero-content {
            position: relative;
            z-index: 2;
        }
        
        .search-box {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border-radius: 50px;
            padding: 0.5rem;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            max-width: 500px;
        }
        
        .search-box .form-control {
            border: none;
            background: transparent;
            padding: 0.75rem 1.5rem;
        }
        
        .search-box .form-control:focus {
            box-shadow: none;
            outline: none;
        }
        
        .search-box .btn {
            border-radius: 50px;
            padding: 0.75rem 2rem;
            font-weight: 600;
        }
        
        /* Category Pills */
        .cat-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: rgba(255,255,255,0.92);
            border-radius: 50px;
            margin-right: 0.75rem;
            margin-bottom: 0.75rem;
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(229,231,235,0.85);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            white-space: nowrap;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        
        .cat-pill i {
            font-size: 1rem;
            transition: transform 0.3s ease;
        }
        
        .cat-pill:hover {
            background: #f9fafb;
            color: #667eea;
            border-color: #667eea;
            transform: translateY(-3px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
        }
        
        .cat-pill:hover i {
            transform: scale(1.2) rotate(5deg);
        }
        
        .cat-pill.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
            transform: translateY(-3px);
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.4);
        }
        
        .cat-pill.active:hover {
            background: linear-gradient(135deg, #5568d3 0%, #6a4192 100%);
            box-shadow: 0 12px 35px rgba(102, 126, 234, 0.5);
        }
        
        /* Product Card */
        .product-card {
            background: rgba(255,255,255,0.9);
            border-radius: 1.5rem;
            padding: 1.25rem;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            border: 1px solid rgba(243,244,246,0.85);
            height: 100%;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
        }
        
        .product-card::before {
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
        
        .product-card:hover {
            transform: translateY(-12px);
            box-shadow: 0 24px 56px rgba(102, 126, 234, 0.18);
            border-color: #667eea;
        }
        
        .product-card:hover::before {
            transform: scaleX(1);
        }
        
        /* Product Icon Box */
        .product-icon-box {
            height: 200px;
            border-radius: 1.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }
        
        .product-icon-box i {
            font-size: 5rem;
            color: rgba(255, 255, 255, 0.95);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            z-index: 2;
        }
        
        .product-card:hover .product-icon-box i {
            transform: scale(1.15) rotate(-5deg);
        }
        
        /* Category-specific gradients */
        .icon-box-electronics { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .icon-box-home { background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%); }
        .icon-box-fashion { background: linear-gradient(135deg, #fa709a 0%, #fee140 100%); }
        .icon-box-books { background: linear-gradient(135deg, #30cfd0 0%, #330867 100%); }
        .icon-box-food { background: linear-gradient(135deg, #ff6b6b 0%, #feca57 100%); }
        .icon-box-default { background: linear-gradient(135deg, #a8edea 0%, #fed6e3 100%); }
        
        /* Add to Cart Button */
        .btn-add-cart {
            width: 45px;
            height: 45px;
            border-radius: 50%;
            border: none;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
        }
        
        .btn-add-cart:hover {
            transform: scale(1.15) rotate(5deg);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.5);
        }
        
        .btn-add-cart i {
            font-size: 1.1rem;
        }
        
        /* Stock Badge */
        .stock-badge {
            position: absolute;
            top: 0.5rem;
            right: 0.5rem;
            z-index: 10;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 0.7rem;
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            white-space: nowrap;
        }
        
        .stock-badge i {
            font-size: 0.7rem;
        }
        
        .stock-badge-low {
            background: rgba(239, 68, 68, 0.95);
            color: white;
            border: none;
            box-shadow: 0 2px 8px rgba(239, 68, 68, 0.3);
            backdrop-filter: blur(10px);
        }
        
        /* Empty State */
        .empty-state {
            text-align: center;
            padding: 5rem 2rem;
        }
        
        .empty-state i {
            font-size: 5rem;
            color: #d1d5db;
            margin-bottom: 1.5rem;
        }
        
        .empty-state p {
            color: #6b7280;
            font-size: 1.125rem;
            font-weight: 500;
        }
        
        /* Section Header */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            padding: 0 0.5rem;
        }
        
        .section-title {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.75rem;
            font-weight: 700;
            color: #111827;
            margin: 0;
        }
        
        .section-title i {
            font-size: 1.5rem;
            color: #667eea;
        }
        
        .section-count {
            font-size: 0.875rem;
            font-weight: 600;
            color: #6b7280;
        }
        
        .section-count span {
            color: #667eea;
            font-size: 1.25rem;
            margin: 0 0.25rem;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- Hero Banner -->
    <div class="hero-banner">
        <div class="hero-content">
            <div class="row align-items-center">
                <div class="col-md-7">
                    <h1 class="fw-bold display-5 mb-3" style="letter-spacing: -0.5px;">
                        探索优质商品 <span style="font-size: 0.7em;">✨</span>
                    </h1>
                    <p class="fs-5 mb-4 opacity-90">精选全球好物，品质保证，极速配送</p>
                    <div class="search-box">
                        <div class="d-flex align-items-center">
                            <i class="fas fa-search text-muted ms-3"></i>
                            <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" placeholder="搜索您想要的商品..."></asp:TextBox>
                            <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-gradient" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
                <div class="col-md-5 d-none d-md-flex justify-content-end align-items-center">
                    <div style="position: relative;">
                        <i class="fas fa-shopping-bag" style="font-size: 12rem; color: rgba(255, 255, 255, 0.2);"></i>
                        <i class="fas fa-star position-absolute" style="top: 20%; right: -20px; font-size: 2rem; color: rgba(255, 255, 255, 0.6); animation: float 3s ease-in-out infinite;"></i>
                        <i class="fas fa-heart position-absolute" style="bottom: 30%; left: -20px; font-size: 1.5rem; color: rgba(255, 255, 255, 0.5); animation: float 3s ease-in-out infinite 1s;"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Section Header (Outside UpdatePanel - No need to refresh) -->
    <div class="section-header">
        <h2 class="section-title">
            <i class="fas fa-layer-group"></i>
            <asp:Label ID="lblCurrentCatName" runat="server" Text="全部商品"></asp:Label>
        </h2>
        <div class="section-count">
            共 <span><asp:Label ID="lblCount" runat="server" Text="0"></asp:Label></span> 件商品
        </div>
    </div>

    <!-- Category Filter (Outside UpdatePanel - Static) -->
    <div class="mb-5 overflow-auto pb-3" style="white-space: nowrap;">
        <asp:LinkButton ID="btnAllCats" runat="server" CssClass="cat-pill" OnClick="FilterCategory_Click" CommandArgument="0">
            <i class="fas fa-th-large"></i>
            全部分类
        </asp:LinkButton>
        <asp:Repeater ID="rptCategories" runat="server">
            <ItemTemplate>
                <asp:LinkButton ID="btnCat" runat="server" CssClass="cat-pill" OnClick="FilterCategory_Click" CommandArgument='<%# Eval("类别编号") %>'>
                    <i class='<%# GetCategoryIcon(Eval("类别名称").ToString()) %>'></i>
                    <%# Eval("类别名称") %>
                </asp:LinkButton>
            </ItemTemplate>
        </asp:Repeater>
    </div>

    <asp:UpdatePanel ID="upProducts" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <!-- Products Grid -->
            <div class="row g-4 fade-in">
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="col-6 col-md-4 col-xl-3">
                            <div class="product-card">
                                <!-- Product Icon (Category-based) -->
                                <div class='product-icon-box <%# GetCategoryColorClass(Container.ItemIndex) %>'>
                                    <i class='<%# GetProductIcon(Container.ItemIndex) %>'></i>
                                    <%# Convert.ToInt32(Eval("商品当前库存量")) < 10 ? "<span class='stock-badge stock-badge-low'><i class='fas fa-exclamation-triangle'></i> 库存紧张</span>" : "" %>
                                </div>
                                
                                <!-- Product Info -->
                                <h6 class="fw-bold mb-2 text-truncate" title='<%# Eval("商品标准名称") %>'>
                                    <%# Eval("商品标准名称") %>
                                </h6>
                                
                                <div class="text-muted small mb-3">
                                    <i class="fas fa-box me-1"></i>
                                    库存: <%# Eval("商品当前库存量") %>
                                </div>
                                
                                <!-- Price & Add to Cart -->
                                <div class="mt-auto d-flex justify-content-between align-items-center pt-2">
                                    <div>
                                        <div class="text-muted small mb-1">售价</div>
                                        <div class="fs-4 fw-bold" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                            ¥<%# Eval("商品销售单价", "{0:N0}") %>
                                        </div>
                                    </div>
                                    <asp:LinkButton ID="btnAddToCart" runat="server" CssClass="btn-add-cart" CommandName="AddToCart" CommandArgument='<%# Eval("商品编号") %>'>
                                        <i class="fas fa-shopping-cart"></i>
                                    </asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- Empty State -->
            <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="empty-state">
                <i class="fas fa-shopping-basket"></i>
                <p>暂无商品，换个条件试试吧</p>
            </asp:Panel>

        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
            <asp:AsyncPostBackTrigger ControlID="btnAllCats" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>