-- ==============================================================================
-- Sample Database - DDL Cleanup Schema
-- Cơ sở dữ liệu mẫu - Dọn dẹp Lược đồ DDL
-- ==============================================================================

-- Safely drop tables in the correct order to avoid Foreign Key violations
-- (Xóa các bảng một cách an toàn theo thứ tự chính xác để tránh vi phạm khóa ngoại).

PROMPT Cleaning up existing tables...

BEGIN
    -- Drop transactions first as it references accounts
    EXECUTE IMMEDIATE 'DROP TABLE transactions CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    -- Drop accounts as it references customers
    EXECUTE IMMEDIATE 'DROP TABLE accounts CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

BEGIN
    -- Drop customers last
    EXECUTE IMMEDIATE 'DROP TABLE customers CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

PROMPT Cleanup completed successfully.
