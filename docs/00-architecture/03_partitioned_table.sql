-- ==============================================================================
-- Stage 0: Relational Architecture - Partition-aware Design
-- Giai đoạn 0: Kiến trúc Quan hệ - Thiết kế nhận biết Phân vùng
-- ==============================================================================

-- In enterprise systems, tables can reach billions of rows. 
-- Oracle Partitioning allows breaking down a large table into smaller, manageable pieces physically, 
-- while keeping it as one logical table.
-- (Trong các hệ thống doanh nghiệp, bảng có thể đạt hàng tỷ hàng. 
-- Phân vùng của Oracle cho phép chia nhỏ một bảng lớn thành các phần vật lý dễ quản lý hơn, 
-- trong khi vẫn giữ nó là một bảng logic duy nhất.)

CREATE TABLE enterprise_transactions (
    transaction_id      NUMBER NOT NULL,
    account_id          NUMBER NOT NULL,
    amount              NUMBER(18,4) NOT NULL,
    transaction_type    VARCHAR2(20) NOT NULL,
    transaction_date    DATE NOT NULL
)
-- RANGE PARTITIONING based on transaction_date
-- (PHÂN VÙNG THEO KHOẢNG dựa trên ngày giao dịch)
PARTITION BY RANGE (transaction_date)
-- We also subpartition by HASH on account_id to distribute IO evenly across disks
-- (Chúng ta cũng chia phân vùng phụ theo mã BĂM trên account_id để phân phối IO đều khắp các ổ đĩa)
SUBPARTITION BY HASH (account_id) SUBPARTITIONS 4
(
    PARTITION tx_2023_q1 VALUES LESS THAN (TO_DATE('2023-04-01', 'YYYY-MM-DD')),
    PARTITION tx_2023_q2 VALUES LESS THAN (TO_DATE('2023-07-01', 'YYYY-MM-DD')),
    PARTITION tx_2023_q3 VALUES LESS THAN (TO_DATE('2023-10-01', 'YYYY-MM-DD')),
    PARTITION tx_2023_q4 VALUES LESS THAN (TO_DATE('2024-01-01', 'YYYY-MM-DD')),
    PARTITION tx_2024_q1 VALUES LESS THAN (TO_DATE('2024-04-01', 'YYYY-MM-DD')),
    
    -- Future partitions can be automatically created using INTERVAL partitioning (Oracle 11g+)
    -- (Các phân vùng tương lai có thể tự động được tạo nhờ kỹ thuật INTERVAL)
    PARTITION tx_future VALUES LESS THAN (MAXVALUE) 
);

-- Local Partitioned Index
-- (Chỉ mục phân vùng cục bộ)
-- An index that is partitioned exactly the same way as the underlying table.
-- If we drop an old partition, the local index drops with it instantly.
-- (Chỉ mục được phân vùng giống hệt như bảng gốc. Nếu ta xóa một phân vùng cũ, chỉ mục của nó cũng bị xóa ngay lập tức).
CREATE INDEX idx_ent_tx_date ON enterprise_transactions(transaction_date) LOCAL;
CREATE INDEX idx_ent_tx_acc ON enterprise_transactions(account_id) LOCAL;

-- Why is Partitioning critical? (Tại sao Phân vùng lại cực kỳ quan trọng?)
-- 1. Partition Pruning: "SELECT * FROM enterprise_transactions WHERE transaction_date = '2023-05-15'" 
--    Oracle will ONLY scan the `tx_2023_q2` partition. It ignores all others.
--    (Oracle sẽ CHỈ quét phân vùng `tx_2023_q2`. Nó bỏ qua tất cả các phân vùng khác.)
-- 2. Lifecycle Management: Archiving old data is as simple as "ALTER TABLE ... DROP PARTITION tx_2023_q1" (Takes 1 second).
--    (Lưu trữ dữ liệu cũ chỉ bằng 1 lệnh DROP PARTITION diễn ra trong 1 giây).
