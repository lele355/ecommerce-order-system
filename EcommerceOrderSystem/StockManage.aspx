<%@ Page Title="库存管理" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="StockManage.aspx.cs" Inherits="EcommerceOrderSystem.StockManage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link href="Content/modern-design.css" rel="stylesheet" />
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showStockModal() { new bootstrap.Modal(document.getElementById('stockInModal')).show(); }
    </script>
    <style>
        /* Stock Header */
        .stock-header {
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
        
        .stock-header::before {
            content: '';
            position: absolute;
            top: -50%;
            right: -10%;
            width: 60%;
            height: 200%;
            background: radial-gradient(circle, rgba(255, 255, 255, 0.1) 0%, transparent 70%);
        }
        
        .stock-header-content {
            position: relative;
            z-index: 2;
        }
        
        /* Product Icon */
        .product-icon-stock {
            width: 55px;
            height: 55px;
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            font-size: 1.5rem;
        }
        
        /* Stock Badge Colors */
        .stock-critical { background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%) !important; color: white !important; }
        .stock-warning { background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%) !important; color: white !important; }
        .stock-good { background: linear-gradient(135deg, #10b981 0%, #059669 100%) !important; color: white !important; }
        
        /* Modal Styles */
        .stock-modal-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 1.5rem 1.5rem 0 0;
        }
        
        .stock-info-box {
            background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%);
            border: 2px solid #e5e7eb;
            border-radius: 1rem;
            padding: 2rem;
            text-align: center;
        }
        
        .qty-input-large {
            font-size: 2.5rem;
            font-weight: 800;
            text-align: center;
            border: 3px solid #e5e7eb;
            border-radius: 1rem;
            padding: 1rem;
            background: #f9fafb;
            color: #111827;
        }
        
        .qty-input-large:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 4px rgba(102, 126, 234, 0.1);
            outline: none;
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
<!-- Stock Header -->
<div class="stock-header">
    <div class="stock-header-content">
        <div class="d-flex align-items-center justify-content-between">
            <div>
                <h1 class="fw-bold mb-2">
                    <i class="fas fa-warehouse me-3"></i>
                    库存管理
                </h1>
                <p class="mb-0 opacity-90">管理商品库存和入库记录</p>
            </div>
            <asp:LinkButton ID="btnViewHistory" runat="server" CssClass="btn btn-light rounded-pill px-4 py-2 fw-600" OnClick="btnViewHistory_Click">
                <i class="fas fa-history me-2"></i>入库历史
            </asp:LinkButton>
        </div>
    </div>
