# 🪟 Windows Setup - Developer Mode Fix

## ⚠️ Error You're Seeing

```
Error: Building with plugins requires symlink support.
Please enable Developer Mode in your system settings.
Run start ms-settings:developers to open settings.
```

## ✅ Quick Fix (5 minutes)

### Method 1: Using Command (Fastest)

1. **Open Command Prompt or PowerShell**
   - Press `Win + R`
   - Type: `cmd` or `powershell`
   - Press Enter

2. **Run this command**:
   ```powershell
   start ms-settings:developers
   ```

3. **Enable Developer Mode**:
   - The Settings window will open to "For developers" section
   - Find **Developer Mode** toggle
   - Click to turn it **ON**
   - Windows will download and install necessary components (~5-10 MB)
   - You may see a User Account Control (UAC) prompt - click **Yes**

4. **Restart (if prompted)**:
   - Some systems require a restart
   - If prompted, restart your computer

5. **Verify in VS Code**:
   ```bash
   flutter doctor -v
   ```

---

### Method 2: Manual Steps (If command doesn't work)

1. **Open Windows Settings**:
   - Press `Win + I`
   - Or click Start → Settings

2. **Navigate to Developer Settings**:
   - Click **Privacy & Security** (Windows 11)
   - OR click **Update & Security** (Windows 10)
   - Click **For developers** on the left sidebar

3. **Enable Developer Mode**:
   - Toggle **Developer Mode** to **ON**
   - Accept the warning prompt
   - Wait for components to download

4. **Restart Windows** (if required)

---

## 🔍 Why This Is Needed

Flutter uses symlinks (symbolic links) for:
- Plugin management
- Efficient file linking
- Build optimization

Windows restricts symlink creation by default for security. Developer Mode removes this restriction.

---

## ✅ After Enabling Developer Mode

1. **Restart VS Code** (close and reopen)

2. **Navigate to your project**:
   ```bash
   cd C:\path\to\test
   # Or wherever you cloned the repository
   ```

3. **Clean and rebuild**:
   ```bash
   flutter clean
   flutter pub get
   ```

4. **Run the app**:
   ```bash
   flutter run -d windows
   ```

   First build will take 10-15 minutes. Be patient!

---

## 🐛 Still Having Issues?

### Issue: "Developer Mode option is grayed out"

**Cause**: Group Policy or Enterprise restrictions

**Fix**:
```powershell
# Run PowerShell as Administrator
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AppModelUnlock" -Name "AllowDevelopmentWithoutDevLicense" -Value 1
```

Then restart your computer.

---

### Issue: "Visual Studio required"

If you see errors about Visual Studio:

1. **Install Visual Studio 2022 Community** (free):
   - Download: https://visualstudio.microsoft.com/downloads/
   - During installation, select:
     - ✅ Desktop development with C++
     - ✅ Windows 10 SDK (or 11)

2. **Verify installation**:
   ```bash
   flutter doctor -v
   ```

   Should show: `[✓] Visual Studio - develop Windows apps`

---

### Issue: Flutter not found

```bash
# Add Flutter to PATH
# 1. Open System Environment Variables
# 2. Edit PATH
# 3. Add: C:\src\flutter\bin (or wherever you installed Flutter)
# 4. Restart Command Prompt/PowerShell
```

---

## 🎯 Complete Windows Checklist

After enabling Developer Mode, verify:

- [ ] Developer Mode is ON (Settings → For developers)
- [ ] Restarted computer (if prompted)
- [ ] Restarted VS Code
- [ ] Ran `flutter doctor -v` (no critical errors)
- [ ] Visual Studio 2022 installed with C++ tools (optional but recommended)
- [ ] Flutter is in PATH
- [ ] Can run `flutter run -d windows` without symlink error

---

## 🚀 Expected Results

After the first successful build:

```bash
flutter run -d windows
```

**Output should be**:
```
Launching lib\main.dart on Windows in debug mode...
Building Windows application...
Syncing files to device Windows...
Flutter run key commands.
r Hot reload.
R Hot restart.
h List all available interactive commands.
d Detach (terminate "flutter run" but leave application running).
c Clear the screen
q Quit (terminate the application on the device).

💪 Running with sound null safety 💪

An Observatory debugger and profiler on Windows is available at: http://127.0.0.1:xxxxx/

The Flutter DevTools debugger and profiler on Windows is available at: http://127.0.0.1:xxxxx/
```

The Lotti app window will open on your screen! 🎉

---

## 📊 What You'll See

When the app launches:
1. **Lotti window** (1280x720 pixels)
2. **Onboarding/Tutorial screens** (first launch)
3. **Main interface** with navigation:
   - Journal (default page)
   - Tasks
   - Calendar
   - Habits
   - Dashboards
   - Settings

---

## 💡 Pro Tips

### Faster Rebuilds
After first build, subsequent runs are much faster (30-60 seconds).

### Hot Reload
While app is running:
- Press `r` → See code changes instantly
- Press `R` → Full restart
- Press `q` → Quit

### Release Build (Much Faster)
For better performance:
```bash
flutter build windows --release
```

App will be in: `build\windows\x64\runner\Release\`

---

## 🆘 Get More Help

**Flutter Doctor**:
```bash
flutter doctor -v
```

**Check Devices**:
```bash
flutter devices
```

**Verbose Logging**:
```bash
flutter run -d windows -v
```

---

**Status**: Follow these steps and the symlink error will be resolved! ✅

**Time Required**: 5-10 minutes (mostly waiting for Windows to enable Developer Mode)

---

*Now you can enjoy Lotti on Windows!* 🎉
