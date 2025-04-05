@echo off
setlocal EnableDelayedExpansion

:: Prompt for wallet address
set /p WALLET=Enter your Verus wallet address:

:: Set pool and other configs
set POOL=na.luckpool.net:3956
set WORKER=worker1
set THREADS=%NUMBER_OF_PROCESSORS%
set MINER_URL=https://github.com/VerusCoin/nheqminer/releases/download/v0.8.1/nheqminer_windows64.zip
set MINER_FOLDER=nheqminer_win

:: Create miner directory
mkdir %MINER_FOLDER%
cd %MINER_FOLDER%

:: Download the miner
echo Downloading Verus nheqminer...
powershell -Command "Invoke-WebRequest -Uri %MINER_URL% -OutFile nheqminer.zip"

:: Extract it
powershell -Command "Expand-Archive -Path 'nheqminer.zip' -DestinationPath ."

:: Run the miner with CPU and GPU if available
echo Starting Verus mining with %THREADS% threads...
nheqminer.exe -v -l %POOL% -u %WALLET%.%WORKER% -t %THREADS%

endlocal
pause