</div>

    <!-- Stock Table -->
    <asp:UpdatePanel ID="upStock" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            
            <div class="table-container fade-in" style="background: rgba(255,255,255,0.85); border: 1px solid rgba(243,244,246,0.85); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); box-shadow: 0 12px 30px rgba(31,38,135,0.12); border-radius: 1.5rem; overflow: hidden;">
                <asp:GridView ID="gvStock" runat="server" AutoGenerateColumns="False" 
                    CssClass="table mb-0" GridLines="None"
                    AllowPaging="True" PageSize="10" OnPageIndexChanging="gvStock_PageIndexChanging" OnRowCommand="gvStock_RowCommand">
                    <Columns>
                        <asp:TemplateField HeaderText="商品名称">
                            <ItemTemplate>
                                <div class="d-flex align-items-center gap-3">
                                    <div class="product-icon-stock">
                                        <i class="fas fa-box"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold"><%# Eval("商品标准名称") %></div>
                                        <small class="text-muted">编号: <%# Eval("商品编号") %></small>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="分类">
                            <ItemTemplate>
                                <span class="badge bg-light text-dark border px-3 py-2">
                                    <i class="fas fa-tag me-1"></i>
                                    <%# Eval("类别名称") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="价格">
                            <ItemTemplate>
                                <div>
                                    <div class="fw-bold" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                        ¥<%# Eval("商品销售单价", "{0:F2}") %>
                                    </div>
                                    <small class="text-muted">成本: ¥<%# Eval("商品进货成本价", "{0:F2}") %></small>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="库存">
                            <ItemTemplate>
                                <span class='badge rounded-pill fw-bold px-4 py-2 <%# Convert.ToInt32(Eval("商品当前库存量")) < 10 ? "stock-critical" : (Convert.ToInt32(Eval("商品当前库存量")) < 50 ? "stock-warning" : "stock-good") %>'>
                                    <%# Eval("商品当前库存量") %> 件
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        
                        <asp:TemplateField HeaderText="状态">
                            <ItemTemplate>
                                <span class='badge rounded-pill px-3 py-2 <%# Convert.ToBoolean(Eval("商品是否上架")) ? "bg-success" : "bg-secondary" %>'>
                                    <%# Convert.ToBoolean(Eval("商品是否上架")) ? "在售" : "停售" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>

                        <asp:TemplateField HeaderText="操作" ItemStyle-CssClass="text-end pe-4" ItemStyle-Width="120px">
                            <ItemTemplate>
                                <div class="d-flex justify-content-end">
                                    <asp:LinkButton ID="btnStockIn" runat="server" CssClass="btn btn-sm btn-outline-primary rounded-pill fw-600 lift-hover" CommandName="StockIn" CommandArgument='<%# Eval("商品编号") %>' style="min-width: 90px;">
                                        <i class="fas fa-plus-circle me-1"></i> 入库
                                    </asp:LinkButton>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <PagerStyle CssClass="grid-pager" />
                    <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="5" />
                </asp:GridView>
            </div>

        </ContentTemplate>
    </asp:UpdatePanel>

    <!-- Stock In Modal - 横向卡片布局 -->
    <div class="modal fade" id="stockInModal" tabindex="-1">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow-lg fade-in" style="border-radius: 1.5rem; overflow: hidden;">
                <asp:UpdatePanel ID="upModal" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="stock-modal-header" style="backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px); box-shadow: 0 10px 24px rgba(118, 75, 162, 0.25);">
                            <h4 class="mb-1 fw-bold">
                                <i class="fas fa-box me-2"></i>
                                商品入库
                            </h4>
                            <p class="mb-0 opacity-90">Stock In Operation</p>
                            <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-0 fade-in">
                            <!-- 横向卡片布局 -->
                            <div class="row g-0">
                                <!-- 左侧：商品信息卡片 -->
                                <div class="col-md-5 p-4" style="background: linear-gradient(135deg, #f9fafb 0%, #ffffff 100%); border-right: 2px solid #e5e7eb;">
                                    <div class="text-center mb-4">
                                        <div class="product-icon-stock mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                                            <i class="fas fa-box"></i>
                                        </div>
                                        <h5 class="fw-bold mb-1"><asp:Label ID="lblModalProdName" runat="server"></asp:Label></h5>
                                        <small class="text-muted">产品信息</small>
                                    </div>
                                    
                                    <!-- 信息卡片 -->
                                    <div class="mb-3">
                                        <div class="d-flex align-items-center p-3" style="background: white; border-radius: 0.75rem; border: 2px solid #e5e7eb;">
                                            <div style="width: 45px; height: 45px; border-radius: 0.625rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.25rem; flex-shrink: 0; margin-right: 0.75rem;">
                                                <i class="fas fa-cubes"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="small text-muted mb-1">当前库存</div>
                                                <div class="fw-bold fs-4" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
                                                    <asp:Label ID="lblModalCurrentStock" runat="server"></asp:Label> 件
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="mb-3">
                                        <div class="d-flex align-items-center p-3" style="background: white; border-radius: 0.75rem; border: 2px solid #e5e7eb;">
                                            <div style="width: 45px; height: 45px; border-radius: 0.625rem; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 1.25rem; flex-shrink: 0; margin-right: 0.75rem;">
                                                <i class="fas fa-user-tie"></i>
                                            </div>
                                            <div class="flex-grow-1">
                                                <div class="small text-muted mb-1">经办人</div>
                                                <div class="fw-bold" style="color: #f59e0b;">
                                                    <asp:Label ID="lblOperator" runat="server"></asp:Label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="alert alert-info mb-0" style="background: rgba(59, 130, 246, 0.1); border: 1px solid rgba(59, 130, 246, 0.2); border-radius: 0.75rem;">
                                        <i class="fas fa-info-circle me-2"></i>
                                        <small>入库操作将立即生效</small>
                                    </div>
                                </div>
                                
                                <!-- 右侧：入库操作区 -->
                                <div class="col-md-7 p-4">
                                    <div class="mb-4">
                                        <label class="form-label fw-bold mb-3 d-flex align-items-center">
                                            <div style="width: 35px; height: 35px; border-radius: 0.5rem; background: linear-gradient(135deg, #10b981 0%, #059669 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem;">
                                                <i class="fas fa-plus-circle"></i>
                                            </div>
                                            <span>入库数量</span>
                                        </label>
                                        <asp:TextBox ID="txtAddQty" runat="server" CssClass="qty-input-large" TextMode="Number" Text="10" min="1" style="width: 100%;"></asp:TextBox>
                                    </div>
                                    
                                    <!-- 实时预览 -->
                                    <div class="mb-4">
                                        <div class="p-4" style="background: linear-gradient(135deg, #ecfdf5 0%, #d1fae5 100%); border-radius: 1rem; border: 2px solid #10b981;">
                                            <div class="row align-items-center">
                                                <div class="col-6 text-center">
                                                    <div class="small text-muted mb-2">当前库存</div>
                                                    <div class="fw-bold fs-2" style="color: #6b7280;">
                                                        <asp:Label ID="lblModalCurrentStock2" runat="server"></asp:Label>
                                                    </div>
                                                </div>
                                                <div class="col-auto">
                                                    <i class="fas fa-arrow-right" style="font-size: 1.5rem; color: #10b981;"></i>
                                                </div>
                                                <div class="col text-center">
                                                    <div class="small text-muted mb-2">入库后库存</div>
                                                    <div class="fw-bold" style="font-size: 2.5rem; color: #10b981;">
                                                        <span id="previewStock">
                                                            <asp:Label ID="lblModalCurrentStock3" runat="server"></asp:Label>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    
                                    <div class="text-center text-muted small">
                                        <i class="fas fa-check-circle me-1" style="color: #10b981;"></i>
                                        请输入要增加的库存数量（最少1件）
                                    </div>
                                </div>
                            </div>
                        </div>
                        
                        <script>
                            // 实时计算预览库存
                            function updateStockPreview() {
                                setTimeout(function() {
                                    var qtyInput = document.querySelector('[id$="txtAddQty"]');
                                    var currentStockLabel = document.querySelector('[id$="lblModalCurrentStock"]');
                                    var previewSpan = document.getElementById('previewStock');
                                    
                                    if (qtyInput && currentStockLabel && previewSpan) {
                                        var current = parseInt(currentStockLabel.textContent.trim()) || 0;
                                        var add = parseInt(qtyInput.value) || 0;
                                        var preview = current + add;
                                        previewSpan.innerHTML = '<span>' + preview + '</span>';
                                        
                                        // 绑定输入事件
                                        qtyInput.removeEventListener('input', handleInput);
                                        qtyInput.addEventListener('input', handleInput);
                                        
                                        // 绑定键盘事件
                                        qtyInput.removeEventListener('keyup', handleInput);
                                        qtyInput.addEventListener('keyup', handleInput);
                                        
                                        // 绑定change事件
                                        qtyInput.removeEventListener('change', handleInput);
                                        qtyInput.addEventListener('change', handleInput);
                                    }
                                }, 100);
                            }
                            
                            function handleInput() {
                                var qtyInput = document.querySelector('[id$="txtAddQty"]');
                                var currentStockLabel = document.querySelector('[id$="lblModalCurrentStock"]');
                                var previewSpan = document.getElementById('previewStock');
                                
                                if (qtyInput && currentStockLabel && previewSpan) {
                                    var current = parseInt(currentStockLabel.textContent.trim()) || 0;
                                    var add = parseInt(qtyInput.value) || 0;
                                    var preview = current + add;
                                    previewSpan.innerHTML = '<span>' + preview + '</span>';
                                }
                            }
                            
                            // 页面加载时初始化
                            document.addEventListener('DOMContentLoaded', updateStockPreview);
                            
                            // UpdatePanel 更新后也要重新绑定
                            if (typeof Sys !== 'undefined') {
                                Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function() {
                                    updateStockPreview();
                                });
                            }
                        </script>
                        
                        <div class="modal-footer border-0 p-4 bg-light fade-in">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>取消
                            </button>
                            <asp:Button ID="btnConfirmStockIn" runat="server" Text="✓ 确认入库" CssClass="btn rounded-pill px-4 py-2 fw-bold" style="background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; border: none;" OnClick="btnConfirmStockIn_Click" />
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

    <!-- 入库历史记录弹窗 -->
    <div class="modal fade" id="historyModal" tabindex="-1">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" style="margin-top: 10px; margin-bottom: 10px;">
            <div class="modal-content border-0 shadow-lg rounded-4">
                <asp:UpdatePanel ID="upHistory" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <div class="modal-header border-0" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 1.75rem 2rem; position: sticky; top: 0; z-index: 2; backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);">
                            <div>
                                <h4 class="fw-bold text-white mb-1" style="letter-spacing: .3px;">
                                    <i class="fas fa-history me-2"></i>入库历史记录
                                </h4>
                                <p class="text-white mb-0 opacity-75" style="font-size: 0.9rem;">Stock In History</p>
                            </div>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="关闭"></button>
                        </div>
                        <div class="modal-body p-0" style="max-height: 70vh; overflow: auto; background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);">
                            <asp:GridView ID="gvHistory" runat="server" AutoGenerateColumns="False" 
                                CssClass="table align-middle mb-0" GridLines="None"
                                AllowPaging="True" PageSize="15" OnPageIndexChanging="gvHistory_PageIndexChanging">
                                <Columns>
                                    <asp:TemplateField HeaderText="记录号" ItemStyle-Width="120px" ItemStyle-CssClass="ps-4">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center py-2">
                                                <div style="width: 40px; height: 40px; border-radius: 0.625rem; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem; box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);">
                                                    <i class="fas fa-hashtag"></i>
                                                </div>
                                                <span class="fw-bold text-dark"><%# Eval("入库记录号") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="商品名称">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center py-2">
                                                <div style="width: 50px; height: 50px; border-radius: 0.875rem; background: linear-gradient(135deg, #e0e7ff 0%, #f3f4f6 100%); display: flex; align-items: center; justify-content: center; margin-right: 0.875rem; border: 2px solid #e5e7eb;">
                                                    <i class="fas fa-box" style="color: #667eea; font-size: 1.375rem;"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold text-dark"><%# Eval("商品标准名称") %></div>
                                                    <div class="small text-muted">
                                                        <i class="fas fa-tag me-1"></i>商品记录
                                                    </div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="入库数量" HeaderStyle-CssClass="text-center" ItemStyle-Width="140px">
                                        <ItemTemplate>
                                            <div class="text-center py-2">
                                                <div style="display: inline-block; padding: 0.625rem 1.5rem; background: linear-gradient(135deg, #10b981 0%, #059669 100%); color: white; border-radius: 50px; font-weight: 700; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);">
                                                    <i class="fas fa-plus me-1"></i><%# Eval("入库数量") %> 件
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="经办人" ItemStyle-Width="150px">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center py-2">
                                                <div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8125rem; margin-right: 0.625rem; box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);">
                                                    <i class="fas fa-user-tie"></i>
                                                </div>
                                                <span class="fw-bold text-dark"><%# string.IsNullOrEmpty(Eval("经办人姓名").ToString()) ? "系统" : Eval("经办人姓名") %></span>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="入库时间" ItemStyle-Width="200px" ItemStyle-CssClass="pe-4">
                                        <ItemTemplate>
                                            <div class="d-flex align-items-center py-2">
                                                <div style="width: 36px; height: 36px; border-radius: 0.5rem; background: linear-gradient(135deg, #8b5cf6 0%, #6d28d9 100%); display: flex; align-items: center; justify-content: center; color: white; font-size: 0.875rem; margin-right: 0.75rem; box-shadow: 0 4px 12px rgba(139, 92, 246, 0.3);">
                                                    <i class="fas fa-calendar-alt"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold text-dark" style="font-size: 0.9375rem;"><%# Eval("入库操作时间", "{0:yyyy-MM-dd}") %></div>
                                                    <div class="small text-muted"><%# Eval("入库操作时间", "{0:HH:mm:ss}") %></div>
                                                </div>
                                            </div>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <RowStyle CssClass="border-0" />
                                <AlternatingRowStyle BackColor="White" />
                                <HeaderStyle CssClass="text-uppercase small fw-bold text-muted border-bottom" Height="48px" BackColor="#f8f9fa" />
                                <PagerStyle CssClass="grid-pager p-3 border-top bg-white" />
                                <PagerSettings Mode="Numeric" Position="Bottom" PageButtonCount="10" />
                            </asp:GridView>
                        </div>
                        <div class="modal-footer border-0 p-3" style="position: sticky; bottom: 0; z-index: 2; background: rgba(255,255,255,0.95); backdrop-filter: blur(10px); -webkit-backdrop-filter: blur(10px);">
                            <button type="button" class="btn btn-light rounded-pill px-4 py-2 fw-bold" data-bs-dismiss="modal">
                                <i class="fas fa-times me-2"></i>关闭
                            </button>
                        </div>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
        </div>
    </div>

</asp:Content>