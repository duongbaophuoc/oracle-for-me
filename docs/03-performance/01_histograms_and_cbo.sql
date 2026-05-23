-- ==============================================================================
-- Stage 3: Performance Engineering - Histograms & The Optimizer
-- Giai đoạn 3: Kỹ thuật Hiệu suất - Biểu đồ phân phối (Histograms)
-- ==============================================================================

-- Problem: We have an `employees` table with 1,000,000 rows.
-- 990,000 employees have status = 'ACTIVE' (99%).
-- 10,000 employees have status = 'INACTIVE' (1%).

-- Scenario 1: Without Histograms (Không có Biểu đồ)
-- Oracle assumes the data is evenly distributed (500k each).
-- Query: SELECT * FROM employees WHERE status = 'INACTIVE';
-- The CBO thinks it will return 500,000 rows. It chooses a FULL TABLE SCAN. 
-- (CBO tưởng sẽ trả về 500k hàng, nên chọn quét toàn bảng -> Cực chậm cho 10k hàng).

-- Scenario 2: With Histograms (Có Biểu đồ)
-- We instruct Oracle to analyze the skewed distribution.

-- Execute this as a DBA to gather schema stats WITH histograms:
BEGIN
  DBMS_STATS.GATHER_TABLE_STATS(
    ownname          => 'HR', 
    tabname          => 'EMPLOYEES', 
    estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE, 
    method_opt       => 'FOR COLUMNS SIZE AUTO status', -- Generate histogram for 'status'
    cascade          => TRUE
  );
END;
/

-- Now, when you run:
-- SELECT * FROM employees WHERE status = 'INACTIVE';
-- The CBO knows it will only return 10,000 rows (1%). It chooses an INDEX RANGE SCAN.
-- (Giờ CBO biết chỉ có 10k hàng, nó sẽ chọn Quét Chỉ mục -> Nhanh tức thì).

-- When you run:
-- SELECT * FROM employees WHERE status = 'ACTIVE';
-- The CBO knows it will return 990,000 rows (99%). It ignores the index and does a FULL TABLE SCAN.
-- (CBO biết sẽ lấy 99% dữ liệu, nó bỏ qua chỉ mục và quét toàn bảng -> Nhanh hơn đọc từng index).

-- View the histogram buckets:
SELECT 
    column_name, 
    num_buckets, 
    histogram 
FROM 
    user_tab_col_statistics 
WHERE 
    table_name = 'EMPLOYEES';
