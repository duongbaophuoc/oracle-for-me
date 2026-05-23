-- ==============================================================================
-- Utility Script: Gather Schema Statistics for Cost-Based Optimizer
-- Tập lệnh Tiện ích: Thu thập thống kê Lược đồ cho Bộ tối ưu hóa
-- ==============================================================================

-- DBA utility script to aggressively gather statistics on core schemas
-- to ensure the CBO always has the most accurate execution plans.
-- (Tập lệnh DBA để thu thập số liệu thống kê liên tục trên các lược đồ lõi 
-- giúp CBO luôn chọn được đường dẫn thực thi tốt nhất).

SET SERVEROUTPUT ON;

DECLARE
    v_schema_name VARCHAR2(30) := 'ENTERPRISE_CORE_DB';
BEGIN
    DBMS_OUTPUT.PUT_LINE('Starting Statistics Gathering for schema: ' || v_schema_name);
    
    -- Gathers stats for all tables, indexes, and partitions in the schema
    DBMS_STATS.GATHER_SCHEMA_STATS(
        ownname          => v_schema_name,
        
        -- Let Oracle decide how much data to sample for the best accuracy/performance tradeoff
        estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
        
        -- Gather stats for Tables, Indexes, and Columns
        cascade          => TRUE,
        
        -- Automatically generate Histograms for columns that are heavily queried and skewed
        method_opt       => 'FOR ALL COLUMNS SIZE AUTO',
        
        -- Parallelize the gathering process using 4 CPU threads
        degree           => 4
    );
    
    DBMS_OUTPUT.PUT_LINE('Statistics Gathering Completed Successfully.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error gathering stats: ' || SQLERRM);
END;
/
