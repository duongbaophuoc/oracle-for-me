# ==============================================================================
# Benchmark Script (Windows): Native PowerShell Concurrency Tester
# Kịch bản Đánh giá Hiệu năng (Windows): Sử dụng Job song song
# ==============================================================================

$dbUser = $env:ORACLE_USER
$dbPass = $env:ORACLE_PASS
$dbUrl = if ($env:ORACLE_URL) { $env:ORACLE_URL } else { "localhost:1521/XEPDB1" }
$threads = if ($env:ORACLE_THREADS) { [int]$env:ORACLE_THREADS } else { 5 }
$duration = if ($env:ORACLE_DURATION) { [int]$env:ORACLE_DURATION } else { 60 }

if (-not $dbUser -or -not $dbPass) {
   Write-Error "Environment variables ORACLE_USER and ORACLE_PASS must be set."
   exit 1
}

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host "🚀 Starting Windows Oracle Benchmark"
Write-Host "Target: $dbUrl | Threads: $threads | Duration: $duration sec"
Write-Host "=========================================================" -ForegroundColor Cyan

# Kịch bản SQL thực thi cho mỗi thread
$sqlScript = @"
SET FEEDBACK OFF;
SET PAGESIZE 0;
DECLARE
    v_acc_id NUMBER;
    v_end_time TIMESTAMP := SYSTIMESTAMP + INTERVAL '$duration' SECOND;
BEGIN
    WHILE SYSTIMESTAMP < v_end_time LOOP
        v_acc_id := TRUNC(DBMS_RANDOM.VALUE(1, 100000));
        UPDATE bank_accounts SET balance = balance + 1 WHERE account_id = v_acc_id;
        COMMIT;
    END LOOP;
END;
/
EXIT;
"@

$sqlScript | Out-File -FilePath "$env:TEMP\bench_task.sql" -Encoding ascii

Write-Host "Launching $threads parallel jobs..."
for ($i = 1; $i -le $threads; $i++) {
   Start-Job -ScriptBlock {
      param($u, $p, $url, $file)
      sqlplus -s "$u/$p@$url" "@$file"
   } -ArgumentList $dbUser, $dbPass, $dbUrl, "$env:TEMP\bench_task.sql" | Out-Null
}

Write-Host "Benchmark is running in background. Waiting for completion..."
Get-Job | Wait-Job | Out-Null

Write-Host "=========================================================" -ForegroundColor Green
Write-Host "✅ Benchmark Completed. All background jobs finished."
Write-Host "=========================================================" -ForegroundColor Green
Get-Job | Remove-Job