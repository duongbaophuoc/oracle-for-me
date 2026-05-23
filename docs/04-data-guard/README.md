# 🟣 Stage 4 — Disaster Recovery: Oracle Data Guard
# Giai đoạn 4 — Khôi phục Thảm họa: Oracle Data Guard

> RAC protects against a server crashing. Data Guard protects against a data center burning down.
> *RAC bảo vệ hệ thống khi một máy chủ bị sập. Data Guard bảo vệ hệ thống khi toàn bộ trung tâm dữ liệu bị cháy.*

---

## 1. Data Guard Architecture (Kiến trúc Data Guard)

Data Guard works by shipping **Redo Logs** from the Primary Database to one or more Standby Databases over the network.
*(Data Guard hoạt động bằng cách vận chuyển các Redo Logs từ CSDL Chính sang một hoặc nhiều CSDL Dự phòng qua mạng).*

### Types of Standby Databases (Các loại CSDL Dự phòng)
- **Physical Standby (Dự phòng Vật lý):** Exact block-by-block replica of the primary. The standby instance is constantly in "Mount" state, applying redo logs physically. You cannot query it while it is applying redo (unless you have Active Data Guard).
  *(Bản sao chính xác từng khối vật lý. Không thể truy vấn nó khi nó đang nạp dữ liệu - trừ khi dùng Active Data Guard).*
- **Logical Standby (Dự phòng Logic):** Transforms redo logs back into SQL statements and executes them. The database is fully open for read/write (though you shouldn't write to replicated tables). Good for creating custom indexes for reporting.
  *(Dịch ngược Redo thành câu lệnh SQL và chạy. CSDL mở hoàn toàn để Đọc/Ghi. Thích hợp cho việc tạo chỉ mục riêng để báo cáo).*

### Active Data Guard (ADG)
- A paid feature that allows a Physical Standby to be open for `READ ONLY` queries *while* it is actively applying redo logs.
  *(Tính năng trả phí cho phép CSDL Dự phòng Vật lý mở ở chế độ CHỈ ĐỌC trong khi nó vẫn đang liên tục nạp Redo logs).*
- Essential for offloading heavy analytical queries to the DR site.
  *(Rất cần thiết để giảm tải các truy vấn phân tích nặng sang trung tâm dữ liệu dự phòng).*

---

## 2. Protection Modes (Các chế độ Bảo vệ)

1. **Maximum Performance (Hiệu suất tối đa):** Primary commits locally and immediately tells the user "Success". Redo is sent to standby asynchronously. If primary crashes, you might lose seconds of data.
   *(Chính commit và báo thành công ngay. Redo gửi đi bất đồng bộ. Có thể mất vài giây dữ liệu nếu sập).*
2. **Maximum Availability (Sẵn sàng tối đa):** Primary waits for the standby to acknowledge receipt of Redo before telling the user "Success". If the network fails, it downgrades to Maximum Performance to avoid halting the application.
   *(Đợi dự phòng xác nhận đã nhận Redo. Nếu mạng đứt, tự động hạ cấp xuống Hiệu suất tối đa để không chặn ứng dụng).*
3. **Maximum Protection (Bảo vệ tối đa):** Similar to Max Availability, but if the standby cannot acknowledge receipt (e.g., network down), the **Primary database will SHUT DOWN** to prevent data divergence. Used in ultra-strict financial systems.
   *(Giống Sẵn sàng tối đa, nhưng nếu mạng đứt, CSDL Chính SẼ TỰ TẮT để ngăn chặn phân kỳ dữ liệu. Dùng trong tài chính cực kỳ khắt khe).*

---

## 3. Operations (Các thao tác Vận hành)

- **Switchover:** Planned role reversal (Primary becomes Standby, Standby becomes Primary) for maintenance. Zero data loss.
  *(Đảo vai trò có kế hoạch để bảo trì. Không mất dữ liệu).*
- **Failover:** Unplanned role reversal because the Primary exploded. Might have data loss depending on the Protection Mode. The old primary must be rebuilt.
  *(Chuyển đổi ngoài kế hoạch vì CSDL Chính nổ tung. Có thể mất dữ liệu. CSDL cũ phải xây lại từ đầu).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. Configure Data Guard Broker (`dgmgrl`) to manage the configuration.
   *(Cấu hình Data Guard Broker để quản lý cụm).*
2. Perform a graceful Switchover from Primary to Standby and back.
   *(Thực hiện lệnh Switchover chuyển từ Chính sang Dự phòng và ngược lại).*