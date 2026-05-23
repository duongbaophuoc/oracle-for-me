-- ==============================================================================
-- Replication: Create Debezium CDC User & Grant Minimal LogMiner Privileges
-- Nhân bản: Tạo người dùng Debezium CDC & Cấp quyền tối thiểu cho LogMiner
-- ==============================================================================

-- Execute this script as SYSDBA on the Container Database (CDB) level.
-- (Thực thi tập lệnh này với quyền SYSDBA tại tầng Container Database - CDB).

-- 1. Create a common user for Debezium (Tạo người dùng chung)
CREATE USER c##dbzuser IDENTIFIED BY "&dbz_password" DEFAULT TABLESPACE users;

-- 2. Grant session and logging registration permissions
-- (Cấp quyền kết nối và đăng ký ghi nhật ký)
GRANT CREATE SESSION TO c##dbzuser CONTAINER=ALL;
GRANT SET CONTAINER TO c##dbzuser CONTAINER=ALL;

-- 3. Grant LogMiner operational privileges (Mandatory for Debezium)
-- (Cấp các quyền vận hành LogMiner - Bắt buộc đối với Debezium CDC)
GRANT SELECT ANY TRANSACTION TO c##dbzuser CONTAINER=ALL;
GRANT LOGMINING TO c##dbzuser CONTAINER=ALL;

-- 4. Grant SELECT privileges only on specific CDC-required system views (Least Privilege)
-- (Cấp quyền SELECT tối thiểu trên các view hệ thống cần thiết cho LogMiner)
GRANT SELECT ON v_$log TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$logfile TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$logmnr_contents TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$logmnr_monitor TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$logmnr_parameters TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$logmnr_session TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$database TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$thread TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$parameter TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$archived_log TO c##dbzuser CONTAINER=ALL;
GRANT SELECT ON v_$archive_dest TO c##dbzuser CONTAINER=ALL;

-- 5. Grant read access to the specific outbox table in the Pluggable Database (PDB)
-- (Cấp quyền đọc bảng dữ liệu outbox cụ thể trong PDB)
-- Connect to your PDB (e.g. XEPDB1) and run:
--   GRANT SELECT ON ENTERPRISE_CORE_DB.ENTERPRISE_OUTBOX TO c##dbzuser;

PROMPT Provisioning completed. Please run schema-specific grants in your PDB.
