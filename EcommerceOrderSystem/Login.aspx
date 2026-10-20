<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="EcommerceOrderSystem.Login" %>

<!DOCTYPE html>
<html lang="zh-cn">
<head runat="server">
    <meta charset="utf-8" />
    <title>登录 - 电商MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Nunito', sans-serif;
            height: 100vh;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .login-container {
            display: flex;
            height: 100vh;
            width: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        /* 左侧登录区域 */
        .login-section {
            flex: 0 0 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 3rem;
            position: relative;
            z-index: 2;
        }
        
        /* 扁平横向卡片式登录表单 */
        .login-card {
            width: 100%;
            max-width: 520px;
            background: rgba(255, 255, 255, 0.98);
            backdrop-filter: blur(20px);
            border-radius: 24px;
            padding: 3.5rem 3.5rem 3rem;
            box-shadow: 
                0 20px 60px rgba(0, 0, 0, 0.15),
                0 10px 30px rgba(0, 0, 0, 0.1);
            animation: slideInLeft 0.8s cubic-bezier(0.2, 0.8, 0.2, 1);
            position: relative;
            overflow: hidden;
        }
        
        /* 卡片左侧装饰条 */
        .login-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
        }
        
        .login-card .logo-section {
            margin-bottom: 2.5rem;
        }
        
        .login-card .logo-icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.2rem;
            box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
        }
        
        .form-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.6rem;
            font-size: 0.95rem;
        }
        
        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 14px;
            padding: 13px 16px;
            background: #f8fafc;
            transition: all 0.3s ease;
            font-size: 0.95rem;
        }
        .form-control:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            outline: none;
        }
        
        .btn-login {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 14px;
            font-weight: 700;
            letter-spacing: 0.5px;
            color: white;
            width: 100%;
            transition: all 0.3s ease;
            font-size: 1rem;
            text-transform: uppercase;
            margin-top: 1rem;
        }
        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(118, 75, 162, 0.4);
            background: linear-gradient(135deg, #5568d3 0%, #6a4192 100%);
        }
        
        .alert {
            border-radius: 12px;
            animation: slideDown 0.3s ease;
            padding: 0.75rem 1.2rem;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        /* 右侧图形装饰区域 */
        .graphics-section {
            flex: 1;
            position: relative;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        /* 左侧区域的背景装饰圆圈 */
        .login-section::before,
        .login-section::after {
            content: '';
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.08);
        }
        
        .login-section::before {
            width: 350px;
            height: 350px;
            top: -80px;
            left: -80px;
            animation: float 8s ease-in-out infinite;
        }
        
        .login-section::after {
            width: 250px;
            height: 250px;
            bottom: -60px;
            right: -60px;
            animation: float 10s ease-in-out infinite reverse;
        }
        
        .graphics-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: white;
            padding: 2rem;
            animation: fadeIn 1s ease-in-out;
        }
        
        .graphics-content h1 {
            font-size: 2.8rem;
            font-weight: 800;
            margin-bottom: 1.2rem;
            text-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
        
        .graphics-content p {
            font-size: 1.15rem;
            opacity: 0.95;
            margin-bottom: 2.5rem;
        }
        
        /* 电商主题图标网格 */
        .icon-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1.8rem;
            max-width: 480px;
            margin: 0 auto;
        }
        
        .icon-item {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(10px);
            border-radius: 18px;
            padding: 1.8rem 1rem;
            transition: 0.3s;
            animation: floatIcon 3s ease-in-out infinite;
        }
        
        .icon-item:nth-child(1) { animation-delay: 0s; }
        .icon-item:nth-child(2) { animation-delay: 0.2s; }
        .icon-item:nth-child(3) { animation-delay: 0.4s; }
        .icon-item:nth-child(4) { animation-delay: 0.6s; }
        .icon-item:nth-child(5) { animation-delay: 0.8s; }
        .icon-item:nth-child(6) { animation-delay: 1s; }
        
        .icon-item:hover {
            background: rgba(255, 255, 255, 0.25);
            transform: translateY(-8px);
        }
        
        .icon-item i {
            font-size: 2.3rem;
            margin-bottom: 0.6rem;
        }
        
        .icon-item span {
            display: block;
            font-size: 0.88rem;
            font-weight: 600;
        }
        
        /* 背景装饰圆圈 */
        .circle {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.1);
        }
        
        .circle1 {
            width: 400px;
            height: 400px;
            top: -100px;
            right: -100px;
            animation: float 6s ease-in-out infinite;
        }
        
        .circle2 {
            width: 300px;
            height: 300px;
            bottom: -80px;
            left: -80px;
            animation: float 8s ease-in-out infinite reverse;
        }
        
        .circle3 {
            width: 200px;
            height: 200px;
            top: 50%;
            left: 10%;
            animation: float 7s ease-in-out infinite;
        }
        
        /* 动画 */
        @keyframes slideInLeft {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        
        @keyframes floatIcon {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        @keyframes float {
            0%, 100% { transform: translate(0, 0); }
            50% { transform: translate(20px, 20px); }
        }
        
        /* 响应式设计 */
        @media (max-width: 992px) {
            .login-section { flex: 0 0 100%; }
            .graphics-section { display: none; }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <!-- 左侧登录表单 -->
        <div class="login-section">
            <form id="form1" runat="server">
                <div class="login-card">
                    <div class="logo-section text-center">
                        <div class="logo-icon mx-auto">
                            <i class="fas fa-shopping-bag fa-2x text-white"></i>
                        </div>
                        <h2 class="fw-bold text-dark mb-2" style="font-size: 1.75rem;">欢迎回来</h2>
                        <p class="text-muted mb-0" style="font-size: 0.95rem;">登录电商订单管理系统</p>
                    </div>

                    <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger border-0 mb-3">
                        <i class="fas fa-exclamation-circle me-1"></i> <asp:Label ID="lblMessage" runat="server"></asp:Label>
                    </asp:Panel>

                    <div class="mb-3">
                        <label class="form-label">账号</label>
                        <div class="position-relative">
                            <span class="position-absolute" style="left: 16px; top: 50%; transform: translateY(-50%); z-index: 10;">
                                <i class="fas fa-user" style="color: #a0aec0;"></i>
                            </span>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control ps-5" placeholder="请输入用户名"></asp:TextBox>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">密码</label>
                        <div class="position-relative">
                            <span class="position-absolute" style="left: 16px; top: 50%; transform: translateY(-50%); z-index: 10;">
                                <i class="fas fa-lock" style="color: #a0aec0;"></i>
                            </span>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control ps-5" TextMode="Password" placeholder="请输入密码"></asp:TextBox>
                        </div>
                    </div>

                    <asp:Button ID="btnLogin" runat="server" Text="立即登录" CssClass="btn-login" OnClick="btnLogin_Click" />
                    <div class="mt-3 d-flex justify-content-between align-items-center">
                        <span class="text-muted small">没有账号？</span>
                        <a href="Register.aspx" class="text-primary fw-bold text-decoration-none">立即注册</a>
                    </div>
                    
                    <div class="mt-4 text-center">
                        <p class="text-muted mb-0" style="font-size: 0.85rem;">&copy; 2024 电商订单管理系统</p>
                    </div>
                </div>
            </form>
        </div>

        <!-- 右侧图形装饰区域 -->
        <div class="graphics-section">
            <!-- 背景装饰圆圈 -->
            <div class="circle circle1"></div>
            <div class="circle circle2"></div>
            <div class="circle circle3"></div>

            <!-- 主要内容 -->
            <div class="graphics-content">
                <h1>电商订单管理系统</h1>
                <p>高效管理 · 智能分析 · 轻松运营</p>

                <!-- 电商主题图标网格 -->
                <div class="icon-grid">
                    <div class="icon-item">
                        <i class="fas fa-shopping-cart"></i>
                        <span>订单管理</span>
                    </div>
                    <div class="icon-item">
                        <i class="fas fa-box"></i>
                        <span>库存管理</span>
                    </div>
                    <div class="icon-item">
                        <i class="fas fa-users"></i>
                        <span>用户管理</span>
                    </div>
                    <div class="icon-item">
                        <i class="fas fa-chart-line"></i>
                        <span>数据分析</span>
                    </div>
                    <div class="icon-item">
                        <i class="fas fa-truck"></i>
                        <span>物流追踪</span>
                    </div>
                    <div class="icon-item">
                        <i class="fas fa-credit-card"></i>
                        <span>支付管理</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>