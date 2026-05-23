-- ==============================================================================
-- Stage 6: Data Warehousing - Incremental ETL (MERGE)
-- Giai đoạn 6: Kho dữ liệu - Đường ống ETL tăng dần (Upsert)
-- ==============================================================================

-- A core task of a Data Engineer is taking data from a "Staging" table
-- (newly extracted data) and inserting/updating it into the final Data Warehouse table.
-- Using MERGE is the most efficient way to achieve this.
-- (Nhiệm vụ cốt lõi của Kỹ sư Dữ liệu là đồng bộ từ bảng Staging vào bảng Kho dữ liệu.
-- Dùng lệnh MERGE là cách tối ưu nhất).

-- Assume `stg_customers` has 10,000 newly updated or created customers from the last hour.
-- Assume `dim_customer` is the main warehouse dimension with 50,000,000 rows.

MERGE INTO dim_customer target
USING stg_customers source
ON (target.customer_id = source.customer_id) -- The matching condition (Khóa nối)

-- If the customer_id already exists, UPDATE their details
-- (Nếu khách hàng đã tồn tại, CẬP NHẬT thông tin của họ)
WHEN MATCHED THEN
    UPDATE SET 
        target.full_name = source.full_name,
        target.customer_type = source.customer_type,
        target.updated_at = SYSDATE
    -- Optimization: Only update if the data actually changed
    -- (Tối ưu: Chỉ cập nhật nếu dữ liệu thực sự có thay đổi để tránh ghi đè thừa)
    WHERE 
        LNNVL(target.full_name = source.full_name)
        OR LNNVL(target.customer_type = source.customer_type)

-- If the customer_id does NOT exist, INSERT them as a new record
-- (Nếu khách hàng chưa tồn tại, CHÈN họ như một bản ghi mới)
WHEN NOT MATCHED THEN
    INSERT (
        customer_id, 
        full_name, 
        customer_type, 
        created_at, 
        updated_at
    )
    VALUES (
        source.customer_id, 
        source.full_name, 
        source.customer_type, 
        SYSDATE, 
        SYSDATE
    );

-- Best Practice for ETL:
-- Wrap this MERGE statement inside a PL/SQL Procedure with Error Logging.
-- (Thực hành tốt: Gói lệnh MERGE này vào một thủ tục PL/SQL kèm theo ghi log lỗi).
-- Oracle provides a feature called "DML Error Logging" (LOG ERRORS INTO err_log) 
-- that prevents the entire MERGE from failing if one row has bad data.
-- (Oracle có tính năng DML Error Logging giúp lệnh MERGE không bị sập toàn bộ nếu chỉ có 1 hàng dữ liệu bị lỗi).
