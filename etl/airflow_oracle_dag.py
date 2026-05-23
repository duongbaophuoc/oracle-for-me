from airflow import DAG
from airflow.providers.oracle.operators.oracle import OracleOperator
from datetime import datetime, timedelta
import os

# Best Practice: Avoid reading files at the top-level of the DAG file.
# The Airflow scheduler parses this file every few seconds, and top-level filesystem I/O
# causes massive performance degradation on the scheduler loop.
# Solution: Use Airflow's native 'template_searchpath' to delegate file I/O to the worker at run time.
#
# (Kinh nghiệm thực tế: Tránh đọc tệp ở cấp độ top-level của file DAG. 
# Trình lập lịch Airflow parse file này liên tục, I/O đĩa sẽ gây nghẽn hiệu năng nghiêm trọng.
# Giải pháp: Sử dụng 'template_searchpath' của Airflow để trì hoãn việc đọc tệp cho Worker khi chạy).

DAG_FOLDER = os.path.dirname(os.path.abspath(__file__))
SQL_DIR = os.path.join(DAG_FOLDER, 'sql')

default_args = {
    'owner': 'data_eng',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

with DAG(
    'oracle_enterprise_etl',
    default_args=default_args,
    schedule_interval='@daily',
    # Registers the SQL directory so Airflow can resolve files automatically
    # (Đăng ký thư mục SQL để Airflow tự động phân giải tệp tin khi thực thi)
    template_searchpath=[SQL_DIR], 
) as dag:

    incremental_upsert = OracleOperator(
        task_id='upsert_sales_fact',
        oracle_conn_id='oracle_production',
        # Passed as a relative file name; parsed lazily by Airflow worker at execution
        # (Chỉ truyền tên tệp; việc đọc tệp được thực hiện trễ bởi Worker khi task chạy)
        sql='02_incremental_etl_merge.sql', 
        autocommit=True
    )