# 📡 Database Replication (Nhân bản & Sao chép Dữ liệu)

This folder contains configurations and scripts for real-time logical replication and Change Data Capture (CDC) utilizing Oracle GoldenGate and Debezium (Kafka Connect).
*Thư mục này chứa các tệp cấu hình và tập lệnh phục vụ cho việc nhân bản logic thời gian thực và Change Data Capture (CDC) sử dụng Oracle GoldenGate và Debezium (Kafka Connect).*

---

## 📂 Directory Structure (Cấu trúc thư mục)

- [01_goldengate_setup.sh](file:///e:/ABC/NoSQL/OracleSQL/replication/01_goldengate_setup.sh): Shell script representing the GGSCI commands to configure Integrated Extract and Integrated Replicat.
- [02_debezium_oracle_connector.json](file:///e:/ABC/NoSQL/OracleSQL/replication/02_debezium_oracle_connector.json): Safe Kafka Connect JSON configuration for Debezium CDC using LogMiner.
- [03_create_debezium_user.sql](file:///e:/ABC/NoSQL/OracleSQL/replication/03_create_debezium_user.sql): DBA DDL script to provision `c##dbzuser` with the strict minimal permissions required for LogMiner.

---

## 🔒 Security Best Practices for Debezium Secrets
In our Debezium configuration (`02_debezium_oracle_connector.json`), the database connection password is externalized using Kafka Connect's `FileConfigProvider`:
```json
"database.password": "${file:/secrets/oracle:password}"
```
To secure this setup in production:
1. **File Protection:** Ensure the `/secrets/oracle` file containing clear-text credentials is owned exclusively by the `connect` user running Kafka Connect.
2. **Access Control:** Restrict read-write permissions tightly using system ACLs:
   ```bash
   chown connect:connect /secrets/oracle
   chmod 400 /secrets/oracle
   ```
3. **Alternative Vaults:** For cloud environments, migrate this to secure keystores like HashiCorp Vault or AWS Secrets Manager.

---

## 🏗️ Architectural Trade-offs: Debezium LogMiner vs Oracle XStream

When designing a large-scale real-time ingestion pipeline from Oracle DB, SREs must choose between two main CDC capture methods:

| Criteria (Tiêu chí) | Debezium LogMiner | Oracle XStream API |
| :--- | :--- | :--- |
| **Licensing (Bản quyền)** | **Free / Open Source** (No extra Oracle license required) | **Commercial** (Requires Oracle GoldenGate license!) |
| **Performance (Hiệu năng)** | Moderate (Good for up to 10k-20k write ops/sec) | **Extreme High-throughput** (Capable of >100k events/sec) |
| **Database Overhead** | High (LogMiner runs heavy SQL queries to parse redo logs) | Low (Direct memory interface offloads parsing engine) |
| **Catalog Lock Latching** | High (Shared pool contention under heavy schema shifts) | None (Streams directly from SGA streams pool) |
| **PGA Memory Consumption** | High (LogMiner allocates significant private process memory) | Extremely Low (Stream processing handled via SGA buffer pools) |

### Key Recommendation
- **Use LogMiner** for small to mid-scale transactional loads or when GoldenGate licensing cost is a major constraint. Ensure you configure a large PGA and allocate dedicated Redo Log disks to withstand LogMiner's query rates.
- **Use XStream** for large-scale financial cores (e.g., Core Banking) where sub-second replication latency is mandatory and CPU/Memory overhead on the primary transactional instance must be minimized.