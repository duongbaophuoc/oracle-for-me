-- ==============================================================================
-- Stage 4: High Availability - Security Hardening (TDE)
-- Thiết lập mã hóa dữ liệu ở mức lưu trữ (Transparent Data Encryption)
-- ==============================================================================

-- Safety Best Practice: Prompt securely inside SQL*Plus using ACCEPT ... HIDE.
-- Never pass passwords as command line arguments (e.g. sqlplus sys/pass @script.sql pass)
-- as it exposes credentials in the operating system process list (ps -ef).
--
-- (Quy tắc bảo mật: Yêu cầu nhập mật khẩu ẩn trực tiếp trong phiên SQL*Plus qua ACCEPT ... HIDE.
-- Không bao giờ truyền mật khẩu qua tham số dòng lệnh vì sẽ bị lộ trong danh sách tiến trình ps -ef).

PROMPT Secure software keystore setup initiation...
ACCEPT wallet_pass CHAR PROMPT 'Enter Software Keystore Wallet Password: ' HIDE

-- 1. Create a Software Keystore (Tạo ví lưu trữ khóa)
ADMINISTER KEY MANAGEMENT CREATE KEYSTORE '/u01/app/oracle/admin/ORCL/wallet' 
IDENTIFIED BY "&wallet_pass";

-- 2. Open the Keystore
ADMINISTER KEY MANAGEMENT SET KEYSTORE OPEN 
IDENTIFIED BY "&wallet_pass";

-- 3. Create/Set the Master Encryption Key
ADMINISTER KEY MANAGEMENT SET KEY 
IDENTIFIED BY "&wallet_pass" WITH BACKUP;

-- 4. Encrypt an existing tablespace (Mã hóa tablespace nhạy cảm)
ALTER TABLESPACE sensitive_data_ts ENCRYPTION USING 'AES256' ENCRYPT;

-- 5. Verify encryption status
SELECT tablespace_name, encrypted FROM dba_tablespaces;

-- Clean up SQL*Plus session variable from memory
UNDEFINE wallet_pass;