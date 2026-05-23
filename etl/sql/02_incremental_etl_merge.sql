-- ==============================================================================
-- Stage 6: Data Warehousing - Incremental ETL (MERGE)
-- Giai đoạn 6: Kho dữ liệu - Đường ống ETL tăng dần (Upsert)
-- ==============================================================================

MERGE INTO dim_customer target
USING stg_customers source
ON (target.customer_id = source.customer_id)

-- If the customer_id already exists, UPDATE their details
WHEN MATCHED THEN
    UPDATE SET 
        target.full_name = source.full_name,
        target.customer_type = source.customer_type,
        target.updated_at = SYSDATE
    -- Tối ưu: So sánh dùng LNNVL để xử lý cột chứa giá trị NULL chính xác
    WHERE 
        LNNVL(target.full_name = source.full_name)
        OR LNNVL(target.customer_type = source.customer_type)

-- If the customer_id does NOT exist, INSERT them as a new record
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
