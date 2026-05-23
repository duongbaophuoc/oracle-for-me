# 🟤 Stage 6 — Data Warehousing & Analytics Engineering
# Giai đoạn 6 — Kỹ thuật Kho Dữ liệu & Phân tích

> A Data Warehouse is not just a copy of the database. It is a highly optimized, historically accurate model designed to answer enterprise-level questions instantly.
> *Kho dữ liệu không chỉ là bản sao của cơ sở dữ liệu. Nó là một mô hình chính xác về lịch sử, được tối ưu hóa cao độ để trả lời ngay lập tức các câu hỏi cấp doanh nghiệp.*

---

## 1. ETL vs ELT Architecture (Kiến trúc ETL so với ELT)

- **ETL (Extract, Transform, Load):** Data is extracted from Oracle, transformed in an external server (like Informatica or DataStage), and then loaded into the Data Warehouse.
  *(Dữ liệu được trích xuất từ Oracle, chuyển đổi tại một máy chủ bên ngoài, rồi nạp vào Kho dữ liệu).*
- **ELT (Extract, Load, Transform):** Data is extracted, loaded raw into a "Staging" schema in the Data Warehouse, and then transformed using Oracle's own immense computing power via SQL (often orchestrated by tools like **dbt** or **Airflow**). This is the modern standard.
  *(Dữ liệu được trích xuất, nạp nguyên bản vào vùng Staging, sau đó chuyển đổi bằng chính sức mạnh tính toán khổng lồ của Oracle thông qua SQL. Đây là tiêu chuẩn hiện đại).*

---

## 2. Advanced Warehouse Optimization (Tối ưu hóa Kho dữ liệu Nâng cao)

### Materialized Views (MViews)
- A standard View runs the underlying query every time it is called.
  *(View tiêu chuẩn sẽ chạy câu lệnh bên dưới mỗi khi được gọi).*
- A Materialized View runs the query once, saves the result physically to disk, and users query the saved result.
  *(MView chạy truy vấn 1 lần, lưu kết quả vật lý xuống đĩa, và người dùng truy vấn trên kết quả đã lưu).*
- **Fast Refresh:** If 10 rows are inserted into a 1-billion row base table, Oracle only applies those 10 new rows to the MView, instead of rebuilding the entire MView (Requires a Materialized View Log).
  *(Làm mới siêu tốc: Nếu có 10 hàng mới vào bảng 1 tỷ hàng, Oracle chỉ nạp thêm 10 hàng đó vào MView thay vì xây dựng lại từ đầu).*

### Query Rewrite (Viết lại Truy vấn)
- A magical feature of the Optimizer. If a user runs a heavy `SELECT SUM(amount) FROM transactions GROUP BY date`, the Optimizer can silently intercept the query, notice an MView exists that already has the answer, and rewrite the query to read from the MView instead. The user doesn't even know it happened.
  *(Tính năng kỳ diệu của CBO. CBO ngầm chặn truy vấn nặng của người dùng, tự động chuyển hướng nó sang đọc từ MView đã được tính sẵn. Người dùng không hề hay biết).*

---

## 3. Incremental Pipelines (Đường ống dữ liệu Tăng dần)

Full table loads are impossible for terabyte-scale tables. Data Engineers must build pipelines that only sync new or updated data.
*(Nạp toàn bộ bảng là bất khả thi với dữ liệu Terabyte. Phải xây dựng đường ống chỉ đồng bộ dữ liệu mới hoặc bị thay đổi).*

- **MERGE (Upsert):** The standard SQL command for incremental loads. It checks if a row exists in the target. If yes -> `UPDATE`. If no -> `INSERT`.
  *(Lệnh chuẩn cho nạp tăng dần. Nếu hàng đã tồn tại -> UPDATE. Nếu chưa -> INSERT).*
- **CDC (Change Data Capture):** Identifying exactly which rows changed using timestamps, sequences, or GoldenGate.
  *(Xác định chính xác hàng nào thay đổi qua mốc thời gian hoặc GoldenGate).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. Build a **Materialized View with Fast Refresh** for daily sales aggregation.
   *(Xây dựng một MView hỗ trợ Fast Refresh để tổng hợp doanh thu hàng ngày).*
2. Write a highly optimized **MERGE (Upsert) statement** to sync incremental data from an OLTP table to a Data Warehouse dimension table.
   *(Viết lệnh MERGE tối ưu cao để đồng bộ dữ liệu tăng dần từ OLTP sang bảng Dimension).*