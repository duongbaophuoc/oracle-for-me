# Lab 08: Wait Events & Active Session History (ASH) Diagnostics
# Bài Lab 08: Phân tích Sự kiện Chờ & Chẩn đoán qua Lịch sử Phiên Hoạt động (ASH)

## Objective (Mục tiêu)
Investigate transient database performance degradation (micro-bottlenecks) in real time using Active Session History (ASH) views to pinpoint the exact session, SQL ID, and lock blocking production users.
*(Điều tra tình trạng suy giảm hiệu năng tạm thời trong thời gian thực bằng cách sử dụng các góc nhìn ASH để xác định chính xác phiên (session), SQL ID và khóa (lock) gây nghẽn cho người dùng).*

## Scenario (Kịch bản)
Users report the application slows down sporadically. Because the issue is transient (lasting only 1-2 minutes), typical hourly AWR reports smooth out the spikes, making them invisible. You must use the second-by-second Active Session History buffer to diagnose the root cause.
*(Người dùng báo ứng dụng bị chậm ngắt quãng. Vì sự cố diễn ra rất nhanh (chỉ 1-2 phút), các báo cáo AWR theo giờ thông thường sẽ làm phẳng các đỉnh nhọn khiến chúng vô hình. Bạn phải dùng ASH (lưu vết theo từng giây) để tìm nguyên nhân).*

## Step-by-Step Instructions (Hướng dẫn từng bước)

### Step 1: Simulate Lock Contention (Create a Transient Spike)
1. In Terminal 1, start a transaction and hold a lock without committing:
   ```sql
   UPDATE accounts SET balance = balance + 100 WHERE account_id = 42;
   -- Do NOT commit!
   ```
2. In Terminal 2, Terminal 3, and Terminal 4, try updating the same account row:
   ```sql
   UPDATE accounts SET balance = balance + 50 WHERE account_id = 42;
   ```
   *These sessions will hang, waiting for the lock to be released.*

### Step 2: Query ASH for Active Wait Events
1. In Terminal 5, run a diagnostic query on `V$ACTIVE_SESSION_HISTORY` to see what is currently happening:
   ```sql
   SELECT event, count(*) 
   FROM v$active_session_history 
   WHERE sample_time > SYSDATE - INTERVAL '5' MINUTE
   GROUP BY event
   ORDER BY count(*) DESC;
   ```
2. You should see `enq: TX - row lock contention` as the top wait event.

### Step 3: Identify the Blocker Session and SQL ID
Run a detailed query to trace the blocked sessions, the SQL ID they are executing, and the blocking session ID:
```sql
SELECT session_id, sql_id, blocking_session, blocking_session_serial#, machine, program 
FROM v$active_session_history 
WHERE event = 'enq: TX - row lock contention'
  AND sample_time > SYSDATE - INTERVAL '5' MINUTE;
```

### Step 4: Resolve the Bottleneck
1. Find the blocking session SID (e.g. `142`) and terminate it cleanly to resolve the contention (refer to `scripts/03_kill_inactive_sessions.sql`):
   ```sql
   ALTER SYSTEM KILL SESSION '142,5678' IMMEDIATE;
   ```
2. Confirm that the waiting sessions immediately resume execution.

---
*Completed successfully when the root cause session is identified via ASH and the blocking wait event is eliminated.*
