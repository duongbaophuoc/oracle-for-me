-- ==============================================================================
-- Warehouses: Complex Analytical Reporting & OLAP Queries
-- Kho dữ liệu: Các truy vấn Phân tích & Báo cáo Phức tạp (OLAP)
-- ==============================================================================

-- These queries run against the Star Schema initialized in `01_create_star_schema.sql`.
-- (Các truy vấn này chạy trên Lược đồ Hình sao đã khởi tạo ở file trước).

-- 1. Year-Over-Year (YoY) Sales Comparison by Product Category
-- (So sánh doanh số cùng kỳ năm trước theo Danh mục Sản phẩm)
WITH monthly_sales AS (
    SELECT 
        p.category,
        d.year,
        d.month,
        SUM(f.total_amount) AS sales_amount
    FROM 
        fact_sales f
    JOIN 
        dim_product p ON f.product_sk = p.product_sk
    JOIN 
        dim_date d ON f.date_key = d.date_key
    GROUP BY 
        p.category, d.year, d.month
)
SELECT 
    category,
    year,
    month,
    sales_amount AS current_month_sales,
    
    -- LAG gets the sales from the exact same month of the PREVIOUS year
    -- (LAG lấy doanh thu của cùng tháng đó ở NĂM TRƯỚC ĐÓ)
    LAG(sales_amount, 12) OVER (
        PARTITION BY category, month 
        ORDER BY year
    ) AS prev_year_sales,
    
    -- YoY Growth Calculation (Tính phần trăm tăng trưởng YoY)
    ROUND(
        (sales_amount - LAG(sales_amount, 12) OVER (
            PARTITION BY category, month ORDER BY year
        )) / LAG(sales_amount, 12) OVER (
            PARTITION BY category, month ORDER BY year
        ) * 100, 2
    ) AS yoy_growth_percent
FROM 
    monthly_sales
ORDER BY 
    category, year, month;

-- 2. Customer RFM Segmentation Prep (Recency, Frequency, Monetary)
-- (Chuẩn bị phân khúc khách hàng RFM)
SELECT 
    f.product_sk, -- Assume product dimension can represent unique product types
    f.branch_sk,
    COUNT(f.sale_id) AS purchase_frequency,
    SUM(f.total_amount) AS total_monetary_value,
    MAX(d.full_date) AS last_purchase_date,
    
    -- Calculate how many days ago they last purchased
    -- (Tính số ngày kể từ lần mua cuối cùng)
    TRUNC(SYSDATE) - MAX(d.full_date) AS recency_days
FROM 
    fact_sales f
JOIN 
    dim_date d ON f.date_key = d.date_key
GROUP BY 
    f.product_sk, f.branch_sk;
