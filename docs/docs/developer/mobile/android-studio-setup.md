---
sidebar_position: 1
title: Development Setup
sidebar_custom_props:
  icon: '🤖'
---

# Mobile App

## Emulation (Android Studio)

Welcome to the Karter project! To contribute you need to configure your environment for Flutter and Android development.

### Prerequisites

Before starting, ensure you have the following installed:
* **Flutter SDK**: Version 3.19.0 or higher.
* **Android Studio**: Latest version for SDK and Emulator management.
* **Linux Tools**: If you are on Fedora, install the build dependencies:
    ```bash
    sudo dnf install clang cmake ninja-build pkgconf-pkg-config gtk3-devel liblzma-devel
    ```

### 1. Android Toolchain Configuration

Flutter requires specific Android components.

#### Install Command-line Tools
1. Open **Android Studio**.
2. Go to **Settings > Languages & Frameworks > Android SDK**.
3. Select the **SDK Tools** tab.
4. Check **Android SDK Command-line Tools (latest)** and click **Apply**.

#### Accept Licenses
Run the following command in your terminal and accept all prompts:
```bash
flutter doctor --android-licenses
```

## Real Devices

### The Lightweight Way: scrcpy (Recommended)
If you have a physical Android device, scrcpy is the fastest way to develop. It mirrors your phone to your desktop with zero lag and minimal CPU usage.

Enable USB Debugging on your phone.

Install scrcpy:
```bash
sudo dnf install scrcpy
```

Connect your phone and run:
```bash
scrcpy --always-on-top --show-touches
```

## Emulation (No Android Studio)
If you prefer a virtual device but want to avoid opening Android Studio:

Create an AVD:
```bash
avdmanager create avd -n KarterDevice -k "system-images;android-34;google_apis;x86_64"
```

Run the emulator:
```bash
emulator -avd KarterDevice -netdelay none -netspeed full
```
