@echo off
rem Mo giao dien quan ly anh xa 14 Edge profile, Gmail va ten mien.
cd /d "%~dp0"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0_he_thong\fix_delete_url_button_layout.ps1"
if errorlevel 1 (
    echo Khong the cap nhat bo cuc nut XOA TOAN BO URL.
    pause
    exit /b 1
)
start "" /b powershell.exe -NoProfile -ExecutionPolicy Bypass -STA -WindowStyle Hidden -File "%~dp0_he_thong\manage_submit_edge_profiles.ps1"
exit /b
