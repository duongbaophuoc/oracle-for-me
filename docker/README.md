# 🐳 Docker Environment
# Môi trường Docker

This folder provides a quick way to spin up an Oracle Database instance locally for testing and development using Docker Compose.
*Thư mục này cung cấp cách thức nhanh chóng để khởi chạy một instance CSDL Oracle cục bộ phục vụ cho việc kiểm thử và phát triển bằng Docker Compose.*

## Pre-requisites (Điều kiện tiên quyết)
- Docker Desktop or Docker Engine installed.
- At least 4GB of RAM allocated to Docker.

## Usage (Cách sử dụng)

1. Start the database (Khởi động CSDL):
   ```bash
   docker-compose up -d
   ```

2. Check the logs to see when it's ready (Kiểm tra log xem đã sẵn sàng chưa):
   ```bash
   docker logs -f oracle-xe
   ```
   *Wait until you see: `DATABASE IS READY TO USE!`*

3. Connect via SQL*Plus or SQL Developer (Kết nối):
   - **Host:** `localhost`
   - **Port:** `1521`
   - **SID/Service Name:** `XEPDB1`
   - **Username:** `system`
   - **Password:** `secret`