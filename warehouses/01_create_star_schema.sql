-- ==============================================================================
-- Warehouses: Star Schema Initialization (OLAP)
-- Kho dữ liệu: Khởi tạo Lược đồ Hình sao (OLAP)
-- ==============================================================================

-- Create Dimension Tables (Bảng Chiều)

-- 1. Date Dimension (Chiều Thời gian)
CREATE TABLE dim_date (
    date_key        NUMBER(8) PRIMARY KEY, -- Format: YYYYMMDD
    full_date       DATE NOT NULL,
    year            NUMBER(4) NOT NULL,
    quarter         NUMBER(1) NOT NULL,
    month           NUMBER(2) NOT NULL,
    day_of_month    NUMBER(2) NOT NULL,
    day_of_week     NUMBER(1) NOT NULL,
    is_weekend      NUMBER(1) NOT NULL
) PCTFREE 0; -- Read-only, maximize storage efficiency

-- 2. Product Dimension (Chiều Sản phẩm)
CREATE TABLE dim_product (
    product_sk      NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, -- Surrogate Key
    product_code    VARCHAR2(50) NOT NULL,
    product_name    VARCHAR2(200) NOT NULL,
    category        VARCHAR2(100) NOT NULL,
    base_price      NUMBER(18,2) NOT NULL
);

-- 3. Branch Dimension (Chiều Chi nhánh)
CREATE TABLE dim_branch (
    branch_sk       NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    branch_code     VARCHAR2(20) NOT NULL,
    region          VARCHAR2(50) NOT NULL,
    city            VARCHAR2(50) NOT NULL
);

-- Create Fact Table (Bảng Dữ kiện)

-- 4. Fact Sales (Dữ kiện Doanh số)
CREATE TABLE fact_sales (
    sale_id         NUMBER NOT NULL,
    date_key        NUMBER(8) NOT NULL,
    product_sk      NUMBER NOT NULL,
    branch_sk       NUMBER NOT NULL,
    quantity        NUMBER NOT NULL,
    total_amount    NUMBER(18,2) NOT NULL,
    
    -- Foreign Keys with RELY DISABLE NOVALIDATE to improve massive ETL performance
    -- (Khóa ngoại lỏng lẻo giúp nạp dữ liệu siêu tốc nhưng vẫn cho CBO biết cấu trúc)
    CONSTRAINT fk_sales_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key) RELY DISABLE NOVALIDATE,
    CONSTRAINT fk_sales_prod FOREIGN KEY (product_sk) REFERENCES dim_product(product_sk) RELY DISABLE NOVALIDATE,
    CONSTRAINT fk_sales_branch FOREIGN KEY (branch_sk) REFERENCES dim_branch(branch_sk) RELY DISABLE NOVALIDATE
)
-- Partitioned by Year to allow easy archival of old data
PARTITION BY RANGE (date_key) (
    PARTITION p_2023 VALUES LESS THAN (20240101),
    PARTITION p_2024 VALUES LESS THAN (20250101),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);

-- 5. OLAP Optimizations: Bitmap Indexes
-- (Tối ưu OLAP: Dùng chỉ mục Bitmap cho các cột ít giá trị phân biệt)
CREATE BITMAP INDEX bidx_sales_date ON fact_sales(date_key);
CREATE BITMAP INDEX bidx_sales_prod ON fact_sales(product_sk);
CREATE BITMAP INDEX bidx_sales_branch ON fact_sales(branch_sk);
