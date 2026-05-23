# 🛠️ Utility Scripts
# Các Tập lệnh Tiện ích

This folder is for DBA operational scripts (Bash, Python) that automate daily tasks.
*Thư mục này dành cho các tập lệnh vận hành của DBA (Bash, Python) dùng để tự động hóa công việc hàng ngày.*

### 📂 Script Catalog (Danh mục các Script)

| Script | Purpose (Mục đích) | Language |
| --- | --- | --- |
| [01_rman_full_backup.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/01_rman_full_backup.sh) | Automated RMAN backup script with channels allocation. *(Tự động sao lưu nóng RMAN).* | Bash |
| [02_gather_schema_stats.sql](file:///e:/ABC/NoSQL/OracleSQL/scripts/02_gather_schema_stats.sql) | Gathers cost-based optimizer schema statistics. *(Thu thập thống kê tối ưu hóa CBO).* | SQL |
| [03_kill_inactive_sessions.sql](file:///e:/ABC/NoSQL/OracleSQL/scripts/03_kill_inactive_sessions.sql) | Safely kills zombie/deadlocked inactive sessions. *(Tự động giải phóng phiên treo).* | SQL |
| [04_security_baseline_healthcheck.sql](file:///e:/ABC/NoSQL/OracleSQL/scripts/04_security_baseline_healthcheck.sql) | Quick audit of default accounts, privileges, profiles, and auditing. *(Kiểm tra cấu hình bảo mật).* | SQL |
| [dataguard_operations.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/dataguard_operations.sh) | Automates Data Guard switches and configurations. *(Quản lý Active/Standby Data Guard).* | Bash |
| [simulate_archive_log_full.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/simulate_archive_log_full.sh) | Chaos simulation of filling the Fast Recovery Area. *(Giả lập tràn bộ nhớ Archive Log).* | Bash |
| [simulate_node_eviction.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/simulate_node_eviction.sh) | Chaos simulation of RAC inter-node communication failure. *(Giả lập sập Node trong RAC).* | Bash |