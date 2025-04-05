@echo off
setlocal EnableDelayedExpansion

:: Set Python version (you can update this)
set PYTHON_VERSION=3.12.2
set INSTALLER_URL=https://www.python.org/ftp/python/%PYTHON_VERSION%/python-%PYTHON_VERSION%-amd64.exe
set INSTALL_DIR=%USERPROFILE%\Python%PYTHON_VERSION%
set LOGFILE=python_install.log

echo Downloading Python %PYTHON_VERSION% installer...
curl -o python-installer.exe %INSTALLER_URL%

:: Install Python in user space
echo Installing Python to %INSTALL_DIR% ...
python-installer.exe /quiet InstallAllUsers=0 TargetDir="%INSTALL_DIR%" Include_launcher=0 PrependPath=0 Include_test=0 > %LOGFILE% 2>&1

:: Add Python to PATH for this session
set PATH=%INSTALL_DIR%;%INSTALL_DIR%\Scripts;%PATH%
echo Temporary PATH set to include Python.

:: Check installation
python --version
pip --version

:: Test PowerShell bypass (optional)
echo Running a PowerShell script with execution policy bypass...
powershell -ExecutionPolicy Bypass -Command "Write-Host 'PowerShell is working in bypass mode.'"

:: Cleanup installer
del python-installer.exe

echo Done. Python is available in this session.
pause
endlocal
