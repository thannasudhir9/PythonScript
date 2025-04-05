@echo off
setlocal

echo Fetching latest Python version info...

curl -s https://www.python.org/ftp/python/ > nul 2>&1
if errorlevel 1 (
    echo Curl is not installed. Please install curl or run this script in PowerShell.
    exit /b 1
)

set PYTHON_VERSION=3.12.2
set INSTALLER_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe

echo Downloading Python %PYTHON_VERSION%...
curl -o python-installer.exe %INSTALLER_URL%

echo Installing Python...
python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_test=0

del python-installer.exe

python --version

endlocal
