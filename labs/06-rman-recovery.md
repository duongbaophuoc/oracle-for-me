# Lab 06: RMAN Disaster Recovery & Point-in-Time Recovery (PITR)
# Bài Lab 06: Phục hồi Thảm họa bằng RMAN & Khôi phục theo Thời điểm (PITR)

## Objective (Mục tiêu)
Perform a full hot database backup using Recovery Manager (RMAN), simulate a catastrophic data loss event (loss of a data file), and recover the database to a specific Point-in-Time before the failure.
*(Thực hiện sao lưu nóng toàn bộ CSDL bằng RMAN, giả lập sự cố mất dữ liệu nghiêm trọng (mất data file) và khôi phục CSDL về một thời điểm cụ thể trước khi xảy ra lỗi).*

## Scenario (Kịch bản)
At 14:00, a critical tablespace datafile is corrupted or deleted accidentally. You have a full cold/hot RMAN backup taken at 12:00, and the database runs in `ARCHIVELOG` mode. You must restore the missing tablespace file and recover all transactions up to 13:59.
*(Lúc 14h, tệp dữ liệu của một tablespace quan trọng bị xóa nhầm. Bạn có bản sao lưu RMAN đầy đủ lúc 12h và CSDL chạy ở chế độ ARCHIVELOG. Bạn cần khôi phục lại tệp bị mất và phục hồi mọi giao dịch đến thời điểm 13:59).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Ensure Archivelog Mode is Active
1. Connect as `SYSDBA`:
   ```sql
   ARCHIVE LOG LIST;
   ```
2. If it says `NOARCHIVELOG`, enable archiving:
   ```sql
   SHUTDOWN IMMEDIATE;
   STARTUP MOUNT;
   ALTER DATABASE ARCHIVELOG;
   ALTER DATABASE OPEN;
   ```

### Step 2: Execute RMAN Hot Backup
1. Launch RMAN and connect to the target database (refer to `scripts/01_rman_full_backup.sh`):
   ```bash
   rman target /
   ```
2. Execute backup of datafiles and control files including active archivelogs:
   ```rman
   BACKUP DATABASE PLUS ARCHIVELOG;
   ```

### Step 3: Simulate Datafile Deletion (Failure Simulation)
1. Find the physical path of a user datafile:
   ```sql
   SELECT file_name FROM dba_data_files WHERE tablespace_name = 'USERS';
   ```
2. Go to the filesystem and delete or rename that datafile (e.g. `users01.dbf`).
3. Flush the buffer cache and try reading from the table to trigger the crash:
   ```sql
   ALTER SYSTEM FLUSH BUFFER_CACHE;
   SELECT * FROM customers; -- ORA-01116 / ORA-01110 Error
   ```

### Step 4: Perform Point-in-Time Recovery using RMAN
1. Switch the database to mount mode:
   ```bash
   sqlplus / as sysdba
   SQL> SHUTDOWN ABORT;
   SQL> STARTUP MOUNT;
   ```
2. Launch RMAN and run the restore/recovery commands:
   ```rman
   RUN {
     SET UNTIL TIME "TO_DATE('2026-05-23 13:59:00', 'YYYY-MM-DD HH24:MI:SS')";
     RESTORE DATABASE;
     RECOVER DATABASE;
     ALTER DATABASE OPEN RESETLOGS;
   }
   ```
3. Verify that the datafile is restored, the database is open, and all transactions prior to the target time are safely recovered.

---
*Completed successfully when the database opens successfully and no transaction loss is reported before the target recovery time.*
