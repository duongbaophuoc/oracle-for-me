# Lab 04: GoldenGate Streaming & Change Data Capture (CDC)
# Bài Lab 04: Luồng Dữ liệu GoldenGate & Bắt Dữ liệu Thay đổi (CDC)

## Objective (Mục tiêu)
Configure Oracle GoldenGate or Debezium to stream real-time DML transactions from an OLTP table to an event stream (Apache Kafka) for downstream analytical consumer systems.
*(Cấu hình Oracle GoldenGate hoặc Debezium để truyền luồng giao dịch DML thời gian thực từ bảng OLTP sang luồng sự kiện Apache Kafka phục vụ các hệ thống phân tích hạ nguồn).*

## Scenario (Kịch bản)
The marketing team needs real-time customer registration notifications. You need to enable transaction capture on the `customers` table and pipe changes to a Kafka topic without impacting production OLTP database performance.
*(Đội Marketing cần nhận thông báo đăng ký của khách hàng theo thời gian thực. Bạn cần bật tính năng bắt giao dịch trên bảng `customers` và truyền các thay đổi này sang một Kafka topic mà không ảnh hưởng hiệu năng CSDL OLTP).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Enable Supplemental Logging on Source
Supplemental logging is required so Oracle includes primary key columns in the Redo/Undo log entries during updates.
*(Supplemental logging là bắt buộc để Oracle đưa các cột khóa chính vào Redo/Undo log khi thực hiện cập nhật).*
1. Connect as `SYSDBA`:
   ```sql
   ALTER DATABASE ADD SUPPLEMENTAL LOG DATA;
   ALTER TABLE customers ADD SUPPLEMENTAL LOG DATA (ALL) COLUMNS;
   ```
2. Verify:
   ```sql
   SELECT supplemental_log_data_min, supplemental_log_data_pk FROM v$database;
   ```

### Step 2: Spin Up the CDC Stack
Deploy the preconfigured Kafka/Debezium stack (refer to `docker/docker-compose-cdc.yml`):
```bash
docker-compose -f docker/docker-compose-cdc.yml up -d
```

### Step 3: Register Debezium Oracle Connector
Configure Debezium to read the Redo logs via LogMiner using the least-privileged user (refer to `replication/02_debezium_oracle_connector.json` and `replication/03_create_debezium_user.sql`):
```bash
curl -X POST -H "Content-Type: application/json" \
  --data @replication/02_debezium_oracle_connector.json \
  http://localhost:8083/connectors
```

### Step 4: Stream Transactions & Verify
1. Insert some test data into the `customers` table:
   ```sql
   INSERT INTO customers (customer_id, first_name, last_name, email) 
   VALUES (seq_customer_id.NEXTVAL, 'John', 'Doe', 'john.doe@example.com');
   COMMIT;
   ```
2. Consume from the Kafka topic to verify the event contains the `before` and `after` states:
   ```bash
   docker exec -it kafka kafka-console-consumer.sh \
     --bootstrap-server localhost:9092 \
     --topic oracle.XEPDB1.CUSTOMERS \
     --from-beginning
   ```

---
*Completed successfully when every SQL insert/update on the customers table instantly produces a JSON event message in Kafka.*
