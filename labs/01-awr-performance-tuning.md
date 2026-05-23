# Lab 01: AWR Performance Tuning & Buffer Busy Waits

# Bài Lab 01: Tinh chỉnh Hiệu năng AWR & Tranh chấp Khối đĩa

## Objective (Mục tiêu)

Identify the root cause of a severe CPU and IO spike in an OLTP database during a high-concurrency event, and resolve it using index reorganization.
_(Xác định nguyên nhân gốc rễ của sự cố tăng đột biến CPU và IO trong CSDL OLTP khi tải đồng thời cao, và khắc phục bằng cách cấu trúc lại chỉ mục)._

## Scenario (Kịch bản)

At 10:00 AM, the `orders` table received a massive influx of inserts. Users reported the system froze. You have the AWR snapshot from 10:00 AM to 11:00 AM.
_(Lúc 10h sáng, bảng `orders` nhận lượng chèn khổng lồ. Hệ thống bị treo. Bạn có snapshot AWR từ 10h đến 11h)._

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Generate the AWR Report

1. Connect as `SYSDBA`: `sqlplus / as sysdba`
2. Run the AWR script: `@$ORACLE_HOME/rdbms/admin/awrrpt.sql`
3. Specify `html` format, 1 day of snapshots, and select the Begin/End snap IDs covering the 10:00 AM window.

### Step 2: Analyze the "Top 10 Foreground Events"

Open the generated HTML report. Look at the Wait Events table.
You will see `buffer busy waits` dominating 90% of the DB Time.

### Step 3: Find the Hot Segment (Tìm phân đoạn nóng)

Scroll down to the **"Segments by Buffer Busy Waits"** section in the AWR report.
You will see that the index `PK_ORDERS_ID` on the `orders` table is the culprit.
_(Bạn sẽ thấy chỉ mục Khóa chính của bảng orders chính là thủ phạm)._

### Step 4: The Root Cause

The `order_id` is generated sequentially (`1, 2, 3...`). 50 parallel application threads are trying to write to the exact same physical block at the right-most edge of the B-Tree index.

### Step 5: The Fix (Khắc phục)

Rebuild the index as a **Reverse Key Index** to physically scatter the sequential IDs across different leaf blocks.
**Note:** Be aware that Reverse Key Indexes prevent _Index Range Scans_. Only use this if the primary access pattern is via single-row lookups.
_(Xây dựng lại thành Chỉ mục khóa đảo ngược để phân tán ngẫu nhiên các ID liên tiếp)._
**Lưu ý:** Chỉ mục đảo ngược sẽ không thể thực hiện quét theo khoảng (Range Scan). Chỉ sử dụng nếu ứng dụng chủ yếu truy vấn theo khóa đơn lẻ).\*

```sql
ALTER INDEX PK_ORDERS_ID REBUILD REVERSE;
```

### Step 6: Verify (Kiểm chứng)

Run the load test again (using `benchmarks/run_benchmark.sh`). Generate a new AWR report. The `buffer busy waits` event should completely disappear.
