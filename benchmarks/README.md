# ⏱️ Benchmarks & Stress Testing (Đánh giá & Kiểm tra Chịu tải)

This folder contains scripts to benchmark the Oracle database under extreme concurrent load to analyze transactional performance, CPU scaling, and identify wait events.
*Thư mục này chứa các kịch bản để đánh giá Oracle dưới tải đồng thời cực lớn nhằm phân tích hiệu năng giao dịch, khả năng mở rộng CPU và xác định các sự kiện chờ (wait events).*

---

## 📂 Directory Files (Tệp tin Thư mục)

- [run_benchmark.sh](file:///e:/ABC/NoSQL/OracleSQL/benchmarks/run_benchmark.sh): Bash script to run parallel background transactions via `sqlplus` on Linux.
- [run_benchmark.ps1](file:///e:/ABC/NoSQL/OracleSQL/benchmarks/run_benchmark.ps1): Native Windows PowerShell script using parallel background job runspaces (`Start-Job`) to stress-test Oracle DB from a Windows machine.

---

## 🚀 Execution Guide (Hướng dẫn Thực thi)

### Option 1: Running on Linux (Bash)
Set your environment variables (optional) and run the shell script:
```bash
export ORACLE_USER="system"
export ORACLE_PASS="secret"
export ORACLE_URL="localhost:1521/XEPDB1"

chmod +x run_benchmark.sh
./run_benchmark.sh
```

### Option 2: Running on Windows (PowerShell)
Open PowerShell as Administrator, set credentials, and run:
```powershell
$env:ORACLE_USER="system"
$env:ORACLE_PASS="secret"
$env:ORACLE_URL="localhost:1521/XEPDB1"

.\run_benchmark.ps1
```

---

## 🛠️ Recommended Industry Tools (Công cụ Chuyên dụng Khuyên dùng)
For production deployments, do not rely on simple custom scripts. Use industry standard tools:
1. **HammerDB:** The industry standard for TPC-C (OLTP) and TPC-H (Data Warehouse) testing. Excellent for generating transactional load.
2. **SLOB (Silly Little Oracle Benchmark):** The gold standard tool for stressing Oracle physical IO and testing storage subsystems (SGA/PGA caching effectiveness) without CPU bottlenecks.