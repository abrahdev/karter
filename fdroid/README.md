# F-Droid

Karter is published on F-Droid. This directory contains the build recipe reference.

## Recipe (for fdroiddata)

To include Karter in the official F-Droid repository, add the following metadata to
[fdroiddata](https://gitlab.com/fdroid/fdroiddata):

```yaml
Categories: Utilities, Sports
License: AGPL-3.0-or-later
WebSite: https://abrahdev.github.io/karter/
SourceCode: https://github.com/abrahdev/karter
IssueTracker: https://github.com/abrahdev/karter/issues
Changelog: https://abrahdev.github.io/karter/roadmap

Name: Karter
AutoName: Karter
Summary: Open source vehicle maintenance tracker
Description: |
  Karter is an open source, local-first vehicle maintenance tracker.

  Track fuel consumption, log maintenance and repairs, monitor service
  intervals, and manage your vehicle fleet — all offline, no account required.

  Features:
  • Multi-vehicle management
  • Fuel economy tracking (MPG, L/100km, km/L)
  • Maintenance log with customizable intervals
  • Spare parts and replacement tracking
  • JSON export
  • Odometer readings (km/mi)
  • OBD-II integration (ELM327) - coming soon
  • Material Design 3 with dark mode

  Privacy-first: all data stays on your device. No telemetry, no
  tracking, no accounts. Licensed under AGPL v3.

RepoType: git
Repo: https://github.com/abrahdev/karter

Builds:
  - versionName: 2026.06.4-alpha
    versionCode: 1
    commit: v2026.06.4-alpha
    subdir: mobile
    init:
      - flutter pub get
    build:
      - flutter build apk --release

AllowedAPKSigningKeys: FCD8A9CBA2D98D376FABC1BBF755ACCDB4B2F3BF6F497FC3FB710FB97B46F582

AutoUpdateMode: Version
UpdateCheckMode: Tags
UpdateCheckData: VERSION|.*|v(.*)
CurrentVersion: 2026.06.4-alpha
CurrentVersionCode: 1
```

## Updating

1. Tag a new release on GitHub matching the version in `VERSION`
2. Update the recipe version and commit hash
3. Submit to fdroiddata

## Fastlane metadata

Android store metadata lives in `mobile/fastlane/metadata/android/`. F-Droid
reads these files automatically for app store listings.
