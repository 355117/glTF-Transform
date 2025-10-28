@echo off
echo ========================================
echo Packing glTF-Transform CLI to .tgz
echo ========================================

REM Change to script directory
cd /d "%~dp0"

REM Install dependencies if needed
if not exist "node_modules\.yarn-state.yml" (
    echo Installing dependencies...
    call yarn install
    if errorlevel 1 (
        echo Error: Failed to install dependencies
        pause
        exit /b 1
    )
    echo.
)

REM Build the project
echo [1/4] Building project...
call yarn build
if errorlevel 1 (
    echo Error: Build failed
    pause
    exit /b 1
)

REM Pack core package
echo [2/4] Packing @gltf-transform/core...
cd packages\core
call npm pack
if errorlevel 1 (
    echo Error: Failed to pack core
    cd ..\..
    pause
    exit /b 1
)
cd ..\..

REM Pack extensions package
echo [3/4] Packing @gltf-transform/extensions...
cd packages\extensions
call npm pack
if errorlevel 1 (
    echo Error: Failed to pack extensions
    cd ..\..
    pause
    exit /b 1
)
cd ..\..

REM Pack functions package
echo [4/4] Packing @gltf-transform/functions...
cd packages\functions
call npm pack
if errorlevel 1 (
    echo Error: Failed to pack functions
    cd ..\..
    pause
    exit /b 1
)
cd ..\..

REM Pack CLI package
echo [5/5] Packing @gltf-transform/cli...
cd packages\cli
call npm pack
if errorlevel 1 (
    echo Error: Failed to pack CLI
    cd ..\..
    pause
    exit /b 1
)
cd ..\..

REM Move all .tgz files to project root
echo.
echo Moving .tgz files to project root...
if not exist "tgz-packages" mkdir tgz-packages
move /Y packages\core\*.tgz tgz-packages\
move /Y packages\extensions\*.tgz tgz-packages\
move /Y packages\functions\*.tgz tgz-packages\
move /Y packages\cli\*.tgz tgz-packages\

echo.
echo ========================================
echo Packaging completed successfully!
echo .tgz files are in: tgz-packages\
echo ========================================
dir /B tgz-packages\*.tgz
echo.
pause

