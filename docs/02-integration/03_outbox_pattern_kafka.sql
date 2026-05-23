-- ==============================================================================
-- Stage 2: Application Integration - Outbox Pattern for Kafka
-- Giai đoạn 2: Tích hợp Ứng dụng - Mẫu Outbox để đồng bộ dữ liệu sang Kafka
-- ==============================================================================

-- Problem: An application needs to update Oracle AND send an event to Kafka.
-- If Oracle commits but Kafka is down, data is inconsistent.
-- If Kafka receives the event but Oracle rolls back, data is inconsistent.
-- (Vấn đề: Ứng dụng cần cập nhật Oracle VÀ gửi sự kiện tới Kafka.
-- Nếu Oracle xác nhận nhưng Kafka sập, dữ liệu mất đồng bộ.
-- Nếu Kafka nhận sự kiện nhưng Oracle hoàn tác, dữ liệu cũng mất đồng bộ.)

-- Solution: The Transactional Outbox Pattern
-- (Giải pháp: Mẫu Outbox Giao dịch)
-- The application writes to the business table AND the outbox table in the SAME Oracle transaction.
-- A separate process (like Oracle GoldenGate or Debezium CDC) reads the outbox table and pushes to Kafka.

-- 1. Create the Outbox Table
-- (Tạo bảng Outbox)
CREATE TABLE enterprise_outbox (
    event_id        VARCHAR2(36) NOT NULL, -- UUID
    aggregate_type  VARCHAR2(50) NOT NULL, -- e.g., 'Customer', 'Account'
    aggregate_id    VARCHAR2(50) NOT NULL, -- The ID of the modified entity
    event_type      VARCHAR2(50) NOT NULL, -- e.g., 'CustomerCreated', 'FundsTransferred'
    payload         CLOB NOT NULL,         -- JSON payload of the event
    created_at      TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    --
    CONSTRAINT pk_outbox PRIMARY KEY (event_id)
)
-- Using a KEEP pool or specific tablespace if this table gets very high throughput
-- (Dùng KEEP pool nếu bảng này có lưu lượng truy xuất cực cao)
PCTFREE 5;

-- 2. PL/SQL Procedure for creating a customer AND emitting an event safely
-- (Thủ tục PL/SQL để tạo khách hàng VÀ phát ra sự kiện một cách an toàn)

CREATE OR REPLACE PROCEDURE create_customer_with_event (
    p_full_name     IN VARCHAR2,
    p_national_id   IN VARCHAR2
) IS
    v_new_customer_id NUMBER;
    v_event_id        VARCHAR2(36);
    v_json_payload    CLOB;
BEGIN
    -- 1. Generate IDs (Sinh ID)
    v_event_id := SYS_GUID(); -- Oracle's UUID equivalent

    -- 2. Insert into the main business table (Chèn vào bảng nghiệp vụ chính)
    INSERT INTO customers (full_name, national_id, customer_type)
    VALUES (p_full_name, p_national_id, 'RETAIL')
    RETURNING customer_id INTO v_new_customer_id;

    -- 3. Construct JSON Payload (Xây dựng chuỗi JSON)
    v_json_payload := '{ "customerId": ' || v_new_customer_id || 
                      ', "fullName": "' || p_full_name || 
                      '", "nationalId": "' || p_national_id || '" }';

    -- 4. Insert into Outbox Table in the SAME TRANSACTION
    -- (Chèn vào bảng Outbox trong CÙNG MỘT GIAO DỊCH)
    INSERT INTO enterprise_outbox (event_id, aggregate_type, aggregate_id, event_type, payload)
    VALUES (v_event_id, 'Customer', TO_CHAR(v_new_customer_id), 'CustomerCreated', v_json_payload);

    -- 5. Commit both inserts together. It's atomic. All or nothing.
    -- (Xác nhận cả hai thao tác chèn cùng lúc. Đảm bảo tính nguyên tử - Tất cả hoặc không gì cả.)
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Customer and Event successfully committed.');

EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Failed. Rolled back Customer and Event.');
        RAISE;
END;
/

-- Debezium (Kafka Connect) will now read the Oracle Redo Logs (via LogMiner/XStream),
-- capture the INSERTs to `enterprise_outbox`, and publish them directly to Kafka topics safely.
-- (Debezium sẽ đọc Redo Logs của Oracle, bắt các lệnh INSERT vào bảng outbox, 
-- và xuất bản chúng trực tiếp lên các Kafka topic một cách an toàn.)
