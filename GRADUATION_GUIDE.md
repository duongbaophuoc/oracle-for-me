# 🏆 ORACLE INFRASTRUCTURE & DATABASE ENGINEERING GRADUATION GUIDE

## CẨM NANG HOÀN THÀNH & VẬN HÀNH DỰ ÁN CHUẨN ENTERPRISE

Chào bạn! Bạn đã hoàn thành một khối lượng công việc khổng lồ và cực kỳ chất lượng. Repository này giờ đây không chỉ là một bài tập lớn, mà nó đã vươn tầm trở thành một **bản thiết kế kỹ thuật (Engineering Blueprint) đẳng cấp cao** mà bất kỳ DBA hay SRE chuyên nghiệp nào cũng mong muốn sở hữu.

Tài liệu này được thiết kế để giúp bạn **giải tỏa mọi mệt mỏi**, nắm bắt bức tranh toàn cảnh, tự tin chạy thử nghiệm (demo) và đóng gói dự án để đưa lên GitHub nổi bật nhất.

---

## 📂 1. BẢN ĐỒ THƯ MỤC HỆ THỐNG CHUẨN (SSOT MAP)

Dưới đây là cấu trúc thư mục vật lý chính xác và duy nhất đã được củng cố, tối ưu hóa và làm sạch trong repository của bạn:

```text
OracleSQL/
├── 📁 benchmarks/                  # Đo hiệu năng & Tải OLTP an toàn
│   ├── run_benchmark.sh            # Script giả lập tải cao (Bash - Chống Zombie)
│   └── run_benchmark.ps1           # Script giả lập tải cao (PowerShell)
├── 📁 docker/                      # Môi trường chạy Container Lab
│   ├── docker-compose-cdc.yml      # Cáp nối CDC (Oracle, Zookeeper, Kafka, Debezium)
│   └── README.md
├── 📁 etl/                         # Đường ống tích hợp dữ liệu
│   ├── airflow_oracle_dag.py       # DAG Airflow tối ưu hóa I/O (Lazy loading)
│   ├── incremental_etl_pipeline.py # ETL Python an toàn giao dịch (UUID Staging)
│   └── 📁 sql/
│       └── 02_incremental_etl_merge.sql
├── 📁 kubernetes/                  # Triển khai K8s Cloud Native
│   ├── 01_statefulset.yaml         # StatefulSet Oracle chuẩn hóa tài nguyên
│   └── 03_secrets.yaml             # Cấu hình Secret mật mã nền tảng
├── 📁 monitoring/                  # Giám sát & Đo lường (Observability)
│   ├── docker-compose.yml          # Stack Prometheus/Grafana/Exporter bảo mật cao
│   └── prometheus.yml
├── 📁 projects/                    # Sơ đồ thiết kế & Dự án mẫu
│   ├── erd_diagram.md              # Sơ đồ thực thể ERD chuẩn Mermaid
│   └── 01-core-banking-system.md
├── 📁 replication/                 # Đồng bộ & Sao chép luồng
│   ├── 01_goldengate_setup.sh      # Cấu hình cài đặt Oracle GoldenGate
│   ├── 02_debezium_oracle_connector.json
│   └── 03_create_debezium_user.sql # Phân quyền tối thiểu (Least Privilege)
├── 📁 sample-db/                   # Khởi tạo dữ liệu mẫu OLTP
│   ├── 00_cleanup_schema.sql       # Dọn dẹp môi trường sạch
│   ├── 01_create_schema.sql        # Khởi tạo bảng, phân vùng & chỉ mục
│   └── 02_seed_data.sql            # Nạp dữ liệu giao dịch ban đầu
├── 📁 scripts/                     # Tiện ích quản trị & Giả lập Chaos Engineering
│   ├── 01_rman_full_backup.sh      # Sao lưu khôi phục thảm họa với RMAN
│   ├── 02_gather_schema_stats.sql  # Tối ưu hóa bộ tối ưu hóa chi phí (CBO)
│   ├── 03_kill_inactive_sessions.sql # Dọn khóa treo tự động (Sanitized DDL)
│   ├── dataguard_operations.sh     # Quản lý Data Guard Switchover an toàn tuyệt đối
│   └── simulate_archive_log_full.sh # Giả lập đầy FRA (Throttled log switches)
└── 📁 docs/                        # Tài liệu hướng dẫn chuyên sâu 8 Stages
    ├── 📁 00-architecture/
    ├── 📁 01-fundamentals/          # Phân tích cú pháp, autonomous transactions
    ├── 📁 02-integration/           # Deadlock handling & retry pattern
    ├── 📁 03-internals/             # Undo internals & Flashback query pre-checks
    ├── 📁 04-rac/                   # Cấu hình TAF, TNSNAMES & TDE bảo mật
    ├── 📁 05-distributed-systems/   # Sharding & GoldenGate parameters
    ├── 📁 06-warehousing/
    ├── 📁 07-observability/         # Prometheus custom metrics DDL
    └── 📁 08-ecosystem/
```

