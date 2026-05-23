-- ==============================================================================
-- Stage 6: Data Warehousing - Materialized Views & Query Rewrite
-- Giai đoạn 6: Kho dữ liệu - View Cụ thể hóa & Tự động Viết lại truy vấn
-- ==============================================================================

-- Problem: A reporting dashboard runs a query every 5 minutes that sums 
-- millions of transaction records. It consumes massive CPU.
-- (Vấn đề: Dashboard chạy truy vấn tính tổng hàng triệu giao dịch mỗi 5 phút. Tốn cực nhiều CPU).

-- 1. Create Materialized View Logs on the Base Tables
-- To enable "Fast Refresh", Oracle needs to track exactly what rows change in the base tables.
-- (Để bật "Fast Refresh", Oracle cần theo dõi chính xác hàng nào thay đổi ở bảng gốc thông qua MView Logs).
CREATE MATERIALIZED VIEW LOG ON enterprise_core_db.transactions
WITH ROWID, SEQUENCE (transaction_date, amount) INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW LOG ON enterprise_core_db.customers
WITH ROWID, SEQUENCE (region_code) INCLUDING NEW VALUES;

-- 2. Create the Materialized View
-- (Tạo View cụ thể hóa)
CREATE MATERIALIZED VIEW mv_daily_regional_sales
BUILD IMMEDIATE
REFRESH FAST ON COMMIT -- Automatically update the MView the moment the base table commits
ENABLE QUERY REWRITE   -- Allow the Optimizer to automatically redirect queries here
AS
SELECT 
    c.region_code,
    TRUNC(t.transaction_date) as sales_date,
    SUM(t.amount) as total_sales,
    COUNT(t.amount) as transaction_count -- COUNT is required for Fast Refresh of Aggregates
FROM 
    enterprise_core_db.customers c
JOIN 
    enterprise_core_db.transactions t ON c.account_id = t.from_account_id
GROUP BY 
    c.region_code, 
    TRUNC(t.transaction_date);

-- 3. The Magic of Query Rewrite (Sự kỳ diệu của Query Rewrite)
-- If a Data Analyst runs this standard query against the massive raw tables:
-- 
-- SELECT c.region_code, SUM(t.amount) 
-- FROM customers c JOIN transactions t ON c.account_id = t.from_account_id
-- WHERE TRUNC(t.transaction_date) = TRUNC(SYSDATE)
-- GROUP BY c.region_code;
--
-- The Optimizer will automatically rewrite it to run against `mv_daily_regional_sales` instead.
-- Execution time drops from 5 minutes to 0.01 seconds.
-- (CBO sẽ ngầm đổi truy vấn của Data Analyst sang lấy từ MView. Thời gian chạy giảm từ 5 phút xuống 0.01s).
