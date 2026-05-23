-- ==============================================================================
-- Stage 3: Oracle Internals - Physical Storage & DBMS_ROWID
-- Giai đoạn 3: Cấu trúc bên trong - Lưu trữ Vật lý & DBMS_ROWID
-- ==============================================================================

-- A ROWID in Oracle is a Base64 encoded string that represents the exact physical 
-- address of a row on the hard drive. 
-- (ROWID trong Oracle là chuỗi Base64 biểu thị địa chỉ vật lý chính xác của một hàng trên ổ đĩa.)

-- Format: OOOOOOFFFBBBBBBRRR
-- OOOOOO: Data Object Number (Mã đối tượng dữ liệu)
-- FFF: Tablespace-relative Datafile Number (Mã Tệp dữ liệu)
-- BBBBBB: Block Number (Mã Khối)
-- RRR: Row Number within the block (Số thứ tự Hàng trong khối)

SELECT 
    rowid AS exact_physical_address,
    customer_id,
    full_name,
    DBMS_ROWID.ROWID_OBJECT(rowid) AS object_id,
    DBMS_ROWID.ROWID_RELATIVE_FNO(rowid) AS file_number,
    DBMS_ROWID.ROWID_BLOCK_NUMBER(rowid) AS block_number,
    DBMS_ROWID.ROWID_ROW_NUMBER(rowid) AS row_number
FROM 
    customers
WHERE 
    ROWNUM <= 5;
    
-- Why is this important? (Tại sao lại quan trọng?)
-- If you experience "buffer busy waits", you can check which exact block is "hot".
-- If you have block corruption (ORA-01578), you use DBMS_ROWID to map the corrupt physical block 
-- back to the specific rows in the table.
-- (Nếu bị lỗi hỏng khối đĩa ORA-01578, bạn dùng DBMS_ROWID để map khối vật lý bị hỏng ngược lại thành các hàng cụ thể trong bảng.)
