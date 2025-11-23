# 🦀 Windows Rust Setup - Required for Matrix Encryption

## ⚠️ Error You're Seeing

```
error MSB8066: Custom build for 'vodozemac_bindings_dart.dll.rule;flutter_vodozemac_cargokit.rule' exited with code -1.
Building Windows application... 47.3s
Error: Build process failed.
```

## 🔍 What's Happening

The `flutter_vodozemac` plugin (used for Matrix E2E encryption) is written in Rust and requires the Rust toolchain to compile. This is needed for Lotti's secure sync feature.

## ✅ Fix: Install Rust (10 minutes)

### Step 1: Download Rust Installer

**Open PowerShell** and run:

```powershell
# Download rustup-init.exe
Invoke-WebRequest -Uri "https://win.rustup.rs/x86_64" -OutFile "$env:TEMP\rustup-init.exe"

# Run the installer
& "$env:TEMP\rustup-init.exe"
```

**OR manually download:**
- Visit: https://rustup.rs/
- Click **"Download rustup-init.exe (64-bit)"**
- Run the downloaded file

### Step 2: Install Rust

When the installer runs:

1. You'll see: **"Welcome to Rust!"**
2. Press **`1`** (or Enter) to proceed with standard installation
3. Wait for download and installation (~500 MB)
4. You'll see: **"Rust is installed now. Great!"**

```
Current installation options:

   default host triple: x86_64-pc-windows-msvc
   default toolchain: stable (default)
   profile: default
   modify PATH variable: yes

1) Proceed with standard installation (default - just press enter)
2) Customize installation
3) Cancel installation
>1
```

### Step 3: Verify Installation

**Close and reopen** PowerShell or VS Code terminal, then:

```powershell
# Check Rust version
rustc --version
# Should show: rustc 1.84.x

# Check Cargo (Rust package manager)
cargo --version
# Should show: cargo 1.84.x
```

### Step 4: Clean and Rebuild Flutter Project

```bash
# Navigate to project
cd C:\Users\srija\Downloads\newlotti\test

# Clean previous build
flutter clean

# Get dependencies again
flutter pub get

# Run the app
flutter run -d windows
```

**First build will take longer** (15-20 minutes) because it needs to compile Rust code.

---

## 🔧 Alternative: Manual Installation

If the PowerShell method doesn't work:

1. **Visit**: https://rustup.rs/
2. **Download**: rustup-init.exe
3. **Run** the installer
4. **Choose**: Option 1 (standard installation)
5. **Restart** your terminal/VS Code
6. **Verify**: `rustc --version`

---

## 🐛 Troubleshooting

### Issue: "rustc not found" after installation

**Cause**: PATH not updated

**Fix**:
1. **Restart VS Code completely** (close all windows)
2. Or manually add to PATH:
   - Press `Win + R`
   - Type: `sysdm.cpl` → Enter
   - Advanced → Environment Variables
   - User variables → PATH → Edit
   - Add: `C:\Users\srija\.cargo\bin`
   - Click OK, restart VS Code

### Issue: Build still fails after Rust installation

**Try**:
```bash
# Clean everything
flutter clean
rm -rf build/
rm -rf .dart_tool/

# Reinstall dependencies
flutter pub get

# Try again
flutter run -d windows
```

### Issue: "MSVC not found" error

**Cause**: Missing Visual Studio C++ tools

**Fix**:
You have Visual Studio BuildTools installed, but ensure:
```powershell
# Verify Visual Studio is properly configured
flutter doctor -v
```

Should show:
```
[✓] Visual Studio - develop Windows apps (Visual Studio Build Tools 2022 17.x.x)
    • Visual Studio at C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools
    • Visual Studio Build Tools 2022 version 17.x.x
    • Windows 10 SDK version 10.0.xxxxx.x
    • MSVC v143 - VS 2022 C++ x64/x86 build tools (v14.xx.xxxx)
```

---

## 📊 Build Time Expectations

### First Build (with Rust compilation)
```
flutter run -d windows
```
- **Time**: 15-20 minutes
- **Compiling**: Rust vodozemac library (~10 min)
- **Compiling**: Flutter Windows app (~5 min)
- **Linking**: Final assembly (~2 min)

### Subsequent Builds
- **Time**: 30-60 seconds
- Rust code is cached, only Flutter changes recompile

---

## ✅ What Rust Is Used For

In Lotti, Rust powers:
- **Matrix E2E Encryption** (vodozemac library)
- **Cryptographic operations** for secure sync
- **High-performance crypto** primitives

If you don't need sync features, you could theoretically skip this, but the plugin is already included in dependencies.

---

## 🎯 Complete Setup Checklist

After installing Rust:

- [ ] Rust installed (`rustc --version` works)
- [ ] Cargo available (`cargo --version` works)
- [ ] Restarted VS Code completely
- [ ] Ran `flutter clean`
- [ ] Ran `flutter pub get`
- [ ] Developer Mode enabled (from previous fix)
- [ ] Visual Studio BuildTools installed
- [ ] Ready to run `flutter run -d windows`

---

## 🚀 Expected Output

After Rust installation and rebuild:

```bash
flutter run -d windows
```

**You should see**:
```
Launching lib\main.dart on Windows in debug mode...
Building Windows application...

[First time: compiling Rust dependencies - this takes 10-15 minutes]

Building Windows application... 1,247.3s (20 minutes)
Syncing files to device Windows...

Flutter run key commands.
r Hot reload. 🔥
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

The Flutter DevTools debugger and profiler on Windows is available at: http://127.0.0.1:xxxxx/
```

**The Lotti app window opens!** 🎉

---

## 💡 Why This Is Needed

**Matrix E2E Encryption Requires Rust**:
- Lotti uses Matrix protocol for device sync
- Matrix's E2E encryption (Olm/Megolm) is implemented in Rust
- The `flutter_vodozemac` plugin wraps this Rust library
- Therefore, Rust toolchain must be installed to compile it

This ensures your sync data is end-to-end encrypted and secure! 🔐

---

## 🆘 Still Having Issues?

Run diagnostics:
```bash
# Check Flutter
flutter doctor -v

# Check Rust
rustc --version
cargo --version

# Check Visual Studio
where msbuild

# Detailed build log
flutter run -d windows -v
```

---

**After installing Rust, the build should complete successfully!** ✅

**Time Required**: 10 minutes (Rust install) + 20 minutes (first build) = ~30 minutes total

---

*Rust is awesome for cryptography - your data will be super secure!* 🦀🔐
