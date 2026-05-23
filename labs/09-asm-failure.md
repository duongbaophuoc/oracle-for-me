# Lab 09: ASM Storage Failure & Disk Rebalancing
# Bài Lab 09: Xử lý Sự cố Lưu trữ ASM & Cân bằng lại Ổ đĩa

## Objective (Mục tiêu)
Simulate a physical disk failure inside an Oracle Automatic Storage Management (ASM) diskgroup, hot-swap the faulty drive, and verify the automated online data rebalancing process without database downtime.
*(Giả lập lỗi hỏng ổ đĩa vật lý trong nhóm đĩa ASM, tiến hành thay thế nóng ổ đĩa hỏng và kiểm chứng quá trình tự động cân bằng lại dữ liệu trực tuyến mà không gây dừng hệ thống).*

## Scenario (Kịch bản)
You run a critical OLTP database on ASM storage. A disk in the `DATA` diskgroup experiences a physical sector hardware failure. You need to drop the failing disk cleanly from the active diskgroup, add a new clean disk, and monitor the background rebalance process to ensure data redundancy is maintained.
*(Hệ thống OLTP chạy trên lưu trữ ASM. Một ổ đĩa trong nhóm đĩa DATA bị hỏng phần cứng. Bạn cần loại bỏ đĩa hỏng ra khỏi nhóm đĩa hoạt động, thêm đĩa mới và theo dõi quá trình rebalance ngầm để đảm bảo tính an toàn dữ liệu).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Query ASM Disk Status
1. Log in to the ASM instance as `SYSASM`:
   ```bash
   sqlplus / as sysasm
   ```
2. Query the current health and paths of all physical disks in the diskgroups:
   ```sql
   SELECT name, path, state, header_status 
   FROM v$asm_disk;
   ```

### Step 2: Simulate Disk Failure & Drop Disk
1. Identify the disk target for simulation (e.g. `DATA_0001`).
2. Instruct ASM to drop the failing disk safely (ASM will automatically move data blocks off the failing disk to other healthy drives in the same group before dropping):
   ```sql
   ALTER DISKGROUP DATA DROP DISK DATA_0001;
   ```

### Step 3: Monitor Online Data Rebalancing
1. Check the progress of the active background rebalance operation:
   ```sql
   SELECT group_number, operation, state, power, est_minutes 
   FROM v$asm_operation;
   ```
   *The state should show `RUN` and display the estimated minutes remaining. The database remains fully readable and writable during this process.*

### Step 4: Add New Storage Disk
Once the faulty drive is replaced by the hardware team, add the new physical disk back into the diskgroup to restore total storage capacity:
```sql
ALTER DISKGROUP DATA ADD DISK '/dev/oracleasm/disks/DISK01_NEW';
```

### Step 5: Verify Final Diskgroup Topology
Check that all disks are online, headers are marked as `MEMBER`, and data distribution is balanced:
```sql
SELECT group_number, disk_number, name, total_mb, free_mb 
FROM v$asm_disk;
```

---
*Completed successfully when the ASM disk rebalance completes without data loss or application downtime.*
