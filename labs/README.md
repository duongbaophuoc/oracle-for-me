# 🧪 Hands-On Labs
# Các Bài Lab Thực Hành

This folder lists the core simulation labs that every Enterprise Database Engineer must complete.
*Thư mục này liệt kê các bài lab mô phỏng cốt lõi mà mọi Kỹ sư CSDL Doanh nghiệp đều phải hoàn thành.*

1. **AWR Diagnostics Lab ([01-awr-performance-tuning.md](file:///e:/ABC/NoSQL/OracleSQL/labs/01-awr-performance-tuning.md)):** Generate an AWR report and resolve sequential B-Tree index hot-spot issues.
   *(Tạo báo cáo AWR và xử lý các điểm nóng tranh chấp khối đĩa trên chỉ mục B-Tree).*
2. **Data Guard Switchover Lab ([02-data-guard-switchover.md](file:///e:/ABC/NoSQL/OracleSQL/labs/02-data-guard-switchover.md)):** Perform graceful active/standby database role reversals using DGMGRL.
   *(Thực hiện lệnh chuyển đổi vai trò dự phòng an toàn bằng công cụ DGMGRL).*
3. **RAC Failover Lab ([03-rac-failover.md](file:///e:/ABC/NoSQL/OracleSQL/labs/03-rac-failover.md)):** Test high availability and Client TAF under sudden node evictions.
   *(Thử nghiệm khả năng chịu lỗi RAC và kết nối TAF khi sập node đột xuất).*
4. **GoldenGate Streaming Lab ([04-goldengate-streaming.md](file:///e:/ABC/NoSQL/OracleSQL/labs/04-goldengate-streaming.md)):** Enable supplemental logging and stream real-time DML tables changes to Kafka.
   *(Kích hoạt ghi vết bổ sung và truyền luồng DML sang Apache Kafka theo thời gian thực).*
5. **Partitioning Lab ([05-partitioning.md](file:///e:/ABC/NoSQL/OracleSQL/labs/05-partitioning.md)):** Implement monthly partition keys and verify partition pruning in execution plans.
   *(Thiết lập phân vùng tự động theo tháng và kiểm tra tính năng cắt tỉa phân vùng).*
6. **RMAN Recovery Lab ([06-rman-recovery.md](file:///e:/ABC/NoSQL/OracleSQL/labs/06-rman-recovery.md)):** Simulate datafile deletions and restore/recover database states using PITR.
   *(Giả lập mất datafile và tiến hành khôi phục CSDL tại một thời điểm quá khứ).*
7. **Parallel Query Lab ([07-parallel-query.md](file:///e:/ABC/NoSQL/OracleSQL/labs/07-parallel-query.md)):** Parallelize large DW aggregations and inspect parallel coordinators in plans.
   *(Chạy song song các truy vấn kho dữ liệu lớn và phân tích hoạt động của PX slaves).*
8. **Wait Events Lab ([08-wait-events.md](file:///e:/ABC/NoSQL/OracleSQL/labs/08-wait-events.md)):** Diagnose active lock contention and locate source SQL blockers using ASH.
   *(Chẩn đoán tranh chấp khóa và tìm câu lệnh gây nghẽn bằng lịch sử ASH).*
9. **ASM Failure Lab ([09-asm-failure.md](file:///e:/ABC/NoSQL/OracleSQL/labs/09-asm-failure.md)):** Drop failing drives online and monitor background ASM data rebalancing.
   *(Loại bỏ ổ đĩa lỗi khỏi nhóm ASM và theo dõi quá trình phân chia lại dữ liệu trực tuyến).*