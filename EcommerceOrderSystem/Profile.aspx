<%@ Page Title="个人中心" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Profile.aspx.cs" Inherits="EcommerceOrderSystem.Profile" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <style>
        /* 个人中心头部 */
        .profile-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 1.5rem;
            padding: 3rem 2rem;
            color: white;
            box-shadow: 0 10px 40px rgba(102, 126, 234, 0.3);
            position: relative;
            overflow: hidden;
            margin-bottom: 2rem;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
        }
        
        .profile-hero::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 400px;
            height: 400px;
            background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
            border-radius: 50%;
        }
        
        .profile-avatar {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: linear-gradient(135deg, rgba(255,255,255,0.2) 0%, rgba(255,255,255,0.1) 100%);
            backdrop-filter: blur(10px);
            border: 3px solid rgba(255,255,255,0.3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2.5rem;
            color: white;
            box-shadow: 0 8px 20px rgba(0,0,0,0.2);
            transition: all 0.3s ease;
            position: relative;
            z-index: 1;
        }
        
        .profile-avatar:hover {
            transform: scale(1.05) rotate(5deg);
        }
        
        .profile-info {
            position: relative;
            z-index: 1;
        }
        
        .profile-name {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .profile-meta {
            opacity: 0.9;
            font-size: 0.95rem;
        }
        
        .profile-badge {
            display: inline-block;
            padding: 0.375rem 0.875rem;
            background: rgba(255,255,255,0.2);
            border-radius: 50px;
            font-size: 0.875rem;
            margin-top: 0.75rem;
            backdrop-filter: blur(10px);
        }
        
        /* 信息卡片 */
        .info-card {
            background: rgba(255,255,255,0.92);
            border-radius: 1.25rem;
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
            border: 1px solid rgba(229,231,235,0.85);
            overflow: hidden;
            transition: all 0.3s ease;
            margin-bottom: 1.5rem;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }
        
        .info-card:hover {
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        
        .info-card-header {
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid rgba(229,231,235,0.85);
            display: flex;
            align-items: center;
            gap: 0.75rem;
            backdrop-filter: blur(6px);
            -webkit-backdrop-filter: blur(6px);
        }
        
        .info-card-icon {
            width: 40px;
            height: 40px;
            border-radius: 0.625rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.125rem;
            color: white;
        }
        
        .icon-basic { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .icon-security { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); }
        
        .info-card-title {
            font-size: 1.125rem;
            font-weight: 700;
            color: #1f2937;
            margin: 0;
        }
        
        .info-card-body {
            padding: 1.5rem;
        }
        
        /* 表单样式 */
        .form-group-modern {
            margin-bottom: 1.5rem;
        }
        
        .form-label-modern {
            font-weight: 600;
            color: #374151;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.875rem;
        }
        
        .form-label-modern i {
            color: #667eea;
        }
        
        .form-control-modern {
            border: 2px solid #e5e7eb;
            border-radius: 0.75rem;
            padding: 0.875rem 1.25rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control-modern:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            outline: none;
        }
        
        /* 统计卡片 */
        .stat-card {
            background: white;
            border-radius: 1rem;
            padding: 1.25rem;
            border: 2px solid #e5e7eb;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .stat-card:hover {
            border-color: #667eea;
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(102, 126, 234, 0.15);
        }
        
        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            margin: 0 auto 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: white;
        }
        
        .stat-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: #1f2937;
            margin-bottom: 0.25rem;
        }
        
        .stat-label {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        /* 操作按钮 */
        .action-buttons {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            padding: 1.5rem;
            background: #f9fafb;
            border-top: 2px solid #e5e7eb;
        }
        
        .btn-save {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            color: white;
            padding: 0.875rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-save:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            color: white;
        }
        
        .btn-reset {
            background: white;
            border: 2px solid #e5e7eb;
            color: #6b7280;
            padding: 0.875rem 2rem;
            border-radius: 50px;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .btn-reset:hover {
            border-color: #9ca3af;
            color: #374151;
        }
        
        /* 提示框 */
        .alert-modern {
            border-radius: 1rem;
            border: none;
            padding: 1rem 1.25rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
            font-weight: 500;
        }
        
        .alert-modern i {
            font-size: 1.25rem;
        }
        
        .alert-success-modern {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
            border-left: 4px solid #10b981;
        }
        
        .alert-danger-modern {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
            border-left: 4px solid #ef4444;
        }
        
        .alert-info-modern {
            background: rgba(59, 130, 246, 0.1);
            color: #2563eb;
            border-left: 4px solid #3b82f6;
        }
        
        /* 响应式 */
        @media (max-width: 768px) {
            .profile-hero {
                padding: 2rem 1.5rem;
            }
            
            .profile-avatar {
                width: 80px;
                height: 80px;
                font-size: 2rem;
            }
            
            .profile-name {
                font-size: 1.5rem;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .btn-save, .btn-reset {
                width: 100%;
            }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-xl-10 col-12">
            <!-- 个人中心头部 -->
            <div class="profile-hero">
                <div class="d-flex align-items-center">
                    <div class="profile-avatar me-4">
                        <i class="fas fa-user"></i>
                    </div>
                    <div class="profile-info">
                        <div class="profile-name">
                            <asp:Label ID="lblUserName" runat="server" Text="用户"></asp:Label>
                        </div>
                        <div class="profile-meta">
                            <i class="fas fa-user-circle me-2"></i>
                            个人资料设置
                        </div>
                    </div>
                </div>
            </div>

            <!-- 提示信息 -->
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert-modern alert-success-modern">
                <i class="fas fa-check-circle"></i>
                <span>信息已成功更新！</span>
            </asp:Panel>
            
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert-modern alert-danger-modern">
                <i class="fas fa-exclamation-circle"></i>
                <asp:Literal ID="ltError" runat="server" />
            </asp:Panel>

            <!-- 账户统计 -->
            <div class="row g-3 mb-4">
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                            <i class="fas fa-shopping-bag"></i>
                        </div>
                        <div class="stat-value">
                            <asp:Label ID="lblTotalOrders" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">累计订单</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div class="stat-value">
                            <asp:Label ID="lblPendingOrders" runat="server" Text="0"></asp:Label>
                        </div>
                        <div class="stat-label">待处理订单</div>
                    </div>
                </div>
                <div class="col-md-4">
                    <div class="stat-card">
                        <div class="stat-icon" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);">
                            <i class="fas fa-dollar-sign"></i>
                        </div>
                        <div class="stat-value">
                            <asp:Label ID="lblTotalSpent" runat="server" Text="¥0"></asp:Label>
                        </div>
                        <div class="stat-label">累计消费</div>
                    </div>
                </div>
            </div>

            <!-- 基本资料卡片 -->
            <div class="info-card">
                <div class="info-card-header">
                    <div class="info-card-icon icon-basic">
                        <i class="fas fa-user-circle"></i>
                    </div>
                    <h5 class="info-card-title">基本资料</h5>
                </div>
                <div class="info-card-body">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <label class="form-label-modern">
                                    <i class="fas fa-id-badge"></i>
                                    登录账号
                                </label>
                                <asp:TextBox ID="txtAccount" runat="server" CssClass="form-control form-control-modern" placeholder="请输入账号"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <label class="form-label-modern">
                                    <i class="fas fa-user"></i>
                                    真实姓名
                                </label>
                                <asp:TextBox ID="txtName" runat="server" CssClass="form-control form-control-modern" placeholder="请输入姓名"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <label class="form-label-modern">
                                    <i class="fas fa-phone"></i>
                                    手机号码
                                </label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control form-control-modern" placeholder="请输入手机号码"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <label class="form-label-modern">
                                    <i class="fas fa-calendar-alt"></i>
                                    注册时间
                                </label>
                                <asp:TextBox ID="txtRegisterTime" runat="server" CssClass="form-control form-control-modern" ReadOnly="true" style="background-color: #f9fafb;"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-12">
                            <div class="form-group-modern mb-0">
                                <label class="form-label-modern">
                                    <i class="fas fa-map-marker-alt"></i>
                                    默认收货地址
                                </label>
                                <asp:TextBox ID="txtAddress" runat="server" CssClass="form-control form-control-modern" TextMode="MultiLine" Rows="3" placeholder="请输入详细收货地址"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    
                    <div class="alert-modern alert-info-modern mt-3">
                        <i class="fas fa-info-circle"></i>
                        <span>请确保您的个人信息准确无误，以便我们为您提供更好的服务。</span>
                    </div>
                </div>
            </div>

            <!-- 安全设置卡片 -->
            <div class="info-card">
                <div class="info-card-header">
                    <div class="info-card-icon icon-security">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h5 class="info-card-title">安全设置</h5>
                </div>
                <div class="info-card-body">
                    <div class="row g-4">
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <label class="form-label-modern">
                                    <i class="fas fa-lock"></i>
                                    新密码
                                </label>
                                <asp:TextBox ID="txtNewPassword" runat="server" CssClass="form-control form-control-modern" TextMode="Password" placeholder="留空表示不修改密码"></asp:TextBox>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group-modern">
                                <label class="form-label-modern">
                                    <i class="fas fa-lock"></i>
                                    确认新密码
                                </label>
                                <asp:TextBox ID="txtConfirmPassword" runat="server" CssClass="form-control form-control-modern" TextMode="Password" placeholder="再次输入新密码"></asp:TextBox>
                            </div>
                        </div>
                    </div>
                    
                    <div class="alert-modern alert-info-modern mt-3">
                        <i class="fas fa-shield-alt"></i>
                        <span>建议使用至少8位字符，并包含字母、数字和特殊符号的强密码。</span>
                    </div>
                </div>
                
                <div class="action-buttons">
                    <asp:Button ID="btnReset" runat="server" Text="重置表单" CssClass="btn-reset" OnClientClick="location.reload(); return false;" />
                    <asp:Button ID="btnSave" runat="server" Text="💾 保存更改" CssClass="btn-save" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
