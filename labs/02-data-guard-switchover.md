# Lab 02: Data Guard Switchover (Role Reversal)
# Bài Lab 02: Đảo vai trò Data Guard

## Objective (Mục tiêu)
Perform a zero-data-loss switchover from the Primary database (Node A) to the Physical Standby database (Node B) using Data Guard Broker (`dgmgrl`).
*(Thực hiện đảo vai trò không mất dữ liệu từ CSDL Chính sang CSDL Dự phòng bằng Data Guard Broker).*

## Step-by-Step Instructions

### Step 1: Validate Readiness (Kiểm tra trạng thái)
On the Primary server, connect to DGMGRL:
```bash
dgmgrl sys/secret
```
Run the validation command to ensure the standby is ready:
```text
DGMGRL> VALIDATE DATABASE 'standby_db';
```
*Expected Output: `Ready for Switchover: Yes`*

### Step 2: Verify Transport Lag (Kiểm tra độ trễ)
Ensure all Redo data has been shipped and applied.
```text
DGMGRL> SHOW DATABASE 'standby_db' 'ApplyLag';
DGMGRL> SHOW DATABASE 'standby_db' 'TransportLag';
```
Both should ideally be `0 seconds`.

### Step 3: Execute Switchover (Thực thi)
Command the broker to perform the switch. The broker will automatically shut down instances, switch roles, and restart them.
*(Ra lệnh cho broker thực hiện. Broker tự động tắt, đổi vai trò, và khởi động lại CSDL).*
```text
DGMGRL> SWITCHOVER TO 'standby_db';
```

### Step 4: Verify the New Roles (Xác nhận)
```text
DGMGRL> SHOW CONFIGURATION;
```
You should now see that `standby_db` is the Primary database, and `primary_db` is now the Physical Standby database.

### Step 5: Failback (Hoàn nguyên)
Once the original primary node's maintenance is complete, run:
```text
DGMGRL> SWITCHOVER TO 'primary_db';
```
To return the cluster to its original state.
