# CLAUDE.md

Guidance for AI coding agents (and new contributors) working in this repo.

## Project

**Broomie** (pubspec name `flutter_cleaner`) — an open-source, macOS-only
Flutter desktop app that cleans mobile-development build artifacts (APK/AAB/IPA
files, Flutter/React Native/Android/iOS build folders, node_modules, Xcode
caches). Distributed via the Mac App Store and a signed/notarized DMG.

## Build & run

```bash
cp .env.example .env        # REQUIRED before first build — .env is a declared
                            # asset; a missing file fails `flutter build`.
flutter pub get
flutter run -d macos        # run the app
flutter build macos         # release build
flutter analyze             # lint — keep error-free
```

- `.env` holds `REVENUECAT_API_KEY` (optional). Leave it empty to run without
  in-app purchases: `RevenueCatService.isConfigured` stays false and all
  Pro/paywall UI is hidden. Never commit `.env` (gitignored); update
  `.env.example` when adding variables, and read them only via
  `EnvConfig` (`lib/config/env.dart`).
- `notarization.config` (untracked) holds DMG notarization credentials used by
  `./create_dmg.sh`.

## Architecture

- **UI framework: `macos_ui` only.** No Material or Cupertino chrome —
  `CupertinoIcons` glyphs (usually inside `MacosIcon`) are the one exception.
  Typography comes from `MacosTheme.of(context).typography` (system font — no
  font packages).
- **App shell**: `main.dart` → macos_window_utils config → dotenv →
  RevenueCat init → `BroomieApp` (`app.dart`, a `MacosApp` with
  `ThemeMode.system`) → `MainView` (`lib/pages/main_view.dart`):
  `MacosWindow` + `Sidebar` driven by the `AppSection` enum, body is a
  lazily-built `IndexedStack` so scans survive section switches. The Pro
  section only appears when `RevenueCatService.isConfigured`. Jump to a
  section from anywhere via `MainView.section.value = AppSection.x`.
- **Theme layer** (`lib/theme/`): `AppTheme` (MacosThemeData light/dark) and
  `AppColors` — semantic, brightness-resolved tokens accessed as
  `context.colors.accent/danger/cardBackground/...`. **Never use raw
  `CupertinoColors`/hardcoded palette colors in widgets**; add a token instead.
  Card idiom: flat `cardBackground` fill + `separator` border, radius 10 —
  no gradients or box shadows.
- **Part-file convention (legacy)**: the two big pages —
  `lib/pages/cleaner_home_page.dart` and
  `lib/pages/xcode_cache_cleaner_page.dart` — are libraries whose services,
  utils, and widgets live in `part` files (`lib/services/*`, `lib/utils/*`,
  `lib/widgets/*`, `lib/widgets/xcode/*`) as extensions on the private State
  class. Part files inherit the parent library's imports — add imports in the
  page file, not the part. Adding UI/logic to these pages means adding
  extension methods. Refactoring toward standalone widgets + injectable
  services is a welcome follow-up, but don't mix it into feature PRs.
- **Manual Guide**: content model in `lib/models/guide_models.dart`, data in
  `lib/data/manual_guide_data.dart` (mirrors `MANUAL_MACOS_CLEANER_GUIDE.md` —
  keep both in sync), UI in `lib/pages/guide/`, checklist persistence in
  `lib/services/guide_progress_service.dart` (shared_preferences).
  Commands can be executed in-app via `ShellCommandService` (`/bin/sh -c` with
  `$HOME` corrected to the real home — the sandbox container path is wrong for
  `~`); destructive commands (`rm -rf`, `simctl delete`) get a confirmation
  dialog first, and sandbox-denied output surfaces a hint to grant access or
  use Terminal. The guide toolbar shows root-volume free space via
  `StorageInfoService` (`df -k /`), refreshed manually or after any executed
  command.
- **Purchases**: `lib/services/revenue_cat_service.dart` wraps
  purchases_flutter; entitlement id is `lifetime_supporter`. Gate every
  purchase-related UI/entry point on `RevenueCatService.isConfigured`.

## Gotchas

- `macos/Runner/MainFlutterWindow.swift` contains the **macos_window_utils
  bootstrap** required by `MacosWindow` AND the `com.broomie/storage` method
  channel (Finder-accurate free space via
  `volumeAvailableCapacityForImportantUsage` — `df` undercounts because it
  excludes purgeable space). Never regenerate it from the stock Flutter
  template.
- `macos/Podfile` pins pod deployment target to 10.15 (macos_ui transitive
  pods use 10.14+ APIs).
- Dialogs use `showMacosAlertDialog`/`MacosAlertDialog` (its `appIcon` is
  required — use `assets/images/icon.png`) and `showMacosSheet` for >2-action
  or rich content.
- `ProgressBar`/`ProgressCircle` values range **0–100**, not 0–1.
- Pages live in an `IndexedStack`, so hidden pages stay alive — gate
  animations/timers on state (e.g. `_isScanning`), never run them
  unconditionally in `build()`.
