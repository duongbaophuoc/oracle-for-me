-- ==============================================================================
-- Sample Database - Verification & Practice Queries
-- Cơ sở dữ liệu mẫu - Truy vấn Kiểm tra & Luyện tập
-- ==============================================================================

-- Run these queries to ensure your sample database is functioning correctly.
-- (Chạy các truy vấn này để chắc chắn cơ sở dữ liệu mẫu hoạt động chính xác).

-- 1. Get Customer Balance Sheet Summary
-- (Tổng hợp bảng cân đối số dư của khách hàng)
SELECT 
    c.customer_id,
    c.full_name,
    COUNT(a.account_id) AS total_accounts,
    SUM(a.balance) AS total_balance_usd
FROM 
    customers c
LEFT JOIN 
    accounts a ON c.customer_id = a.customer_id
GROUP BY 
    c.customer_id, 
    c.full_name
ORDER BY 
    total_balance_usd DESC;

-- 2. Trace Financial Money Flow
-- (Theo dõi dòng chảy tiền giao dịch giữa các tài khoản)
SELECT 
    t.transaction_id,
    t.transaction_date,
    f_cust.full_name AS sender,
    f_acc.account_number AS sender_acc,
    t.amount,
    t.transaction_type,
    t.status,
    t_cust.full_name AS receiver,
    t_acc.account_number AS receiver_acc
FROM 
    transactions t
JOIN 
    accounts f_acc ON t.from_account_id = f_acc.account_id
JOIN 
    customers f_cust ON f_acc.customer_id = f_cust.customer_id
JOIN 
    accounts t_acc ON t.to_account_id = t_acc.account_id
JOIN 
    customers t_cust ON t_acc.customer_id = t_cust.customer_id
ORDER BY 
    t.transaction_date DESC;
