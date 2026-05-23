# 🔴 Stage 3 — Oracle Internals (Cấu trúc bên trong Oracle)

> To truly master Oracle, you must stop thinking in tables and rows, and start thinking in memory structures and physical disk blocks.
> *Để thực sự làm chủ Oracle, bạn phải ngừng tư duy theo bảng và hàng, mà hãy bắt đầu tư duy theo cấu trúc bộ nhớ và các khối đĩa vật lý.*

---

## 1. Oracle Memory Architecture (Kiến trúc Bộ nhớ Oracle)

An Oracle "Database" is the files on disk. An Oracle "Instance" is the memory and background processes running on the server.
*(Một "Cơ sở dữ liệu" Oracle là các tệp trên đĩa. Một "Phiên bản" Oracle (Instance) là bộ nhớ và các tiến trình nền chạy trên máy chủ.)*

### SGA (System Global Area - Vùng Nhớ Chung Toàn Hệ thống)
Shared memory allocated when the instance starts. All users share this.
*(Bộ nhớ dùng chung được cấp phát khi khởi động instance. Tất cả người dùng đều dùng chung vùng này).*
- **Shared Pool:** Caches parsed SQL statements and execution plans (Library Cache) and data dictionary details (Dictionary Cache). If this is too small, Oracle constantly re-parses queries (Hard Parse).
  *(Lưu trữ các câu lệnh SQL đã được phân tích và kế hoạch thực thi. Nếu vùng này quá nhỏ, Oracle liên tục phải phân tích lại truy vấn).*
- **Database Buffer Cache:** Caches data blocks read from disk. The larger this is, the fewer physical disk reads are needed.
  *(Lưu trữ các khối dữ liệu đọc từ đĩa. Càng lớn, số lần đọc đĩa vật lý càng ít).*
- **Redo Log Buffer:** A tiny, incredibly fast buffer that records changes before they are written to the Redo Log files on disk. Essential for data durability.
  *(Vùng đệm nhỏ, cực nhanh, ghi lại các thay đổi trước khi ghi xuống đĩa. Cực kỳ quan trọng để đảm bảo độ bền dữ liệu).*

### PGA (Program Global Area - Vùng Nhớ Quy trình)
Private memory allocated for each server process (each connected user).
*(Bộ nhớ riêng được cấp phát cho mỗi tiến trình máy chủ - mỗi người dùng kết nối).*
- Used for sorting (`ORDER BY`, `GROUP BY`), hash joins, and session variables.
  *(Dùng để sắp xếp dữ liệu, hash joins và biến phiên).*

---

## 2. Oracle Storage Internals (Cấu trúc Lưu trữ Oracle)

Oracle organizes data logically, which maps to physical files.
*(Oracle tổ chức dữ liệu một cách logic, sau đó ánh xạ vào các tệp vật lý).*

`Database -> Tablespaces -> Segments -> Extents -> Data Blocks`

- **Data Blocks:** The smallest unit of IO (typically 8KB). A row sits inside a block. Oracle reads blocks, not rows.
  *(Đơn vị IO nhỏ nhất, thường là 8KB. Một hàng nằm trong một khối. Oracle đọc khối, không đọc hàng).*
- **Segments:** A table, an index, or a partition is a segment. It is made of multiple Extents.
  *(Một bảng, một chỉ mục, hoặc một phân vùng là một segment).*
- **ASM (Automatic Storage Management):** Oracle's proprietary volume manager and file system. It strips data across multiple disks for maximum IO throughput.
  *(Hệ thống quản lý lưu trữ tự động của Oracle. Nó chia nhỏ dữ liệu qua nhiều ổ đĩa để tối đa hóa lưu lượng IO).*

---

## 3. Redo & Undo Internals (Cấu trúc Redo & Undo)

### Redo Logs (Nhật ký Làm lại)
- Write-Ahead Logging (WAL) architecture. Every change is written to the Redo Log Buffer, and then written to the physical Redo Log Files sequentially.
  *(Mọi thay đổi được ghi vào Redo Buffer, sau đó ghi tuần tự xuống file vật lý).*
- **Purpose:** Recovery. If the server crashes, Oracle replays the Redo Logs to reconstruct committed data.
  *(Mục đích: Khôi phục. Nếu máy chủ sập, Oracle chạy lại Redo Logs để tái tạo dữ liệu).*

### Undo Segments (Phân đoạn Hoàn tác)
- When data is updated, the *old* version of the block is written to the Undo Segment.
  *(Khi dữ liệu bị cập nhật, phiên bản cũ được ghi vào Undo Segment).*
- **Purpose 1:** Rollback (Hoàn tác giao dịch nếu có lỗi).
- **Purpose 2:** Read Consistency (Tính nhất quán khi đọc). A long-running query will read the old data from Undo if another session changes it mid-query.
  *(Tính nhất quán khi đọc. Truy vấn chạy lâu sẽ đọc dữ liệu cũ từ Undo nếu phiên khác thay đổi dữ liệu đó).*
- **Purpose 3:** Flashback (Querying data "as of" 2 hours ago).
  *(Truy vấn dữ liệu "tại thời điểm" cách đây 2 giờ).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. Write a script to query `V$SGASTAT` and `V$PGASTAT` to analyze the current memory footprint of the Oracle instance.
   *(Viết script truy vấn `V$SGASTAT` và `V$PGASTAT` để phân tích dấu chân bộ nhớ hiện tại của instance).*
2. Inspect the block structure of a table using `DBMS_ROWID` to find out which Data File and Block a specific row belongs to.
   *(Kiểm tra cấu trúc khối của một bảng bằng `DBMS_ROWID` để biết một hàng cụ thể thuộc về Tệp dữ liệu và Khối nào).*
3. Use Flashback Query (`AS OF TIMESTAMP`) to recover a row that was accidentally deleted 5 minutes ago.
   *(Sử dụng Flashback Query để khôi phục một hàng vô tình bị xóa 5 phút trước).*