@echo off
cd /d "%~dp0"

echo Installing Python dependencies...
python -m pip install flask flask-sqlalchemy

echo Installation completed successfully!
pause
