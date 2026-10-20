<%@ Page Title="购物车" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="EcommerceOrderSystem.Cart" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <style>
        /* Page Header */
        .cart-header {
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
        
        .cart-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 60%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        }
        
        .cart-header-content {
            position: relative;
            z-index: 2;
        }
        
        /* Cart Item Card */
        .cart-item-card {
            background: rgba(255,255,255,0.9);
            border-radius: 1.5rem;
            padding: 1.5rem;
            margin-bottom: 1.25rem;
            display: flex;
            align-items: center;
            gap: 1.5rem;
            border: 1px solid rgba(243,244,246,0.85);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
        }
        
        .cart-item-card::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transform: scaleY(0);
            transition: transform 0.3s ease;
        }
        
        .cart-item-card:hover {
            border-color: #667eea;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.15);
            transform: translateX(5px);
        }
        
        .cart-item-card:hover::before {
            transform: scaleY(1);
        }
        
        /* Product Icon */
        .cart-item-icon {
            width: 90px;
            height: 90px;
            border-radius: 1.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            transition: transform 0.3s ease;
        }
        
        .cart-item-icon i {
            font-size: 2.5rem;
            color: rgba(255, 255, 255, 0.95);
        }
        
        .cart-item-card:hover .cart-item-icon {
            transform: scale(1.05) rotate(-5deg);
        }
        
        /* Quantity Controls */
        .qty-controls {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            background: #f3f4f6;
            border-radius: 50px;
            padding: 0.5rem 1rem;
        }
        
        .qty-btn {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            border: none;
            background: white;
            color: #6b7280;
        }
        
        .qty-btn:hover {
            background: #667eea;
            color: white;
            transform: scale(1.1);
        }
        
        .qty-input {
            border: none;
            background: transparent;
            width: 40px;
            text-align: center;
            font-weight: 700;
            font-size: 1.125rem;
            color: #111827;
        }
        
        /* Remove Button */
        .btn-remove {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid #fee2e2;
            color: #ef4444;
            background: #fef2f2;
            transition: all 0.3s ease;
        }
        
        .btn-remove:hover {
            background: #ef4444;
            color: white;
            border-color: #ef4444;
            transform: scale(1.1) rotate(5deg);
        }
        
        /* Summary Card */
        .summary-card {
            background: rgba(255,255,255,0.95);
            border-radius: 2rem;
            padding: 2rem;
            border: 1px solid rgba(243,244,246,0.85);
            position: sticky;
            top: 100px;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: 0 12px 30px rgba(31,38,135,0.12);
        }
        
        .summary-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1rem 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .summary-row:last-child {
            border-bottom: none;
        }
        
        .summary-total {
            font-size: 2rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* Checkout Button */
        .btn-checkout {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 1.25rem 2rem;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.125rem;
            transition: all 0.3s ease;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
            width: 100%;
        }
        
        .btn-checkout:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        /* Empty State */
        .empty-cart {
            text-align: center;
            padding: 5rem 2rem;
        }
        
        .empty-cart-icon {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: linear-gradient(135deg, #f3f4f6 0%, #e5e7eb 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
        }
        
        .empty-cart-icon i {
            font-size: 4rem;
            color: #9ca3af;
        }
        
        @media (max-width: 768px) {
            .cart-item-card {
                flex-wrap: wrap;
                gap: 1rem;
            }
            
            .cart-item-icon {
                width: 70px;
                height: 70px;
            }
            
            .cart-item-icon i {
                font-size: 2rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
<!-- Cart Header -->
<div class="cart-header">
    <div class="cart-header-content">
        <div class="d-flex align-items-center justify-content-between">
            <div>
                <h1 class="fw-bold mb-2">
                    <i class="fas fa-shopping-cart me-3"></i>
                    我的购物车
                </h1>
                <p class="mb-0 opacity-90">精心挑选，即刻拥有</p>
            </div>
            <asp:LinkButton ID="btnClearCart" runat="server" CssClass="btn btn-light rounded-pill px-4" OnClick="btnClearCart_Click">
                <i class="fas fa-trash-alt me-2"></i>清空购物车
            </asp:LinkButton>
        </div>
    </div>
</div>
    
<asp:UpdatePanel ID="upCart" runat="server">
    <ContentTemplate>
        <div class="row">
            <div class="col-lg-8">
                    
                    <asp:GridView ID="gvCart" runat="server" AutoGenerateColumns="False" 
                        CssClass="w-100" GridLines="None" ShowHeader="False"
                        OnRowCommand="gvCart_RowCommand">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <div class="cart-item-card">
                                        <!-- Product Icon -->
                                        <div class='cart-item-icon <%# GetCartItemColorClass(Container.DataItemIndex) %>'>
                                            <i class='<%# GetCartItemIcon(Container.DataItemIndex) %>'></i>
                                        </div>
                                        
                                        <!-- Product Info -->
                                        <div class="flex-grow-1">
                                            <h5 class="fw-bold mb-2"><%# Eval("ProductName") %></h5>
                                            <div class="d-flex align-items-center gap-3">
                                                <span class="text-muted">
                                                    <i class="fas fa-tag me-1"></i>
                                                    单价: <span class="fw-600"><%# Eval("Price", "¥{0:F2}") %></span>
                                                </span>
                                                <span class="text-muted">
                                                    <i class="fas fa-warehouse me-1"></i>
                                                    库存: <span class="fw-600"><%# Eval("Stock") %></span>
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <!-- Quantity Controls -->
                                        <div class="qty-controls">
                                            <asp:LinkButton ID="btnMinus" runat="server" CssClass="qty-btn" CommandName="Minus" CommandArgument='<%# Eval("ProductId") %>'>
                                                <i class="fas fa-minus"></i>
                                            </asp:LinkButton>
                                            <asp:TextBox ID="txtQty" runat="server" CssClass="qty-input" Text='<%# Eval("Quantity") %>' ReadOnly="true"></asp:TextBox>
                                            <asp:LinkButton ID="btnPlus" runat="server" CssClass="qty-btn" CommandName="Plus" CommandArgument='<%# Eval("ProductId") %>'>
                                                <i class="fas fa-plus"></i>
                                            </asp:LinkButton>
                                        </div>
                                        
                                        <!-- Subtotal -->
                                        <div class="text-center mx-4">
                                            <div class="text-muted small mb-1">小计</div>
                                            <div class="fw-bold fs-4" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; min-width: 100px;">
                                                <%# Eval("SubTotal", "¥{0:F2}") %>
                                            </div>
                                        </div>
                                        
                                        <!-- Remove Button -->
                                        <asp:LinkButton ID="btnRemove" runat="server" CssClass="btn-remove" CommandName="RemoveItem" CommandArgument='<%# Eval("ProductId") %>'>
                                            <i class="fas fa-trash-alt"></i>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="empty-cart">
                                <div class="empty-cart-icon">
                                    <i class="fas fa-shopping-cart"></i>
                                </div>
                                <h4 class="fw-bold mb-3 text-muted">购物车空空如也</h4>
                                <p class="text-muted mb-4">快去挑选心仪的商品吧</p>
                                <a href="Default.aspx" class="btn btn-gradient rounded-pill px-5 py-3">
                                    <i class="fas fa-arrow-left me-2"></i>
                                    去购物
                                </a>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>

                <div class="col-lg-4">
                    <!-- Summary Card -->
                    <div class="summary-card">
                        <h4 class="fw-bold mb-4">
                            <i class="fas fa-file-invoice me-2 text-primary"></i>
                            订单摘要
                        </h4>
                        
                        <div class="summary-row">
                            <span class="text-muted">
                                <i class="fas fa-shopping-bag me-2"></i>
                                商品数量
                            </span>
                            <span class="fw-bold fs-5"><asp:Label ID="lblTitleCount" runat="server" Text="0"></asp:Label> 件</span>
                        </div>
                        
                        <div class="summary-row">
                            <span class="text-muted">
                                <i class="fas fa-dollar-sign me-2"></i>
                                商品总额
                            </span>
                            <span class="fw-bold fs-5"><asp:Label ID="lblFinalTotal" runat="server" Text="¥0.00"></asp:Label></span>
                        </div>
                        
                        <div class="summary-row" style="padding-top: 1.5rem;">
                            <span class="fw-bold fs-5">
                                <i class="fas fa-calculator me-2"></i>
                                应付金额
                            </span>
                            <span class="summary-total"><asp:Label ID="lblFinalTotal2" runat="server" Text="¥0.00"></asp:Label></span>
                        </div>
                        
                        <div class="mt-4">
                            <asp:Button ID="btnCheckout" runat="server" Text="立即结算" CssClass="btn-checkout" OnClick="btnCheckout_Click" />
                            <a href="Default.aspx" class="btn btn-outline-secondary rounded-pill w-100 mt-3 py-3">
                                <i class="fas fa-reply me-2"></i>
                                继续购物
                            </a>
                        </div>
                        
                        <!-- Security Icons -->
                        <div class="text-center mt-4 pt-3 border-top">
                            <div class="text-muted small mb-2">
                                <i class="fas fa-shield-alt me-1 text-success"></i>
                                安全支付保障
                            </div>
                            <div class="d-flex justify-content-center gap-3 text-muted">
                                <i class="fab fa-cc-visa fa-2x"></i>
                                <i class="fab fa-cc-mastercard fa-2x"></i>
                                <i class="fab fa-alipay fa-2x"></i>
                                <i class="fab fa-weixin fa-2x"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>