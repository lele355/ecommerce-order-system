<%@ Page Title="收入分析" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="IncomeAnalysis.aspx.cs" Inherits="EcommerceOrderSystem.IncomeAnalysis" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        /* 收入分析页面样式 */
        .analysis-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 2rem;
            padding: 3rem 2.5rem;
            color: white;
            margin-bottom: 2.5rem;
            position: relative;
            overflow: hidden;
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            box-shadow: 0 12px 32px rgba(118, 75, 162, 0.25);
        }
        
        .analysis-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 60%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        }
        
        .analysis-header-content {
            position: relative;
            z-index: 2;
        }
        
        /* 统计卡片 */
        .stat-card-analysis {
            background: rgba(255,255,255,0.92);
            border-radius: 1.5rem;
            padding: 1.75rem;
            border: 1px solid rgba(243,244,246,0.85);
            transition: all 0.3s ease;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
            height: 100%;
        }
        
        .stat-card-analysis:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 40px rgba(102, 126, 234, 0.18);
        }
        
        .stat-icon-analysis {
            width: 60px;
            height: 60px;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.75rem;
            color: white;
            margin-bottom: 1rem;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.15);
        }
        
        .stat-value-analysis {
            font-size: 2.25rem;
            font-weight: 800;
            margin-bottom: 0.5rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .stat-label-analysis {
            font-size: 0.9375rem;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 0.5rem;
        }
        
        .stat-change {
            font-size: 0.875rem;
            font-weight: 600;
            padding: 0.375rem 0.75rem;
            border-radius: 50px;
            display: inline-flex;
            align-items: center;
            gap: 0.375rem;
        }
        
        .stat-change.positive {
            background: rgba(16, 185, 129, 0.1);
            color: #059669;
        }
        
        .stat-change.negative {
            background: rgba(239, 68, 68, 0.1);
            color: #dc2626;
        }
        
        /* 图表容器 */
        .chart-card {
            background: rgba(255,255,255,0.92);
            border-radius: 1.5rem;
            padding: 2rem;
            border: 1px solid rgba(243,244,246,0.85);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
            margin-bottom: 2rem;
        }
        
        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f3f4f6;
        }
        
        .chart-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #111827;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .chart-title i {
            width: 40px;
            height: 40px;
            border-radius: 0.625rem;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.125rem;
            color: white;
        }
        
        /* 筛选器 */
        .date-filter {
            display: flex;
            gap: 0.5rem;
            align-items: center;
        }
        
        .filter-btn {
            padding: 0.5rem 1rem;
            border-radius: 50px;
            border: 1px solid #e5e7eb;
            background: white;
            color: #6b7280;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .filter-btn:hover {
            border-color: #667eea;
            color: #667eea;
        }
        
        .filter-btn.active {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-color: transparent;
        }
        
        /* 数据表格 */
        .data-table-wrapper {
            background: rgba(255,255,255,0.92);
            border-radius: 1.5rem;
            overflow: hidden;
            border: 1px solid rgba(243,244,246,0.85);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            box-shadow: 0 12px 28px rgba(31,38,135,0.12);
        }
        
        .progress-bar-custom {
            height: 8px;
            border-radius: 50px;
            background: #e5e7eb;
            overflow: hidden;
            margin-top: 0.5rem;
        }
        
        .progress-fill {
            height: 100%;
            border-radius: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            transition: width 0.6s ease;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- 页面头部 -->
    <div class="analysis-header fade-in">
        <div class="analysis-header-content">
            <div class="d-flex align-items-center justify-content-between">
                <div>
                    <h1 class="fw-bold mb-2">
                        <i class="fas fa-chart-line me-3"></i>
                        收入分析报表
                    </h1>
                    <p class="mb-0 opacity-90">实时监控销售收入、成本和利润数据</p>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-light rounded-pill px-4" onclick="refreshData()">
                        <i class="fas fa-sync-alt me-2"></i>刷新数据
                    </button>
                    <button type="button" class="btn btn-light rounded-pill px-4" onclick="exportReport()">
                        <i class="fas fa-download me-2"></i>导出报表
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- 核心统计卡片 -->
    <div class="row g-4 mb-4 fade-in">
        <div class="col-md-6 col-xl-3">
            <div class="stat-card-analysis">
                <div class="stat-icon-analysis" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);">
                    <i class="fas fa-dollar-sign"></i>
                </div>
                <div class="stat-label-analysis">总收入</div>
                <div class="stat-value-analysis">
                    <asp:Label ID="lblTotalRevenue" runat="server" Text="¥0.00"></asp:Label>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <asp:Label ID="lblRevenueChange" runat="server" Text="+12.5%"></asp:Label>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-xl-3">
            <div class="stat-card-analysis">
                <div class="stat-icon-analysis" style="background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);">
                    <i class="fas fa-shopping-cart"></i>
                </div>
                <div class="stat-label-analysis">总成本</div>
                <div class="stat-value-analysis">
                    <asp:Label ID="lblTotalCost" runat="server" Text="¥0.00"></asp:Label>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <asp:Label ID="lblCostChange" runat="server" Text="+8.3%"></asp:Label>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-xl-3">
            <div class="stat-card-analysis">
                <div class="stat-icon-analysis" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <div class="stat-label-analysis">净利润</div>
                <div class="stat-value-analysis">
                    <asp:Label ID="lblNetProfit" runat="server" Text="¥0.00"></asp:Label>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <asp:Label ID="lblProfitChange" runat="server" Text="+15.7%"></asp:Label>
                </div>
            </div>
        </div>
        
        <div class="col-md-6 col-xl-3">
            <div class="stat-card-analysis">
                <div class="stat-icon-analysis" style="background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);">
                    <i class="fas fa-percentage"></i>
                </div>
                <div class="stat-label-analysis">利润率</div>
                <div class="stat-value-analysis">
                    <asp:Label ID="lblProfitMargin" runat="server" Text="0%"></asp:Label>
                </div>
                <div class="stat-change positive">
                    <i class="fas fa-arrow-up"></i>
                    <asp:Label ID="lblMarginChange" runat="server" Text="+2.1%"></asp:Label>
                </div>
            </div>
        </div>
    </div>

    <!-- 收入趋势图表 -->
    <div class="row g-4 mb-4">
        <div class="col-xl-8">
            <div class="chart-card fade-in">
                <div class="chart-header">
                    <div class="chart-title">
                        <div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);" class="chart-title i">
                            <i class="fas fa-chart-area"></i>
                        </div>
                        <span>收入趋势分析</span>
                    </div>
                    <div class="date-filter">
                        <asp:LinkButton ID="btnFilter7Days" runat="server" CssClass="filter-btn active" OnClick="FilterPeriod_Click" CommandArgument="7">
                            近7天
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnFilter30Days" runat="server" CssClass="filter-btn" OnClick="FilterPeriod_Click" CommandArgument="30">
                            近30天
                        </asp:LinkButton>
                        <asp:LinkButton ID="btnFilter90Days" runat="server" CssClass="filter-btn" OnClick="FilterPeriod_Click" CommandArgument="90">
                            近90天
                        </asp:LinkButton>
                    </div>
                </div>
                <div style="position: relative; height: 350px;">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-xl-4">
            <div class="chart-card fade-in">
                <div class="chart-header">
                    <div class="chart-title">
                        <div style="background: linear-gradient(135deg, #10b981 0%, #059669 100%);" class="chart-title i">
                            <i class="fas fa-chart-pie"></i>
                        </div>
                        <span>成本构成</span>
                    </div>
                </div>
                <div style="position: relative; height: 350px;">
                    <canvas id="costPieChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- 商品收入排行 -->
    <div class="data-table-wrapper fade-in">
        <div class="p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold m-0">
                    <i class="fas fa-trophy me-2 text-warning"></i>
                    商品销售排行
                </h5>
                <asp:DropDownList ID="ddlTopCount" runat="server" CssClass="form-select w-auto" AutoPostBack="true" OnSelectedIndexChanged="ddlTopCount_SelectedIndexChanged">
                    <asp:ListItem Text="前10名" Value="10" Selected="True"></asp:ListItem>
                    <asp:ListItem Text="前20名" Value="20"></asp:ListItem>
                    <asp:ListItem Text="前50名" Value="50"></asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>
        <asp:GridView ID="gvTopProducts" runat="server" AutoGenerateColumns="False" 
            CssClass="table align-middle mb-0" GridLines="None">
            <Columns>
                <asp:TemplateField HeaderText="排名" ItemStyle-Width="80px" ItemStyle-CssClass="ps-4">
                    <ItemTemplate>
                        <div class="fw-bold fs-4" style='color: <%# Container.DataItemIndex < 3 ? "#f59e0b" : "#6b7280" %>'>
                            #<%# Container.DataItemIndex + 1 %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="商品名称">
                    <ItemTemplate>
                        <div>
                            <div class="fw-bold text-dark"><%# Eval("商品标准名称") %></div>
                            <small class="text-muted">编号: <%# Eval("商品编号") %></small>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="销售数量" HeaderStyle-CssClass="text-center">
                    <ItemTemplate>
                        <div class="text-center">
                            <span class="badge bg-primary bg-opacity-10 text-primary fw-bold px-3 py-2">
                                <%# Eval("销售数量") %> 件
                            </span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="销售收入" HeaderStyle-CssClass="text-end pe-4">
                    <ItemTemplate>
                        <div class="text-end">
                            <div class="fw-bold fs-5" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                ¥<%# Eval("销售收入", "{0:N2}") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="成本" HeaderStyle-CssClass="text-end">
                    <ItemTemplate>
                        <div class="text-end">
                            <div class="text-danger fw-bold">
                                ¥<%# Eval("总成本", "{0:N2}") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="利润" HeaderStyle-CssClass="text-end">
                    <ItemTemplate>
                        <div class="text-end">
                            <div class="text-success fw-bold">
                                ¥<%# Eval("利润", "{0:N2}") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
                
                <asp:TemplateField HeaderText="占比" ItemStyle-Width="200px" ItemStyle-CssClass="pe-4">
                    <ItemTemplate>
                        <div>
                            <div class="small text-muted mb-1"><%# Eval("占比", "{0:P1}") %></div>
                            <div class="progress-bar-custom">
                                <div class="progress-fill" style='width: <%# Eval("占比", "{0:P0}") %>'></div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
            <HeaderStyle CssClass="bg-light text-muted small fw-bold border-bottom" Height="50px" />
        </asp:GridView>
    </div>

    <script>
        // 图表数据（从后端传递）
        var revenueData = <%= RevenueChartData %>;
        var costData = <%= CostPieData %>;
        
        // 收入趋势图表
        var revenueCtx = document.getElementById('revenueChart').getContext('2d');
        var revenueChart = new Chart(revenueCtx, {
            type: 'line',
            data: {
                labels: revenueData.labels,
                datasets: [{
                    label: '收入',
                    data: revenueData.revenue,
                    borderColor: 'rgb(102, 126, 234)',
                    backgroundColor: 'rgba(102, 126, 234, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: '成本',
                    data: revenueData.cost,
                    borderColor: 'rgb(239, 68, 68)',
                    backgroundColor: 'rgba(239, 68, 68, 0.1)',
                    tension: 0.4,
                    fill: true
                }, {
                    label: '利润',
                    data: revenueData.profit,
                    borderColor: 'rgb(16, 185, 129)',
                    backgroundColor: 'rgba(16, 185, 129, 0.1)',
                    tension: 0.4,
                    fill: true
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'top'
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: function(value) {
                                return '¥' + value.toLocaleString();
                            }
                        }
                    }
                }
            }
        });
        
        // 成本构成饼图
        var costCtx = document.getElementById('costPieChart').getContext('2d');
        var costPieChart = new Chart(costCtx, {
            type: 'doughnut',
            data: {
                labels: costData.labels,
                datasets: [{
                    data: costData.values,
                    backgroundColor: [
                        'rgb(102, 126, 234)',
                        'rgb(239, 68, 68)',
                        'rgb(16, 185, 129)',
                        'rgb(245, 158, 11)',
                        'rgb(139, 92, 246)'
                    ]
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        display: true,
                        position: 'bottom'
                    }
                }
            }
        });
        
        function refreshData() {
            location.reload();
        }
        
        function exportReport() {
            alert('导出功能开发中...');
        }
    </script>

</asp:Content>
