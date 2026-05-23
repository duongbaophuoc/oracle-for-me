# 🟢 Stage 1 — Oracle Fundamentals & PL/SQL
# Giai đoạn 1 — Nền tảng Oracle & PL/SQL

This stage transitions from basic SQL syntax to enterprise-grade Oracle programming, introducing PL/SQL to push business logic closer to the data.
*Giai đoạn này chuyển tiếp từ cú pháp SQL cơ bản sang lập trình Oracle cấp độ doanh nghiệp, giới thiệu PL/SQL để đẩy logic nghiệp vụ xuống gần dữ liệu nhất.*

---

## 1. Advanced Oracle SQL (Oracle SQL Nâng cao)

Enterprise SQL is rarely `SELECT * FROM table`. It involves complex analytical processing.
*SQL doanh nghiệp hiếm khi chỉ là `SELECT * FROM table`. Nó bao gồm việc xử lý phân tích phức tạp.*

### Hierarchical & Recursive Queries (Truy vấn Phân cấp & Đệ quy)
- **CONNECT BY:** Oracle's traditional syntax for querying tree-like structures (e.g., organizational charts, category trees).
  *(Cú pháp truyền thống của Oracle để truy vấn các cấu trúc dạng cây (ví dụ: sơ đồ tổ chức, danh mục cây).)*
- **Recursive CTE (`WITH` clause):** ANSI standard way of recursive querying, allowing extremely complex data transformations in a single pass.
  *(Biểu thức bảng chung đệ quy theo tiêu chuẩn ANSI, cho phép chuyển đổi dữ liệu cực kỳ phức tạp chỉ trong một lần duyệt dữ liệu.)*

### Analytic (Window) Functions (Hàm Phân tích / Window Functions)
The most powerful SQL feature for data engineers. Computes aggregate values over a group of rows while still returning individual rows.
*Tính năng SQL mạnh mẽ nhất dành cho kỹ sư dữ liệu. Tính toán các giá trị tổng hợp trên một nhóm các hàng mà vẫn trả về từng hàng riêng lẻ.*
- `ROW_NUMBER()`, `RANK()`, `DENSE_RANK()`
- `LEAD()`, `LAG()` (Crucial for time-series and event analysis / *Quan trọng cho phân tích chuỗi thời gian và sự kiện*)
- `SUM() OVER (...)`, `AVG() OVER (...)`

### Views & Materialized Views (View và View Cụ thể hóa)
- **Views (View logic):** Logical abstraction of complex queries.
  *(Sự trừu tượng hóa logic của các truy vấn phức tạp.)*
- **Materialized Views (MViews):** Pre-computed and physically stored results of queries. Essential for Data Warehouses to reduce CPU/IO loads for heavy aggregations.
  *(Kết quả truy vấn được tính toán trước và lưu trữ vật lý. Rất cần thiết cho Kho dữ liệu để giảm tải CPU/IO cho các phép tính tổng hợp nặng.)*

---

## 2. PL/SQL Programming (Lập trình PL/SQL)

PL/SQL (Procedural Language/SQL) allows you to write high-performance data processing routines directly inside the database engine, avoiding network roundtrips.
*PL/SQL cho phép bạn viết các thói quen xử lý dữ liệu hiệu suất cao trực tiếp bên trong engine CSDL, tránh được độ trễ mạng do phải gọi đi gọi lại.*

### Core Components (Các thành phần cốt lõi)
- **Procedures (Thủ tục):** Execute business logic. *(Thực thi logic nghiệp vụ.)*
- **Functions (Hàm):** Return a value, can be used directly inside SQL `SELECT` statements. *(Trả về giá trị, có thể dùng trực tiếp trong lệnh SQL `SELECT`.)*
- **Packages (Gói):** Grouping related Procedures/Functions. Essential for modularizing enterprise code and managing memory efficiency (caching package state).
  *(Nhóm các Thủ tục/Hàm có liên quan. Cần thiết để mô-đun hóa mã nguồn doanh nghiệp và quản lý hiệu quả bộ nhớ).*

### High-Performance PL/SQL (PL/SQL Hiệu năng cao)
If you process millions of rows row-by-row (Cursor FOR Loop), performance will crash due to Context Switches.
*Nếu bạn xử lý hàng triệu hàng theo từng hàng một, hiệu suất sẽ sụp đổ do việc chuyển đổi ngữ cảnh (Context Switches).*
- **BULK COLLECT:** Fetch multiple rows into memory (Collections) at once.
  *(Truy xuất nhiều hàng vào bộ nhớ cùng một lúc.)*
- **FORALL:** Send multiple DML statements (INSERT/UPDATE) to the SQL engine in a single batch.
  *(Gửi hàng loạt các câu lệnh DML xuống SQL engine trong một đợt duy nhất.)*
- **Pipelined Functions:** Stream data directly to the consumer without waiting for the entire result set to be generated.
  *(Truyền dữ liệu dạng luồng trực tiếp đến nơi tiêu thụ mà không cần đợi toàn bộ tập kết quả được tạo ra.)*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. **Write a complex Analytic Query:** Find the Top 3 highest-spending customers per region without using `GROUP BY`.
   - Refer to [01_analytic_functions.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/01-fundamentals/01_analytic_functions.sql) for standard window function and hierarchical queries.
   - *(Xem các ví dụ hàm phân tích tại [01_analytic_functions.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/01-fundamentals/01_analytic_functions.sql)).*
2. **Implement a Package with Exception Handling:** Handle banking transactions with strict deadlock retry and error logging.
   - Refer to [02_transaction_package.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/01-fundamentals/02_transaction_package.sql) for the complete PL/SQL transactional package code.
   - *(Xem cấu trúc Gói PL/SQL chuyển khoản an toàn tại [02_transaction_package.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/01-fundamentals/02_transaction_package.sql)).*
3. **Compare Standard Loop vs BULK COLLECT / FORALL:** Measure performance improvements.
   - Refer to [03_bulk_processing_performance.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/01-fundamentals/03_bulk_processing_performance.sql) to execute and measure context switch reductions.
   - *(Xem so sánh hiệu năng chèn hàng loạt tại [03_bulk_processing_performance.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/01-fundamentals/03_bulk_processing_performance.sql)).*