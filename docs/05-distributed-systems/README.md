# ⚫ Stage 5 — Distributed Oracle Infrastructure
# Giai đoạn 5 — Hạ tầng Oracle Phân tán

> When a single cluster is no longer enough to handle the global load, or when data sovereignty laws require data to reside in specific countries, we must distribute the database.
> *Khi một cụm duy nhất không còn đủ để xử lý tải toàn cầu, hoặc khi luật chủ quyền dữ liệu yêu cầu dữ liệu phải nằm ở các quốc gia cụ thể, chúng ta phải phân tán cơ sở dữ liệu.*

---

## 1. Oracle Sharding (Phân mảnh Dữ liệu)

Unlike RAC (where all nodes share the same disk), **Sharding** shares NOTHING.
*(Khác với RAC - nơi tất cả các node dùng chung một ổ đĩa, Sharding KHÔNG CHIA SẺ BẤT CỨ THỨ GÌ).*

- Data is horizontally partitioned across multiple independent Oracle databases (Shards).
  *(Dữ liệu được phân vùng theo chiều ngang qua nhiều cơ sở dữ liệu Oracle độc lập - gọi là các Shard).*
- Each Shard has its own CPU, Memory, and Disk.
  *(Mỗi Shard có CPU, RAM và Đĩa riêng biệt).*
- **Sharding Key (Khóa phân mảnh):** E.g., `customer_id`. The application connects to a Shard Director, provides the `customer_id`, and is routed directly to the database that holds that customer.
  *(Ví dụ: `customer_id`. Ứng dụng kết nối tới Shard Director, cung cấp `customer_id`, và được định tuyến thẳng tới CSDL chứa khách hàng đó).*

### Use Cases (Trường hợp sử dụng)
- Ultra-high throughput OLTP (e.g., massive e-commerce platforms).
- Data sovereignty (European customers in EU Shard, US customers in US Shard).

---

## 2. Oracle GoldenGate & Logical Replication (Nhân bản Logic)

Data Guard replicates data physically at the block level. **GoldenGate** replicates logically at the SQL level.
*(Data Guard nhân bản dữ liệu vật lý ở cấp độ khối đĩa. GoldenGate nhân bản logic ở cấp độ câu lệnh SQL).*

- **Change Data Capture (CDC):** GoldenGate reads the Oracle Redo Logs, extracts the `INSERT/UPDATE/DELETE` operations, and sends them to a target system.
  *(Bắt dữ liệu thay đổi: Đọc Redo Logs, trích xuất thao tác Thêm/Sửa/Xóa và gửi tới hệ thống đích).*
- **Heterogeneous Replication:** Oracle to PostgreSQL, Oracle to Kafka, Oracle to Snowflake. Data Guard can only do Oracle to Oracle.
  *(Nhân bản không đồng nhất: Từ Oracle sang PostgreSQL, Kafka, Snowflake. Data Guard chỉ có thể làm Oracle sang Oracle).*
- **Active-Active Replication:** You can write to two databases simultaneously across the globe, and GoldenGate syncs them bidirectionally (though conflict resolution is complex).
  *(Bạn có thể Ghi vào 2 CSDL ở 2 nơi trên thế giới cùng lúc, GoldenGate sẽ đồng bộ hai chiều - dù việc xử lý xung đột khá phức tạp).*

---

## 3. Streaming & Event-Driven Architecture (Kiến trúc Hướng sự kiện)

- Modern enterprise backends don't run batch jobs at midnight. They react to data changes instantly.
  *(Backend doanh nghiệp hiện đại không chạy batch job lúc nửa đêm nữa. Họ phản ứng với thay đổi dữ liệu tức thời).*
- Connecting Oracle to **Apache Kafka** via GoldenGate Big Data Adapter or Debezium turns the database into a stream of events.
  *(Kết nối Oracle với Kafka qua GoldenGate hoặc Debezium biến CSDL thành một luồng sự kiện liên tục).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. **Configure an Oracle Sharded Architecture:** Partition data across independent Shards using table DDL.
   - Refer to [01_sharding_configuration.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/05-distributed-systems/01_sharding_configuration.sql) for Shard Catalog and Sharded Table setup.
   - *(Xem kịch bản cấu hình Sharding tại [01_sharding_configuration.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/05-distributed-systems/01_sharding_configuration.sql)).*
2. **Write GoldenGate parameter files:** Capture and route logical schema updates.
   - Refer to [02_goldengate_extract.prm](file:///e:/ABC/NoSQL/OracleSQL/docs/05-distributed-systems/02_goldengate_extract.prm) for standard CDC extraction configuration.
   - *(Xem tệp tham số trích xuất tại [02_goldengate_extract.prm](file:///e:/ABC/NoSQL/OracleSQL/docs/05-distributed-systems/02_goldengate_extract.prm)).*
3. **Advanced Replication CLI Setup:**
   - Refer to the dedicated [replication/](file:///e:/ABC/NoSQL/OracleSQL/replication/) directory for real-world Debezium configs, GoldenGate terminal commands, and user DDL schemas.
   - *(Xem thêm các cấu hình chi tiết Debezium và GGSCI tại thư mục [replication/](file:///e:/ABC/NoSQL/OracleSQL/replication/)).*