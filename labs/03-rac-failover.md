# Lab 03: RAC Failover & Chaos Engineering
# Bài Lab 03: RAC Failover & Kỹ thuật Tạo Sự cố Giả lập

## Objective (Mục tiêu)
Verify cluster high availability and Transparent Application Failover (TAF) by triggering a simulated node eviction and monitoring active client connections.
*(Kiểm chứng tính sẵn sàng cao của cụm RAC và cơ chế tự động chuyển vùng trong suốt (TAF) bằng cách giả lập sập một node và theo dõi kết nối đang hoạt động).*

## Scenario (Kịch bản)
A production cluster consists of Node 1 and Node 2. You need to ensure that during hardware failure on Node 1, clients reading from the `OLTP_SERVICE` are migrated transparently to Node 2 without experiencing query abortion or connection termination.
*(Hệ thống production có Node 1 và Node 2. Bạn cần đảm bảo khi Node 1 gặp sự cố phần cứng, các client đang đọc từ `OLTP_SERVICE` sẽ được chuyển hướng mượt mà sang Node 2 mà không bị lỗi truy vấn hoặc đứt kết nối).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Verify RAC Services Status
1. Check the status of current services using the Server Control utility:
   ```bash
   srvctl status service -d XEPDB1 -s oltp_service
   ```
2. Ensure the service is running on both nodes or has Node 2 as a configured failover target.

### Step 2: Establish TAF Connection from Client
1. Use the pre-configured `tnsnames.ora` with TAF parameters (refer to `docs/04-rac/02_taf_tnsnames.ora`):
   ```bash
   sqlplus system/secret@oltp_service_taf
   ```
2. Check which instance you are currently connected to:
   ```sql
   SELECT sys_context('USERENV', 'INSTANCE_NAME') AS current_instance FROM dual;
   ```

### Step 3: Run a Long-Running Query
Start a heavy query that takes several seconds or minutes, simulating active traffic:
```sql
SELECT COUNT(*) FROM transactions a, transactions b;
```

### Step 4: Simulate Node Eviction (Chaos Step)
1. Open another terminal and execute the chaos script (refer to `scripts/simulate_node_eviction.sh`):
   ```bash
   ./scripts/simulate_node_eviction.sh
   ```
   *This script halts the local Oracle instance abruptly using `SHUTDOWN ABORT` or kills the clusterware background processes.*

### Step 5: Verify Failover (TAF Validation)
1. Observe the query running in Step 3. It may experience a short delay (sub-second or few seconds) but should complete successfully.
2. Query the instance name again:
   ```sql
   SELECT sys_context('USERENV', 'INSTANCE_NAME') AS current_instance FROM dual;
   ```
   *The instance name should show the surviving node (e.g., `XE2` instead of `XE1`).*
3. Verify connection failover details:
   ```sql
   SELECT failover_type, failover_method, failed_over 
   FROM v$session 
   WHERE sid = sys_context('USERENV', 'SID');
   ```

---
*Completed successfully when all client queries survive node eviction without application crash.*
