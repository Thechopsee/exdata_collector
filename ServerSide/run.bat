@echo off
cd /d "%~dp0"

set CONFIG=local

:parse_args
if "%~1"=="" goto start_server
if /i "%~1"=="-c" (
    set CONFIG=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="--config" (
    set CONFIG=%~2
    shift
    shift
    goto parse_args
)
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--help" goto show_help
echo Unknown option: %~1
echo Use -h or --help for usage information
exit /b 1

:show_help
echo Usage: %~nx0 [-c^|--config CONFIG]
echo.
echo Options:
echo   -c, --config CONFIG    Configuration to use (local, local2, production)
echo   -h, --help             Show this help message
echo.
echo Available configurations:
echo   local      - Local development (192.168.1.27:5000, debug=True)
echo   local2     - Alternative local (10.0.0.19:5000, debug=True)
echo   production - Production deployment (10.0.0.19:5051, debug=False)
exit /b 0

:start_server
echo Using configuration: %CONFIG%
python DataColector.py %CONFIG%
