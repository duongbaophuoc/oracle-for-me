#!/bin/bash
# ==============================================================================
# Chaos Engineering: Simulate Cluster Node Eviction
# Kịch bản Kiểm thử Sự cố: Mô phỏng mất kết nối Node
# ==============================================================================

# User confirmation to prevent accidental destruction in production environments
# (Xác nhận từ người dùng để tránh thực thi nhầm lẫn trên production).
read -p "⚠️ WARNING: This will hard-kill Node 2 using 'crsctl stop crs -f'. This can leave ASM disk groups dirty. Continue? (y/N) " confirm
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 0
fi

echo "========================================================="
echo "[START] Running HA / Service status check..."
srvctl status service -d PRODDB

echo "[CHAOS] Simulating Kernel Panic / Hard Power Off on Node 2..."
# In Lab, we do a hard stop (crsctl stop crs -f) to simulate an abrupt crash.
# WARNING: This hard abort stops the ASM instance dirty, simulating emergency eviction.
# In a standard production graceful maintenance operation, ALWAYS use:
# 'crsctl stop crs' OR 'srvctl stop nodeapps -n <node_name>'
sudo crsctl stop crs -f

echo "[CHAOS] Node 2 is DOWN."
echo "[CHECK] Monitor Application Logs: Connections should failover to Node 1 via TAF."
echo "[CHECK] Run: 'srvctl status database -d PRODDB' to see service migration."

sleep 60
echo "[RECOVERY] Bringing Node 2 back online..."
sudo crsctl start crs