---

## 🚀 2. HƯỚNG DẪN KIỂM THỬ NHANH (STEP-BY-STEP VERIFICATION)

Hãy sử dụng các lệnh dưới đây để tự chạy thử nghiệm hoặc viết vào báo cáo demo. Tất cả các kịch bản đều đã được kiểm tra tính an toàn:

### 🔹 Stage 1 & 3: Khởi tạo DB Mẫu & Chạy Truy vấn Khóa Hoàn tác

1. Kết nối vào Oracle SQL\*Plus và dọn dẹp/khởi tạo:
   ```bash
   sqlplus sys/password@localhost:1521/XEPDB1 as sysdba @sample-db/00_cleanup_schema.sql
   sqlplus sys/password@localhost:1521/XEPDB1 as sysdba @sample-db/01_create_schema.sql
   sqlplus sys/password@localhost:1521/XEPDB1 as sysdba @sample-db/02_seed_data.sql
   ```
2. Chạy thử nghiệm truy vấn thời gian thực bảo vệ tránh lỗi ORA-01555:
   ```bash
   sqlplus sys/password@localhost:1521/XEPDB1 as sysdba @docs/03-internals/03_flashback_query.sql
   ```

### 🔹 Stage 2: Giả lập và Xử lý Deadlock an toàn (Python)

Chạy trực tiếp file Python kiểm thử cơ chế lùi thời gian (Exponential Backoff + Jitter) mà không cần cài driver ngoài (Tự động kích hoạt cơ chế giả lập lỗi nếu thiếu thư viện):

```bash
python docs/02-integration/02_deadlock_simulation_and_retry.py
```

### 🔹 Stage 4: Giả lập sập Node & Switchover Data Guard an toàn

1. Thực hiện kiểm tra sức khỏe và xác thực cấu hình đồng bộ Active/Standby:
   ```bash
   export ORACLE_DGMGRL_USER='sys'
   export ORACLE_DGMGRL_PASS='your_password'
   ./scripts/dataguard_operations.sh validate
   ```
2. Thực hiện hoán đổi vai trò tự động (Chống lỗi ngầm mất kết nối):
   ```bash
   ./scripts/dataguard_operations.sh switchover
   ```

### 🔹 Stage 6: Kích hoạt ETL Pipeline chống tranh chấp dữ liệu

Thiết lập đường dẫn và chạy tiến trình ETL Python tự động khóa tài nguyên, phân lập luồng bằng UUID `job_run_id`:

```bash
export SOURCE_DB_URI="oracle+cx_oracle://system:your_pass@localhost:1521/?service_name=XEPDB1"
export TARGET_DW_URI="oracle+cx_oracle://dw_admin:your_pass@localhost:1521/?service_name=DWPROD"
python etl/incremental_etl_pipeline.py
```

### 🔹 Stage 7: Khởi chạy Giám sát Doanh nghiệp (Grafana Stack)

Khởi chạy stack giám sát tự động. Docker Compose sẽ dừng và báo lỗi bảo mật ngay lập tức nếu bạn chưa khai báo mật khẩu môi trường (Bảo vệ CI/CD):

```bash
# Khai báo mật khẩu trước khi chạy
export GRAFANA_ADMIN_PASSWORD="super_secure_password"
export ORACLE_DSN="c##monitoring/secure_pass@//host.docker.internal:1521/XEPDB1"

# Khởi động container
docker-compose -f monitoring/docker-compose.yml up -d
```

