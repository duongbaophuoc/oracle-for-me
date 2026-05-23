# ==============================================================================
# Stage 4: Data Guard - DGMGRL Broker Setup
# Giai đoạn 4: Data Guard - Cấu hình qua Data Guard Broker
# ==============================================================================

# Data Guard Broker is the standard tool to manage a Data Guard configuration.
# Instead of running complex SQL commands manually on both nodes, you use the 
# command-line tool `dgmgrl`.
# (Data Guard Broker là công cụ chuẩn để quản lý Data Guard. Thay vì chạy lệnh SQL 
# phức tạp thủ công trên cả 2 node, ta dùng CLI `dgmgrl`).

# 1. Start the Data Guard Broker process on BOTH servers (in SQL*Plus):
# ALTER SYSTEM SET dg_broker_start=true;

# 2. Connect to the Primary database using DGMGRL
dgmgrl sys/secret@primary_db

# 3. Create the Configuration
# (Tạo Cấu hình)
DGMGRL> CREATE CONFIGURATION 'EnterpriseDR' AS 
        PRIMARY DATABASE IS 'primary_db' 
        CONNECT IDENTIFIER IS primary_db;

# 4. Add the Standby Database
# (Thêm CSDL Dự phòng)
DGMGRL> ADD DATABASE 'standby_db' AS 
        CONNECT IDENTIFIER IS standby_db 
        MAINTAINED AS PHYSICAL;

# 5. Enable the Configuration
# (Kích hoạt Cấu hình, Redo logs sẽ bắt đầu được gửi đi)
DGMGRL> ENABLE CONFIGURATION;

# 6. Check the Status
# (Kiểm tra trạng thái)
DGMGRL> SHOW CONFIGURATION;
# Expected Output:
# Configuration - EnterpriseDR
#   Protection Mode: MaxPerformance
#   Members:
#   primary_db - Primary database
#     standby_db - Physical standby database 
# Fast-Start Failover: DISABLED
# Configuration Status:
# SUCCESS

# 7. Upgrade Protection Mode to Maximum Availability (if required)
# (Nâng cấp chế độ bảo vệ lên Sẵn sàng Tối đa)
DGMGRL> EDIT DATABASE 'primary_db' SET PROPERTY LogXptMode='SYNC';
DGMGRL> EDIT DATABASE 'standby_db' SET PROPERTY LogXptMode='SYNC';
DGMGRL> EDIT CONFIGURATION SET PROTECTION MODE AS MAXAVAILABILITY;

# 8. Enable Fast-Start Failover (FSFO)
# FSFO requires an external server running the "Observer" process.
# If the Observer sees the Primary go down, it automatically fails over to the Standby.
# (FSFO tự động chuyển dự phòng nếu Primary sập. Cần một máy chủ thứ 3 chạy tiến trình Observer).
DGMGRL> START OBSERVER;
DGMGRL> ENABLE FAST_START FAILOVER;
