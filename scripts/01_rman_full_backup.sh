#!/bin/bash
# ==============================================================================
# Utility Script: Automated RMAN Full Database Backup
# Tập lệnh Tiện ích: Tự động sao lưu toàn bộ CSDL bằng RMAN
# ==============================================================================

# Environment Variables (Set these according to your server)
export ORACLE_SID=ORCL
export ORACLE_HOME=/u01/app/oracle/product/19.0.0/dbhome_1
export PATH=$ORACLE_HOME/bin:$PATH
BACKUP_DIR="/backup/rman/full"
DATE_SUFFIX=$(date +'%Y%m%d_%H%M%S')
LOG_FILE="/backup/rman/logs/backup_${DATE_SUFFIX}.log"

echo "========================================================="
echo "Starting Oracle RMAN Full Backup at $(date)"
echo "Log file: $LOG_FILE"
echo "========================================================="

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR
mkdir -p /backup/rman/logs

# Execute RMAN Backup
rman target / log=$LOG_FILE <<EOF
RUN {
    # Allocate 4 parallel channels to speed up backup to disk
    ALLOCATE CHANNEL c1 DEVICE TYPE DISK;
    ALLOCATE CHANNEL c2 DEVICE TYPE DISK;
    ALLOCATE CHANNEL c3 DEVICE TYPE DISK;
    ALLOCATE CHANNEL c4 DEVICE TYPE DISK;

    # Perform highly compressed backup of the entire database and archive logs
    BACKUP AS COMPRESSED BACKUPSET 
      DATABASE FORMAT '${BACKUP_DIR}/db_%d_%T_%U.bck'
      PLUS ARCHIVELOG FORMAT '${BACKUP_DIR}/arch_%d_%T_%U.bck';

    # Crosscheck to ensure catalog matches physical files
    CROSSCHECK BACKUP;
    CROSSCHECK ARCHIVELOG ALL;

    # Delete backups older than the retention policy (e.g., 7 days)
    DELETE NOPROMPT OBSOLETE;
    
    # Release channels
    RELEASE CHANNEL c1;
    RELEASE CHANNEL c2;
    RELEASE CHANNEL c3;
    RELEASE CHANNEL c4;
}
EXIT;
EOF

# Check for RMAN errors in log file
if grep -i "RMAN-" $LOG_FILE; then
    echo "❌ Backup completed with ERRORS. Please check $LOG_FILE."
    exit 1
else
    echo "✅ Backup completed SUCCESSFULLY at $(date)."
    exit 0
fi
