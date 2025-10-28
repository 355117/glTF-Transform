@echo off
echo ========================================
echo Installing glTF-Transform CLI globally
echo ========================================

REM Change to script directory
cd /d "%~dp0"

REM Check if tgz-packages directory exists
if not exist "tgz-packages" (
    echo Error: tgz-packages directory not found
    echo Please run pack-cli.bat first
    pause
    exit /b 1
)

REM Find the .tgz files
for /f "delims=" %%i in ('dir /b tgz-packages\gltf-transform-core-*.tgz 2^>nul') do set CORE_TGZ=%%i
for /f "delims=" %%i in ('dir /b tgz-packages\gltf-transform-extensions-*.tgz 2^>nul') do set EXT_TGZ=%%i
for /f "delims=" %%i in ('dir /b tgz-packages\gltf-transform-functions-*.tgz 2^>nul') do set FUNC_TGZ=%%i
for /f "delims=" %%i in ('dir /b tgz-packages\gltf-transform-cli-*.tgz 2^>nul') do set CLI_TGZ=%%i

REM Check if files were found
if "%CORE_TGZ%"=="" (
    echo Error: Core package not found
    pause
    exit /b 1
)
if "%EXT_TGZ%"=="" (
    echo Error: Extensions package not found
    pause
    exit /b 1
)
if "%FUNC_TGZ%"=="" (
    echo Error: Functions package not found
    pause
    exit /b 1
)
if "%CLI_TGZ%"=="" (
    echo Error: CLI package not found
    pause
    exit /b 1
)

echo Found packages:
echo - %CORE_TGZ%
echo - %EXT_TGZ%
echo - %FUNC_TGZ%
echo - %CLI_TGZ%
echo.

REM Install packages in order
echo [1/4] Installing @gltf-transform/core...
call npm install --global tgz-packages\%CORE_TGZ%
if errorlevel 1 (
    echo Error: Failed to install core
    pause
    exit /b 1
)

echo [2/4] Installing @gltf-transform/extensions...
call npm install --global tgz-packages\%EXT_TGZ%
if errorlevel 1 (
    echo Error: Failed to install extensions
    pause
    exit /b 1
)

echo [3/4] Installing @gltf-transform/functions...
call npm install --global tgz-packages\%FUNC_TGZ%
if errorlevel 1 (
    echo Error: Failed to install functions
    pause
    exit /b 1
)

echo [4/4] Installing @gltf-transform/cli...
call npm install --global tgz-packages\%CLI_TGZ%
if errorlevel 1 (
    echo Error: Failed to install CLI
    pause
    exit /b 1
)

echo.
echo ========================================
echo Installation completed successfully!
echo ========================================
echo.
echo Testing installation...
call gltf-transform --version
echo.
echo You can now use 'gltf-transform' command globally
echo.
pause