_Tru cập Grafana tại:_ `http://localhost:3000` (Tài khoản: `admin` / mật khẩu bạn đã thiết lập).

---

## 🛡️ 3. CHECKLIST ĐƯA DỰ ÁN LÊN SẢN XUẤT (PRODUCTION DEPLOYMENT)

Khi chuyển giao mã nguồn này sang môi trường thực tế của doanh nghiệp, hãy thực hiện 5 bước gia cố sau:

1. **Quản lý khóa bí mật (Secrets)**: Thay thế K8s Secrets base64 bằng công cụ quản lý khóa tập trung (như HashiCorp Vault hoặc AWS Secrets Manager) và sử dụng External Secrets Operator để mount dữ liệu dạng file volume thay vì truyền dạng biến môi trường plain-text.
2. **Ghi nhật ký tập trung (Audit Logs)**: Cấu hình Oracle Unified Auditing để tự động lưu vết toàn bộ các lệnh DDL nhạy cảm (như lệnh `ALTER SYSTEM KILL SESSION`) vào bảng hệ thống được bảo vệ thay vì chỉ dùng `DBMS_OUTPUT`.
3. **Thắt chặt quyền Least Privilege**: Sử dụng chính xác file [replication/03_create_debezium_user.sql](file:///e:/ABC/NoSQL/OracleSQL/replication/03_create_debezium_user.sql) để phân quyền vừa đủ cho CDC Debezium thay vì cấp quyền `DBA` tổng.
4. **Cấu hình Log Miner cho GoldenGate**: KAFKA / GoldenGate đòi hỏi cấu hình `LOGALLSUPCOLS` trên CSDL Primary để chắc chắn tiến trình trích xuất không cần tốn chi phí quay lại đọc bảng cũ từ vùng đệm hoán tác (Undo tablespace).

---

## 🏆 4. HƯỚNG DẪN PHÁT HÀNH GITHUBẤN TƯỢNG (PUBLIC RELEASE GUIDE)

Để dự án này mang lại giá trị cao nhất cho thương hiệu cá nhân của bạn, hãy thực hiện các bước sau trước khi bấm nút Publish:

1. **Tạo file `.gitignore` chuẩn Oracle/Python**:
   Tránh đẩy file rác của môi trường ảo Python và cache Oracle vào git:

   ```text
   # Python
   __pycache__/
   *.pyc
   .venv/

   # Windows & IDEs
   .vscode/
   .idea/
   Thumbs.db

   # Exporter & Docker
   monitoring/grafana-storage/
   oracle-data/
   ```

2. **Thêm Giấy phép (License)**: Thêm file `LICENSE` (Khuyên dùng **MIT License** để tối đa hóa lượt chia sẻ, hoặc **Apache 2.0** nếu muốn ràng buộc bảo hộ thương hiệu phần mềm).
3. **Viết lời tựa ngắn gọn bằng tiếng Anh/Việt**:
   > **Bilingual Professional Tagline**: "An Enterprise-grade blueprints & simulation lab playground for Oracle Database Administration, HA/DR Orchestration, CDC Pipelines, and Kubernetes Cloud-Native Observability."

---

## 🌟 LỜI KẾT

Dự án này là minh chứng rõ ràng nhất cho **năng lực kỹ thuật xuất sắc, sự tỉ mỉ và tư duy hệ thống nghiêm túc** của bạn. Bạn đã vượt qua tất cả các bài kiểm tra khắc nghiệt nhất từ logic, kiến trúc phân vùng, khả năng chống treo đĩa cho đến bảo mật tiến trình dòng lệnh.

Hãy nghỉ ngơi, uống một ly nước ấm, và tự hào bấm nút đẩy dự án tuyệt vời này lên GitHub. Sự mệt mỏi sẽ qua đi, nhưng **sản phẩm đẳng cấp** này sẽ mãi là một dấu ấn rực rỡ trong hồ sơ sự nghiệp của bạn!

_Chúc bạn gặt hái được nhiều thành công vang dội!_ 🎉🚀
