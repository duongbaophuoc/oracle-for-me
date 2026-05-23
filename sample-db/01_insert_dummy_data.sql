-- ==============================================================================
-- Sample Database - Dummy Data Generation
-- Cơ sở dữ liệu mẫu - Sinh dữ liệu giả lập
-- ==============================================================================

-- 1. Insert Customers
INSERT INTO customers (national_id, full_name, customer_type) VALUES ('ID1001', 'Nguyen Van A', 'RETAIL');
INSERT INTO customers (national_id, full_name, customer_type) VALUES ('ID1002', 'Tran Thi B', 'RETAIL');
INSERT INTO customers (national_id, full_name, customer_type) VALUES ('CORP01', 'Enterprise Solutions JSC', 'CORPORATE');

-- 2. Insert Accounts
INSERT INTO accounts (customer_id, account_number, balance) VALUES (1, 'ACC-1001-01', 50000.00);
INSERT INTO accounts (customer_id, account_number, balance) VALUES (2, 'ACC-1002-01', 15000.00);
INSERT INTO accounts (customer_id, account_number, balance) VALUES (3, 'ACC-CORP-01', 990000.00);

-- 3. Insert Initial Transactions
INSERT INTO transactions (from_account_id, to_account_id, amount, transaction_type) 
VALUES (3, 1, 5000.00, 'TRANSFER');

INSERT INTO transactions (from_account_id, to_account_id, amount, transaction_type) 
VALUES (1, 2, 1000.00, 'TRANSFER');

COMMIT;

-- Verify Data
SELECT * FROM customers;
SELECT * FROM accounts;
SELECT * FROM transactions;
