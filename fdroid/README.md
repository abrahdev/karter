# F-Droid

Karter is published on F-Droid. This directory contains the build recipe reference.

## Recipe (for fdroiddata)

To include Karter in the official F-Droid repository, add the following metadata to
[fdroiddata](https://gitlab.com/fdroid/fdroiddata):

```yaml
Categories:Utilities,Sports
License:AGPL-3.0-or-later
Web Site:https://abrahdev.github.io/karter/
Source Code:https://github.com/abrahdev/karter
Issue Tracker:https://github.com/abrahdev/karter/issues
Changelog:https://abrahdev.github.io/karter/roadmap

Name:Karter
Auto Name:Karter
Summary:Open source vehicle maintenance tracker
Description: |-
    Karter is an open source, local-first vehicle maintenance tracker.

    Track fuel consumption, log maintenance and repairs, monitor service
    intervals, and manage your vehicle fleet — all offline, no account
    required.

    Features:
    • Multi-vehicle management
    • Fuel economy tracking (MPG, L/100km, km/L)
    • Maintenance log with customizable intervals
    • Spare parts and replacement tracking
    • CSV export
    • Odometer readings (km/mi)
    • OBD-II integration (ELM327) — coming soon
    • Material Design 3 with dark mode

    Privacy-first: all data stays on your device. No telemetry, no
    tracking, no accounts. Licensed under AGPL v3.

Repo Type:git
Repo:https://github.com/abrahdev/karter

Build:
  - commit: v2026.06.4-alpha
    subdir: mobile
    init:
      - flutter pub get
    build:
      - flutter build apk --release

AllowedAPKSigningKeys:sha256:FC:D8:A9:CB:A2:D9:8D:37:6F:AB:C1:BB:F7:55:AC:CD:B4:B2:F3:BF:6F:49:7F:C3:FB:71:0F:B9:7B:46:F5:82

AutoUpdateMode:Version
UpdateCheckMode:Tags
UpdateCheckData:VERSION|.*|v(.*)
CurrentVersion:2026.06.4-alpha
CurrentVersionCode:1
```

## Updating

1. Tag a new release on GitHub matching the version in `VERSION`
2. Update the recipe version and commit hash
3. Submit to fdroiddata

## Fastlane metadata

Android store metadata lives in `mobile/fastlane/metadata/android/`. F-Droid
reads these files automatically for app store listings.
