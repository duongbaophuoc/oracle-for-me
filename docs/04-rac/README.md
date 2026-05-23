# 🟣 Stage 4 — High Availability: Oracle RAC (Real Application Clusters)
# Giai đoạn 4 — Sẵn sàng cao: Oracle RAC

> A single database instance is a single point of failure. Oracle RAC allows multiple instances on different servers to run against the same physical database.
> *Một instance cơ sở dữ liệu duy nhất là một điểm lỗi duy nhất (SPOF). Oracle RAC cho phép nhiều instance trên các máy chủ khác nhau cùng chạy trên cùng một CSDL vật lý.*

---

## 1. Oracle RAC Architecture (Kiến trúc Oracle RAC)

In a standard Oracle setup, 1 Instance maps to 1 Database. In RAC, N Instances map to 1 Database.
*(Trong cài đặt chuẩn, 1 Instance ánh xạ tới 1 Database. Trong RAC, N Instances ánh xạ tới 1 Database).*

### Cache Fusion (Dung hợp Bộ đệm)
- If Node 1 reads a block from disk into its Buffer Cache, and Node 2 wants to update that block, Node 2 doesn't go to the disk. Node 1 sends the block directly to Node 2's memory over a high-speed private network (Interconnect).
- *(Nếu Node 1 đọc một khối vào Buffer Cache và Node 2 muốn cập nhật khối đó, Node 2 sẽ không đọc từ đĩa. Node 1 sẽ gửi khối đó trực tiếp vào bộ nhớ của Node 2 qua mạng nội bộ tốc độ cao - Interconnect).*

### Split-Brain Syndrome (Hội chứng Chia não)
- If the Interconnect network fails, Node 1 and Node 2 can't see each other. Both might think the other is dead and try to write to the same disk block, causing corruption.
- **Oracle Clusterware** resolves this by having nodes "vote" on a shared Voting Disk. The node that gets disconnected from the majority is forcefully rebooted (Node Eviction) to protect the data.
- *(Nếu mạng nội bộ lỗi, 2 node không thấy nhau và đều tưởng bên kia đã chết, dẫn đến ghi đè dữ liệu hỏng hóc. Oracle giải quyết bằng cách cho "bầu cử" trên ổ đĩa chung. Node nào mất kết nối với số đông sẽ bị cưỡng chế khởi động lại để bảo vệ dữ liệu).*

---

## 2. Workload Management (Quản lý Khối lượng Công việc)

You do not connect directly to a specific Node. You connect to a **Service**.
*(Bạn không kết nối trực tiếp đến một Node cụ thể. Bạn kết nối tới một **Service**).*

- **OLTP Service:** Configured to run primarily on Node 1 (with Node 2 as backup) to minimize Cache Fusion traffic for highly contested updates.
  *(Chạy chủ yếu trên Node 1 để giảm thiểu lưu lượng mạng Cache Fusion do tranh chấp cập nhật).*
- **Reporting Service:** Configured to load balance across all available nodes.
  *(Được cấu hình để cân bằng tải qua tất cả các node hiện có).*

---

## 3. Transparent Application Failover (TAF) & FAN
- **TAF:** If Node 1 crashes while a user is running a `SELECT` statement, the connection automatically migrates to Node 2, and the `SELECT` statement resumes without the application throwing an error.
  *(Nếu Node 1 sập khi user đang chạy lệnh SELECT, kết nối tự chuyển sang Node 2 và lệnh SELECT tiếp tục chạy mà ứng dụng không hề hay biết).*
- **FAN (Fast Application Notification):** The cluster immediately sends an event to the connection pool (like JDBC UCP) telling it Node 1 is dead, so the pool instantly routes new connections to Node 2 instead of waiting for TCP timeouts.
  *(Cụm RAC gửi ngay tín hiệu cho Connection Pool báo Node 1 đã chết, để pool lập tức chuyển hướng kết nối mới sang Node 2 thay vì đợi timeout).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. **Create specific Oracle Services:** Configure OLTP and Reporting workloads using `srvctl` commands.
   - Refer to [01_rac_services_config.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/04-rac/01_rac_services_config.sql) for standard provisioning commands.
   - *(Tạo các Service riêng biệt cho OLTP và Báo cáo. Xem kịch bản cấu hình tại [01_rac_services_config.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/04-rac/01_rac_services_config.sql)).*
2. **Configure Client Failover (TAF):** Enable client connection migration.
   - Refer to [02_taf_tnsnames.ora](file:///e:/ABC/NoSQL/OracleSQL/docs/04-rac/02_taf_tnsnames.ora) for client connection configuration.
   - *(Cấu hình file `tnsnames.ora` kích hoạt tính năng chuyển đổi dự phòng trong suốt. Xem tệp mẫu tại [02_taf_tnsnames.ora](file:///e:/ABC/NoSQL/OracleSQL/docs/04-rac/02_taf_tnsnames.ora)).*
3. **Simulate Node Eviction (Chaos Engineering):** Test cluster failover.
   - Run the chaos simulation at [scripts/simulate_node_eviction.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/simulate_node_eviction.sh) to trigger a hard failover and monitor TAF.
   - *(Mô phỏng sự cố sập node để kiểm tra cơ chế Failover. Xem tại [scripts/simulate_node_eviction.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/simulate_node_eviction.sh)).*