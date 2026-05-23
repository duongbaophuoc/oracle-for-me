# 📊 Monitoring Stack
# Ngăn xếp Giám sát

This folder contains configurations for monitoring Oracle using a modern Cloud-Native stack.
*Thư mục này chứa các cấu hình để giám sát Oracle bằng ngăn xếp Cloud-Native hiện đại.*

- **Prometheus:** Pulls metrics from the `oracledb_exporter`.
- **Grafana:** Visualizes the metrics.
- **Oracle Exporter:** Connects to Oracle and translates `V$SYSMETRIC` into Prometheus format.

## Usage
Run `docker-compose up -d` in this directory to spin up Prometheus and Grafana.
*(Chạy lệnh `docker-compose up -d` để khởi động Prometheus và Grafana).*