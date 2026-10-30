@echo off
setlocal EnableDelayedExpansion

title FaceFusion Launcher
cd /d "%~dp0"

echo.
echo  =============================================
echo   FaceFusion ^| Auto-setup ^& Launch
echo  =============================================
echo.

:: ── 1. Locate Python ─────────────────────────────────────────────────────────
echo [1/5] Checking Python...

set "PYTHON_EXE="
for %%P in (python.exe py.exe) do (
    if not defined PYTHON_EXE (
        for /f "delims=" %%F in ('where %%P 2^>nul') do (
            if not defined PYTHON_EXE set "PYTHON_EXE=%%F"
        )
    )
)

if not defined PYTHON_EXE (
    echo [ERROR] Python not found. Please install Python 3.10+ from https://python.org
    echo         and make sure it is added to your PATH.
    goto :error
)

:: Verify version is >= 3.10
"%PYTHON_EXE%" -c "import sys; assert sys.version_info >= (3,10), f'Need Python 3.10+, got {sys.version}'" 2>nul
if errorlevel 1 (
    echo [ERROR] Python 3.10 or newer is required.
    echo         Found: && "%PYTHON_EXE%" --version
    goto :error
)

echo        Found: && "%PYTHON_EXE%" --version
echo.

:: ── 2. Ensure pip is available ────────────────────────────────────────────────
echo [2/5] Checking pip...
"%PYTHON_EXE%" -m pip --version >nul 2>&1
if errorlevel 1 (
    echo        pip not found, bootstrapping...
    "%PYTHON_EXE%" -m ensurepip --upgrade
    if errorlevel 1 (
        echo [ERROR] Could not install pip. Please install it manually.
        goto :error
    )
)
echo        pip OK.
echo.

:: ── 3. Check / install FFmpeg ─────────────────────────────────────────────────
echo [3/5] Checking FFmpeg...
where ffmpeg >nul 2>&1
if errorlevel 1 (
    echo        FFmpeg not found. Attempting to install via winget...
    winget install --id Gyan.FFmpeg -e --silent --accept-package-agreements --accept-source-agreements
    if errorlevel 1 (
        echo [WARN]  winget install failed. Please install FFmpeg manually from https://ffmpeg.org/download.html
        echo         and add it to your PATH, then re-run this script.
        goto :error
    )
    echo        FFmpeg installed. Refreshing PATH...
    :: Refresh PATH so ffmpeg is visible in this session
    for /f "tokens=2*" %%A in ('reg query "HKCU\Environment" /v PATH 2^>nul') do set "USER_PATH=%%B"
    for /f "tokens=2*" %%A in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PATH 2^>nul') do set "SYS_PATH=%%B"
    set "PATH=!SYS_PATH!;!USER_PATH!"
) else (
    echo        FFmpeg OK.
)
echo.

:: ── 4. Install Python dependencies ───────────────────────────────────────────
echo [4/5] Installing Python packages...
echo        (This may take several minutes on first run)
echo.

:: Upgrade pip silently first
"%PYTHON_EXE%" -m pip install --upgrade pip --quiet

:: Install all requirements except onnxruntime lines (we install the right variant below)
"%PYTHON_EXE%" -m pip install ^
    gradio-rangeslider==0.0.8 ^
    gradio==5.50.0 ^
    numpy==2.2.1 ^
    onnx==1.21.0 ^
    opencv-python==4.13.0.92 ^
    tqdm==4.67.3 ^
    scipy==1.17.1

if errorlevel 1 (
    echo.
    echo [ERROR] Package installation failed. Check the output above for details.
    goto :error
)

:: Install onnxruntime – ask user if no GPU was pre-selected
echo.
echo        Selecting onnxruntime backend...
echo.
echo        [1] CPU only          - onnxruntime        (default, works everywhere)
echo        [2] NVIDIA GPU        - onnxruntime-gpu     (requires CUDA)
echo        [3] Intel GPU         - onnxruntime-openvino
echo        [4] AMD / DirectML    - onnxruntime-directml
echo        [5] Qualcomm QNN      - onnxruntime-qnn
echo.
set /p "ONNX_CHOICE=   Enter choice [1-5] or press Enter for default (CPU): "

if "%ONNX_CHOICE%"=="" set "ONNX_CHOICE=1"
if "%ONNX_CHOICE%"=="1" set "ONNX_PKG=onnxruntime==1.26.0"
if "%ONNX_CHOICE%"=="2" set "ONNX_PKG=onnxruntime-gpu==1.26.0"
if "%ONNX_CHOICE%"=="3" set "ONNX_PKG=onnxruntime-openvino==1.24.1"
if "%ONNX_CHOICE%"=="4" set "ONNX_PKG=onnxruntime-directml==1.24.4"
if "%ONNX_CHOICE%"=="5" set "ONNX_PKG=onnxruntime-qnn==1.24.4"

if not defined ONNX_PKG (
    echo [WARN]  Invalid choice, defaulting to CPU.
    set "ONNX_PKG=onnxruntime==1.26.0"
)

:: Remove any conflicting onnxruntime installs first
"%PYTHON_EXE%" -m pip uninstall onnxruntime onnxruntime-gpu onnxruntime-openvino onnxruntime-directml onnxruntime-qnn -y -q 2>nul

echo        Installing %ONNX_PKG% ...
"%PYTHON_EXE%" -m pip install %ONNX_PKG%
if errorlevel 1 (
    echo.
    echo [ERROR] Failed to install %ONNX_PKG%. Check the output above.
    goto :error
)

echo.
echo        All packages installed successfully.
echo.

:: ── 5. Launch FaceFusion ──────────────────────────────────────────────────────
echo [5/5] Launching FaceFusion...
echo.
echo  =============================================
echo   Open your browser at: http://127.0.0.1:7860
echo  =============================================
echo.

set "CONDA_READY=1"
"%PYTHON_EXE%" facefusion.py run

if errorlevel 1 (
    echo.
    echo [ERROR] FaceFusion exited with an error (code %errorlevel%).
    goto :error
)

goto :done

:error
echo.
echo  =============================================
echo   Setup failed. See messages above.
echo  =============================================
echo.
pause
exit /b 1

:done
echo.
echo  FaceFusion closed.
pause
exit /b 0
