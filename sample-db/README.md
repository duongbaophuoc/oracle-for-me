# 🗂️ Sample OLTP Database
# Cơ sở Dữ liệu Mẫu OLTP

This folder contains DML scripts to generate dummy data for the `enterprise_core_db` schema defined in `docs/00-architecture`.
*Thư mục này chứa các lệnh thao tác dữ liệu (DML) để tạo dữ liệu giả lập cho lược đồ `enterprise_core_db` đã được định nghĩa ở thư mục `docs/00-architecture`.*

## Instructions
1. Run `docs/00-architecture/01_oltp_financial_schema.sql` first to create the tables.
2. Run `01_insert_dummy_data.sql` to populate the tables with test data.