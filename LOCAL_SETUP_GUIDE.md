# 🚀 Local Setup Guide - Run Lotti on Your Machine

This guide will help you run the Lotti application on your local computer.

---

## 📋 Prerequisites

Before you start, you'll need:
- **Git** installed
- **Flutter SDK** (we'll install this together)
- **Your preferred IDE** (VS Code or Android Studio recommended)
- **15-20 GB free disk space**

---

## 🎯 Step-by-Step Setup

### Step 1: Clone the Repository

```bash
# Clone your repository
git clone https://github.com/Srijan222/test.git

# Navigate to the project
cd test

# Checkout the Lotti implementation branch
git checkout claude/implement-lotti-01P43N9WGX4BPe5rE4hU3oVL

# Verify you're on the right branch
git branch --show-current
# Should show: claude/implement-lotti-01P43N9WGX4BPe5rE4hU3oVL
```

---

### Step 2: Install Flutter

Choose your operating system:

#### 🍎 **macOS**

```bash
# Option 1: Using Homebrew (recommended)
brew install --cask flutter

# Option 2: Manual download
# 1. Download from: https://docs.flutter.dev/get-started/install/macos
# 2. Extract to ~/development/flutter
# 3. Add to PATH:
export PATH="$PATH:$HOME/development/flutter/bin"
# Add this line to ~/.zshrc or ~/.bash_profile to make it permanent
```

#### 🐧 **Linux (Ubuntu/Debian)**

```bash
# 1. Install required dependencies
sudo apt-get update
sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# 2. Install Flutter
cd ~/development
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:$HOME/development/flutter/bin"

# 3. Add to PATH permanently (add to ~/.bashrc or ~/.zshrc)
echo 'export PATH="$PATH:$HOME/development/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# 4. Install GTK3 libraries (for Linux desktop)
sudo apt-get install -y libgtk-3-dev

# 5. Install emoji fonts (for proper emoji rendering)
sudo apt install fonts-noto-color-emoji
cd ~/test
./linux/install_emoji_fonts.sh
```

#### 🪟 **Windows**

```powershell
# Download Flutter from: https://docs.flutter.dev/get-started/install/windows
# 1. Extract the zip file to C:\src\flutter
# 2. Add to PATH: C:\src\flutter\bin
# 3. Open PowerShell as Administrator and run:

# Enable Developer Mode
Start-Process ms-settings:developers

# Install Git for Windows
# Download from: https://git-scm.com/download/win
```

---

### Step 3: Verify Flutter Installation

```bash
# Run Flutter doctor to check installation
flutter doctor

# You should see something like:
# [✓] Flutter (Channel stable, 3.38.3)
# [✓] Android toolchain (if you want Android)
# [✓] Chrome (if you want web)
# [✓] VS Code (if installed)
```

**Common issues:**
- ❌ Android toolchain missing → That's OK if you just want desktop!
- ❌ Xcode missing (macOS) → Only needed for iOS development
- ⚠️ Any warnings → Usually safe to ignore for desktop development

---

### Step 4: Install Project Dependencies

```bash
# Make sure you're in the project directory
cd ~/test  # or wherever you cloned it

# Install Flutter packages
flutter pub get

# This will download 100+ packages - takes 2-5 minutes
# You should see: "Got dependencies!"
```

---

### Step 5: Generate Code Files

The generated files are already included, but if you need to regenerate:

```bash
# Generate code (this was already done, but you can re-run if needed)
flutter pub run build_runner build --delete-conflicting-outputs

# This takes about 3-4 minutes
# You'll see: "Built with build_runner in XXXs; wrote 2865 outputs."
```

---

### Step 6: Run the Application! 🎉

Choose your platform:

#### 🍎 **macOS Desktop**

```bash
# Run on macOS
flutter run -d macos

# Or with verbose output
flutter run -d macos -v

# The app will compile and launch!
# First run takes 5-10 minutes (compiling)
# Subsequent runs are much faster (30-60 seconds)
```

#### 🐧 **Linux Desktop**

```bash
# List available devices
flutter devices

# Run on Linux
flutter run -d linux

# Or specify the device ID if multiple devices shown
flutter run -d linux
```

#### 🪟 **Windows Desktop**

```powershell
# Run on Windows
flutter run -d windows

# First build takes 10-15 minutes
# Be patient!
```

#### 📱 **Android** (if you have Android Studio)

```bash
# 1. Start an Android emulator in Android Studio
# OR connect a physical Android device with USB debugging

# 2. List devices
flutter devices

# 3. Run on Android
flutter run -d android

# Or specify device ID
flutter run -d <device-id>
```

#### 🍎 **iOS** (macOS only, requires Xcode)

```bash
# 1. Open Xcode and install iOS Simulator
# 2. Start iOS Simulator

# 3. Run on iOS
flutter run -d ios
```

---

## 🎨 What You'll See

When the app launches, you'll see:

1. **First Launch**: Onboarding/tutorial screens
2. **Main Interface**:
   - Journal page (default)
   - Navigation: Journal, Tasks, Calendar, Habits, Dashboards, Settings
3. **Empty State**: No data yet - ready for you to start using!

---

## ⚙️ Initial Configuration

### Configure AI Providers (Optional)

1. Click **Settings** (gear icon)
2. Navigate to **AI Settings**
3. Add your API keys:
   - **OpenAI**: Get from https://platform.openai.com/api-keys
   - **Anthropic**: Get from https://console.anthropic.com/
   - **Google Gemini**: Get from https://makersuite.google.com/app/apikey
   - **Ollama**: Install locally from https://ollama.ai

### Enable Sync (Optional)

1. Go to **Settings** → **Sync**
2. Create Matrix account:
   - Option 1: https://app.element.io (free public server)
   - Option 2: Self-host Matrix server
3. Login with Matrix credentials
4. Sync will be automatically E2E encrypted

---

## 🐛 Troubleshooting

### Build Errors

```bash
# Clear build cache
flutter clean

# Reinstall dependencies
flutter pub get

# Regenerate code
flutter pub run build_runner build --delete-conflicting-outputs

# Try running again
flutter run -d <platform>
```

### "No devices found"

```bash
# For macOS desktop
flutter config --enable-macos-desktop

# For Linux desktop
flutter config --enable-linux-desktop

# For Windows desktop
flutter config --enable-windows-desktop

# Verify
flutter devices
```

### macOS: "App can't be opened because developer cannot be verified"

```bash
# Right-click the app → "Open"
# Or disable Gatekeeper (not recommended):
sudo spctl --master-disable
```

### Linux: Missing GTK libraries

```bash
sudo apt-get install -y \
  libgtk-3-dev \
  libglu1-mesa \
  clang \
  cmake \
  ninja-build \
  pkg-config
```

### Windows: Build fails

```powershell
# Install Visual Studio 2022 with:
# - Desktop development with C++
# - Windows 10 SDK

# Run as Administrator
flutter doctor --verbose
```

---

## 🔥 Hot Reload (Development Mode)

When the app is running in debug mode:

- Press **`r`** → Hot reload (instantly see changes)
- Press **`R`** → Hot restart (full app restart)
- Press **`q`** → Quit
- Press **`h`** → Help

Make code changes in your IDE, press `r`, and see updates instantly!

---

## 🏗️ Building for Production

### Release Build (much faster!)

```bash
# macOS
flutter build macos --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release

# Android APK
flutter build apk --release

# iOS (requires Apple Developer account)
flutter build ios --release
```

The compiled app will be in:
- **macOS**: `build/macos/Build/Products/Release/lotti.app`
- **Linux**: `build/linux/x64/release/bundle/`
- **Windows**: `build\windows\x64\runner\Release\`
- **Android**: `build/app/outputs/flutter-apk/app-release.apk`

---

## 📊 Development Commands

```bash
# Run tests
flutter test

# Run specific test
flutter test test/features/ai/ai_test.dart

# Static analysis
flutter analyze

# Check for outdated packages
flutter pub outdated

# Format code
dart format .

# Run with verbose logging
flutter run -d <platform> -v
```

---

## 💡 Tips for Best Experience

### Performance
- **First run**: Expect 5-15 minutes (compiling)
- **Hot reload**: Changes in ~1 second
- **Subsequent runs**: 30-60 seconds

### Development
- Use **VS Code** with Flutter extension
- Enable **hot reload** for instant updates
- Use **Flutter DevTools** for debugging

### IDE Setup

#### VS Code
```bash
# Install Flutter extension
# Press Cmd/Ctrl+Shift+P
# Type: "Extensions: Install Extensions"
# Search: "Flutter"
# Install both "Flutter" and "Dart"
```

#### Android Studio
- Install Flutter plugin
- Install Dart plugin
- Restart Android Studio

---

## 🎯 Quick Start Checklist

- [ ] Git installed
- [ ] Repository cloned
- [ ] Flutter SDK installed
- [ ] `flutter doctor` passes (at least Flutter and one platform)
- [ ] `flutter pub get` completed
- [ ] `flutter devices` shows at least one device
- [ ] `flutter run -d <platform>` launched successfully
- [ ] App is running on your screen! 🎉

---

## 🆘 Need Help?

### Check Build Status
```bash
# Verbose flutter doctor
flutter doctor -v

# Check Flutter version
flutter --version

# List all devices
flutter devices

# Show detailed logs
flutter run -d <platform> -v
```

### Common Questions

**Q: How long does first build take?**
A: 5-15 minutes depending on your machine

**Q: Can I run without AI providers?**
A: Yes! AI features are optional

**Q: Do I need Android Studio?**
A: No, only if you want to run on Android

**Q: Can I run on multiple platforms?**
A: Yes! Build for all platforms you have installed

**Q: Is internet required?**
A: Only for initial setup. App works offline after that.

---

## 🎊 Success!

If you see the Lotti app running on your screen with the beautiful UI, navigation working, and you can create tasks - **CONGRATULATIONS!** 🎉

You now have a fully functional AI-powered, privacy-first task manager running locally on your machine!

---

## 📚 Next Steps

1. **Explore the app**:
   - Create your first task
   - Record an audio note
   - Try the AI features
   - Set up categories

2. **Configure AI** (optional):
   - Add API keys for AI providers
   - Try task summarization
   - Test audio transcription

3. **Set up Sync** (optional):
   - Create Matrix account
   - Enable device sync
   - Test E2E encryption

4. **Customize**:
   - Change themes
   - Set up habits
   - Configure categories
   - Adjust settings

---

**Enjoy your privacy-first, AI-powered productivity companion!** 🚀

*Your data stays yours. Your AI, your choice. Your productivity, amplified.*
