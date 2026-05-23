# 🟡 Stage 2 — Application Integration & SQL Engineering
# Giai đoạn 2 — Tích hợp Ứng dụng & Kỹ thuật SQL

Once the database foundation is built, the next critical step is ensuring enterprise applications can interact with Oracle securely, efficiently, and with high concurrency.
*Sau khi nền tảng cơ sở dữ liệu được xây dựng, bước quan trọng tiếp theo là đảm bảo các ứng dụng doanh nghiệp có thể tương tác với Oracle một cách an toàn, hiệu quả và có khả năng đồng thời cao.*

---

## 1. Query Engineering & Optimizer Guidance (Kỹ thuật Truy vấn & Hướng dẫn Tối ưu hóa)

Enterprise databases execute millions of queries per second. How an application sends those queries dictates whether the system scales or crashes.
*Các CSDL doanh nghiệp thực thi hàng triệu truy vấn mỗi giây. Cách một ứng dụng gửi các truy vấn đó quyết định hệ thống sẽ mở rộng tốt hay bị sụp đổ.*

### Bind Variables (Biến Liên kết)
- **The #1 cause of Oracle performance issues** is not using bind variables.
  *(Nguyên nhân số 1 gây ra các vấn đề về hiệu suất Oracle là không sử dụng biến liên kết.)*
- Without bind variables (`SELECT * FROM users WHERE id = 123`), Oracle must parse every query from scratch (Hard Parse), destroying the CPU and Shared Pool.
  *(Thiếu biến liên kết, Oracle phải phân tích lại mọi truy vấn từ đầu (Hard Parse), làm hủy hoại CPU và vùng nhớ Shared Pool.)*
- With bind variables (`SELECT * FROM users WHERE id = :id`), Oracle parses once (Soft Parse) and reuses the execution plan.
  *(Với biến liên kết, Oracle chỉ phân tích 1 lần và tái sử dụng kế hoạch thực thi.)*

### Cursor Sharing & Pagination (Chia sẻ Cursor & Phân trang)
- **Pagination (Phân trang):** Using `OFFSET ... FETCH NEXT` (Oracle 12c+) to paginate results cleanly at the database level rather than fetching millions of rows to the application memory.
  *(Sử dụng OFFSET... FETCH NEXT để phân trang gọn gàng tại cấp độ CSDL thay vì kéo hàng triệu dòng về bộ nhớ ứng dụng.)*
- **Batch Processing:** Processing records in batches (e.g., using `JDBC batch updates`) to reduce network overhead.
  *(Xử lý các bản ghi theo lô để giảm chi phí mạng do phải gửi đi gửi lại.)*

---

## 2. Transactions & Concurrency (Giao dịch & Đồng thời)

Oracle operates on **Multi-Version Concurrency Control (MVCC)**. Understanding this is mandatory for backend engineers.
*Oracle vận hành dựa trên Kiểm soát đa phiên bản đồng thời (MVCC). Backend Engineer bắt buộc phải hiểu điều này.*

### ACID & Read Consistency (ACID & Tính nhất quán khi đọc)
- **"Readers do not block writers, and writers do not block readers."**
  *("Người đọc không chặn người ghi, và người ghi không chặn người đọc" - nguyên lý cốt lõi của Oracle.)*
- Oracle uses **Undo Segments** to construct a point-in-time snapshot of the data for any query. If a transaction modifies data, Oracle keeps the old version in the Undo Segment so other users can still read it.
  *(Oracle sử dụng Undo Segment để dựng lại ảnh chụp dữ liệu tại một thời điểm. Nếu có sự thay đổi, bản cũ được giữ ở Undo Segment để người khác vẫn đọc được.)*

### Locking Mechanisms (Cơ chế Khóa)
- **Row-level locking:** Oracle locks data at the lowest possible level (the row), never escalating to table locks for DML operations.
  *(Khóa cấp độ hàng: Oracle khóa ở mức thấp nhất có thể, không bao giờ tự động nâng cấp thành khóa toàn bảng (table lock) cho các thao tác DML.)*
- **Deadlocks (ORA-00060):** Occurs when two sessions hold locks that the other wants. Oracle automatically detects this, kills one statement, and throws an exception. Applications must implement **Retry Patterns** to handle this gracefully.
  *(Xảy ra khi 2 phiên cùng giữ khóa mà bên kia cần. Oracle tự động phát hiện, hủy 1 câu lệnh và ném ra lỗi. Ứng dụng phải có cơ chế Thử lại (Retry Pattern) để xử lý gọn gàng.)*

---

## 3. Enterprise Architecture Patterns (Các Mẫu Kiến trúc Doanh nghiệp)

Modern applications are distributed. Oracle must fit into these ecosystems.
*Ứng dụng hiện đại có tính phân tán. Oracle phải phù hợp với các hệ sinh thái này.*

- **CQRS (Command Query Responsibility Segregation):** Separating read and write operations. You might write to an Oracle OLTP master and read from an Active Data Guard standby.
  *(Phân tách trách nhiệm Đọc/Ghi. Có thể ghi vào Master OLTP và đọc từ cơ sở dữ liệu dự phòng Active Data Guard.)*
- **Idempotency (Tính lũy đẳng):** Designing database operations so that executing them multiple times yields the same result. Crucial for safely retrying failed network calls.
  *(Thiết kế các thao tác sao cho việc thực thi nhiều lần vẫn cho ra cùng một kết quả. Quan trọng để an toàn thử lại khi rớt mạng.)*
- **Distributed Transactions (Giao dịch phân tán - 2PC):** Committing transactions across multiple databases safely using Two-Phase Commit, though modern microservices prefer Sagas or Outbox Patterns.
  *(Giao dịch qua nhiều CSDL dùng Two-Phase Commit, dù Microservices hiện đại thích dùng Saga hoặc Outbox Pattern hơn.)*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. Write a Java (JDBC) or Python (cx_Oracle/oracledb) script to insert 10,000 rows **with** and **without** bind variables. Compare the CPU usage.
   *(Viết mã chèn 10.000 hàng có và không có biến liên kết. So sánh mức sử dụng CPU.)*
2. Simulate a **Deadlock** between two parallel database sessions and write application code to catch `ORA-00060` and retry safely.
   *(Giả lập tình trạng Deadlock giữa 2 phiên chạy song song và viết mã ứng dụng để bắt lỗi ORA-00060 và thử lại an toàn.)*
3. Implement an **Outbox Pattern** table to sync Oracle data to Apache Kafka.
   *(Triển khai bảng Outbox Pattern để đồng bộ dữ liệu Oracle sang Apache Kafka.)*