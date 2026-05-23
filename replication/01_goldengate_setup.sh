# ==============================================================================
# Replication: GoldenGate CLI & Registration Sequence
# Nhân bản: Kịch bản Đăng ký & Vận hành GoldenGate CLI (GGSCI)
# ==============================================================================

# This shell script lists the command sequence to configure Oracle GoldenGate
# on the source and target servers using the GGSCI command line.
# (Kịch bản này liệt kê trình tự lệnh để cấu hình GoldenGate trên máy chủ nguồn 
# và đích bằng công cụ dòng lệnh GGSCI).

# ---------------------------------------------------------
# ON SOURCE DATABASE (Tại CSDL Nguồn)
# ---------------------------------------------------------

# 1. Start the GoldenGate Manager (Khởi động Trình quản lý GG)
ggsci <<EOF
START MANAGER
INFO MANAGER
EOF

# 2. Enable schema-level trandata (Bật trích xuất dữ liệu giao dịch cho schema)
# This is mandatory so Oracle writes supplemental logging to Redo logs.
# (Bắt buộc để Oracle ghi nhật ký bổ sung vào Redo logs phục vụ trích xuất).
ggsci <<EOF
DBLOGIN USERIDALIAS ogg_admin DOMAIN OracleGoldenGate
ADD SCHEMATRANDATA enterprise_core_db
EOF

# 3. Add the Extract Process (Thêm tiến trình Trích xuất Extract)
ggsci <<EOF
ADD EXTRACT ext_fin, INTEGRATED TRANLOG, BEGIN NOW
ADD EXTTRAIL ./dirdat/ex, EXTRACT ext_fin, MEGABYTES 100
START ext_fin
INFO ext_fin
EOF

# 4. Add the Data Pump Process (Thêm tiến trình Pump trung chuyển)
ggsci <<EOF
ADD EXTRACT pmp_fin, EXTTRAILSOURCE ./dirdat/ex, BEGIN NOW
ADD RMTTRAIL ./dirdat/rt, EXTRACT pmp_fin, MEGABYTES 100
START pmp_fin
INFO pmp_fin
EOF

# ---------------------------------------------------------
# ON TARGET DATABASE (Tại CSDL Đích - Kho dữ liệu)
# ---------------------------------------------------------

# 1. DBLogin and Add Replicat Process (Thêm tiến trình nạp Replicat)
# Uses Integrated Replicat for high-performance parallel execution
# (Sử dụng Replicat tích hợp để thực thi song song hiệu năng cao).
ggsci <<EOF
DBLOGIN USERIDALIAS ogg_admin_target DOMAIN OracleGoldenGate
ADD REPLICAT rep_fin, INTEGRATED, EXTTRAIL ./dirdat/rt
START rep_fin
INFO rep_fin
EOF
