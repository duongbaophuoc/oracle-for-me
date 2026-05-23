# 🏛️ Oracle Infrastructure & Enterprise Database Engineering Roadmap

### From Oracle SQL & PL/SQL → Enterprise Data Platforms → Mission-Critical Database Infrastructure

_Từ Oracle SQL & PL/SQL → Nền tảng Dữ liệu Doanh nghiệp → Hạ tầng Cơ sở dữ liệu Trọng yếu_
[![Oracle Infrastructure CI](https://github.com/duongbaophuoc/oracle-for-me/actions/workflows/oracle-infrastructure-ci.yml/badge.svg)](https://github.com/duongbaophuoc/oracle-for-me/actions/workflows/oracle-infrastructure-ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.md)
[![Oracle](https://img.shields.io/badge/Oracle-Database-red?logo=oracle&logoColor=white)](https://www.oracle.com/database/)
[![PL/SQL](https://img.shields.io/badge/PL%2FSQL-Programming-blue)](https://docs.oracle.com/en/database/oracle/oracle-database/)
[![Stages](https://img.shields.io/badge/Stages-8-green)](docs/)
[![Labs](https://img.shields.io/badge/Labs-8-orange)](labs/)
[![Diagrams](https://img.shields.io/badge/Diagrams-6-purple)](diagrams/)
[![SQL Developer](https://img.shields.io/badge/Tool-SQL_Developer-darkblue)](https://www.oracle.com/database/sqldeveloper/)
[![Oracle XE](https://img.shields.io/badge/Oracle-XE_21c-red)](https://www.oracle.com/database/technologies/xe-downloads.html)

> A production-grade Oracle engineering roadmap designed for:
> _Một lộ trình kỹ sư Oracle cấp độ thực tế (production) được thiết kế dành cho:_
>
> - Oracle Database Engineers (Kỹ sư CSDL Oracle)
> - Enterprise DBAs (Quản trị viên CSDL Doanh nghiệp)
> - SQL Infrastructure Engineers (Kỹ sư Hạ tầng SQL)
> - Platform Engineers (Kỹ sư Nền tảng)
> - Reliability Engineers (Kỹ sư Độ tin cậy)
> - Data Engineers (Kỹ sư Dữ liệu)
> - Data Warehouse Engineers (Kỹ sư Kho dữ liệu)
> - Enterprise Architects (Kiến trúc sư Doanh nghiệp)
> - Distributed Systems Engineers (Kỹ sư Hệ thống Phân tán)
> - Financial/Telecom Infrastructure Engineers (Kỹ sư Hạ tầng Tài chính/Viễn thông)
>
> Focused on:
> _Tập trung vào:_
>
> - Oracle internals (Cấu trúc bên trong Oracle)
> - SGA/PGA architecture (Kiến trúc bộ nhớ SGA/PGA)
> - Cost-Based Optimizer (Bộ tối ưu hóa dựa trên chi phí - CBO)
> - RAC clustering (Cụm máy chủ RAC)
> - Data Guard (Giải pháp dự phòng Data Guard)
> - enterprise HA & disaster recovery (Khả năng sẵn sàng cao & khôi phục sau thảm họa cho doanh nghiệp)
> - observability & diagnostics (Khả năng quan sát & chẩn đoán)
> - Exadata & engineered systems (Hệ thống phần cứng chuyên dụng & Exadata)
> - warehousing & analytics (Kho dữ liệu & Phân tích)
> - distributed enterprise infrastructure (Hạ tầng doanh nghiệp phân tán)
>
> This is not a beginner Oracle SQL tutorial.
> _Đây không phải là một hướng dẫn Oracle SQL cho người mới bắt đầu._
>
> This roadmap teaches how Oracle powers mission-critical enterprise systems.
> _Lộ trình này hướng dẫn cách Oracle vận hành các hệ thống doanh nghiệp trọng yếu._

---

# 📌 Roadmap Philosophy (Triết lý Lộ trình)

Most Oracle tutorials focus only on:
_Hầu hết các hướng dẫn Oracle chỉ tập trung vào:_

- SELECT statements (Câu lệnh SELECT)
- PL/SQL basics (Cơ bản về PL/SQL)
- simple indexes (Chỉ mục cơ bản)
- CRUD operations (Các thao tác CRUD)

Real Oracle engineering requires understanding:
_Kỹ thuật thực hành Oracle thực tế yêu cầu hiểu rõ:_

- how Oracle memory architecture works (Cách kiến trúc bộ nhớ Oracle hoạt động)
- how redo/undo behave internally (Cách redo/undo hoạt động bên trong)
- how RAC synchronizes nodes (Cách RAC đồng bộ hóa các node)
- how Oracle optimizes execution plans (Cách Oracle tối ưu hóa kế hoạch thực thi)
- how enterprise HA is implemented (Cách triển khai HA cấp doanh nghiệp)
- how Data Guard recovery works (Cách Data Guard khôi phục hoạt động)
- how Oracle handles massive OLTP workloads (Cách Oracle xử lý khối lượng tải OLTP khổng lồ)
- how enterprise observability is performed (Cách thực hiện quan sát cấp doanh nghiệp)
- how warehouse systems scale (Cách mở rộng hệ thống kho dữ liệu)
- how mission-critical systems maintain uptime (Cách các hệ thống trọng yếu duy trì thời gian hoạt động)

This repository focuses on production engineering depth.
_Kho lưu trữ này tập trung vào chiều sâu kỹ thuật ở cấp độ môi trường thực tế (production)._

---

# 🎯 Target Roles (Vai trò Mục tiêu)

| Role (Vai trò)                                         | Coverage (Mức độ bao phủ) |
| ------------------------------------------------------ | ------------------------- |
| Oracle DBA                                             | ✅                        |
| Database Engineer (Kỹ sư Cơ sở dữ liệu)                | ✅                        |
| SQL Infrastructure Engineer (Kỹ sư Hạ tầng SQL)        | ✅                        |
| Platform Engineer (Kỹ sư Nền tảng)                     | ✅                        |
| Reliability Engineer (Kỹ sư Độ tin cậy)                | ✅                        |
| Enterprise Architect (Kiến trúc sư Doanh nghiệp)       | ✅                        |
| Data Engineer (Kỹ sư Dữ liệu)                          | ✅                        |
| Data Warehouse Engineer (Kỹ sư Kho dữ liệu)            | ✅                        |
| Backend Engineer (Kỹ sư Backend)                       | ✅                        |
| Distributed Systems Engineer (Kỹ sư Hệ thống phân tán) | ✅                        |

---

# 🗺️ Learning Architecture (Kiến trúc Học tập)

| Stage (Giai đoạn) | Focus (Trọng tâm)                                                                              | Level (Cấp độ)                   |
| ----------------- | ---------------------------------------------------------------------------------------------- | -------------------------------- |
| 🟢 Stage 0        | Relational Architecture & Enterprise Modeling (Kiến trúc Quan hệ & Mô hình hóa Doanh nghiệp)   | Foundations (Nền tảng)           |
| 🟢 Stage 1        | Oracle Fundamentals & PL/SQL (Nền tảng Oracle & PL/SQL)                                        | Beginner (Người mới bắt đầu)     |
| 🟡 Stage 2        | Application Integration & SQL Engineering (Tích hợp Ứng dụng & Kỹ thuật SQL)                   | Intermediate (Trung cấp)         |
| 🔴 Stage 3        | Oracle Internals & Performance Engineering (Cấu trúc bên trong Oracle & Kỹ thuật Hiệu suất)    | Advanced (Nâng cao)              |
| 🟣 Stage 4        | High Availability & Enterprise Operations (Khả năng Sẵn sàng cao & Vận hành Doanh nghiệp)      | Production (Thực tế)             |
| ⚫ Stage 5        | Distributed Oracle Infrastructure (Hạ tầng Oracle Phân tán)                                    | Infrastructure (Hạ tầng)         |
| 🟤 Stage 6        | Data Warehousing & Analytics Engineering (Kỹ thuật Kho dữ liệu & Phân tích)                    | Data Platform (Nền tảng Dữ liệu) |
| 🔵 Stage 7        | Observability, Diagnostics & Incident Engineering (Khả năng Quan sát, Chẩn đoán & Xử lý Sự cố) | Expert (Chuyên gia)              |
| 🟠 Stage 8        | Exadata, Cloud & Enterprise Ecosystem (Exadata, Đám mây & Hệ sinh thái Doanh nghiệp)           | Specialized (Chuyên biệt)        |

---

# 🟢 Stage 0 — Relational Architecture & Enterprise Modeling (Kiến trúc Quan hệ & Mô hình hóa Doanh nghiệp)

> Enterprise systems fail more often from poor modeling than poor queries.
> _Các hệ thống doanh nghiệp thất bại thường do mô hình hóa kém hơn là do truy vấn kém._

### 🧠 Relational Modeling (Mô hình hóa Quan hệ)

| Topic (Chủ đề)             | Description (Mô tả)                                                 |
| -------------------------- | ------------------------------------------------------------------- |
| ERD Design                 | Enterprise relationships (Mối quan hệ doanh nghiệp)                 |
| Cardinality                | Relational modeling (Mô hình hóa quan hệ)                           |
| Normalization              | 1NF → BCNF (Chuẩn hóa)                                              |
| Denormalization            | Analytical optimization (Tối ưu hóa phân tích bằng cách giải chuẩn) |
| OLTP vs OLAP               | Workload separation (Phân tách khối lượng công việc)                |
| Star Schemas               | Data warehouse modeling (Mô hình hóa kho dữ liệu)                   |
| Snowflake Schemas          | Enterprise analytics (Phân tích doanh nghiệp)                       |
| Slowly Changing Dimensions | Historical tracking (Theo dõi lịch sử)                              |
| Surrogate Keys             | Warehouse identifiers (Định danh kho dữ liệu)                       |
| Multi-tenant Architecture  | Enterprise isolation (Cách ly cấp doanh nghiệp)                     |
| Temporal Modeling          | Historical systems (Hệ thống lịch sử)                               |
| Partition-aware Design     | Large-table engineering (Kỹ thuật cho bảng dữ liệu lớn)             |

### 🔐 Integrity & Governance (Tính toàn vẹn & Quản trị)

| Topic (Chủ đề)         | Description (Mô tả)                              |
| ---------------------- | ------------------------------------------------ |
| Primary Keys           | Row identity (Định danh hàng)                    |
| Foreign Keys           | Referential integrity (Tính toàn vẹn tham chiếu) |
| CHECK Constraints      | Validation rules (Quy tắc xác thực)              |
| Virtual Columns        | Computed values (Giá trị được tính toán)         |
| Function-based Indexes | Computed indexing (Chỉ mục dựa trên tính toán)   |
| Data Governance        | Enterprise standards (Tiêu chuẩn doanh nghiệp)   |

**🎯 Outcomes (Kết quả đạt được):**

- Design enterprise-grade Oracle schemas (Thiết kế schema Oracle cấp doanh nghiệp)
- Build scalable OLTP & OLAP architectures (Xây dựng kiến trúc OLTP & OLAP có khả năng mở rộng)
- Understand enterprise relational trade-offs (Hiểu rõ sự đánh đổi trong quan hệ cấp doanh nghiệp)

---

# 🟢 Stage 1 — Oracle Fundamentals & PL/SQL (Nền tảng Oracle & PL/SQL)

### 🛠️ Environment & Tooling (Môi trường & Công cụ)

| Topic (Chủ đề)               | Description (Mô tả)                        |
| ---------------------------- | ------------------------------------------ |
| Oracle Database Installation | Setup & configuration (Cài đặt & Cấu hình) |
| SQL\*Plus                    | Oracle CLI (Giao diện dòng lệnh Oracle)    |
| SQL Developer                | Oracle IDE (Môi trường phát triển Oracle)  |
| Oracle Enterprise Manager    | Monitoring platform (Nền tảng giám sát)    |
| Docker Oracle XE             | Local development (Phát triển cục bộ)      |
| Listener Configuration       | Network connectivity (Kết nối mạng)        |

### 📚 Oracle SQL Fundamentals (Nền tảng Oracle SQL)

| Topic (Chủ đề)               | Description (Mô tả)                               |
| ---------------------------- | ------------------------------------------------- |
| Oracle Data Types            | NUMBER, VARCHAR2, CLOB (Kiểu dữ liệu)             |
| DDL                          | CREATE, ALTER, DROP (Ngôn ngữ định nghĩa dữ liệu) |
| DML                          | CRUD operations (Các thao tác thêm/sửa/xóa)       |
| MERGE                        | Upsert logic (Logic chèn/cập nhật)                |
| Analytic Functions           | Advanced SQL (SQL nâng cao)                       |
| Hierarchical Queries         | CONNECT BY (Truy vấn phân cấp)                    |
| Recursive Subquery Factoring | Recursive CTE (Biểu thức bảng chung đệ quy)       |
| Views                        | Logical abstraction (Trừu tượng hóa logic)        |
| Materialized Views           | Query acceleration (Tăng tốc truy vấn)            |

### ⚙️ PL/SQL Programming (Lập trình PL/SQL)

| Topic (Chủ đề)      | Description (Mô tả)                                |
| ------------------- | -------------------------------------------------- |
| Procedures          | Business logic (Logic nghiệp vụ)                   |
| Functions           | Reusable computation (Tính toán tái sử dụng)       |
| Packages            | Modular programming (Lập trình mô-đun)             |
| Triggers            | Event-driven automation (Tự động hóa theo sự kiện) |
| Exception Handling  | Fault management (Quản lý lỗi)                     |
| Dynamic SQL         | Runtime execution (Thực thi tại thời gian chạy)    |
| Bulk Collect        | High-throughput fetching (Truy xuất lưu lượng cao) |
| FORALL              | Batch DML (DML theo lô)                            |
| Pipelined Functions | Stream processing (Xử lý luồng)                    |

**🎯 Outcomes (Kết quả đạt được):**

- Understand Oracle SQL deeply (Hiểu sâu về Oracle SQL)
- Build enterprise PL/SQL systems (Xây dựng hệ thống PL/SQL doanh nghiệp)
- Use Oracle tooling professionally (Sử dụng các công cụ Oracle một cách chuyên nghiệp)

---

# 🟡 Stage 2 — Application Integration & SQL Engineering (Tích hợp Ứng dụng & Kỹ thuật SQL)

### 🔌 Enterprise Application Integration (Tích hợp Ứng dụng Doanh nghiệp)

| Topic (Chủ đề) | Description (Mô tả)                                    |
| -------------- | ------------------------------------------------------ |
| JDBC           | Java integration (Tích hợp Java)                       |
| ODP.NET        | .NET Oracle driver (Driver Oracle cho .NET)            |
| SQLAlchemy     | Python integration (Tích hợp Python)                   |
| Hibernate/JPA  | Enterprise ORM (ORM doanh nghiệp)                      |
| cx_Oracle      | Python Oracle connectivity (Kết nối Oracle cho Python) |

### ⚡ Query Engineering (Kỹ thuật Truy vấn)

| Topic (Chủ đề)        | Description (Mô tả)                                        |
| --------------------- | ---------------------------------------------------------- |
| Bind Variables        | Plan reuse (Tái sử dụng kế hoạch thực thi)                 |
| Cursor Sharing        | SQL scalability (Khả năng mở rộng SQL)                     |
| Batch Processing      | Throughput optimization (Tối ưu hóa thông lượng)           |
| Query Rewriting       | Optimizer guidance (Hướng dẫn bộ tối ưu hóa)               |
| Pagination Strategies | Enterprise querying (Truy vấn phân trang cấp doanh nghiệp) |
| Analytic Windows      | Advanced analytics (Cửa sổ phân tích nâng cao)             |
| Recursive Queries     | Hierarchical traversal (Duyệt phân cấp)                    |

### 🔄 Transactions & Concurrency (Giao dịch & Đồng thời)

| Topic (Chủ đề)           | Description (Mô tả)                                           |
| ------------------------ | ------------------------------------------------------------- |
| ACID                     | Transaction guarantees (Đảm bảo giao dịch)                    |
| Read Consistency         | Oracle MVCC (Tính nhất quán khi đọc)                          |
| Undo Segments            | Historical visibility (Hiển thị dữ liệu lịch sử)              |
| Row-level Locking        | Concurrency control (Kiểm soát đồng thời qua khóa cấp dòng)   |
| Deadlocks                | Detection & troubleshooting (Phát hiện & xử lý deadlock)      |
| Isolation Levels         | Transaction semantics (Mức độ cô lập giao dịch)               |
| Distributed Transactions | Enterprise consistency (Tính nhất quán doanh nghiệp phân tán) |

### 🏗️ Enterprise Architecture Patterns (Các Mẫu Kiến trúc Doanh nghiệp)

| Topic (Chủ đề)                 | Description (Mô tả)                                  |
| ------------------------------ | ---------------------------------------------------- |
| CQRS                           | Read/write segregation (Phân tách đọc/ghi)           |
| Event-driven Systems           | Messaging architectures (Kiến trúc nhắn tin/sự kiện) |
| Retry Patterns                 | Failure handling (Xử lý lỗi)                         |
| Idempotency                    | Safe retries (Thử lại an toàn)                       |
| Service-oriented Architectures | Enterprise integration (Tích hợp cấp doanh nghiệp)   |

**🎯 Outcomes (Kết quả đạt được):**

- Integrate Oracle into enterprise applications (Tích hợp Oracle vào ứng dụng doanh nghiệp)
- Build scalable transactional systems (Xây dựng hệ thống giao dịch có khả năng mở rộng)
- Optimize enterprise SQL workloads (Tối ưu hóa khối lượng tải SQL doanh nghiệp)

---

# 🔴 Stage 3 — Oracle Internals & Performance Engineering (Cấu trúc bên trong Oracle & Kỹ thuật Hiệu suất)

### 🧠 Oracle Memory Architecture (Kiến trúc Bộ nhớ Oracle)

| Topic (Chủ đề)       | Description (Mô tả)                                      |
| -------------------- | -------------------------------------------------------- |
| Instance vs Database | Oracle architecture (Kiến trúc Oracle)                   |
| SGA                  | Shared memory (Bộ nhớ dùng chung)                        |
| PGA                  | Process memory (Bộ nhớ tiến trình)                       |
| Shared Pool          | SQL cache (Bộ nhớ đệm SQL)                               |
| Buffer Cache         | Data cache (Bộ nhớ đệm Dữ liệu)                          |
| Redo Log Buffer      | Durability pipeline (Luồng đảm bảo độ bền dữ liệu)       |
| Large Pool           | Backup/shared workloads (Sao lưu/Khối lượng tải chia sẻ) |
| Result Cache         | Query caching (Bộ nhớ đệm kết quả truy vấn)              |

### 💾 Oracle Storage Internals (Cấu trúc Lưu trữ Oracle)

| Topic (Chủ đề)      | Description (Mô tả)                                    |
| ------------------- | ------------------------------------------------------ |
| Data Blocks         | Storage units (Đơn vị lưu trữ khối)                    |
| Extents             | Allocation units (Đơn vị cấp phát)                     |
| Segments            | Object storage (Lưu trữ đối tượng)                     |
| Tablespaces         | Logical storage (Lưu trữ logic)                        |
| ASM                 | Automatic Storage Management (Quản lý lưu trữ tự động) |
| Bigfile Tablespaces | Large-storage systems (Hệ thống lưu trữ lớn)           |
| Partitioning        | Large-table scalability (Mở rộng cho bảng lớn)         |

### 🔄 Redo & Undo Internals (Cấu trúc bên trong Redo & Undo)

| Topic (Chủ đề)   | Description (Mô tả)                                     |
| ---------------- | ------------------------------------------------------- |
| Redo Logs        | WAL architecture (Kiến trúc Ghi-trước-khi-Giao dịch)    |
| Undo Segments    | Historical data (Dữ liệu lịch sử)                       |
| SCN              | System Change Number (Số định danh thay đổi hệ thống)   |
| Checkpoints      | Recovery coordination (Điều phối khôi phục)             |
| Flashback        | Historical recovery (Khôi phục dữ liệu quá khứ)         |
| Read Consistency | MVCC implementation (Triển khai Kiểm soát đa phiên bản) |

### 📊 Cost-Based Optimizer (CBO) (Bộ Tối ưu hóa Dựa trên Chi phí)

| Topic (Chủ đề)         | Description (Mô tả)                              |
| ---------------------- | ------------------------------------------------ |
| Execution Plans        | Query plans (Kế hoạch thực thi truy vấn)         |
| Histograms             | Statistics distribution (Phân phối thống kê)     |
| Cardinality Estimation | Planner decisions (Ước lượng số lượng hàng)      |
| SQL Profiles           | Optimizer guidance (Hướng dẫn tối ưu hóa)        |
| SQL Plan Baselines     | Plan stability (Sự ổn định của kế hoạch)         |
| Adaptive Optimization  | Runtime tuning (Tối ưu hóa khi chạy)             |
| Parallel Execution     | Query acceleration (Tăng tốc truy vấn song song) |

### 📇 Indexing Deep Dive (Chuyên sâu về Chỉ mục)

| Topic (Chủ đề)         | Description (Mô tả)                             |
| ---------------------- | ----------------------------------------------- |
| B-Tree Indexes         | General indexing (Chỉ mục thông thường)         |
| Bitmap Indexes         | Warehouse optimization (Tối ưu hóa kho dữ liệu) |
| Function-based Indexes | Computed indexing (Chỉ mục tính toán)           |
| Reverse Key Indexes    | Insert scalability (Mở rộng thao tác chèn)      |
| Partitioned Indexes    | Large-scale indexing (Chỉ mục quy mô lớn)       |
| Index Compression      | Storage reduction (Nén chỉ mục)                 |

### ⚡ Wait Events & Diagnostics (Sự kiện Chờ & Chẩn đoán)

| Topic (Chủ đề)    | Description (Mô tả)                                           |
| ----------------- | ------------------------------------------------------------- |
| Wait Events       | Bottleneck analysis (Phân tích điểm nghẽn)                    |
| AWR               | Automatic Workload Repository (Kho lưu trữ công việc tự động) |
| ASH               | Active Session History (Lịch sử phiên hoạt động)              |
| ADDM              | Diagnostic advisor (Cố vấn chẩn đoán)                         |
| Latch Contention  | Internal synchronization (Đồng bộ hóa nội bộ)                 |
| Library Cache     | SQL parsing bottlenecks (Điểm nghẽn khi phân tích SQL)        |
| Buffer Busy Waits | IO contention (Tranh chấp IO)                                 |

**🎯 Outcomes (Kết quả đạt được):**

- Understand Oracle internals deeply (Hiểu sâu cấu trúc bên trong của Oracle)
- Diagnose enterprise bottlenecks professionally (Chẩn đoán điểm nghẽn một cách chuyên nghiệp)
- Optimize large-scale Oracle workloads (Tối ưu hóa khối lượng tải lớn của Oracle)
- Troubleshoot mission-critical systems (Xử lý sự cố hệ thống trọng yếu)

---

# 🟣 Stage 4 — High Availability & Enterprise Operations (Khả năng Sẵn sàng cao & Vận hành Doanh nghiệp)

### 🔁 High Availability & Disaster Recovery (Khả năng Sẵn sàng cao & Khôi phục Thảm họa)

| Topic (Chủ đề)      | Description (Mô tả)                                  |
| ------------------- | ---------------------------------------------------- |
| Oracle RAC          | Multi-node clustering (Cụm máy chủ nhiều node)       |
| Cache Fusion        | RAC synchronization (Đồng bộ RAC)                    |
| Data Guard          | Disaster recovery (Khôi phục thảm họa)               |
| Physical Standby    | Block-level replication (Sao chép mức khối)          |
| Logical Standby     | SQL-level replication (Sao chép mức SQL)             |
| Active Data Guard   | Readable standby (Cơ sở dữ liệu dự phòng có thể đọc) |
| Fast-start Failover | Automated recovery (Khôi phục tự động)               |
| Multi-site DR       | Regional resilience (Khả năng phục hồi khu vực)      |

### 💾 Backup & Recovery (Sao lưu & Khôi phục)

| Topic (Chủ đề)       | Description (Mô tả)                                      |
| -------------------- | -------------------------------------------------------- |
| RMAN                 | Enterprise backup system (Hệ thống sao lưu doanh nghiệp) |
| Incremental Backups  | Efficient recovery (Khôi phục hiệu quả)                  |
| Block Media Recovery | Targeted repair (Sửa chữa nhắm mục tiêu)                 |
| PITR                 | Point-in-time recovery (Khôi phục theo thời điểm)        |
| Flashback Database   | Historical rewind (Quay lại quá khứ)                     |
| Recovery Catalog     | Backup metadata (Siêu dữ liệu sao lưu)                   |
| Backup Validation    | Recovery testing (Kiểm thử khôi phục)                    |

### 🔐 Enterprise Security (Bảo mật Doanh nghiệp)

| Topic (Chủ đề)              | Description (Mô tả)                          |
| --------------------------- | -------------------------------------------- |
| Users & Roles               | Access management (Quản lý truy cập)         |
| Virtual Private Database    | Row-level security (Bảo mật mức hàng)        |
| Transparent Data Encryption | Encryption at rest (Mã hóa dữ liệu tĩnh)     |
| Oracle Wallet               | Secret management (Quản lý khóa bí mật)      |
| Database Vault              | Separation of duties (Phân tách trách nhiệm) |
| Unified Auditing            | Compliance logging (Ghi nhật ký tuân thủ)    |
| Fine-grained Auditing       | Detailed monitoring (Giám sát chi tiết)      |

**🎯 Outcomes (Kết quả đạt được):**

- Operate Oracle safely in enterprise production (Vận hành Oracle an toàn trên môi trường thực tế)
- Build mission-critical HA systems (Xây dựng các hệ thống HA trọng yếu)
- Recover enterprise systems during disasters (Khôi phục hệ thống trong thảm họa)

---

# ⚫ Stage 5 — Distributed Oracle Infrastructure (Hạ tầng Oracle Phân tán)

### 🌐 Distributed Enterprise Systems (Hệ thống Doanh nghiệp Phân tán)

| Topic (Chủ đề)           | Description (Mô tả)                                    |
| ------------------------ | ------------------------------------------------------ |
| Distributed Databases    | Multi-node systems (Hệ thống nhiều node)               |
| Sharding                 | Horizontal scalability (Mở rộng theo chiều ngang)      |
| Oracle GoldenGate        | Real-time replication (Sao chép theo thời gian thực)   |
| Distributed Transactions | Cross-node consistency (Tính nhất quán qua nhiều node) |
| CAP Theorem              | Distributed trade-offs (Thuyết CAP)                    |
| Global Data Services     | Multi-region routing (Định tuyến đa vùng)              |
| Read Scaling             | Replica architectures (Kiến trúc bản sao đọc)          |

### 📡 Messaging & Streaming (Nhắn tin & Truyền dữ liệu Luồng)

| Topic (Chủ đề)       | Description (Mô tả)                              |
| -------------------- | ------------------------------------------------ |
| CDC                  | Change data capture (Bắt dữ liệu thay đổi)       |
| GoldenGate Streams   | Real-time pipelines (Luồng thời gian thực)       |
| Kafka Integration    | Event streaming (Truyền sự kiện liên tục)        |
| Enterprise Messaging | SOA integration (Tích hợp kiến trúc SOA)         |
| Event-driven Systems | Distributed workflows (Luồng công việc phân tán) |

### ⚙️ Infrastructure Engineering (Kỹ thuật Hạ tầng)

| Topic (Chủ đề)     | Description (Mô tả)                                        |
| ------------------ | ---------------------------------------------------------- |
| Connection Pooling | Enterprise scaling (Mở rộng kết nối doanh nghiệp)          |
| Shared Servers     | Session scalability (Mở rộng số lượng phiên)               |
| Resource Manager   | Workload governance (Quản lý tải)                          |
| Parallel Query     | High-throughput execution (Thực thi luồng truy vấn lớn)    |
| Parallel DML       | Bulk processing (Xử lý hàng loạt)                          |
| Parallel DDL       | Large maintenance operations (Vận hành bảo trì quy mô lớn) |

**🎯 Outcomes (Kết quả đạt được):**

- Build distributed Oracle infrastructures (Xây dựng các hạ tầng Oracle phân tán)
- Scale enterprise Oracle systems safely (Mở rộng quy mô các hệ thống Oracle an toàn)
- Integrate Oracle into global architectures (Tích hợp Oracle vào kiến trúc toàn cầu)

---

# 🟤 Stage 6 — Data Warehousing & Analytics Engineering (Kỹ thuật Kho dữ liệu & Phân tích)

### 🏗️ Data Warehouse Architecture (Kiến trúc Kho dữ liệu)

| Topic (Chủ đề)    | Description (Mô tả)                                     |
| ----------------- | ------------------------------------------------------- |
| OLTP vs OLAP      | Workload separation (Phân chia công việc đọc/ghi)       |
| Star Schemas      | Warehouse modeling (Mô hình hóa kho dữ liệu)            |
| Snowflake Schemas | Enterprise analytics (Phân tích quy mô lớn)             |
| Fact Tables       | Event-centric data (Dữ liệu sự kiện)                    |
| Dimension Tables  | Business attributes (Thuộc tính doanh nghiệp)           |
| SCD Type 1/2/3    | Historical tracking (Theo dõi dữ liệu thay đổi lịch sử) |
| Aggregate Tables  | Query acceleration (Bảng tổng hợp tăng tốc độ)          |
| Data Marts        | Department analytics (Phân tích cấp phòng ban)          |

### 🔄 ETL & Data Pipelines (Đường ống ETL & Dữ liệu)

| Topic (Chủ đề)         | Description (Mô tả)                                 |
| ---------------------- | --------------------------------------------------- |
| Oracle Data Integrator | Enterprise ETL (Hệ thống ETL doanh nghiệp)          |
| ETL Pipelines          | Data movement (Di chuyển dữ liệu)                   |
| Incremental Loads      | Efficient synchronization (Đồng bộ hóa tăng dần)    |
| CDC Pipelines          | Streaming ingestion (Nạp dữ liệu luồng)             |
| Airflow                | Workflow orchestration (Điều phối quy trình)        |
| dbt                    | Transform management (Quản lý quá trình chuyển đổi) |
| Spark Integration      | Distributed analytics (Phân tích dữ liệu phân tán)  |
| Batch vs Streaming     | Processing models (Mô hình xử lý theo lô vs luồng)  |

### 📊 Analytics & Reporting (Phân tích & Báo cáo)

| Topic (Chủ đề)      | Description (Mô tả)                                  |
| ------------------- | ---------------------------------------------------- |
| Oracle OLAP         | Multidimensional analytics (Phân tích đa chiều)      |
| Materialized Views  | Query acceleration (Tăng tốc truy vấn với MView)     |
| Query Rewrite       | Optimizer acceleration (Tăng tốc qua bộ tối ưu hóa)  |
| BI Integration      | Enterprise reporting (Báo cáo doanh nghiệp - BI)     |
| KPI Systems         | Metrics engineering (Kỹ thuật chỉ số KPI)            |
| In-memory Analytics | Real-time reporting (Báo cáo phân tích trong bộ nhớ) |

### 🤖 Data Science Infrastructure (Hạ tầng Khoa học Dữ liệu)

| Topic (Chủ đề)          | Description (Mô tả)                                |
| ----------------------- | -------------------------------------------------- |
| Oracle Machine Learning | In-database ML (Học máy ngay trong CSDL)           |
| Feature Pipelines       | ML infrastructure (Hạ tầng đặc trưng ML)           |
| Data Lakes              | Hybrid analytics (Phân tích hồ dữ liệu lai)        |
| Predictive Models       | Enterprise AI (Mô hình dự đoán AI)                 |
| Data Validation         | Quality engineering (Kiểm soát chất lượng dữ liệu) |

**🎯 Outcomes (Kết quả đạt được):**

- Build enterprise analytics platforms (Xây dựng nền tảng phân tích doanh nghiệp)
- Design warehouse & ETL systems (Thiết kế kho dữ liệu và hệ thống ETL)
- Integrate Oracle into data ecosystems (Tích hợp Oracle vào hệ sinh thái dữ liệu)

---

# 🔵 Stage 7 — Observability, Diagnostics & Incident Engineering (Khả năng Quan sát, Chẩn đoán & Xử lý Sự cố)

### 📊 Monitoring & Observability (Giám sát & Khả năng quan sát)

| Topic (Chủ đề)       | Description (Mô tả)                                            |
| -------------------- | -------------------------------------------------------------- |
| Enterprise Manager   | Centralized monitoring (Giám sát tập trung)                    |
| AWR Reports          | Performance analytics (Phân tích hiệu suất từ AWR)             |
| ASH Reports          | Active workload analysis (Phân tích lượng truy cập hiện tại)   |
| ADDM                 | Automatic diagnostics (Chẩn đoán tự động)                      |
| Wait Event Analysis  | Bottleneck diagnosis (Phân tích nguyên nhân chờ nghẽn cổ chai) |
| Redo Metrics         | Recovery visibility (Theo dõi khả năng phục hồi)               |
| RAC Monitoring       | Cluster observability (Giám sát cụm RAC)                       |
| Prometheus Exporters | Metrics collection (Thu thập thông số qua Prometheus)          |
| Grafana              | Visualization (Trực quan hóa hệ thống bằng Grafana)            |

### 🚨 Incident Engineering (Kỹ thuật Xử lý Sự cố)

| Topic (Chủ đề)           | Description (Mô tả)                                                     |
| ------------------------ | ----------------------------------------------------------------------- |
| RAC Split-brain          | Cluster failure (Lỗi cụm chia cắt não)                                  |
| Redo Log Saturation      | Throughput pressure (Áp lực lưu lượng nạp Redo)                         |
| Archive Log Explosion    | Storage emergencies (Khẩn cấp không gian lưu trữ Archive Log)           |
| Library Cache Contention | Parsing bottlenecks (Điểm nghẽn khi phân tích lệnh SQL)                 |
| Undo Exhaustion          | Transaction pressure (Quá tải dung lượng Undo cho giao dịch)            |
| Failover Incidents       | DR troubleshooting (Xử lý lỗi cơ chế chuyển đổi dự phòng)               |
| Query Regression         | Optimizer instability (Sự suy giảm hiệu suất truy vấn do bộ tối ưu hóa) |

### 📈 Capacity Planning (Quy hoạch Dung lượng)

| Topic (Chủ đề)         | Description (Mô tả)                                       |
| ---------------------- | --------------------------------------------------------- |
| SGA Sizing             | Shared-memory planning (Hoạch định bộ nhớ SGA)            |
| PGA Sizing             | Process-memory planning (Hoạch định bộ nhớ quy trình PGA) |
| Redo Sizing            | Recovery architecture (Tính toán dung lượng Redo)         |
| IO Throughput Planning | Storage engineering (Quy hoạch năng lực IO)               |
| RAC Capacity Planning  | Cluster scalability (Quy hoạch khả năng mở rộng cụm RAC)  |

**🎯 Outcomes (Kết quả đạt được):**

- Operate Oracle professionally (Vận hành Oracle chuyên nghiệp)
- Diagnose enterprise infrastructure incidents (Chẩn đoán các sự cố hạ tầng doanh nghiệp)
- Build observable & reliable systems (Xây dựng các hệ thống có thể theo dõi và đáng tin cậy)

---

# 🟠 Stage 8 — Exadata, Cloud & Enterprise Ecosystem (Exadata, Đám mây & Hệ sinh thái Doanh nghiệp)

### 🧩 Oracle Enterprise Ecosystem (Hệ sinh thái Doanh nghiệp Oracle)

| Technology (Công nghệ)      | Purpose (Mục đích)                                         |
| --------------------------- | ---------------------------------------------------------- |
| Exadata                     | Engineered systems (Hệ thống phần cứng chuyên dụng)        |
| Oracle Cloud Infrastructure | Cloud platform (Nền tảng đám mây - OCI)                    |
| Autonomous Database         | Managed Oracle (Cơ sở dữ liệu Oracle tự quản lý)           |
| GoldenGate                  | Replication platform (Nền tảng đồng bộ/nhân bản dữ liệu)   |
| Oracle Analytics Cloud      | Enterprise analytics (Phân tích doanh nghiệp trên Đám mây) |
| Oracle Kubernetes Engine    | Container orchestration (Điều phối Container)              |

### ☁️ Cloud & Hybrid Infrastructure (Đám mây & Hạ tầng Lai)

| Topic (Chủ đề)         | Description (Mô tả)                                  |
| ---------------------- | ---------------------------------------------------- |
| OCI Architecture       | Cloud infrastructure (Kiến trúc hạ tầng đám mây OCI) |
| Hybrid Oracle Systems  | On-prem + cloud (Hệ thống kết hợp nội bộ & Đám mây)  |
| Kubernetes Deployments | Containerized Oracle (Oracle trên nền Container)     |
| Infrastructure as Code | Automated provisioning (Tự động hóa triển khai IaC)  |
| DevOps Pipelines       | Database CI/CD (Tích hợp & triển khai CSDL tự động)  |

### ⚙️ Enterprise Governance (Quản trị Doanh nghiệp)

| Topic (Chủ đề)    | Description (Mô tả)                                              |
| ----------------- | ---------------------------------------------------------------- |
| Compliance        | Enterprise regulation (Tuân thủ tiêu chuẩn doanh nghiệp)         |
| Auditing          | Operational traceability (Khả năng truy xuất quy trình vận hành) |
| Data Governance   | Enterprise standards (Tiêu chuẩn dữ liệu doanh nghiệp)           |
| Security Policies | Risk management (Chính sách bảo mật, quản lý rủi ro)             |

**🎯 Outcomes (Kết quả đạt được):**

- Understand Oracle enterprise ecosystems (Hiểu hệ sinh thái doanh nghiệp của Oracle)
- Operate cloud & hybrid Oracle systems (Vận hành hệ thống Oracle đám mây & lai)
- Build enterprise-grade infrastructure platforms (Xây dựng nền tảng hạ tầng cấp doanh nghiệp)

---

# 🧪 Production Labs (Phòng thí nghiệm Thực tế)

| Lab (Bài Lab)             | Focus (Trọng tâm)                                                          |
| ------------------------- | -------------------------------------------------------------------------- |
| RAC Failover Lab          | Cluster recovery (Khôi phục cụm RAC)                                       |
| Data Guard Switchover Lab | DR operations (Thực hành diễn tập chuyển đổi dự phòng)                     |
| AWR Diagnostics Lab       | Bottleneck analysis (Phân tích chẩn đoán nút thắt cổ chai AWR)             |
| GoldenGate Streaming Lab  | CDC pipelines (Đường ống luồng dữ liệu CDC GoldenGate)                     |
| Partitioning Lab          | Large-table scaling (Thực hành kỹ thuật phân vùng với bảng lớn)            |
| RMAN Recovery Lab         | Disaster recovery (Phục hồi thảm họa bằng RMAN)                            |
| Parallel Query Lab        | Warehouse acceleration (Tăng tốc xử lý kho dữ liệu với Truy vấn song song) |
| Wait Events Lab           | Performance diagnosis (Chẩn đoán sự cố dựa trên các Sự kiện chờ)           |
| ASM Failure Lab           | Storage troubleshooting (Xử lý lỗi hệ thống lưu trữ ASM)                   |

---

# 🗂️ Sample Systems (Hệ thống Mẫu)

## OLTP Database — `enterprise_core_db` (CSDL Xử lý Giao dịch OLTP)

| Table (Bảng) | Purpose (Mục đích)                                |
| ------------ | ------------------------------------------------- |
| customers    | Enterprise clients (Khách hàng doanh nghiệp)      |
| accounts     | Financial records (Bản ghi tài chính)             |
| transactions | High-volume operations (Giao dịch số lượng lớn)   |
| products     | Enterprise catalog (Danh mục sản phẩm)            |
| payments     | Financial processing (Xử lý thanh toán)           |
| audit_logs   | Compliance tracking (Theo dõi quá trình tuân thủ) |

## Analytics Warehouse — `enterprise_dw` (Kho dữ liệu Phân tích)

| Table (Bảng) | Purpose (Mục đích)                                    |
| ------------ | ----------------------------------------------------- |
| fact_sales   | Sales analytics (Bảng dữ kiện phân tích bán hàng)     |
| dim_customer | Customer dimensions (Bảng chiều thông tin khách hàng) |
| dim_product  | Product dimensions (Bảng chiều sản phẩm)              |
| dim_date     | Time hierarchy (Hệ thống phân cấp thời gian)          |

## Enterprise Reporting — `reporting_db` (CSDL Báo cáo Doanh nghiệp)

| Table (Bảng)    | Purpose (Mục đích)                              |
| --------------- | ----------------------------------------------- |
| dashboards      | KPI reporting (Báo cáo chỉ số KPI)              |
| reports         | Enterprise reports (Báo cáo doanh nghiệp chung) |
| compliance_logs | Audit systems (Hệ thống kiểm toán)              |

---

# 📁 Repository Structure (Cấu trúc Kho lưu trữ)

```text
oracle-infrastructure-enterprise-database-engineering-roadmap/
│
├── docs/                                  # Tài liệu kiến thức các giai đoạn (Stages)
│   ├── 00-architecture/                   # Kiến trúc tổng thể & Mô hình hóa (Stage 0)
│   ├── 01-fundamentals/                   # Cơ bản và PL/SQL (Stage 1)
│   ├── 02-integration/                    # Tích hợp ứng dụng & SQL (Stage 2)
│   ├── 03-internals/                      # Cấu trúc bên trong Oracle (Stage 3)
│   ├── 03-performance/                    # Tối ưu hóa hiệu suất (Stage 3)
│   ├── 04-rac/                            # Oracle RAC (Stage 4)
│   ├── 04-data-guard/                     # Oracle Data Guard (Stage 4)
│   ├── 05-distributed-systems/            # Hệ thống phân tán (Stage 5)
│   ├── 06-warehousing/                    # Kho dữ liệu (Stage 6)
│   ├── 07-observability/                  # Khả năng giám sát & theo dõi (Stage 7)
│   └── 08-ecosystem/                      # Đám mây & Hệ sinh thái doanh nghiệp (Stage 8)
│
├── sample-db/                             # Cơ sở dữ liệu mẫu cho thực hành (OLTP)
├── warehouses/                            # Dữ liệu & Script tạo kho dữ liệu (OLAP)
├── etl/                                   # Kịch bản Pipeline / dbt / Airflow
├── replication/                           # Cấu hình sao chép GoldenGate/Streams
├── monitoring/                            # Cấu hình giám sát (Prometheus, Grafana, AWR)
├── docker/                                # Môi trường Docker Compose
├── kubernetes/                            # Môi trường Kubernetes (OKE)
├── benchmarks/                            # Tập lệnh Benchmark và test tải
├── labs/                                  # Bài lab hướng dẫn thực hành chi tiết
├── diagrams/                              # Sơ đồ thiết kế (PlantUML / Draw.io)
├── scripts/                               # Tiện ích, tập lệnh quản trị Shell/Python
└── projects/                              # Các dự án mẫu, đồ án
```

---

# 🐳 Development Environment (Môi trường Phát triển)

### Docker Oracle XE (Khởi tạo Oracle bản XE với Docker)

```bash
docker run -d \
  --name oracle-xe \
  -p 1521:1521 \
  -e ORACLE_PASSWORD=secret \
  gvenzl/oracle-xe:21-slim
```

### SQL\*Plus (Kết nối qua dòng lệnh CLI)

```bash
# Recommendation: Use /nolog to avoid password exposure in process list
sqlplus system@localhost:1521/XEPDB1
```

---

# 🛠️ Recommended Tooling (Công cụ Khuyên dùng)

| Tool (Công cụ)     | Purpose (Mục đích)                                      |
| ------------------ | ------------------------------------------------------- |
| SQL Developer      | Oracle IDE (Trình soạn thảo mã Oracle)                  |
| SQL\*Plus          | Oracle CLI (Dòng lệnh Oracle)                           |
| Enterprise Manager | Monitoring platform (Nền tảng giám sát hệ thống)        |
| RMAN               | Backup management (Quản lý sao lưu/phục hồi)            |
| GoldenGate         | Replication platform (Nền tảng sao chép thời gian thực) |
| AWR/ASH            | Performance diagnostics (Công cụ chẩn đoán hiệu suất)   |
| Prometheus         | Monitoring (Thu thập Metrics)                           |
| Grafana            | Visualization (Vẽ biểu đồ và giao diện theo dõi)        |
| Airflow            | Workflow orchestration (Điều phối Workflow, ETL)        |
| dbt                | Transform pipelines (Xử lý chuyển đổi luồng dữ liệu)    |
| Kafka              | Streaming platform (Nền tảng Streaming dữ liệu sự kiện) |

---

# 📚 Recommended Reading (Tài liệu Đọc thêm)

### Oracle (Hệ quản trị Oracle)

- Oracle Database Concepts (Các khái niệm lõi về CSDL Oracle)
- Oracle Performance Tuning Guide (Hướng dẫn tinh chỉnh hiệu suất Oracle)
- Oracle Internals (Chuyên sâu cấu trúc nội bộ Oracle)
- Expert Oracle Database Architecture (Kiến trúc CSDL Oracle cho chuyên gia)
- Oracle RAC Handbook (Sổ tay Oracle RAC)

### Distributed Systems (Hệ thống Phân tán)

- Designing Data-Intensive Applications (Thiết kế ứng dụng dữ liệu lớn)
- Database Internals (Bên trong các hệ quản trị cơ sở dữ liệu)
- Site Reliability Engineering (Kỹ thuật SRE từ Google)

### Data Engineering (Kỹ thuật Dữ liệu)

- Fundamentals of Data Engineering (Nền tảng về kỹ thuật dữ liệu)
- The Data Warehouse Toolkit (Cẩm nang Kho dữ liệu)
- Streaming Systems (Hệ thống truyền tải luồng sự kiện)

---

# 🚀 Final Goal (Mục tiêu Cuối cùng)

By the end of this roadmap, you should be able to:
_Đến khi hoàn thành lộ trình này, bạn sẽ có khả năng:_

✅ Understand Oracle internals deeply 
(Hiểu sâu sắc các cấu trúc nội bộ của Oracle)
✅ Diagnose enterprise bottlenecks professionally 
(Chẩn đoán các điểm nghẽn của doanh nghiệp một cách chuyên nghiệp)
✅ Build mission-critical Oracle infrastructures 
(Xây dựng các hạ tầng CSDL Oracle trọng yếu)
✅ Operate RAC & Data Guard systems 
(Vận hành hệ thống Oracle RAC & Data Guard)
✅ Design distributed Oracle architectures 
(Thiết kế kiến trúc hệ thống Oracle phân tán)
✅ Build enterprise warehouse & analytics platforms 
(Xây dựng các nền tảng phân tích và kho dữ liệu doanh nghiệp)
✅ Implement enterprise HA & disaster recovery 
(Triển khai hệ thống khôi phục sau thảm họa & HA cho doanh nghiệp)
✅ Monitor and troubleshoot infrastructure incidents 
(Giám sát và khắc phục sự cố hạ tầng)
✅ Operate Oracle under mission-critical workloads 
(Vận hành Oracle dưới những tải công việc quan trọng)
✅ Work professionally as an Oracle Infrastructure Engineer / Enterprise Database Engineer 
(Làm việc chuyên nghiệp với tư cách là một Kỹ sư Hạ tầng Oracle / Kỹ sư CSDL Doanh nghiệp)
By the end of this roadmap, you should be able to:
_Đến khi hoàn thành lộ trình này, bạn sẽ có khả năng:_

✅ Understand Oracle internals deeply (Hiểu sâu sắc các cấu trúc nội bộ của Oracle)
✅ Diagnose enterprise bottlenecks professionally (Chẩn đoán các điểm nghẽn của doanh nghiệp một cách chuyên nghiệp)
✅ Build mission-critical Oracle infrastructures (Xây dựng các hạ tầng CSDL Oracle trọng yếu)
✅ Operate RAC & Data Guard systems (Vận hành hệ thống Oracle RAC & Data Guard)
✅ Design distributed Oracle architectures (Thiết kế kiến trúc hệ thống Oracle phân tán)
✅ Build enterprise warehouse & analytics platforms (Xây dựng các nền tảng phân tích và kho dữ liệu doanh nghiệp)
✅ Implement enterprise HA & disaster recovery (Triển khai hệ thống khôi phục sau thảm họa & HA cho doanh nghiệp)
✅ Monitor and troubleshoot infrastructure incidents (Giám sát và khắc phục sự cố hạ tầng)
✅ Operate Oracle under mission-critical workloads (Vận hành Oracle dưới những tải công việc quan trọng)
✅ Work professionally as an Oracle Infrastructure Engineer / Enterprise Database Engineer (Làm việc chuyên nghiệp với tư cách là một Kỹ sư Hạ tầng Oracle / Kỹ sư CSDL Doanh nghiệp)
