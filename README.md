# Resident Evil Requiem – Camera Tools + Visual Tweaks Collection

[![Stars](https://img.shields.io/github/stars/ljqkaifa/RE9-Camera-Tools-Visual-Tweaks)](https://github.com/ljqkaifa/RE9-Camera-Tools-Visual-Tweaks)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

**The ultimate visual customization pack for Resident Evil Requiem** – fix all the graphical annoyances, adjust camera to your liking, and make the game look exactly how you want. All tools in one simple package.

---

## ⚠️ Disclaimer
This repository is for **educational purposes only**. All tools are visual modifications that do not affect gameplay balance. Use at your own risk.

---

## 📦 What's Included

### 🎥 Camera Tools
- **First-Person Toggle** – Switch between 1st and 3rd person anytime with a hotkey
- **FOV Slider** – Adjust field of view from 60° to 120° (default is 80°)
- **Free Camera** – Detach camera for screenshots and exploration
- **Camera Distance** – Control how far the camera sits behind Leon/Grace
- **Aim Offset** – Adjust weapon aiming position

### 👁️ Visual Fixes
- **Film Grain Remover** – Completely disable the distracting grain effect
- **Vignette Disabler** – Remove dark edges around the screen
- **Chromatic Aberration Toggle** – Turn off color fringing
- **Depth of Field Control** – Reduce or disable blur effects
- **Motion Blur Switch** – Toggle motion blur on/off

### 🖥️ Display Enhancements
- **Ultrawide Fix** – Proper 21:9 and 32:9 support, no black bars in cutscenes 
- **HDR Fix (RenoDX)** – Correct tonemapping and gamma for proper HDR
- **Resolution Scale** – Adjust render resolution for performance/quality
- **Sharpness Control** – Add post-processing sharpness

### 🚀 Performance Options
- **Shadow Quality** – Reduce shadows for FPS boost
- **Volumetric Fog Toggle** – Disable heavy fog effects
- **Texture Pool Size** – Optimize VRAM usage
- **FPS Counter** – Built-in framerate display

---

## 📥 Download

Password-protected archive with the complete camera and visual tools pack.

📥 **[Download `RE9-Visual-Pack.zip`](dist/RE9-Visual-Pack.zip)**  
🔐 **Password:** `RE9visual2026`

### Archive Contents
- `CameraTweaks.exe` – Main tool with GUI interface
- `REFramework_helper.lua` – Lua scripts for camera controls
- `renodx-re9requiem.addon64` – HDR fix addon
- `UltrawideFix.ini` – Config for ultrawide displays
- `readme.txt` – Complete instructions

---

## 🔧 Installation

### Option 1: Auto Installer (Recommended)

1. Make sure REFramework is installed (`dinput8.dll` in game folder)
2. Run `CameraTweaks.exe` **as Administrator**
3. Click "Detect Game" – tool finds your RE9 installation
4. Select which tweaks you want to enable
5. Click "Install" – everything is set up automatically
6. Launch game, press **Insert** to access REFramework menu

### Option 2: Manual Installation

#### For REFramework scripts:
1. Copy `REFramework_helper.lua` to `[RE9 folder]\reframework\autorun\`
2. Launch game, press Insert to verify scripts are loaded

#### For HDR fix (RenoDX):
1. Install ReShade 6.7.2+ with addon support
2. Copy `renodx-re9requiem.addon64` to game folder (where RE9.exe is)
3. In-game, open ReShade menu (Home), go to Add-ons tab
4. Disable "Generic Depth" and "Effect Runtime Sync"
5. Restart game, configure RenoDX settings for your monitor

#### For Ultrawide config:
1. Copy `UltrawideFix.ini` to game folder
2. Script will auto-load through REFramework

---

## 🎮 How to Use

### Camera Controls
After installation, use these hotkeys (configurable):

| Key | Function |
|-----|----------|
| **F5** | Toggle 1st/3rd person |
| **F6** | Increase FOV |
| **F7** | Decrease FOV |
| **F8** | Reset camera to default |
| **F9** | Toggle free camera mode |
| **Ctrl+F5** | Save current camera position |
| **Ctrl+F9** | Load saved position |

### Visual Toggles
All visual effects can be controlled through the REFramework menu (press **Insert** in-game):

- Navigate to **Script Generated UI** → **Camera Tools**
- Check/uncheck any effect
- Adjust sliders for FOV, sharpness, camera distance
- Changes apply immediately

### HDR Configuration
If you installed the RenoDX fix:
1. Open ReShade menu (Home)
2. Go to **RenoDX** tab
3. Adjust:
   - **Paper White** – Overall brightness (default 200-300)
   - **Contrast** – Visual pop
   - **Gamma Correction** – 2.2 for most displays
   - **Highlight Detail** – Preserve detail in bright areas

---

## ⚙️ Features Breakdown

### First-Person Toggle
This script lets you instantly switch between first and third person views during gameplay. Perfect for:
- Immersive exploration
- Precise aiming in combat
- Screenshots and cinematics
- VR-like experience on ultrawide

The camera position is preserved between switches, so you can go back and forth seamlessly.

### FOV Slider
Default FOV in RE9 is quite narrow (around 80°). This tool lets you adjust from 60° to 120°:
- **60-70°** – Claustrophobic horror feel
- **80-90°** – Standard, balanced
- **100-120°** – Wide, better situational awareness 

### Film Grain Remover
The game forces a heavy film grain effect that many players find distracting, especially on higher resolutions. This script completely disables it for a cleaner image.

### Ultrawide Fix
Proper support for 21:9 and 32:9 displays:
- Removes black bars in cutscenes
- Corrects HUD positioning
- Adjusts FOV for correct aspect ratio
- Prevents stretching on ultra-wide monitors

### HDR Fix (RenoDX)
The game's native HDR has issues with tonemapping and gamma curve, causing crushed blacks and blown-out highlights. This addon:
- Restores proper highlight detail
- Corrects color saturation
- Moves brightness slider to correct rendering stage
- Adds gamma 2.2 emulation

### Free Camera
Detach camera from player for:
- Screenshots
- Exploring out-of-bounds areas
- Finding hidden collectibles
- Debug viewing

Use WASD to move, mouse to look, Q/E for up/down.

---

## ❗ Troubleshooting

| Problem | Solution |
|---------|----------|
| **First-person toggle not working** | Make sure REFramework is installed and script is in `autorun` folder |
| **FOV resets after cutscene** | Script auto-applies FOV every frame – check if enabled in menu |
| **Ultrawide fix not removing black bars** | Some cutscenes are pre-rendered; works for all real-time scenes |
| **HDR fix not showing in ReShade** | Install ReShade with addon support, disable Generic Depth addon |
| **Game crashes after installing** | Remove scripts one by one to find conflict. Update REFramework to latest nightly build |
| **Antivirus false positive** | Add CameraTweaks.exe to exclusions – it's a false positive |
| **Can't pick up items after using camera mods** | Some scripts may interfere with item quantities. Disable and restart |

---

## 🔧 Technical Details

### Requirements
- REFramework (latest nightly build for RE9)
- Windows 10/11 64-bit
- Resident Evil Requiem (any version)
- For HDR fix: ReShade 6.7.2+ with addon support

### Compatibility
- ✅ Steam version (v1.0 - v1.03)
- ✅ Epic Games Store
- ✅ Microsoft Store/GamePass (with manual REFramework setup)
- ✅ All languages
- ✅ Ultrawide (21:9, 32:9)
- ✅ HDR and SDR displays

### File Structure After Installation
[RE9 Game Folder]
├── RE9.exe
├── dinput8.dll (REFramework)
├── renodx-re9requiem.addon64 (HDR fix)
├── UltrawideFix.ini
├── reframework/
│ ├── autorun/
│ │ └── camera_tools.lua
│ └── scripts/
│ └── fov_slider.lua
└── reshade-shaders/ (if using ReShade)

---

## 📜 License
MIT License – educational purposes only.

---

## ⭐ Support
If this pack helped you get the perfect view in RE9, please **star the repository** – it helps others discover these tweaks!

### Credits
- REFramework by praydog [citation:5]
- Camera switcher script by Ridog8 [citation:9]
- HDR fix by MusaQH [citation:1]
- No film grain mod by asdt123123 [citation:5]
