---
sidebar_position: 2
title: Development Setup
---

# Moblie App

Welcome to the Karter project! [cite_start]To contribute to our **Local-First** vehicular maintenance app[cite: 2, 17], you need to configure your environment for Flutter and Android development.

## Prerequisites

Before starting, ensure you have the following installed:
* [cite_start]**Flutter SDK**: Version 3.19.0 or higher.
* **Android Studio**: Latest version for SDK and Emulator management.
* **Fedora/Linux Tools**: If you are on Fedora, install the build dependencies:
    ```bash
    sudo dnf install clang cmake ninja-build pkgconf-pkg-config gtk3-devel liblzma-devel
    ```

## 1. Android Toolchain Configuration

[cite_start]Flutter requires specific Android components to manage the **MVP Phase 1** features[cite: 19].

### Install Command-line Tools
1. Open **Android Studio**.
2. Go to **Settings > Languages & Frameworks > Android SDK**.
3. Select the **SDK Tools** tab.
4. Check **Android SDK Command-line Tools (latest)** and click **Apply**.

### Accept Licenses
Run the following command in your terminal and accept all prompts:
```bash
flutter doctor --android-licenses