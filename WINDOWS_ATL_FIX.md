# 🔧 Windows ATL Component Fix

## ⚠️ Error You're Seeing

```
error C1083: Cannot open include file: 'atlbase.h': No such file or directory
error C1083: Cannot open include file: 'atlstr.h': No such file or directory
Building Windows application... 486.7s
Error: Build process failed.
```

## 🔍 What's Happening

You have Visual Studio Build Tools installed, but the **ATL (Active Template Library)** component is missing. ATL is required by:
- `flutter_local_notifications_windows` plugin
- `flutter_secure_storage_windows` plugin

## ✅ Fix: Add ATL Component (5 minutes)

### Method 1: Using Visual Studio Installer (Recommended)

1. **Open Visual Studio Installer**:
   - Press `Win + S` (Search)
   - Type: `Visual Studio Installer`
   - Click to open

   **OR** run directly:
   ```powershell
   start "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe"
   ```

2. **Modify Your Installation**:
   - Find **Visual Studio Build Tools 2022**
   - Click **"Modify"** button (next to Launch/More)

3. **Select Required Components**:

   In the **Workloads** tab:
   - ✅ **Desktop development with C++** (should already be checked)

   In the **Individual components** tab (click this tab):
   - Search for: `ATL`
   - ✅ Check **"C++ ATL for latest v143 build tools (x86 & x64)"**
   - ✅ Check **"C++ MFC for latest v143 build tools (x86 & x64)"** (recommended)

   Also ensure these are checked:
   - ✅ **MSVC v143 - VS 2022 C++ x64/x86 build tools**
   - ✅ **Windows 10 SDK** (or Windows 11 SDK)
   - ✅ **C++ CMake tools for Windows**

4. **Install**:
   - Click **"Modify"** button at bottom right
   - Wait for download and installation (~500 MB)
   - **No restart needed**

5. **Verify Installation**:
   ```bash
   flutter doctor -v
   ```

   Should show:
   ```
   [✓] Visual Studio - develop Windows apps
       • Visual Studio Build Tools 2022 version 17.x.x
       • MSVC v143
       • Windows 10 SDK
   ```

---

### Method 2: Command Line Installation

If you prefer command line:

```powershell
# Run as Administrator
& "C:\Program Files (x86)\Microsoft Visual Studio\Installer\setup.exe" modify `
  --installPath "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools" `
  --add Microsoft.VisualStudio.Component.VC.ATL `
  --add Microsoft.VisualStudio.Component.VC.ATLMFC `
  --quiet --norestart
```

Wait for completion, then proceed to rebuild.

---

### Method 3: Fresh Visual Studio Community Install

If modifying doesn't work, install **Visual Studio 2022 Community** (free):

1. **Download**:
   - Visit: https://visualstudio.microsoft.com/downloads/
   - Download **Visual Studio 2022 Community**

2. **Run Installer**, select:
   - ✅ **Desktop development with C++**

3. **In Individual Components** tab, ensure:
   - ✅ C++ ATL for latest v143 build tools
   - ✅ C++ MFC for latest v143 build tools
   - ✅ MSVC v143 - VS 2022 C++ build tools
   - ✅ Windows 10 SDK (or 11)
   - ✅ C++ CMake tools

4. **Install** (~8-10 GB)

---

## 🔄 After Installing ATL

### Step 1: Clean Previous Build

```bash
# In VS Code terminal or PowerShell
cd C:\Users\srija\Downloads\newlotti\test

# Clean everything
flutter clean

# Remove build folder completely
Remove-Item -Recurse -Force build\
```

### Step 2: Verify Visual Studio

```bash
flutter doctor -v
```

**Expected output:**
```
[✓] Visual Studio - develop Windows apps (Visual Studio Build Tools 2022 17.x.x)
    • Visual Studio at C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools
    • Visual Studio Build Tools 2022 version 17.x.x
    • Windows 10 SDK version 10.0.xxxxx.x
    • MSVC v143 - VS 2022 C++ x64/x86 build tools
```

### Step 3: Rebuild

```bash
flutter pub get
flutter run -d windows
```

**First build**: 15-20 minutes (compiling Rust + C++)

---

## 🐛 Troubleshooting

### Issue: Still getting ATL errors after installation

**Try**:
```bash
# Completely clean
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Restart VS Code
# Then rebuild
flutter pub get
flutter run -d windows
```

### Issue: Visual Studio Installer not found

**Manual download**:
1. Go to: https://visualstudio.microsoft.com/downloads/
2. Download **Visual Studio 2022 Community** (free)
3. Install with C++ workload + ATL components

### Issue: Multiple Visual Studio versions

If you have multiple VS versions:

```bash
# Check which VS Flutter is using
flutter doctor -v
```

If using wrong version:
```bash
# Force specific VS version
flutter config --enable-windows-desktop
flutter doctor -v
```

---

## 📦 What Gets Installed

**ATL (Active Template Library)**:
- Size: ~500 MB
- Purpose: C++ Windows development templates
- Used by: Windows Flutter plugins for native features

**Required components:**
- MSVC compiler (C++ build tools)
- Windows SDK (Windows API headers)
- ATL/MFC libraries (Windows controls)
- CMake tools (build system)

---

## 🎯 Complete Windows Build Requirements

For Lotti on Windows, you need:

- [x] **Developer Mode** enabled (symlinks) ✅
- [x] **Rust toolchain** installed (Matrix encryption) ✅
- [ ] **Visual Studio Build Tools** with ATL ⬅️ **YOU ARE HERE**
- [ ] **Flutter SDK** (already have)

After fixing ATL, the build should complete!

---

## ⏱️ Total Setup Time

- Visual Studio ATL install: ~5-10 minutes
- First build with all dependencies: ~15-20 minutes
- Subsequent builds: ~30-60 seconds

---

## 🚀 Expected Output After Fix

```bash
flutter run -d windows
```

**Success looks like:**
```
Launching lib\main.dart on Windows in debug mode...
Building Windows application...
[Compiling Rust dependencies...]
[Compiling C++ plugins with ATL...]
[Linking final executable...]

Building Windows application... 1,247.3s
Syncing files to device Windows...

Flutter run key commands.
r Hot reload. 🔥
R Hot restart.

💪 Running with sound null safety 💪

The Flutter DevTools debugger and profiler on Windows is available at:
http://127.0.0.1:xxxxx/
```

**Lotti window opens!** 🎉

---

## 💡 Why ATL Is Needed

**ATL (Active Template Library)**:
- Provides C++ classes for Windows COM components
- Required by native Windows plugins
- Lightweight Windows UI controls
- Used by secure storage and notifications plugins

Think of it as "glue" between Flutter and Windows APIs.

---

## 🆘 Still Stuck?

**Run diagnostics:**
```bash
# Check Visual Studio
flutter doctor -v

# Check for ATL headers manually
dir "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Tools\MSVC\*\atlmfc\include\atlbase.h"

# If found, ATL is installed correctly
```

**If ATL file exists but still fails:**
```bash
# Try forcing rebuild
flutter clean
flutter pub cache repair
flutter pub get
flutter run -d windows -v
```

---

**After adding ATL, your build should succeed!** ✅

**Status**: Install ATL component → Clean → Rebuild → Success! 🎯

---

*Almost there! Just one more component needed.* 💪
