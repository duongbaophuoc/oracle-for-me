# 🔵 Stage 7 — Observability, Diagnostics & Incident Engineering
# Giai đoạn 7 — Khả năng Quan sát, Chẩn đoán & Kỹ thuật Xử lý sự cố

> "You can't manage what you can't measure." In mission-critical environments, observability is the difference between a 2-minute blip and a 4-hour catastrophic outage.
> *"Bạn không thể quản lý những gì bạn không thể đo lường". Trong môi trường trọng yếu, khả năng quan sát là sự khác biệt giữa một sự cố 2 phút và một thảm họa sập hệ thống 4 giờ.*

---

## 1. Modern Observability Stack (Ngăn xếp Giám sát Hiện đại)

Traditionally, Oracle is monitored via **Oracle Enterprise Manager (OEM)**. However, modern infrastructure teams often integrate Oracle into a unified observability stack.
*(Theo truyền thống, Oracle được giám sát qua OEM. Tuy nhiên, các đội hạ tầng hiện đại thường tích hợp Oracle vào một hệ thống giám sát tập trung).*

- **Prometheus Exporters:** Custom scripts or open-source exporters (like `oracledb_exporter`) query Oracle system views (like `v$sysmetric`) and expose them as HTTP endpoints for Prometheus to scrape.
  *(Các script tùy chỉnh truy vấn góc nhìn hệ thống Oracle và phơi bày chúng thành điểm cuối HTTP để Prometheus thu thập).*
- **Grafana:** Visualizes the metrics from Prometheus into beautiful, real-time dashboards (e.g., Active Sessions, IOPS, Redo Generation Rate).
  *(Trực quan hóa số liệu từ Prometheus thành các bảng điều khiển thời gian thực).*

---

## 2. Incident Engineering (Kỹ thuật Xử lý Sự cố)

A Database Reliability Engineer (DBRE) must know exactly what to do when pagers go off at 3 AM.
*(Kỹ sư Độ tin cậy CSDL phải biết chính xác cần làm gì khi còi báo động réo lúc 3 giờ sáng).*

### Common Incidents (Các sự cố thường gặp)
- **Archive Log Explosion:** A rogue batch job generates massive updates, filling up the Archive Log destination (`FRA`). Once 100% full, the database completely freezes.
  - *Fix:* Back up the logs using RMAN, or add emergency disk space.
  - *(Giao dịch cập nhật khổng lồ làm đầy bộ lưu trữ Archive Log. Khi đầy 100%, CSDL bị đóng băng hoàn toàn. Sửa: Backup qua RMAN hoặc thêm đĩa khẩn cấp).*
- **Undo Exhaustion (ORA-01555 "Snapshot too old"):** A 10-hour query is trying to read old data, but the Undo space was overwritten by heavy concurrent writes.
  - *Fix:* Increase `UNDO_RETENTION` or rewrite the query to be faster.
  - *(Truy vấn chạy quá lâu bị ghi đè không gian Undo. Sửa: Tăng UNDO_RETENTION hoặc tối ưu lại truy vấn).*
- **Library Cache Contention:** Sudden CPU spike to 100% due to an application release that stopped using Bind Variables.
  - *Fix:* Kill the application connections, force the devs to roll back, or aggressively use `CURSOR_SHARING = FORCE` as a band-aid.
  - *(CPU đột ngột tăng 100% do bản cập nhật mới không dùng biến liên kết. Sửa: Dùng `CURSOR_SHARING = FORCE` làm băng dán tạm thời).*

---

## 📝 Practice Plan (Kế hoạch Thực hành)

1. **Write custom Prometheus Exporter queries:** 
   - Refer to [01_prometheus_exporter_metrics.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/07-observability/01_prometheus_exporter_metrics.sql) to view raw queries fetching transaction rates, SGA sizing, and physical disk waits directly from V$ views.
   - *(Xem các câu lệnh truy vấn thu thập số liệu hệ thống tại [01_prometheus_exporter_metrics.sql](file:///e:/ABC/NoSQL/OracleSQL/docs/07-observability/01_prometheus_exporter_metrics.sql)).*
2. **Simulate and Resolve Archive Log Full Disaster:**
   - Execute the automated chaos simulation script at [scripts/simulate_archive_log_full.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/simulate_archive_log_full.sh) to trigger a database freeze (ORA-00257) and perform emergency RMAN recoveries.
   - *(Thực thi kịch bản giả lập đầy dung lượng log gây treo máy tại [scripts/simulate_archive_log_full.sh](file:///e:/ABC/NoSQL/OracleSQL/scripts/simulate_archive_log_full.sh) và giải phóng bằng RMAN).*