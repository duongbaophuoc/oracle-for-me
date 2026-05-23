# Lab 07: Parallel Query & Large-Scale Warehouse Aggregation
# Bài Lab 07: Truy vấn Song song & Tổng hợp Kho Dữ liệu Quy mô lớn

## Objective (Mục tiêu)
Configure and test Oracle Parallel Execution (Parallel Query/Parallel DML) to dramatically reduce query execution times for massive data warehouse reporting and batch processing tasks.
*(Cấu hình và kiểm thử cơ chế thực thi song song của Oracle để giảm thiểu tối đa thời gian chạy các báo cáo kho dữ liệu lớn và các tác vụ xử lý hàng loạt).*

## Scenario (Kịch bản)
An analytical query aggregates 50 million sales records to calculate year-over-year revenue, taking over 10 minutes to run on a single CPU thread. You need to leverage Oracle's multi-core capability to distribute the workload and get the report in under 30 seconds.
*(Một truy vấn phân tích tổng hợp 50 triệu bản ghi doanh thu đang mất hơn 10 phút khi chạy đơn luồng. Bạn cần tận dụng kiến trúc đa nhân của máy chủ để phân chia tải và lấy kết quả trong dưới 30 giây).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Check Current Database Parallel Resource Limits
Ensure the database has parallel execution parameters configured:
```sql
SHOW PARAMETER parallel_max_servers;
SHOW PARAMETER parallel_threads_per_cpu;
```

### Step 2: Establish the Base Query Time (Serial Execution)
Run a heavy aggregation query with parallel execution disabled and measure the runtime:
```sql
-- Disable parallel execution for the session
ALTER SESSION DISABLE PARALLEL QUERY;

SET TIMING ON;
SELECT product_id, SUM(amount), COUNT(*) 
FROM transactions_partitioned 
GROUP BY product_id;
SET TIMING OFF;
```

### Step 3: Run the Query with Parallel Hints (Parallel Execution)
1. Instruct the Cost-Based Optimizer (CBO) to use a degree of parallelism (DOP) of 4:
   ```sql
   SET TIMING ON;
   SELECT /*+ PARALLEL(t, 4) */ product_id, SUM(amount), COUNT(*) 
   FROM transactions_partitioned t
   GROUP BY product_id;
   SET TIMING OFF;
   ```
2. Compare the runtimes between Step 2 and Step 3. You should see a near-linear speedup relative to the number of allocated threads.

### Step 4: Verify Parallel Execution Details
1. Check the execution plan:
   ```sql
   EXPLAIN PLAN FOR
   SELECT /*+ PARALLEL(t, 4) */ product_id, SUM(amount), COUNT(*) 
   FROM transactions_partitioned t 
   GROUP BY product_id;
   
   SELECT * FROM TABLE(dbms_xplan.display);
   ```
2. Look for operations containing `PX COORDINATOR`, `PX SEND`, and `PX RECEIVE`, indicating that parallel coordinator and slave processes divided and consolidated the workload.
3. Query active parallel sessions during execution:
   ```sql
   SELECT * FROM v$px_session;
   ```

---
*Completed successfully when the query speedup is confirmed and PX operations are verified in the explain plan.*
