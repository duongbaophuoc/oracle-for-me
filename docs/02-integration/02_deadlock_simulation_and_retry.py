# ==============================================================================
# Stage 2: Application Integration - Deadlock Handling & Retry Pattern
# Giai đoạn 2: Tích hợp Ứng dụng - Xử lý Deadlock & Mẫu Thử lại
# ==============================================================================

import time
import random

# Try importing the real oracledb library. If it fails, fallback to a robust mock exception structure
# so the script runs flawlessly out of the box for study without external driver dependencies.
# (Thử import thư viện oracledb. Nếu thất bại, tự động chuyển sang cơ chế giả lập cấu trúc lỗi
# để script chạy độc lập phục vụ học tập mà không cần cài đặt driver bên ngoài).
try:
    import oracledb
except ImportError:
    class MockOracleError(Exception):
        pass
        
    class MockDatabaseError(MockOracleError):
        def __init__(self, error_obj):
            super().__init__(error_obj)
            # Mimics real driver where e.args[0] is the error details object
            self.args = (error_obj,)
            
    class oracledb:
        DatabaseError = MockDatabaseError

class MockErrorDetails:
    def __init__(self, code, message):
        self.code = code
        self.message = message
    def __str__(self):
        return self.message

class MockConnection:
    def rollback(self):
        print("[SYSTEM] conn.rollback() executed. All row locks released successfully.")
    def commit(self):
        print("[SYSTEM] Transaction committed.")
    def cursor(self):
        return MockCursor()

class MockCursor:
    def execute(self, sql, params=None):
        pass

def execute_transfer_with_retry(from_acc, to_acc, amount, max_retries=3):
    """
    Executes a database transfer with Exponential Backoff + Jitter for Deadlocks.
    (Thực thi chuyển tiền với cơ chế lùi thời gian theo cấp số nhân + Jitter cho Deadlock.)
    """
    attempt = 0
    conn = MockConnection()
    cursor = conn.cursor()
    
    while attempt < max_retries:
        try:
            print(f"[Attempt {attempt + 1}] Starting transfer from {from_acc} to {to_acc}...")
            
            # Application Logic:
            # 1. cursor.execute("UPDATE accounts SET balance = balance - :amount WHERE account_id = :from_acc", ...)
            # 2. cursor.execute("UPDATE accounts SET balance = balance + :amount WHERE account_id = :to_acc", ...)
            
            # Simulating an ORA-00060 exception randomly for demonstration (70% failure rate)
            if random.random() < 0.7:  
                # Build mock error detail containing code 60 and trigger exception
                mock_error = MockErrorDetails(
                    code=60, 
                    message="ORA-00060: deadlock detected while waiting for resource"
                )
                raise oracledb.DatabaseError(mock_error)
                
            conn.commit()
            print("Transfer successful! Transaction committed.\n")
            return True # Success
            
        except oracledb.DatabaseError as e:
            # Safely unpack the error object from the first element of args
            # (Giải nén đối tượng lỗi từ args để đối chiếu mã lỗi)
            error_obj, = e.args
            
            # Compare directly against integer error code 60 (ORA-00060) which is bulletproof
            if hasattr(error_obj, 'code') and error_obj.code == 60:
                print(f"[Warning] Deadlock (ORA-00060) detected on attempt {attempt + 1}.")
                
                # Executing the rollback is CRITICAL before retrying to release existing locks.
                # Wrap in internal try-except block to handle case where connection is lost
                # during transaction rollback.
                #
                # (Thực thi rollback để giải phóng khóa. Bọc trong try-except phòng trường hợp
                # kết nối mạng bị đứt trong lúc rollback gây đổ vỡ chương trình).
                try:
                    conn.rollback() 
                except Exception as rollback_err:
                    print(f"[Fatal Warning] conn.rollback() failed: {rollback_err}. Connection may be broken.")
                
                attempt += 1
                if attempt >= max_retries:
                    print("[Error] Max retries reached. Transfer failed permanently.\n")
                    return False
                    
                # Exponential Backoff with Jitter (Lùi thời gian cấp số nhân có độ lệch)
                sleep_time = (2 ** attempt) + random.uniform(0, 1)
                print(f"Sleeping for {sleep_time:.2f} seconds before retrying...\n")
                time.sleep(sleep_time)
                
            else:
                try:
                    conn.rollback()
                except Exception as rollback_err:
                    pass
                print(f"[Fatal] Unexpected Database Error: {e}")
                raise
                
    return False

# Run the simulation
if __name__ == "__main__":
    execute_transfer_with_retry(from_acc=101, to_acc=202, amount=500.00)
