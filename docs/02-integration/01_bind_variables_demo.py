# ==============================================================================
# Stage 2: Application Integration - Bind Variables vs Hard Parsing
# Giai đoạn 2: Tích hợp Ứng dụng - Biến liên kết vs Phân tích cứng
# ==============================================================================

# This Python script (using oracledb) demonstrates why Bind Variables are the 
# absolute most important concept for Oracle performance and scalability.
# (Kịch bản Python này chứng minh tại sao Biến liên kết là khái niệm quan trọng 
# bậc nhất đối với hiệu năng và khả năng mở rộng của Oracle.)

import oracledb
import time

# Connection details (Thông tin kết nối)
# dsn = oracledb.makedsn("localhost", 1521, service_name="XEPDB1")
# connection = oracledb.connect(user="system", password="secret", dsn=dsn)

def run_without_bind_variables(cursor, iterations=10000):
    """
    WARNING: THIS IS HOW YOU CRASH AN ORACLE DATABASE.
    (CẢNH BÁO: ĐÂY LÀ CÁCH BẠN LÀM SẬP CƠ SỞ DỮ LIỆU ORACLE).
    
    Every query is unique because the literal value is concatenated into the string.
    Oracle has to perform a "Hard Parse" for every single query:
    1. Check syntax
    2. Check semantics (tables, columns, permissions)
    3. Generate execution plan
    This destroys the Shared Pool and burns CPU.
    """
    print(f"Running {iterations} inserts WITHOUT bind variables (Hard Parsing)...")
    start_time = time.time()
    
    for i in range(iterations):
        # BAD PRACTICE: Concatenating values directly into the SQL string
        # (THỰC HÀNH XẤU: Nối trực tiếp giá trị vào chuỗi SQL)
        sql = f"INSERT INTO test_binds (id, val) VALUES ({i}, 'Data_{i}')"
        cursor.execute(sql)
        
    end_time = time.time()
    print(f"Time taken WITHOUT bind variables: {end_time - start_time:.2f} seconds\n")

def run_with_bind_variables(cursor, iterations=10000):
    """
    BEST PRACTICE: USING BIND VARIABLES.
    (THỰC HÀNH TỐT NHẤT: SỬ DỤNG BIẾN LIÊN KẾT).
    
    The SQL string is identical every time ("... VALUES (:1, :2)").
    Oracle performs a "Hard Parse" exactly ONCE. 
    The next 9,999 times, it does a "Soft Parse", instantly reusing the execution plan.
    """
    print(f"Running {iterations} inserts WITH bind variables (Soft Parsing)...")
    start_time = time.time()
    
    # GOOD PRACTICE: Using :1, :2 (or named binds like :id, :val)
    # (THỰC HÀNH TỐT: Sử dụng :1, :2 hoặc tên biến như :id, :val)
    sql = "INSERT INTO test_binds (id, val) VALUES (:1, :2)"
    
    for i in range(iterations):
        cursor.execute(sql, (i, f'Data_{i}'))
        
    end_time = time.time()
    print(f"Time taken WITH bind variables: {end_time - start_time:.2f} seconds\n")

def run_bulk_bind_variables(cursor, iterations=10000):
    """
    ULTIMATE PRACTICE: EXECUTEMANY (Bulk Binding).
    (THỰC HÀNH TỐI THƯỢNG: EXECUTEMANY - Nạp hàng loạt).
    
    Instead of sending 10,000 separate network requests, we send 1 array 
    over the network and Oracle processes it in bulk.
    """
    print(f"Running {iterations} inserts with BULK BINDING (executemany)...")
    start_time = time.time()
    
    sql = "INSERT INTO test_binds (id, val) VALUES (:1, :2)"
    # Prepare an array of data
    data = [(i, f'Data_{i}') for i in range(iterations)]
    
    # Send all at once (Gửi tất cả cùng một lúc)
    cursor.executemany(sql, data)
        
    end_time = time.time()
    print(f"Time taken with BULK BINDING: {end_time - start_time:.4f} seconds\n")

# Execution flow:
# 1. Without Binds: ~15 seconds (High CPU usage)
# 2. With Binds: ~2 seconds (Low CPU usage)
# 3. Bulk Binds: ~0.05 seconds (Minimal network IO)
