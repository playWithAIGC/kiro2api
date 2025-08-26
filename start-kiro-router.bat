@echo off
chcp 65001 >nul
:: ==========================================
:: One-click start script for Kiro app
:: Author: ChatGPT
:: ==========================================

setlocal

:: --- Miniconda installation path ---
set "CONDA_DIR=D:\ProgramData\miniconda3"
set "ENV_NAME=kiro"

:: --- Check if conda exists ---
if not exist "%CONDA_DIR%\Scripts\conda.exe" (
    echo ERROR: Conda not found. Check your Miniconda installation path.
    pause
    exit /b
)

:: --- Activate Conda environment ---
echo Activating environment "%ENV_NAME%"...
call "%CONDA_DIR%\Scripts\activate.bat" %ENV_NAME%

:: --- Optional: confirm Python and pip versions ---
python --version
pip --version

:: --- Start the app ---
echo Starting Kiro app (app.py)...
python "%~dp0app.py"

endlocal
pause
