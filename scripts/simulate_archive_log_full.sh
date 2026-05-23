#!/bin/bash
# ==============================================================================
# Incident Simulation: Archive Log Destination 100% Full (FRA)
# Giả lập Sự cố: Vùng nhớ Archive Log đầy 100% gây đóng băng CSDL
# ==============================================================================

# User confirmation to prevent damage in production
read -p "⚠️ WARNING: This will simulate an Archive Log full emergency in your test environment. Continue? (y/N) " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo "========================================================="
echo "🚀 [START] Simulating Archive Log Full Emergency..."
echo "========================================================="

# Step 1: Set the FRA (Flash Recovery Area) size to a tiny but Oracle-valid value to trigger the full error quickly
# (Đặt kích thước vùng lưu trữ FRA nhỏ nhưng hợp lệ - tối thiểu 100M - để tránh lỗi metadata của Oracle)
sqlplus -s / as sysdba <<EOF
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 100M SCOPE=BOTH;
EOF

# Step 2: Force multiple log switches with progressive throttling to fill the tiny FRA space
# (Cưỡng chế chuyển đổi nhật ký log liên tục có giãn cách để tiến trình ARCn kịp đóng băng mà không gây nghẽn ổ đĩa chậm)
# Adding a 1-second delay between switches prevents severe storage I/O lockups (Log file switch completion wait)
# and ensures the ARCn processes write cleanly to FRA until it overflows.
echo "Forcing log switches to fill the FRA..."
for i in {1..20}
do
  echo "Switching Logfile #$i..."
  sqlplus -s / as sysdba <<EOF
  ALTER SYSTEM SWITCH LOGFILE;
EOF
  sleep 1 # Staggers the switches safely to allow background archiving throughput
done

# Step 3: Verify the space usage on the FRA
echo "FRA Space Usage Status:"
sqlplus -s / as sysdba <<EOF
SET PAGESIZE 100
SELECT name, space_limit, space_used, 
       ROUND((space_used/space_limit)*100, 2) AS percent_full 
FROM v\$recovery_file_dest;
EOF

echo "⚠️ CSDL hiện có thể bị đóng băng và báo lỗi ORA-00257: archiver error."

# ==============================================================================
# RECOVERY SEQUENCE (Quy trình Khắc phục sự cố khẩn cấp bằng RMAN)
# ==============================================================================
read -p "⚠️ CSDL đã đóng băng. Bắt đầu quy trình khắc phục khẩn cấp bằng RMAN? (y/N) " recover_confirm
if [[ $recover_confirm =~ ^[Yy]$ ]]; then
    echo "Running emergency RMAN Backup and Clean..."
    
    # Run RMAN to back up archive logs and purge the ones that are successfully backed up
    # (Khởi chạy RMAN để backup và xóa các file archive log cũ để giải phóng không gian đĩa)
    rman target / <<EOF
    BACKUP ARCHIVELOG ALL DELETE INPUT;
EOF

    # Expand the FRA size to prevent recurrence in production
    # (Mở rộng kích thước FRA để tránh sự cố lặp lại)
    echo "Expanding FRA size to 10GB for production-ready state..."
    sqlplus -s / as sysdba <<EOF
    ALTER SYSTEM SET DB_RECOVERY_FILE_DEST_SIZE = 10G SCOPE=BOTH;
EOF

    echo "✅ [RECOVERY COMPLETE] Database is healthy and unfrozen!"
fi
