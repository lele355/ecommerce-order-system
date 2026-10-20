<%@ Page Title="确认订单" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Checkout.aspx.cs" Inherits="EcommerceOrderSystem.Checkout" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <style>
        /* Page Header */
        .checkout-header {
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
        
        .checkout-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 60%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        }
        
        .checkout-header-content {
            position: relative;
            z-index: 2;
        }
        
        /* Progress Steps */
        .checkout-steps {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 2rem;
            margin-top: 2rem;
        }
        
        .checkout-step {
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
            position: relative;
        }
        
        .checkout-step-number {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.25);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 1.25rem;
            transition: all 0.3s ease;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        
        .checkout-step.active .checkout-step-number {
            background: white;
            color: #667eea;
            box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.3);
        }
        
        .checkout-step-label {
            font-size: 0.875rem;
            font-weight: 600;
            opacity: 0.8;
        }
        
        .checkout-step.active .checkout-step-label {
            opacity: 1;
        }
        
        .checkout-step-line {
            position: absolute;
            top: 25px;
            left: 50%;
            width: 100%;
            height: 2px;
            background: rgba(255, 255, 255, 0.3);
            z-index: -1;
        }
        
        /* Section Card */
        .section-card {
            background: rgba(255,255,255,0.92);
            border-radius: 1.5rem;
            padding: 2rem;
            margin-bottom: 2rem;
            border: 1px solid rgba(243,244,246,0.85);
            transition: all 0.3s ease;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
        }
        
        .section-card:hover {
            border-color: #667eea;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.1);
        }
        
        .section-title {
            font-size: 1rem;
            font-weight: 700;
            text-transform: uppercase;
            color: #6b7280;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .section-title i {
            color: #667eea;
            font-size: 1.25rem;
        }
        
        /* Address Card */
        .address-input-card {
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            border: 1px dashed rgba(229,231,235,0.9);
            border-radius: 1.25rem;
            padding: 2rem;
            transition: all 0.3s ease;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        
        .address-input-card:focus-within {
            border-color: #667eea;
            border-style: solid;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
        }
        
        .address-icon-box {
            width: 60px;
            height: 60px;
            border-radius: 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-right: 1.5rem;
            flex-shrink: 0;
        }
        
        .address-icon-box i {
            font-size: 1.75rem;
            color: white;
        }
        
        /* Modern Input */
        .modern-input {
            border: none;
            border-bottom: 2px solid #e5e7eb;
            border-radius: 0;
            padding: 0.75rem 0.5rem;
            background: transparent;
            width: 100%;
            font-weight: 600;
            color: #111827;
            transition: all 0.3s ease;
        }
        
        .modern-input:focus {
            outline: none;
            border-bottom-color: #667eea;
            background: rgba(102, 126, 234, 0.02);
        }
        
        .modern-input::placeholder {
            color: #9ca3af;
            font-weight: 400;
        }
        
        .modern-label {
            font-size: 0.8125rem;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 0.5rem;
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Product Item */
        .checkout-product-item {
            display: flex;
            align-items: center;
            gap: 1.25rem;
            padding: 1.25rem 0;
            border-bottom: 1px solid #f3f4f6;
            transition: all 0.2s ease;
        }
        
        .checkout-product-item:last-child {
            border-bottom: none;
        }
        
        .checkout-product-item:hover {
            background: #f9fafb;
            margin: 0 -1rem;
            padding-left: 1rem;
            padding-right: 1rem;
        }
        
        .checkout-product-icon {
            width: 70px;
            height: 70px;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
        }
        
        .checkout-product-icon i {
            font-size: 2rem;
            color: rgba(255, 255, 255, 0.95);
        }
        
        /* Summary Card */
        .summary-sticky-card {
            background: rgba(255,255,255,0.95);
            border-radius: 2rem;
            padding: 2.5rem;
            border: 1px solid rgba(243,244,246,0.85);
            position: sticky;
            top: 100px;
            box-shadow: 0 12px 30px rgba(31,38,135,0.12);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
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
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 1.5rem 0;
            margin-top: 1rem;
            border-top: 2px solid #f3f4f6;
        }
        
        .summary-total-amount {
            font-size: 2.5rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        /* Pay Button */
        .btn-pay {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 1.5rem 2rem;
            border-radius: 50px;
            font-weight: 700;
            font-size: 1.25rem;
            transition: all 0.3s ease;
            box-shadow: 0 15px 40px rgba(102, 126, 234, 0.3);
            width: 100%;
        }
        
        .btn-pay:hover {
            transform: translateY(-3px);
            box-shadow: 0 20px 50px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-pay i {
            margin-right: 0.75rem;
        }
        
        /* Security Badge */
        .security-badge {
            text-align: center;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid #f3f4f6;
        }
        
        .security-icons {
            display: flex;
            justify-content: center;
            gap: 1.5rem;
            margin-top: 1rem;
            color: #9ca3af;
        }
        
        .security-icons i {
            font-size: 2rem;
        }
        
        /* Back Button */
        .btn-back {
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-back:hover {
            color: #667eea;
            transform: translateX(-5px);
        }
        
        @media (max-width: 768px) {
            .checkout-steps {
                gap: 1rem;
            }
            
            .checkout-step-number {
                width: 40px;
                height: 40px;
                font-size: 1rem;
            }
            
            .checkout-step-label {
                font-size: 0.75rem;
            }
            
            .checkout-product-icon {
                width: 60px;
                height: 60px;
            }
            
            .checkout-product-icon i {
                font-size: 1.5rem;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
<!-- Checkout Header -->
<div class="checkout-header">
    <div class="checkout-header-content">
        <div class="d-flex align-items-center justify-content-between mb-2">
            <h1 class="fw-bold mb-0">
                <i class="fas fa-check-circle me-3"></i>
                确认订单
            </h1>
            <a href="Cart.aspx" class="btn-back">
                <i class="fas fa-arrow-left me-2"></i>
                返回购物车
            </a>
        </div>
            
        <!-- Progress Steps -->
        <div class="checkout-steps">
            <div class="checkout-step">
                <div class="checkout-step-number">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="checkout-step-label">购物车</div>
            </div>
            <div class="checkout-step-line"></div>
            <div class="checkout-step active">
                <div class="checkout-step-number">
                    <i class="fas fa-check"></i>
                </div>
                <div class="checkout-step-label">确认订单</div>
            </div>
            <div class="checkout-step-line"></div>
            <div class="checkout-step">
                <div class="checkout-step-number">
                    <i class="fas fa-credit-card"></i>
                </div>
                <div class="checkout-step-label">支付</div>
            </div>
        </div>
    </div>
</div>

    <div class="row g-4">
        
        <!-- Left Side: Details -->
        <div class="col-lg-8">
            
            <!-- 1. Shipping Address -->
            <div class="section-card">
                <div class="section-title">
                    <i class="fas fa-shipping-fast"></i>
                    收货信息
                </div>
                
                <div class="address-input-card">
                    <div class="d-flex align-items-start">
                        <div class="address-icon-box">
                            <i class="fas fa-map-marker-alt"></i>
                        </div>
                        <div class="flex-grow-1">
                            <div class="row g-4">
                                <div class="col-md-6">
                                    <label class="modern-label">收货人</label>
                                    <asp:TextBox ID="txtName" runat="server" CssClass="modern-input" placeholder="请输入收货人姓名"></asp:TextBox>
                                </div>
                                <div class="col-md-6">
                                    <label class="modern-label">联系电话</label>
                                    <asp:TextBox ID="txtPhone" runat="server" CssClass="modern-input" placeholder="请输入联系电话"></asp:TextBox>
                                </div>
                                <div class="col-12">
                                    <label class="modern-label">详细地址</label>
                                    <asp:TextBox ID="txtAddress" runat="server" CssClass="modern-input" placeholder="请输入收货地址（省市区街道门牌号）"></asp:TextBox>
                                </div>
                            </div>
                            
                            <div class="d-flex align-items-center gap-2 mt-4 text-muted">
                                <i class="fas fa-info-circle"></i>
                                <small>请确保收货信息准确无误，以便快速送达</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 2. Product List -->
            <div class="section-card">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div class="section-title mb-0">
                        <i class="fas fa-box-open"></i>
                        商品清单
                    </div>
                    <span class="badge rounded-pill" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 0.5rem 1rem; font-size: 0.875rem;">
                        共 <asp:Label ID="lblCount" runat="server" Text="0"></asp:Label> 件商品
                    </span>
                </div>

                <asp:GridView ID="gvCheckout" runat="server" AutoGenerateColumns="False" GridLines="None" ShowHeader="False" CssClass="w-100">
                    <Columns>
                        <asp:TemplateField>
                            <ItemTemplate>
                                <div class="checkout-product-item">
                                    <!-- Product Icon -->
                                    <div class='checkout-product-icon <%# GetCheckoutItemColorClass(Container.DataItemIndex) %>'>
                                        <i class='<%# GetCheckoutItemIcon(Container.DataItemIndex) %>'></i>
                                    </div>
                                    
                                    <!-- Product Info -->
                                    <div class="flex-grow-1">
                                        <h6 class="fw-bold mb-1"><%# Eval("ProductName") %></h6>
                                        <div class="d-flex align-items-center gap-3 text-muted small">
                                            <span>
                                                <i class="fas fa-tag me-1"></i>
                                                单价: <span class="fw-600"><%# Eval("Price", "¥{0:F2}") %></span>
                                            </span>
                                            <span>
                                                <i class="fas fa-times me-1"></i>
                                                数量: <span class="fw-600"><%# Eval("Quantity") %></span>
                                            </span>
                                        </div>
                                    </div>
                                    
                                    <!-- Subtotal -->
                                    <div class="text-end">
                                        <div class="text-muted small mb-1">小计</div>
                                        <div class="fw-bold fs-5" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                            <%# Eval("SubTotal", "¥{0:F2}") %>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>

        <!-- Right Side: Summary (Sticky) -->
        <div class="col-lg-4">
            <div class="summary-sticky-card">
                <h4 class="fw-bold mb-4">
                    <i class="fas fa-receipt me-2" style="color: #667eea;"></i>
                    费用明细
                </h4>
                
                <div class="summary-row">
                    <span class="text-muted">
                        <i class="fas fa-shopping-bag me-2"></i>
                        商品总价
                    </span>
                    <span class="fw-bold"><asp:Label ID="lblTotal" runat="server" Text="¥0.00"></asp:Label></span>
                </div>
                
                <div class="summary-row">
                    <span class="text-muted">
                        <i class="fas fa-shipping-fast me-2"></i>
                        配送费
                    </span>
                    <span class="fw-bold text-success">
                        ¥0.00
                        <small class="ms-2 badge bg-success bg-opacity-10 text-success">免邮</small>
                    </span>
                </div>
                
                <div class="summary-row">
                    <span class="text-muted">
                        <i class="fas fa-gift me-2"></i>
                        优惠减免
                    </span>
                    <span class="fw-bold text-danger">- ¥0.00</span>
                </div>
                
                <div class="summary-total">
                    <div>
                        <div class="text-muted small mb-1">应付金额</div>
                        <div class="fw-bold fs-5">实付款</div>
                    </div>
                    <div class="summary-total-amount"><asp:Label ID="lblFinalTotal" runat="server" Text="¥0.00"></asp:Label></div>
                </div>

                <asp:Button ID="btnSubmitOrder" runat="server" Text="🔒 立即支付" CssClass="btn-pay" OnClick="btnSubmitOrder_Click" OnClientClick="return confirm('确认提交订单并支付吗？');" />
                
                <!-- Security -->
                <div class="security-badge">
                    <div class="text-muted small mb-2">
                        <i class="fas fa-shield-alt me-1 text-success"></i>
                        SSL 256位安全加密
                    </div>
                    <div class="security-icons">
                        <i class="fab fa-cc-visa"></i>
                        <i class="fab fa-cc-mastercard"></i>
                        <i class="fab fa-alipay"></i>
                        <i class="fab fa-weixin"></i>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Error Alert -->
    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger position-fixed shadow-lg" style="bottom: 2rem; right: 2rem; max-width: 400px; z-index: 9999; border-radius: 1rem;">
        <div class="d-flex align-items-start">
            <i class="fas fa-exclamation-circle fs-3 me-3 text-danger"></i>
            <div class="flex-grow-1">
                <h6 class="fw-bold mb-1">提交失败</h6>
                <asp:Label ID="lblMsg" runat="server"></asp:Label>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </asp:Panel>

</asp:Content>