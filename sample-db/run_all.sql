-- ==============================================================================
-- Master Script: Initialize and Populate Sample Database
-- Tập lệnh Chính: Khởi tạo và Nạp Dữ liệu cho CSDL Mẫu
-- ==============================================================================

-- This script runs all schema initializations sequentially.
-- Run this in SQL*Plus or SQL Developer:
-- SQL> @run_all.sql
-- (Tập lệnh này chạy tuần tự tất cả các bước khởi tạo CSDL mẫu).

SET FEEDBACK ON;
SET ECHO ON;

PROMPT =========================================================
PROMPT 🚀 Starting Core Banking Sample Database Installation
PROMPT =========================================================

-- Step 1: Clean up existing schemas (Xóa các bảng cũ nếu có)
@00_cleanup_schema.sql

-- Step 2: Create DDL tables, indexes, and constraints (Tạo cấu trúc bảng)
@01_create_schema.sql

-- Step 3: Populate sample records (Nạp dữ liệu mẫu)
@01_insert_dummy_data.sql

-- Step 4: Run diagnostic queries to verify success (Chạy kiểm thử)
@03_sample_queries.sql

PROMPT =========================================================
PROMPT ✅ Installation Completed Successfully!
PROMPT =========================================================
