# 🟢 Stage 0 — Relational Architecture & Enterprise Modeling
# Giai đoạn 0 — Kiến trúc Quan hệ & Mô hình hóa Doanh nghiệp

> Enterprise systems fail more often from poor modeling than poor queries.
> *Các hệ thống doanh nghiệp thất bại thường do mô hình hóa kém hơn là do truy vấn kém.*

This stage focuses on the absolute foundation of any database engineering task: how to structure data for massive scale, maintaining data integrity, and balancing read/write performance.
*Giai đoạn này tập trung vào nền tảng tuyệt đối của bất kỳ tác vụ kỹ thuật cơ sở dữ liệu nào: cách cấu trúc dữ liệu cho quy mô khổng lồ, duy trì tính toàn vẹn dữ liệu và cân bằng hiệu suất đọc/ghi.*

---

## 1. Relational Modeling (Mô hình hóa Quan hệ)

At the enterprise level, a database is not just a collection of tables; it is a strict representation of business rules.
*Ở cấp độ doanh nghiệp, cơ sở dữ liệu không chỉ là một tập hợp các bảng; nó là một sự đại diện nghiêm ngặt cho các quy tắc nghiệp vụ.*

### OLTP vs OLAP Architecture (Kiến trúc OLTP so với OLAP)
- **OLTP (Online Transaction Processing):** Optimized for high-speed writes, high concurrency, and strict ACID compliance (e.g., banking systems, e-commerce checkout). Highly normalized.
  *(Tối ưu hóa cho tốc độ ghi cao, độ đồng thời cao và tuân thủ ACID nghiêm ngặt (ví dụ: hệ thống ngân hàng, thanh toán thương mại điện tử). Được chuẩn hóa cao độ.)*
- **OLAP (Online Analytical Processing):** Optimized for massive analytical reads, aggregations, and historical queries (e.g., business intelligence, reporting). Denormalized (Star/Snowflake schemas).
  *(Tối ưu hóa cho các truy vấn đọc phân tích lớn, tổng hợp và truy vấn lịch sử (ví dụ: BI, báo cáo). Bị giải chuẩn (Mô hình sao/bông tuyết).)*

### Advanced Modeling Techniques (Các kỹ thuật Mô hình hóa Nâng cao)
- **Partition-aware Design (Thiết kế nhận biết phân vùng):** Designing tables with partition keys in mind so Oracle can leverage partition-pruning. Crucial for multi-terabyte tables.
  *(Thiết kế các bảng với khóa phân vùng để Oracle có thể tận dụng kỹ thuật cắt tỉa phân vùng (partition-pruning). Cực kỳ quan trọng đối với các bảng quy mô terabyte.)*
- **Multi-tenant Architecture (Kiến trúc đa người thuê):** Using Oracle Multitenant (CDB/PDB) or row-level isolation (Virtual Private Database) to serve multiple clients from a single database safely.
  *(Sử dụng kiến trúc đa người thuê của Oracle (CDB/PDB) hoặc cách ly cấp độ hàng để phục vụ an toàn cho nhiều khách hàng từ một cơ sở dữ liệu duy nhất.)*
- **Temporal Modeling (Mô hình hóa dữ liệu thời gian):** Designing architectures that track data exactly as it was at any point in time (often built on top of Oracle Flashback Data Archive).
  *(Thiết kế kiến trúc theo dõi dữ liệu chính xác như tại bất kỳ thời điểm nào trong quá khứ - thường xây dựng trên tính năng Oracle Flashback Data Archive.)*
- **Slowly Changing Dimensions (SCD Type 2):** Keeping track of historical changes in Data Warehouses without losing previous state.
  *(Theo dõi các thay đổi lịch sử trong Kho dữ liệu mà không làm mất trạng thái trước đó.)*

---

## 2. Integrity & Governance (Tính toàn vẹn & Quản trị Dữ liệu)

Data consistency is enforced at the database layer, not the application layer.
*Tính nhất quán của dữ liệu được ép buộc ở tầng cơ sở dữ liệu, chứ không phải ở tầng ứng dụng.*

### Enterprise Constraint Design (Thiết kế Ràng buộc Doanh nghiệp)
- **Primary & Foreign Keys:** The backbone of referential integrity. In Data Warehouses, these might be enforced via `RELY DISABLE NOVALIDATE` to guide the Optimizer without write penalties.
  *(Khóa chính & ngoại: Xương sống của tính toàn vẹn tham chiếu. Trong Kho dữ liệu, chúng có thể được thiết lập qua `RELY DISABLE NOVALIDATE` để hướng dẫn Bộ tối ưu hóa mà không làm chậm tốc độ ghi.)*
- **CHECK Constraints:** Essential for ensuring business rules (e.g., `status IN ('ACTIVE', 'PENDING', 'CLOSED')`).
  *(Ràng buộc CHECK: Thiết yếu để đảm bảo quy tắc nghiệp vụ (vd: trạng thái chỉ có thể là ACTIVE, PENDING, CLOSED).)*

### Advanced Column Techniques (Kỹ thuật Cột Nâng cao)
- **Virtual Columns (Cột ảo):** Columns that compute their value on the fly (e.g., `total_price AS (quantity * unit_price)`). They do not consume disk space and can be indexed.
  *(Các cột tính toán giá trị trực tiếp tại thời điểm truy vấn. Chúng không tốn dung lượng đĩa và có thể được đánh chỉ mục.)*
- **Function-based Indexes (Chỉ mục dựa trên hàm):** When queries always filter using a function (e.g., `UPPER(email)`), a standard index is useless. A function-based index computes and stores the result of the function.
  *(Khi truy vấn luôn lọc bằng một hàm, chỉ mục tiêu chuẩn sẽ vô dụng. Chỉ mục dựa trên hàm sẽ tính toán và lưu trữ kết quả của hàm đó để tìm kiếm nhanh.)*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. **Design an OLTP schema** for a massive financial trading system, focusing on 3NF.
   *(Thiết kế một schema OLTP cho một hệ thống giao dịch tài chính lớn, tập trung vào chuẩn 3NF.)*
2. **Design an OLAP Star Schema** transforming that financial data into a reporting structure.
   *(Thiết kế một Mô hình Sao OLAP để chuyển đổi dữ liệu tài chính đó thành cấu trúc báo cáo.)*
3. Implement a **Partition-aware table** for `transactions` based on `transaction_date`.
   *(Triển khai một bảng có nhận biết phân vùng cho `transactions` dựa trên cột `transaction_date`.)*