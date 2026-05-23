#!/bin/bash
# ==============================================================================
# Stage 4: Enterprise Operations - Data Guard Management
# Script for automated Switchover and Health Check using DGMGRL
# ==============================================================================

DB_UNIQUE_NAME_PRIMARY="PROD_SITE_A"
DB_UNIQUE_NAME_STANDBY="DR_SITE_B"

DGMGRL_USER="${ORACLE_DGMGRL_USER}"
DGMGRL_PASS="${ORACLE_DGMGRL_PASS}"

# Security best practice: Fail if credentials are not set and we are not using OS Authentication
if [ -n "$ORACLE_DGMGRL_USER" ] && [ -z "$ORACLE_DGMGRL_PASS" ]; then
    echo "❌ Error: ORACLE_DGMGRL_PASS environment variable must be set if ORACLE_DGMGRL_USER is provided." >&2
    exit 1
fi

# Use OS authentication if username is not explicitly set
if [ -z "$ORACLE_DGMGRL_USER" ]; then
    DGMGRL_CONN="/"
    echo "⚠️ WARNING: No credentials provided. Falling back to OS Authentication ('/')."
    echo "Ensure you are running this script as the 'oracle' OS user with proper OSDBA group memberships."
    echo "Otherwise, export ORACLE_DGMGRL_USER='sys' and export ORACLE_DGMGRL_PASS='yourpassword'."
else
    DGMGRL_CONN="${DGMGRL_USER}/${DGMGRL_PASS}"
fi

# Chuyển đổi vai trò chủ động (Switchover) - Không mất dữ liệu an toàn
function perform_switchover() {
    echo "Running pre-switchover validation..."
    # Capture DGMGRL validation output in silent mode to inspect errors
    # (Thu thập kết quả validate để phân tích trước khi chạy lệnh phá hủy)
    VAL_OUTPUT=$(dgmgrl -silent $DGMGRL_CONN "validate database '$DB_UNIQUE_NAME_STANDBY';")
    echo "$VAL_OUTPUT"
    
    # 1. Check dgmgrl exit code to catch command-level failures (e.g. invalid connection or OS auth denied)
    # (Kiểm tra mã thoát dgmgrl để bắt lỗi cấp độ dòng lệnh ngay lập tức)
    if [ $? -ne 0 ]; then
        echo "❌ ERROR: DGMGRL validation command execution failed. Check connections, permissions or OSDBA setup!" >&2
        exit 1
    fi

    # 2. Check if standby is structurally ready for switchover
    # (Kiểm tra xem standby đã sẵn sàng hoàn toàn cho quá trình switchover chưa)
    if ! echo "$VAL_OUTPUT" | grep -Ei "Ready for Switchover:[[:space:]]*Yes" > /dev/null; then
        echo "❌ ERROR: Standby database is NOT ready for switchover. Aborting role switch for safety!" >&2
        exit 1
    fi
    
    echo "✅ Validation passed. Performing role switchover to $DB_UNIQUE_NAME_STANDBY..."
    dgmgrl $DGMGRL_CONN "switchover to '$DB_UNIQUE_NAME_STANDBY';"
}

function show_health() {
    echo "Checking Data Guard Configuration Status..."
    dgmgrl $DGMGRL_CONN "show configuration;"
}

function run_validation() {
    echo "Executing explicit DGMGRL validation on database '$DB_UNIQUE_NAME_STANDBY'..."
    dgmgrl $DGMGRL_CONN "validate database '$DB_UNIQUE_NAME_STANDBY';"
}

case "$1" in
    switchover)
        perform_switchover
        ;;
    validate)
        run_validation
        ;;
    health)
        show_health
        ;;
    *)
        echo "Usage: $0 {switchover|validate|health}"
        exit 1
        ;;
esac

echo "Operation Complete."
