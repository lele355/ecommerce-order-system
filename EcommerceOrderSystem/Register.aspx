<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="EcommerceOrderSystem.Register" %>

<!DOCTYPE html>
<html lang="zh-cn">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>用户注册 - 电商MIS</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Nunito', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem;
        }
        
        .register-card {
            width: 100%;
            max-width: 500px;
            background: white;
            border-radius: 24px;
            padding: 3rem;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            animation: slideIn 0.5s ease-out;
        }
        
        @keyframes slideIn {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .logo-icon {
            width: 70px;
            height: 70px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1.5rem;
            box-shadow: 0 8px 16px rgba(102, 126, 234, 0.3);
        }
        
        h2 {
            color: #2d3748;
            font-weight: 800;
            text-align: center;
            margin-bottom: 0.5rem;
        }
        
        .subtitle {
            text-align: center;
            color: #718096;
            margin-bottom: 2rem;
            font-size: 0.95rem;
        }
        
        .form-label {
            font-weight: 600;
            color: #4a5568;
            margin-bottom: 0.5rem;
            font-size: 0.9rem;
        }
        
        .form-control {
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            padding: 12px 16px 12px 45px;
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
        
        .input-icon {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #a0aec0;
            z-index: 10;
        }
        
        .btn-register {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 14px;
            font-weight: 700;
            color: white;
            width: 100%;
            transition: all 0.3s ease;
            font-size: 1rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 1rem;
        }
        
        .btn-register:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(118, 75, 162, 0.4);
        }
        
        .btn-back {
            background: #f7fafc;
            border: 2px solid #e2e8f0;
            border-radius: 50px;
            padding: 14px;
            font-weight: 600;
            color: #4a5568;
            width: 100%;
            transition: all 0.3s ease;
            font-size: 1rem;
            margin-top: 0.75rem;
        }
        
        .btn-back:hover {
            background: #edf2f7;
            border-color: #cbd5e0;
        }
        
        .alert {
            border-radius: 12px;
            border: none;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
        }
        
        .alert-danger {
            background: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="register-card">
            <div class="logo-icon">
                <i class="fas fa-user-plus fa-2x text-white"></i>
            </div>
            
            <h2>创建新账户</h2>
            <p class="subtitle">欢迎加入电商订单管理系统</p>
            
            <asp:Panel ID="pnlSuccess" runat="server" Visible="false" CssClass="alert alert-success mb-3">
                <i class="fas fa-check-circle me-2"></i>
                <asp:Label ID="lblSuccess" runat="server"></asp:Label>
            </asp:Panel>
            
            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger mb-3">
                <i class="fas fa-exclamation-circle me-2"></i>
                <asp:Label ID="lblError" runat="server"></asp:Label>
            </asp:Panel>
            
            <div class="mb-3">
                <label class="form-label">登录账号</label>
                <div class="position-relative">
                    <i class="fas fa-user input-icon"></i>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="请输入用户名" MaxLength="50"></asp:TextBox>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">设置密码</label>
                <div class="position-relative">
                    <i class="fas fa-lock input-icon"></i>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="请输入密码" MaxLength="50"></asp:TextBox>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">真实姓名</label>
                <div class="position-relative">
                    <i class="fas fa-id-card input-icon"></i>
                    <asp:TextBox ID="txtRealName" runat="server" CssClass="form-control" placeholder="请输入真实姓名" MaxLength="50"></asp:TextBox>
                </div>
            </div>
            
            <asp:Button ID="btnRegister" runat="server" Text="立即注册" CssClass="btn-register" OnClick="btnRegister_Click" />
            <asp:Button ID="btnBack" runat="server" Text="返回登录" CssClass="btn-back" OnClick="btnBack_Click" CausesValidation="false" />
        </div>
    </form>
</body>
</html>
