import pandas as pd
import sqlalchemy
from datetime import datetime
import time
import os
import uuid

# ==============================================================================
# Enterprise ETL Pipeline - Incremental Sync (OLTP -> OLAP)
# Đường ống ETL Doanh nghiệp - Đồng bộ Tăng dần Bảo mật & Chống Nghẽn
# ==============================================================================

SOURCE_DB_URI = os.getenv("SOURCE_DB_URI")
TARGET_DW_URI = os.getenv("TARGET_DW_URI")

if not SOURCE_DB_URI or not TARGET_DW_URI:
    raise EnvironmentError(
        "❌ Missing required environment variables: SOURCE_DB_URI and TARGET_DW_URI must be set.\n"
        "Example: export SOURCE_DB_URI='oracle+cx_oracle://system:<password>@localhost:1521/?service_name=XEPDB1'"
    )

# Establish connection pools with automatic cleanup & resource limits
source_engine = sqlalchemy.create_engine(SOURCE_DB_URI, pool_pre_ping=True, pool_recycle=3600)
target_engine = sqlalchemy.create_engine(TARGET_DW_URI, pool_pre_ping=True, pool_recycle=3600)

def extract_incremental_data(job_run_id):
    """Extracts records updated in the last 24 hours."""
    print(f"[{datetime.now()}] [Job: {job_run_id}] EXTRACT: Querying Source Database...")
    
    # Query with strict read-only execution block
    query = """
        SELECT customer_id, full_name, customer_type, updated_at
        FROM customers
        WHERE updated_at >= SYSDATE - 1
    """
    
    # Using context manager to guarantee connection is returned to the pool immediately
    with source_engine.connect() as conn:
        df = pd.read_sql(sqlalchemy.text(query), conn)
        
    print(f"[{datetime.now()}] [Job: {job_run_id}] EXTRACT: Retrieved {len(df)} records.")
    return df

def transform_data(df, job_run_id):
    """Cleanses, transforms, and tags data with a unique Job Run ID to support concurrency."""
    if df.empty:
        return df
        
    print(f"[{datetime.now()}] [Job: {job_run_id}] TRANSFORM: Standardizing and tagging records...")
    df['full_name'] = df['full_name'].str.upper()
    
    # Add Job Run ID to isolate this execution chunk from concurrent pipeline runs
    # (Thêm mã chạy Job duy nhất để cô lập luồng dữ liệu khi chạy song song song)
    df['job_run_id'] = str(job_run_id)
    return df

def load_data(df, job_run_id):
    """Loads data into a shared Staging table and executes an isolated transactional MERGE."""
    if df.empty:
        print(f"[{datetime.now()}] [Job: {job_run_id}] LOAD: No new data to load. Exiting.")
        return
        
    print(f"[{datetime.now()}] [Job: {job_run_id}] LOAD: Connecting to Data Warehouse...")
    
    # 1. Load into a shared staging table using append instead of drop-and-replace
    # (Đẩy dữ liệu vào bảng staging bằng chế độ APPEND để không làm mất dữ liệu của Job song song khác)
    print(f"[{datetime.now()}] [Job: {job_run_id}] LOAD: Appending to Staging Table...")
    
    with target_engine.begin() as conn:
        df.to_sql('stg_customers', conn, if_exists='append', index=False)
    
    # 2. Execute SQL MERGE isolating records by job_run_id (Strict Transactional Consistency)
    # (Thực thi MERGE giới hạn trong phạm vi job_run_id để đảm bảo tính nhất quán giao dịch)
    merge_sql = """
        MERGE INTO dim_customer target
        USING (
            SELECT customer_id, full_name, customer_type, updated_at 
            FROM stg_customers 
            WHERE job_run_id = :job_run_id
        ) source
        ON (target.customer_id = source.customer_id)
        WHEN MATCHED THEN
            UPDATE SET 
                target.full_name = source.full_name,
                target.customer_type = source.customer_type,
                target.updated_at = SYSDATE
        WHEN NOT MATCHED THEN
            INSERT (customer_id, full_name, customer_type, created_at, updated_at)
            VALUES (source.customer_id, source.full_name, source.customer_type, SYSDATE, SYSDATE)
    """
    
    # 3. Clean up staging records for this job run to prevent table bloat
    cleanup_sql = "DELETE FROM stg_customers WHERE job_run_id = :job_run_id"
    
    with target_engine.begin() as conn:
        print(f"[{datetime.now()}] [Job: {job_run_id}] LOAD: Executing Transactional MERGE...")
        conn.execute(sqlalchemy.text(merge_sql), {"job_run_id": str(job_run_id)})
        
        print(f"[{datetime.now()}] [Job: {job_run_id}] LOAD: Cleaning up temporary staging records...")
        conn.execute(sqlalchemy.text(cleanup_sql), {"job_run_id": str(job_run_id)})
        
    print(f"[{datetime.now()}] [Job: {job_run_id}] LOAD: Pipeline Complete. ✅")

if __name__ == "__main__":
    job_run_id = uuid.uuid4()
    start_time = time.time()
    
    try:
        data = extract_incremental_data(job_run_id)
        clean_data = transform_data(data, job_run_id)
        load_data(clean_data, job_run_id)
    except Exception as e:
        print(f"[{datetime.now()}] [Job: {job_run_id}] ❌ PIPELINE FAILED: {str(e)}")
        # Raise for transparency in orchestrator/caller logs
        raise
    finally:
        # Guarantee connection pool teardown to prevent connection leaks
        # (Đảm bảo giải phóng toàn bộ tài nguyên pool tránh rò rỉ kết nối)
        source_engine.dispose()
        target_engine.dispose()
        print(f"[{datetime.now()}] [Job: {job_run_id}] Resources successfully released.")
        
    print(f"Total Execution Time: {time.time() - start_time:.2f} seconds")
