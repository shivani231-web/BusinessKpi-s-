-- ===============================================
-- Business KPIs SQL Queries
-- SQL Server / Microsoft SQL Express
-- Author: SHIVANI MUDAGAL
-- Purpose: Create views and perform checks for Power BI dashboard
-- ===============================================

-- Use the database
USE BusinessKPIs;
GO

-- ===============================================
-- 1️⃣ Monthly Revenue View
-- Creates a view with Year, Month, YearMonth, and MonthlyRevenue
-- ===============================================
CREATE VIEW dbo.vw_monthly_revenue AS
SELECT
YEAR(order_date) AS [Year],
MONTH(order_date) AS [Month],
CONCAT(CAST(YEAR(order_date) AS VARCHAR(4)),'-', RIGHT('0' + CAST(MONTH(order_date) AS VARCHAR(2)),2)) AS YearMonth,
SUM(revenue) AS MonthlyRevenue
FROM dbo.sales
GROUP BY YEAR(order_date), MONTH(order_date);
GO

-- ===============================================
-- 2️⃣ Top Products View
-- Summarizes revenue and units sold by product
-- ===============================================
CREATE VIEW dbo.vw_top_products AS
SELECT 
p.product_id, 
p.product_name, 
p.category,
SUM(s.revenue) AS Revenue,
SUM(s.quantity) AS UnitsSold
FROM dbo.sales s
JOIN dbo.products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category;
GO

-- ===============================================
-- 3️⃣ Region Revenue View
-- Summarizes revenue by customer region
-- ===============================================
CREATE VIEW dbo.vw_region_revenue AS
SELECT 
c.region, 
SUM(s.revenue) AS Revenue
FROM dbo.sales s
JOIN dbo.customers c ON s.customer_id = c.customer_id
GROUP BY c.region;
GO

-- ===============================================
-- 4️⃣ KPI Summary View
-- Aggregated KPIs: TotalRevenue, TotalProfit, TotalOrders, AvgOrderValue
-- ===============================================
CREATE VIEW dbo.vw_kpis AS
SELECT
SUM(revenue) AS TotalRevenue,
SUM(profit) AS TotalProfit,
COUNT(*) AS TotalOrders,
CASE WHEN COUNT(*) = 0 THEN 0 ELSE SUM(revenue)/COUNT(*) END AS AvgOrderValue
FROM dbo.sales;
GO

-- ===============================================
-- ✅ Test / Validation Queries
-- Check your views and totals
-- ===============================================

-- 1️⃣ Total Revenue Check
SELECT SUM(revenue) AS TotalRevenue FROM dbo.sales;

-- 2️⃣ Monthly Revenue View Check
SELECT * FROM dbo.vw_monthly_revenue ORDER BY [Year], [Month];

-- 3️⃣ Top Products View Check (Top 5)
SELECT TOP 5 * FROM dbo.vw_top_products;

-- 4️⃣ Region Revenue View Check
SELECT * FROM dbo.vw_region_revenue;
