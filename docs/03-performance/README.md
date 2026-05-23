# 🔴 Stage 3 — Performance Engineering (Kỹ thuật Tối ưu Hiệu suất)

> Performance tuning in Oracle is not guessing; it is reading the math from the Cost-Based Optimizer and analyzing Wait Events.
> *Tinh chỉnh hiệu suất trong Oracle không phải là đoán mò; nó là việc đọc toán học từ Bộ Tối ưu hóa dựa trên Chi phí (CBO) và phân tích các Sự kiện Chờ.*

---

## 1. Cost-Based Optimizer (CBO)

When you submit a SQL query, Oracle doesn't just run it. The CBO calculates thousands of possible execution paths and picks the one with the lowest "Cost" (mostly IO + CPU estimates).
*(Khi gửi truy vấn, CBO sẽ tính toán hàng nghìn đường dẫn thực thi và chọn đường có "Chi phí" thấp nhất - ước tính IO và CPU).*

### Statistics (Thống kê)
The CBO relies completely on statistics (`DBMS_STATS`).
*(CBO phụ thuộc hoàn toàn vào hệ thống thống kê).*
- How many rows in the table? (Có bao nhiêu hàng?)
- How many distinct values in a column? (Có bao nhiêu giá trị phân biệt trong một cột?)
- **Histograms:** If data is skewed (e.g., 90% of employees are 'ACTIVE', 10% are 'INACTIVE'), standard statistics fail. Histograms tell the CBO exactly how data is distributed.
  *(Biểu đồ phân phối: Nếu dữ liệu bị lệch, thống kê thường sẽ sai. Histogram báo cho CBO chính xác cách dữ liệu phân bổ).*

### Execution Plans (Kế hoạch Thực thi)
Reading an execution plan via `DBMS_XPLAN.DISPLAY_CURSOR` is the most important skill for a database engineer.
*(Đọc kế hoạch thực thi là kỹ năng quan trọng nhất của kỹ sư cơ sở dữ liệu).*
- **TABLE ACCESS FULL (Quét toàn bảng):** Scanning every block. Bad for returning 1 row, excellent for returning 1 million rows.
- **INDEX RANGE SCAN (Quét dải chỉ mục):** Traversing the B-Tree index to find specific rows.
- **NESTED LOOPS (Vòng lặp lồng):** Best for joining small datasets.
- **HASH JOIN (Kết nối Băm):** Best for joining massive datasets.

---

## 2. Indexing Deep Dive (Chuyên sâu về Chỉ mục)

An index is physically a B-Tree (Balanced Tree) structure pointing to `ROWID`s.
*(Chỉ mục về mặt vật lý là cấu trúc Cây B phân bằng trỏ đến ROWID).*

### Types of Indexes (Các loại Chỉ mục)
- **B-Tree Indexes:** Standard. Good for high-cardinality data (Unique IDs, Names).
  *(Chỉ mục B-Tree: Chuẩn. Tốt cho dữ liệu có độ phân biệt cao).*
- **Bitmap Indexes:** Perfect for low-cardinality data in Data Warehouses (Gender, Status). **Never use in OLTP** as it locks entire blocks of rows during updates.
  *(Chỉ mục Bitmap: Hoàn hảo cho dữ liệu độ phân biệt thấp trong Kho dữ liệu. KHÔNG BAO GIỜ dùng trong OLTP vì nó gây khóa hàng loạt).*
- **Reverse Key Indexes:** In an OLTP system with high inserts from auto-increment IDs, the right side of the B-Tree gets extremely hot (Buffer Busy Waits). A reverse key index flips the bytes (`1234` becomes `4321`) to distribute inserts across the entire index structure.
  *(Chỉ mục khóa đảo ngược: Tránh tình trạng quá nhiệt ở một nhánh của B-Tree khi chèn ID tăng tự động).*

---

## 3. Diagnostics & Wait Events (Chẩn đoán & Sự kiện Chờ)

If the database is slow, it is waiting on something. Oracle instruments *every single wait*.
*(Nếu CSDL chậm, nghĩa là nó đang phải chờ đợi một thứ gì đó. Oracle ghi lại MỌI sự chờ đợi).*

### Wait Events (Sự kiện chờ)
- `db file sequential read`: Normal. Waiting for a single block from disk (usually an index lookup).
- `db file scattered read`: Normal/Bad. Waiting for multiple blocks (usually a Full Table Scan).
- `log file sync`: The session has committed and is waiting for the Redo Log Buffer to be flushed to disk. Usually a storage IO bottleneck.
  *(Phiên đã Commit và đang đợi vùng đệm Redo ghi xuống đĩa. Thường do nghẽn IO đĩa).*
- `latch: library cache`: Severe contention in the Shared Pool. Usually caused by not using Bind Variables.
  *(Tranh chấp nghiêm trọng trong Shared Pool. Thường do KHÔNG dùng biến liên kết).*

### Enterprise Tooling (Công cụ Doanh nghiệp)
- **AWR (Automatic Workload Repository):** Takes a snapshot of all performance metrics every hour. You compare two snapshots to see exactly what the database was doing during that hour.
  *(Chụp lại toàn bộ thông số hiệu năng mỗi giờ. So sánh 2 snapshot để biết CSDL đã làm gì trong giờ đó).*
- **ASH (Active Session History):** Samples what every active session is doing every 1 second. Crucial for diagnosing micro-spikes.
  *(Lấy mẫu xem mỗi phiên đang làm gì mỗi 1 giây. Dùng để chẩn đoán các lỗi giật lag bất thợt).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. Use `DBMS_STATS.GATHER_TABLE_STATS` to gather stats with a Histogram on a highly skewed column, then compare the Execution Plans before and after.
   *(Sử dụng DBMS_STATS để thu thập thống kê Histogram trên một cột bị lệch, so sánh kế hoạch thực thi trước và sau).*
2. Create a **Reverse Key Index** and analyze how it prevents block contention during massive concurrent inserts.
   *(Tạo Chỉ mục Khóa đảo ngược và phân tích cách nó ngăn chặn tranh chấp khối khi chèn đồng thời số lượng lớn).*
3. Generate an **AWR Report** (using `awrrpt.sql`) and analyze the "Top 5 Timed Foreground Events".
   *(Tạo Báo cáo AWR và phân tích "Top 5 Sự kiện tốn thời gian nhất").*