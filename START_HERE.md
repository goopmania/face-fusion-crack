# 🚀 FaceFusion — Quick Start Guide

> **One-click setup and launch for Windows.** No conda, no manual installs — just run the script.

---

## Prerequisites

Before running the script, make sure you have:

| Requirement | Version | Download |
|---|---|---|
| **Python** | 3.10 or newer | [python.org](https://www.python.org/downloads/) |
| **Windows** | 10 / 11 | — |
| **winget** | any (pre-installed on Win 11) | [aka.ms/winget](https://aka.ms/winget) |

> **FFmpeg** is installed automatically by the script if it isn't already on your system.

---

## How to Run

1. **Navigate** to the `facefusion` folder in File Explorer.
2. **Double-click** `start.bat`.
3. Follow the on-screen prompts (takes ~5 minutes on first run).
4. Open your browser at **[http://127.0.0.1:7860](http://127.0.0.1:7860)** when the app starts.

That's it. On every subsequent run, the script skips straight to launching.

---

## What the Script Does — Step by Step

```
[1/5] Checking Python
      Locates Python on your PATH and verifies it is version 3.10+.

[2/5] Checking pip
      Ensures pip is available; bootstraps it automatically if missing.

[3/5] Checking FFmpeg
      If ffmpeg is not on PATH, installs it silently via winget (Gyan.FFmpeg).

[4/5] Installing Python packages
      Installs all pinned dependencies from requirements.txt, then asks you
      to choose an onnxruntime backend (see table below). Previous conflicting
      versions are removed automatically.

[5/5] Launching FaceFusion
      Starts the Gradio UI. Open http://127.0.0.1:7860 in your browser.
```

---

## Choosing an Acceleration Backend

When prompted during step 4, pick the backend that matches your hardware:

| # | Choice | Package | When to use |
|---|---|---|---|
| **1** | CPU only *(default)* | `onnxruntime 1.26.0` | Works on any machine — press **Enter** to select |
| **2** | NVIDIA GPU | `onnxruntime-gpu 1.26.0` | Requires CUDA Toolkit installed |
| **3** | Intel GPU | `onnxruntime-openvino 1.24.1` | Intel Arc / integrated graphics |
| **4** | AMD / DirectML | `onnxruntime-directml 1.24.4` | AMD or any DirectX 12 GPU |
| **5** | Qualcomm QNN | `onnxruntime-qnn 1.24.4` | Snapdragon X Elite / NPU |

> To change your backend later, just re-run `start.bat` and select a different option — it will uninstall the old one first.

---

## Installed Package Versions

| Package | Version |
|---|---|
| gradio | 5.50.0 |
| gradio-rangeslider | 0.0.8 |
| numpy | 2.2.1 |
| onnx | 1.21.0 |
| opencv-python | 4.13.0.92 |
| tqdm | 4.67.3 |
| scipy | 1.17.1 |
| onnxruntime *(variant)* | see table above |

---

## Troubleshooting

**`Python not found`**
- Install Python 3.10+ from [python.org](https://www.python.org/downloads/).
- During installation, check **"Add Python to PATH"**.

**`Package installation failed`**
- Check your internet connection.
- Try running `start.bat` as **Administrator** (right-click → Run as administrator).

**`FFmpeg install failed`**
- Download FFmpeg manually from [ffmpeg.org](https://ffmpeg.org/download.html).
- Extract it and add the `bin` folder to your system PATH.
- Then re-run `start.bat`.

**`onnxruntime-gpu` errors at runtime**
- Make sure the [CUDA Toolkit](https://developer.nvidia.com/cuda-downloads) matching your driver is installed.
- Re-run `start.bat` and switch to CPU (option 1) to confirm the base app works.

**The browser page doesn't open**
- Wait a few extra seconds for the server to start.
- Manually open [http://127.0.0.1:7860](http://127.0.0.1:7860) in your browser.

---

## Project Structure

```
facefusion/
├── start.bat          ← Run this to set up and launch
├── START_HERE.md      ← This guide
├── facefusion.py      ← Main entry point
├── requirements.txt   ← Python dependencies
├── install.py         ← Original installer (conda-based)
├── facefusion/        ← Core application modules
└── .assets/           ← Models and assets (auto-downloaded on first use)
```

---

## Links

- 📖 Full documentation: [docs.facefusion.io](https://docs.facefusion.io)
- 🐛 Issues / bug reports: [github.com/facefusion/facefusion](https://github.com/facefusion/facefusion)
- 🪟 Official Windows installer: [windows-installer.facefusion.io](http://windows-installer.facefusion.io)

---

*FaceFusion v3.7.1 — Industry leading face manipulation platform.*
