@echo off
setlocal

REM ================================
REM InsightNews simple local runner
REM Usage:
REM   run_local_simple.bat          (defaults to 8000)
REM   run_local_simple.bat 5000     (custom port)
REM ================================

set TARGET=src.app:app

REM Port argument
set PORT=%1
if "%PORT%"=="" set PORT=8000

REM Must be run from project root (requirements.txt present)
if not exist requirements.txt goto no_req

echo [1/5] Creating virtual environment (.venv)
py -3.11 -m venv .venv >nul 2>&1
if errorlevel 1 py -3 -m venv .venv >nul 2>&1
if errorlevel 1 python -m venv .venv

echo [2/5] Activating virtual environment
call .\.venv\Scripts\activate.bat

echo [3/5] Installing dependencies
python -m pip install --upgrade pip
pip install -r requirements.txt
pip install waitress

echo [4/5] Environment
set WEB_CONCURRENCY=1
set PYTHONUNBUFFERED=1

echo [5/5] Starting server at http://localhost:%PORT%
python -m waitress --host=127.0.0.1 --port=%PORT% %TARGET%
goto :eof

:no_req
echo [ERROR] requirements.txt not found. Run this from your project root.
exit /b 1
