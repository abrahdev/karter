# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2026.07.13+17] - 2026-07-26

### Changed

- Subscription model: single `karter_supporter` product with 3 base plans (bronze/silver/gold monthly)
- Product IDs aligned with Google Play Console

## [2026.07.12+16] - 2026-07-26

### Added

- In-app purchases for tip program (Google Play Billing)
- 6 purchase tiers: Bronze/Silver/Gold × one-time + monthly subscription
- Supporter badge for purchasers
- Restore purchases option
- Multi-file document attachments
- Full-screen photo viewer with share
- Document files open with system viewer on tap

### Fixed

- CarouselView tap now opens full-screen photo viewer
- Spanish translations: placa → matrícula, voseo → tuteo throughout

## [2026.07.11+15] - 2026-07-26

### Added

- Full haptic feedback system with 3 modes (Off/Clear/Rich) (#41)
- Haptic mode selector with demo vibration on select
- Escalating haptic methods: lightTap, mediumTap, heavyTap, success, warning, delete
- Base widgets: KarterSwitchListTile and KarterSegmentedButton with auto-haptic
- Odometer dialog: hold-to-repeat with acceleration, symmetric layout
- Shake-to-odometer with disable toggle (#37)
- Notification permission modal with official flutter_local_notifications API (#40)
- Slider haptic feedback on onChangeEnd

### Fixed

- Language label in More page always showing "English" regardless of selected locale

### Changed

- Migrated all toggles and segmented buttons to new base widgets
- Removed permission_handler dependency

## [2026.07.10+14] - 2026-07-21

### Added

- M3 design overhaul: responsive 2-column layouts for Vehicle Detail & More pages
- Vehicle form redesigned with 4-card M3 layout
- VehicleCard context menu (long-press / right-click: Edit, Add to dashboard, Setup notifications)
- Shared SectionHeader widget for consistent section titles
- Global AppSpacing.pagePadding constant
- Roboto font family applied globally
- Changelog now shows as modal bottom sheet with current version only

### Fixed

- Restore Docs & Onboarding Replay in Feedback section
- Restore Data & Security section in More page
- Template Source disabled icon (cloud_off)

## [2026.07.9+13] - 2026-07-18

### Added

- Interface color toggle for M3 surface tinting
- Custom color toggle with real-time system accent detection
- Language picker (System / English / Spanish / Eesti)
- Haptic feedback toggle
- Feedback & rating page with configurable reminders (#27)
- Onboarding walkthrough (#15)
- In-app rating prompt after saving maintenance log (#17)
- Changelog, privacy policy, and tips pages

### Fixed

- Changelog asset loading (CHANGELOG.md added to Flutter assets)
- GoRouter usage in MaterialApp.builder (#23)

### Changed

- Reorganized More page with Material 3 grouped cards
- Updated Estonian translations (#24, #25, #26)

## [2026.07.8+12] - 2026-07-14

### Added

- Template source toggle (online GitHub / local offline)
- Template detail modal and interactive browser
- Motorcycle templates (Honda, Yamaha, Suzuki, Kawasaki, Benelli)
- Autocomplete for brand/model from template index

### Changed

- Upgraded all dependencies to latest versions
- Reorganized templates directory structure
- Split template translations from ARB to i18n JSON

## [2026.07.7+11] - 2026-07-10

### Added

- Vehicle documents with FAB speed dial and modal upload
- PDF export with tab layout and i18n support
- Service cost and vehicle currency fields
- Photos on service records (camera/gallery)
- Template search on vehicle creation with maintenance interval i18n

### Fixed

- Template search validation (brand/model/year only)
- Autocomplete overlay flicker (remove setState from onChanged)
- Modal theme adaptation with div layout

## [2026.07.6+10] - 2026-07-07

### Added

- Notification system with odometer and maintenance reminders
- FAB speed dial animation (staggered entry, rotation)
- Material Motion animations for modals and bottom sheets
- VehicleDocument export/import with base64 inline files

### Fixed

- Double Dialog in `karterShowDialog`
- ListTile ink splash on More page
- Notification list not refreshing after settings change
- Reset `odometerReminderLastNotified` on odometer update
- Unused imports, deprecated RadioListTile & DropdownButtonFormField.value

### Changed

- Migrated all modals to bottom sheets with M3 motion tokens
- Cleaned up unused imports and deprecated widgets

## [2026.07.5+9] - 2026-07-07

### Added

- Initial changelog tracking

[Unreleased]: https://github.com/abrahdev/karter/compare/v2026.07.11...HEAD
[2026.07.11+15]: https://github.com/abrahdev/karter/compare/v2026.07.10...v2026.07.11
[2026.07.9+13]: https://github.com/abrahdev/karter/compare/v2026.07.8-alpha...v2026.07.9
[2026.07.8+12]: https://github.com/abrahdev/karter/compare/v2026.07.7-alpha...v2026.07.8-alpha
[2026.07.7+11]: https://github.com/abrahdev/karter/compare/v2026.07.4+6...v2026.07.7-alpha
[2026.07.6+10]: https://github.com/abrahdev/karter/compare/v2026.07.4+6...v2026.07.6
[2026.07.5+9]: https://github.com/abrahdev/karter/releases/tag/v2026.07.4+6
