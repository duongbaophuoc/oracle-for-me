-- ==============================================================================
-- Sample Database - Schema DDL Creation
-- Cơ sở dữ liệu mẫu - Khởi tạo Lược đồ DDL
-- ==============================================================================

-- 1. Create the Customers Table
CREATE TABLE customers (
    customer_id     NUMBER GENERATED ALWAYS AS IDENTITY,
    national_id     VARCHAR2(50) NOT NULL,
    full_name       VARCHAR2(200) NOT NULL,
    customer_type   VARCHAR2(20) NOT NULL,
    status          VARCHAR2(20) DEFAULT 'ACTIVE' NOT NULL,
    created_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at      TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    --
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    CONSTRAINT uq_customers_nat_id UNIQUE (national_id),
    CONSTRAINT chk_cust_status CHECK (status IN ('ACTIVE', 'SUSPENDED', 'CLOSED')),
    CONSTRAINT chk_cust_type CHECK (customer_type IN ('RETAIL', 'CORPORATE'))
) PCTFREE 10;

-- 2. Create the Accounts Table
CREATE TABLE accounts (
    account_id      NUMBER GENERATED ALWAYS AS IDENTITY,
    customer_id     NUMBER NOT NULL,
    account_number  VARCHAR2(30) NOT NULL,
    currency_code   VARCHAR2(3) DEFAULT 'USD' NOT NULL,
    balance         NUMBER(18, 4) DEFAULT 0 NOT NULL,
    is_locked       NUMBER(1) DEFAULT 0 NOT NULL,
    opened_date     DATE DEFAULT SYSDATE NOT NULL,
    --
    CONSTRAINT pk_accounts PRIMARY KEY (account_id),
    CONSTRAINT uq_account_number UNIQUE (account_number),
    CONSTRAINT fk_accounts_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_acc_locked CHECK (is_locked IN (0, 1)),
    CONSTRAINT chk_acc_balance CHECK (balance >= 0) -- Balance can never be negative
) PCTFREE 20;

CREATE INDEX idx_accounts_cust_id ON accounts(customer_id);

-- 3. Create the Transactions Table (Partitioned by Date for scalability)
CREATE TABLE transactions (
    transaction_id      NUMBER GENERATED ALWAYS AS IDENTITY,
    from_account_id     NUMBER,
    to_account_id       NUMBER,
    amount              NUMBER(18, 4) NOT NULL,
    transaction_type    VARCHAR2(30) NOT NULL,
    transaction_date    DATE DEFAULT SYSDATE NOT NULL,
    status              VARCHAR2(20) DEFAULT 'COMPLETED' NOT NULL,
    --
    CONSTRAINT pk_transactions PRIMARY KEY (transaction_id, transaction_date), -- Key must include partition column
    CONSTRAINT fk_tx_from_acc FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    CONSTRAINT fk_tx_to_acc FOREIGN KEY (to_account_id) REFERENCES accounts(account_id),
    CONSTRAINT chk_tx_amount CHECK (amount > 0),
    CONSTRAINT chk_tx_status CHECK (status IN ('PENDING', 'COMPLETED', 'FAILED', 'REVERSED'))
)
PARTITION BY RANGE (transaction_date) (
    PARTITION tx_q1_2026 VALUES LESS THAN (TO_DATE('2026-04-01', 'YYYY-MM-DD')),
    PARTITION tx_q2_2026 VALUES LESS THAN (TO_DATE('2026-07-01', 'YYYY-MM-DD')),
    PARTITION tx_future VALUES LESS THAN (MAXVALUE)
) PCTFREE 5;

CREATE INDEX idx_tx_from_acc ON transactions(from_account_id) LOCAL;
CREATE INDEX idx_tx_to_acc ON transactions(to_account_id) LOCAL;
