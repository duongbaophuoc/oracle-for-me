-- ==============================================================================
-- Oracle Database Security Baseline Health Check
-- Kịch bản kiểm tra nhanh cấu hình bảo mật cơ sở (Security Baseline) của CSDL
-- ==============================================================================
-- Objective: Quick assessment of common security vulnerabilities, default profiles,
-- and excessive system privileges in an enterprise Oracle deployment.
--
-- Note: Must be run as SYSDBA or a user with SELECT_CATALOG_ROLE.
-- ==============================================================================

SET PAGESIZE 100;
SET LINESIZE 150;
SET FEEDBACK ON;

PROMPT =========================================================================;
PROMPT 🛡️  ORACLE SECURITY BASELINE HEALTH CHECK REPORT
PROMPT =========================================================================;

PROMPT;
PROMPT 1. DETECT UNLOCKED DEFAULT ACCOUNTS (Phát hiện tài khoản mặc định đang mở khóa);
PROMPT -------------------------------------------------------------------------;
-- Check for common default accounts that are not locked
SELECT username, account_status, created 
FROM dba_users 
WHERE username IN ('SYS', 'SYSTEM', 'OUTLN', 'DBSNMP', 'APPQOSSYS', 'CTXSYS', 'ANONYMOUS', 'XDB', 'XS$NULL', 'HR', 'SCOTT')
  AND account_status = 'OPEN'
ORDER BY username;

PROMPT;
PROMPT 2. HIGH-RISK SYSTEM PRIVILEGES GRANTED TO USERS (Quyền hệ thống nguy cơ cao);
PROMPT -------------------------------------------------------------------------;
-- Identify direct high-risk system privileges granted to non-system accounts
SELECT grantee, privilege, admin_option 
FROM dba_sys_privs 
WHERE privilege IN ('GRANT ANY PRIVILEGE', 'ALTER SYSTEM', 'DROP ANY TABLE', 'ALTER ANY TABLE', 'CREATE ANY TABLE', 'SELECT ANY DICTIONARY')
  AND grantee NOT IN ('SYS', 'SYSTEM', 'DBA')
ORDER BY grantee, privilege;

PROMPT;
PROMPT 3. DBA ROLE GRANTEES (Danh sách người dùng được cấp quyền DBA);
PROMPT -------------------------------------------------------------------------;
-- Check who has been granted the DBA role
SELECT grantee, admin_option, delegate_option 
FROM dba_role_privs 
WHERE granted_role = 'DBA' 
  AND grantee NOT IN ('SYS', 'SYSTEM')
ORDER BY grantee;

PROMPT;
PROMPT 4. UNIFIED AUDITING STATUS (Trạng thái cấu hình Unified Auditing);
PROMPT -------------------------------------------------------------------------;
-- Confirm if Oracle Unified Auditing is enabled (Default since 12c)
SELECT parameter, value 
FROM v$option 
WHERE parameter = 'Unified Auditing';

PROMPT;
PROMPT 5. PASSWORD COMPLEXITY IN USER PROFILES (Kiểm tra độ phức tạp của mật khẩu);
PROMPT -------------------------------------------------------------------------;
-- Check if password verification function is set to verify complexity
SELECT profile, resource_name, limit 
FROM dba_profiles 
WHERE resource_name = 'PASSWORD_VERIFY_FUNCTION'
ORDER BY profile;

PROMPT;
PROMPT 6. OBJECT PRIVILEGES GRANTED TO PUBLIC (Quyền đối tượng cấp cho PUBLIC);
PROMPT -------------------------------------------------------------------------;
-- High risk if critical packages are granted to PUBLIC
SELECT table_name, privilege 
FROM dba_tab_privs 
WHERE grantee = 'PUBLIC' 
  AND table_name IN ('DBMS_BACKUP_RESTORE', 'DBMS_OBFUSCATION_TOOLKIT', 'DBMS_CRYPTO', 'UTL_HTTP', 'UTL_FILE', 'UTL_SMTP', 'DBMS_SYS_SQL')
ORDER BY table_name;

PROMPT =========================================================================;
PROMPT ✅ Baseline Audit complete. Mitigate any unexpected OPEN status or grants.
PROMPT =========================================================================;
