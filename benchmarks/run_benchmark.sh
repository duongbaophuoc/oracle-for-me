#!/bin/bash
# ==============================================================================
# Benchmark Script: Simulating High Concurrency safely using SLOB concepts
# Kịch bản Benchmark: Giả lập đồng thời cao và kiểm soát tài nguyên an toàn
# ==============================================================================

DB_USER="${ORACLE_USER}"
DB_PASS="${ORACLE_PASS}"
DB_URL="${ORACLE_URL:-localhost:1521/XEPDB1}"

# Safe default for threads to prevent freezing low-resource sandboxes
THREADS="${ORACLE_THREADS:-5}" 
DURATION="${ORACLE_DURATION:-300}" # 5 minutes default

# 1. Require credentials to prevent hardcoded credential exposure
if [ -z "$DB_USER" ] || [ -z "$DB_PASS" ]; then
    echo "❌ ERROR: ORACLE_USER and ORACLE_PASS environment variables must be set." >&2
    echo "Usage: export ORACLE_USER='username' && export ORACLE_PASS='pass' && $0" >&2
    exit 1
fi

# REGISTER TRAP FOR CLEANUP: Protect against Zombie processes
# If user cancels with Ctrl+C (SIGINT) or the process receives SIGTERM, 
# this block immediately terminates all background sqlplus threads.
#
# (ĐĂNG KÝ BẪY TRAP ĐỂ DỌN DẸP TIẾN TRÌNH CON: Tránh lỗi Zombie Process.
# Nếu người dùng nhấn Ctrl+C hoặc gửi tín hiệu dừng, tiến trình con sẽ bị hủy lập tức).
trap 'echo -e "\n⚠️ Termination signal received. Purging background benchmark threads..."; kill $(jobs -p) 2>/dev/null; exit 1' SIGINT SIGTERM

echo "========================================================="
echo "🚀 Starting Oracle Concurrency Benchmark (OLTP)"
echo "Target: $DB_URL"
echo "Threads: $THREADS | Duration: $DURATION seconds"
echo "========================================================="

# 2. Connection Pre-check (Kiểm tra kết nối ban đầu)
echo "Verifying database connectivity before launching benchmark..."
CONN_TEST=$(sqlplus -L -S "$DB_USER/$DB_PASS@$DB_URL" <<EOF
SET PAGESIZE 0 FEEDBACK OFF;
SELECT 'CONNECTED_OK' FROM dual;
exit;
EOF
)

if [[ ! "$CONN_TEST" =~ "CONNECTED_OK" ]]; then
    echo "❌ ERROR: Database connection failed. Aborting benchmark run for safety." >&2
    echo "Reason: $CONN_TEST" >&2
    exit 1
fi
echo "✅ Connection verified successfully. Initiating benchmark..."

# 3. Thread Ramp-up & Execution with Throttling
for ((i=1; i<=$THREADS; i++))
do
  echo "Spawning Thread #$i..."
  (
    sqlplus -s "$DB_USER/$DB_PASS@$DB_URL" <<EOF
      WHENEVER SQLERROR EXIT 1;
      SET FEEDBACK OFF;
      SET TERMOUT OFF;
      SET PAGESIZE 0;
      DECLARE
         v_acc_id NUMBER;
         v_end_time TIMESTAMP := SYSTIMESTAMP + INTERVAL '$DURATION' SECOND;
      BEGIN
         WHILE SYSTIMESTAMP < v_end_time LOOP
            v_acc_id := TRUNC(DBMS_RANDOM.VALUE(1, 100000));
            -- Simulate small OLTP update
            UPDATE accounts SET balance = balance + 1 WHERE account_id = v_acc_id;
            COMMIT;
         END LOOP;
      END;
/
EOF
  ) &
  
  # Stagger process spawns by 200ms to throttle CPU burst
  sleep 0.2
done

echo "========================================================="
echo "Waiting for $THREADS threads to finish workload..."
echo "========================================================="
wait
echo "✅ Benchmark Completed. Check AWR reports for wait events."
