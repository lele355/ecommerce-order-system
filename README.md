# 电商订单管理系统

基于 ASP.NET WebForms 的电商订单全流程管理系统

## 功能模块

| 端 | 页面 | 功能 |
|---|---|---|
| 前台 | `Default` / `Menu` | 商品浏览、分类筛选 |
| 前台 | `Cart` / `Checkout` | 购物车、下单结算 |
| 前台 | `MyOrders` / `Profile` | 订单查询、个人中心 |
| 后台 | `Dashboard` | 数据概览 |
| 后台 | `CategoryManage` | 商品分类管理 |
| 后台 | `IncomeAnalysis` | 营收统计分析 |
| 通用 | `Login` | 用户认证 |

## 目录结构

```
EcommerceOrderSystem/
  *.aspx / *.aspx.cs        页面与后台代码
  *.aspx.designer.cs        设计器生成代码
  CartItem.cs               购物车数据模型
  Content/modern-design.css 前端样式
  EcommerceOrderSystem.csproj / packages.config
  Web.config                数据库连接配置（口令已脱敏）
```

## 技术栈

ASP.NET WebForms · C# · SQL Server · ADO.NET · CSS

## 复现提示

1. Visual Studio 打开 `.csproj`，还原 NuGet 包
2. 在 SQL Server 中建库（`.mdf` 数据库文件未纳入版本管理）
3. 修改 `Web.config` 中的连接字符串为自己的账号

> **安全说明**：源码与配置中涉及的数据库连接口令，已全部替换为占位符 `YOUR_PASSWORD_HERE`。本地复现时请自行配置数据库账号。



---

**安家乐** · 西安理工大学 机械工程学院 · 工业工程（2023 级 / 2027 届）

GitHub：[@Lele355](https://github.com/Lele355)

*本仓库内容为个人学习成果，仅供学习交流参考。*
