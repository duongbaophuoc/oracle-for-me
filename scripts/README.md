# 🛠️ Utility Scripts
# Các Tập lệnh Tiện ích

This folder is for DBA operational scripts (Bash, Python) that automate daily tasks.
*Thư mục này dành cho các tập lệnh vận hành của DBA (Bash, Python) dùng để tự động hóa công việc hàng ngày.*

### Example: Automated RMAN Backup (Mẫu: Tự động Sao lưu RMAN)
```bash
#!/bin/bash
export ORACLE_SID=ORCL
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1

rman target / <<EOF
RUN {
  ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
  BACKUP AS COMPRESSED BACKUPSET DATABASE PLUS ARCHIVELOG;
  DELETE OBSOLETE;
}
EXIT;
EOF
```
*(Lưu các script vận hành thực tế của bạn vào thư mục này).*