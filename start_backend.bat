@echo off
echo Starting LivenessAI Backend...
echo.

REM Navigate to backend directory
cd /d "c:\Projects\livenessAI\backend"

REM Activate virtual environment
call venv\Scripts\activate

REM Start the server
echo Starting uvicorn server...
echo Backend will be available at: http://localhost:8000
echo API Docs at: http://localhost:8000/docs
echo.
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

pause
