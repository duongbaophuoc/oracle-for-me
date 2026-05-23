# Lab 05: Partitioning & Large-Table Scalability
# Bài Lab 05: Kỹ thuật Phân vùng & Mở rộng Bảng Dữ liệu Lớn

## Objective (Mục tiêu)
Migrate a monolithic database table containing millions of rows to a partitioned table structure by date range to optimize query performance (partition pruning) and simplify historical data retention.
*(Chuyển đổi một bảng CSDL nguyên khối chứa hàng triệu dòng sang cấu trúc phân vùng theo khoảng thời gian để tối ưu hiệu năng truy vấn và đơn giản hóa việc dọn dẹp dữ liệu lịch sử).*

## Scenario (Kịch bản)
The `transactions` table has grown to 500GB. Queries filtering on `transaction_date` are performing slow full table scans. You need to implement range-partitioning by month and verify that query execution plans read only the necessary partitions (pruning).
*(Bảng `transactions` đã tăng lên 500GB. Các truy vấn lọc theo ngày đang chạy quét toàn bộ bảng (full scan) rất chậm. Bạn cần triển khai phân vùng theo tháng và kiểm chứng kế hoạch thực thi chỉ đọc các phân vùng cần thiết).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Create a Range-Partitioned Table
Refer to the schema definition at `docs/00-architecture/03_partitioned_table.sql`. We configure automatic monthly partitions using `INTERVAL`:
```sql
CREATE TABLE transactions_partitioned (
    transaction_id NUMBER,
    account_id NUMBER,
    transaction_date DATE,
    amount NUMBER(15,2),
    status VARCHAR2(20)
)
PARTITION BY RANGE (transaction_date)
INTERVAL (NUMTOYMINTERVAL(1, 'MONTH'))
(
    PARTITION p_init VALUES LESS THAN (TO_DATE('2026-01-01', 'YYYY-MM-DD'))
);
```

### Step 2: Populate Data Across Partitions
Populate data from multiple years to auto-create monthly partitions:
```sql
INSERT INTO transactions_partitioned
SELECT transaction_id, account_id, transaction_date, amount, status FROM transactions;
COMMIT;
```

### Step 3: Verify Created Partitions
Check the physical partitions allocated in the data dictionary:
```sql
SELECT partition_name, high_value 
FROM user_tab_partitions 
WHERE table_name = 'TRANSACTIONS_PARTITIONED'
ORDER BY partition_position;
```

### Step 4: Verify Partition Pruning in Execution Plans
1. Enable SQL tracing or generate the explain plan for a query restricted to a specific month:
   ```sql
   EXPLAIN PLAN FOR
   SELECT * FROM transactions_partitioned 
   WHERE transaction_date BETWEEN TO_DATE('2026-03-01', 'YYYY-MM-DD') 
                             AND TO_DATE('2026-03-31', 'YYYY-MM-DD');
   ```
2. Display the plan:
   ```sql
   SELECT * FROM TABLE(dbms_xplan.display);
   ```
3. Look at the `Pstart` and `Pstop` columns. They should indicate specific partition numbers instead of `KEY` or `ALL`, showing that Oracle skipped reading other irrelevant monthly data blocks.

---
*Completed successfully when the execution plan shows partition pruning active, restricting IO to a single target block partition.*
