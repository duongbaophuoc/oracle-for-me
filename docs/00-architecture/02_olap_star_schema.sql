-- ==============================================================================
-- Stage 0: Relational Architecture - OLAP Star Schema
-- Giai đoạn 0: Kiến trúc Quan hệ - Lược đồ Hình sao OLAP (Kho dữ liệu)
-- ==============================================================================

-- In a Data Warehouse, we denormalize data into Facts and Dimensions 
-- to optimize for fast analytical read aggregations.
-- (Trong Kho dữ liệu, chúng ta giải chuẩn dữ liệu thành Bảng Dữ kiện (Fact) và Bảng Chiều (Dimension)
-- để tối ưu hóa cho các phép tính tổng hợp đọc nhanh.)

-- 1. Dimension: Time (Bảng Chiều: Thời gian)
CREATE TABLE dim_time (
    time_key        NUMBER PRIMARY KEY, -- YYYYMMDD
    full_date       DATE NOT NULL,
    day_of_week     NUMBER NOT NULL,
    day_name        VARCHAR2(10) NOT NULL,
    month_val       NUMBER NOT NULL,
    month_name      VARCHAR2(20) NOT NULL,
    quarter_val     NUMBER NOT NULL,
    year_val        NUMBER NOT NULL,
    is_weekend      NUMBER(1) NOT NULL -- 0: Weekday, 1: Weekend
) PCTFREE 0; -- Dimensions are heavily read, rarely updated. (Bảng chiều chủ yếu là đọc, ít cập nhật).

-- 2. Dimension: Customer (Bảng Chiều: Khách hàng - SCD Type 2)
-- Uses Slowly Changing Dimensions (SCD) Type 2 to track historical changes
-- (Sử dụng SCD Type 2 để theo dõi các thay đổi lịch sử)
CREATE TABLE dim_customer (
    customer_sk     NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Surrogate Key (Khóa đại diện)
    customer_id     NUMBER NOT NULL, -- Original ID from OLTP
    full_name       VARCHAR2(200) NOT NULL,
    customer_type   VARCHAR2(20) NOT NULL,
    -- SCD Type 2 Tracking Columns
    valid_from      DATE NOT NULL,
    valid_to        DATE DEFAULT TO_DATE('9999-12-31', 'YYYY-MM-DD') NOT NULL,
    is_current      NUMBER(1) DEFAULT 1 NOT NULL
);

-- 3. Dimension: Account (Bảng Chiều: Tài khoản)
CREATE TABLE dim_account (
    account_sk      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id      NUMBER NOT NULL,
    account_number  VARCHAR2(30) NOT NULL,
    currency_code   VARCHAR2(3) NOT NULL
);

-- 4. Fact Table: Daily Transactions (Bảng Dữ kiện: Giao dịch hàng ngày)
CREATE TABLE fact_daily_transactions (
    time_key            NUMBER NOT NULL,
    customer_sk         NUMBER NOT NULL,
    account_sk          NUMBER NOT NULL,
    transaction_type    VARCHAR2(30) NOT NULL,
    -- Measures (Các chỉ số đo lường)
    total_tx_count      NUMBER DEFAULT 0 NOT NULL,
    total_tx_amount     NUMBER(18, 4) DEFAULT 0 NOT NULL,
    -- 
    -- Relaxed Foreign Keys for ETL performance (RELY DISABLE NOVALIDATE)
    -- (Nới lỏng Khóa ngoại để tăng hiệu suất ETL - giúp Optimizer nhận biết nhưng không kiểm tra tốn thời gian)
    CONSTRAINT fk_fact_time FOREIGN KEY (time_key) REFERENCES dim_time(time_key) RELY DISABLE NOVALIDATE,
    CONSTRAINT fk_fact_cust FOREIGN KEY (customer_sk) REFERENCES dim_customer(customer_sk) RELY DISABLE NOVALIDATE,
    CONSTRAINT fk_fact_acc FOREIGN KEY (account_sk) REFERENCES dim_account(account_sk) RELY DISABLE NOVALIDATE
);

-- BITMAP Indexes for Data Warehouse (Chỉ mục BITMAP cho Kho dữ liệu)
-- Bitmap indexes are perfect for low-cardinality columns in OLAP, but terrible for OLTP concurrency.
-- (Chỉ mục Bitmap hoàn hảo cho các cột có số lượng giá trị phân biệt thấp trong OLAP, nhưng rất tệ cho OLTP).
CREATE BITMAP INDEX bidx_fact_tx_type ON fact_daily_transactions(transaction_type);
CREATE BITMAP INDEX bidx_fact_time ON fact_daily_transactions(time_key);
