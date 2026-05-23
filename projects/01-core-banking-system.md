# Capstone Project: Enterprise Core Banking Architecture
# Đồ án Tốt nghiệp: Kiến trúc Ngân hàng Lõi Doanh nghiệp

## Business Scenario (Kịch bản Nghiệp vụ)
You are the Lead Database Engineer for a new digital bank. The bank is preparing for its official launch and expects 1 million concurrent users on Day 1. The CTO has tasked you with building the entire Oracle infrastructure from the ground up.
*(Bạn là Kỹ sư trưởng CSDL. Ngân hàng chuẩn bị ra mắt và dự kiến 1 triệu user đồng thời vào Ngày 1. CTO yêu cầu bạn xây dựng toàn bộ hạ tầng Oracle từ đầu).*

## Deliverables & Requirements (Yêu cầu & Kết quả Bàn giao)

### Phase 1: Storage & Memory Engineering
1. Configure an Oracle 21c/23c instance using Docker.
2. Define a custom `SGA_TARGET` of 2GB and `PGA_AGGREGATE_TARGET` of 1GB.
3. Create two dedicated Tablespaces: `TS_BANK_DATA` and `TS_BANK_INDEXES`.

### Phase 2: Schema Design (OLTP)
Create the Core Banking Schema in 3NF:
- `users` table.
- `accounts` table (Foreign Key to users).
- `transactions` table (Must be **Partitioned** by `transaction_date`).
- **Constraint:** Ensure `balance` in `accounts` can never drop below $0 using a `CHECK` constraint.

### Phase 3: PL/SQL Business Logic
Create a Package `pkg_transactions`:
- Implement a `transfer_funds` procedure.
- MUST use `SELECT ... FOR UPDATE` to prevent concurrent race conditions (Double spending).
- MUST include strict Exception Handling (Rollback on failure, commit on success).

### Phase 4: Data Warehousing (OLAP)
1. Create a Star Schema in a different schema `bank_dw`.
2. Write a Python ETL script using `pandas` and `cx_oracle/oracledb` to migrate yesterday's completed transactions into the Data Warehouse.
3. Build a **Materialized View** with `FAST REFRESH` that calculates "Total Daily Transaction Volume by Account".

### Phase 5: High Availability & Disaster Recovery
- Write the exact `dgmgrl` commands you would run to set up a Physical Standby database.
- Create a `tnsnames.ora` file configured for Transparent Application Failover (TAF).

---
*Pass Criteria: The PL/SQL package must successfully transfer funds without deadlocking under a 50-thread concurrent stress test, and the ETL script must run without full table scans.*
*(Tiêu chí Đạt: Gói PL/SQL chuyển tiền thành công không bị deadlock khi ép tải 50 luồng, và script ETL chạy không bị quét toàn bảng).*
