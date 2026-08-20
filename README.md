<div align="center">

# 🧹 Broomie

**Reclaim gigabytes from mobile-dev build artifacts — in one click.**

A native macOS app that finds the `build/`, `node_modules/`, `.xcarchive` and
`DerivedData` junk scattered across every project on your Mac, shows you exactly
what it costs you, and cleans it safely.

[![Mac App Store](https://img.shields.io/badge/Mac%20App%20Store-Download-0D96F6?style=for-the-badge&logo=apple&logoColor=white)](https://apps.apple.com/us/app/broomie-appbuild-dev-cleaner/id6755060683?mt=12)
[![Download DMG](https://img.shields.io/badge/Direct%20Download-.dmg-555?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/iamnabink/macOs-mobile-dev-cleaner/releases/latest)

![Platform](https://img.shields.io/badge/macOS-10.15%2B-lightgrey)
![Built with Flutter](https://img.shields.io/badge/built%20with-Flutter-02569B?logo=flutter&logoColor=white)
![Signed & Notarized](https://img.shields.io/badge/signed%20%26%20notarized-by%20Apple-success)
[![Latest release](https://img.shields.io/github/v/release/iamnabink/macOs-mobile-dev-cleaner)](https://github.com/iamnabink/macOs-mobile-dev-cleaner/releases/latest)
[![License](https://img.shields.io/badge/license-PolyForm%20Noncommercial-blue)](LICENSE)

<img src="assets/images/appstore/broomie_appstore_1.png" alt="Broomie scanning for build artifacts" width="90%">

</div>

---

## Why

As a mobile developer you accumulate build output faster than you notice it:

| Culprit | Typical damage |
| --- | --- |
| Flutter `build/` folders | hundreds of MB, times every project |
| `node_modules/` | 200–800 MB each |
| Xcode DerivedData & `.xcarchive` | several GB |
| Stray APK / AAB / IPA files | steadily piling up |

Cleaning it by hand means hunting through directories and hoping you don't
delete something that matters. Broomie does the hunting, shows the totals, and
**never touches source code**.

## Install

**Mac App Store** *(recommended — auto-updates)*
→ [apps.apple.com](https://apps.apple.com/us/app/broomie-appbuild-dev-cleaner/id6755060683?mt=12)

**Direct download**
→ grab the `.dmg` from [Releases](https://github.com/iamnabink/macOs-mobile-dev-cleaner/releases/latest), open it, drag Broomie to Applications.

Every release is **code-signed with an Apple Developer ID certificate and
notarized by Apple**, so it opens with no security warning. On first launch
macOS asks permission to access your home directory — Broomie needs it to scan
your projects.

## What it cleans

- **Flutter** — `build/` directories
- **React Native / Node** — `node_modules/`, `android/app/build/`, `ios/build/`
- **iOS** — DerivedData and `.xcarchive` files
- **Packages** — stray `.apk`, `.aab`, `.ipa`

## Safety

- **Never deletes source code** — build artifacts only
- **Skips system directories**
- **Preview before deleting** — see exactly what goes
- **Open in Finder** — right-click any item to inspect it first

## Requirements

macOS 10.15 (Catalina) or later · Intel or Apple Silicon · ~50 MB free

## Screenshots

| | |
| :---: | :---: |
| <img src="assets/images/appstore/broomie_appstore_2.png" alt="Scan results with per-project sizes"> | <img src="assets/images/appstore/broomie_appstore_3.png" alt="Reclaiming Xcode DerivedData"> |
| **See what's eating the disk** — every project, sorted by size | **Xcode caches** — usually the biggest single win |
| <img src="assets/images/appstore/broomie_appstore_4.png" alt="Guided deep-clean routine"> | <img src="assets/images/appstore/broomie_appstore_5.png" alt="Detail view showing what is safe to delete"> |
| **Guided deep clean** — step through it safely | **Know before you delete** — inspect anything first |

---

## Building from Source

```bash
git clone https://github.com/iamnabink/macOs-mobile-dev-cleaner.git
cd macOs-mobile-dev-cleaner

# REQUIRED: create your local .env (the build fails without it — it's a bundled asset)
cp .env.example .env

flutter pub get
flutter run -d macos
```

**About `.env`:** the only variable is `REVENUECAT_API_KEY` (RevenueCat public
SDK key for in-app purchases). **Leave it empty** — the app runs fully
featured with the Pro/paywall UI hidden. Never commit your `.env`.

The UI is built entirely with [macos_ui](https://pub.dev/packages/macos_ui).
See [CLAUDE.md](CLAUDE.md) for architecture notes and conventions.

---

## CI/CD

[![Release](https://github.com/iamnabink/macOs-mobile-dev-cleaner/actions/workflows/release.yml/badge.svg)](https://github.com/iamnabink/macOs-mobile-dev-cleaner/actions/workflows/release.yml)

One tag ships both channels. GitHub Actions builds on `macos-latest`, signs and
notarizes with Apple, uploads the `.pkg` to App Store Connect and attaches the
notarized `.dmg` to a GitHub Release — no local Xcode step, and no fastlane
(`xcrun altool` and `notarytool` do the work, authenticated with an App Store
Connect API key).

## Releasing

Both distribution channels are built by
[`.github/workflows/release.yml`](.github/workflows/release.yml) from a single
tag — no manual signing, notarizing or uploading.

```bash
git tag v9.0.1 && git push origin v9.0.1
```

| Job | Produces | Goes to |
| --- | --- | --- |
| `testflight` | signed `.pkg` | App Store Connect → TestFlight → Mac App Store |
| `dmg` | signed + notarized `.dmg` | GitHub Release |

### Releasing one channel only

A suffix on the tag selects the channel:

| Tag | TestFlight | GitHub Release |
| --- | :---: | :---: |
| `v9.0.1` | ✅ | ✅ |
| `v9.0.1-testflight` | ✅ | — |
| `v9.0.1-dmg` | — | ✅ |

The suffix is stripped from the version label, so `v9.0.1-dmg` still produces
`Broomie-v9.0.1.dmg`.

### Building without publishing

Actions → Release → **Run workflow**, then choose:

- **target** — `both`, `testflight` or `dmg`
- **publish** — `false` builds and attaches the artifacts to the run without
  uploading to App Store Connect or creating a GitHub Release

Useful for testing a pipeline change without burning a version number: both
stores reject a re-used build number, so a failed publish costs you one.

**Bump the version first** — both stores reject a re-used build number:

```yaml
# pubspec.yaml
version: 9.0.1+13
```

### How signing works

Two different Apple credentials, for two different purposes:

- **Mac App Store** — the archive is signed with an *Apple Distribution*
  certificate and a Mac App Store provisioning profile, both created on demand
  by Xcode cloud signing (`-allowProvisioningUpdates` authenticated with the
  App Store Connect API key). Nothing has to exist on the machine beforehand.
- **Direct download** — the app is signed with a *Developer ID Application*
  certificate (hardened runtime, `--options runtime`), then notarized by Apple
  and stapled, so Gatekeeper opens it offline with no warning. The `.dmg` is
  signed and notarized separately from the `.app` inside it.

Notarization uses the same App Store Connect API key as the upload, so no Apple
ID or app-specific password is involved.

### Required secrets

Stored in the `release` **environment** (Settings → Environments → release),
which each job declares with `environment: release`.

| Secret | Used by |
| --- | --- |
| `ASC_KEY_P8` | both — base64 of the App Store Connect `.p8` key |
| `ASC_KEY_ID` | both |
| `ASC_ISSUER_ID` | both |
| `APPLE_TEAM_ID` | both |
| `REVENUECAT_API_KEY` | both — see below |
| `MACOS_CERTIFICATE` | dmg — base64 of the Developer ID `.p12` |
| `MACOS_CERTIFICATE_PWD` | dmg |
| `KEYCHAIN_PASSWORD` | dmg, optional (throwaway CI keychain) |

> [!IMPORTANT]
> `.env` is a **declared asset** in `pubspec.yaml` but is gitignored, so CI must
> recreate it or the build fails outright with
> `No file or variants found for asset: .env`. That is what
> `REVENUECAT_API_KEY` is for. Leave the secret empty to ship without in-app
> purchases — the Pro/paywall UI hides itself (see `lib/config/env.dart`).
>
> The RevenueCat *public SDK key* ships inside the app bundle by design, like a
> Firebase API key. The secret keeps it out of this public repo's history, not
> out of the binary.

> [!WARNING]
> When exporting the Developer ID `.p12`, export **only that identity** and
> **include its private key**. Exporting "all identities" from a shared login
> keychain also exports every other developer's private key.

### Releasing locally

`./create_dmg.sh` still builds, signs and notarizes a DMG from your Mac using
`notarization.config` (gitignored: `APPLE_ID`, `APPLE_APP_PASSWORD`,
`TEAM_ID`). CI is the normal path; the script is there for testing the pipeline
without cutting a tag.

## License

[PolyForm Noncommercial 1.0.0](LICENSE) — free to use, modify and share for any
**noncommercial** purpose: personal projects, study, research, hobby work, and
use by charities, schools, and public institutions.

**Selling it, or using it commercially, needs permission.** Broomie is a paid
app on the Mac App Store, and this license keeps that intact while leaving the
source open to read, learn from, fork and contribute to.

Want to use it commercially? [Open an issue](https://github.com/iamnabink/macOs-mobile-dev-cleaner/issues/new) or get in touch.

## Contributing

We welcome contributions! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting a pull request.

**Found a bug or have a feature request?**
- 🐛 [Report a Bug](https://github.com/iamnabink/macOs-mobile-dev-cleaner/issues/new?template=bug_report.md)
- ✨ [Request a Feature](https://github.com/iamnabink/macOs-mobile-dev-cleaner/issues/new?template=feature_request.md)
- 📖 [Documentation Issue](https://github.com/iamnabink/macOs-mobile-dev-cleaner/issues/new?template=documentation.md)

**Quick Start:**
1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Make your changes
4. Commit with clear messages (`git commit -m 'feat: add amazing feature'`)
5. Push to your branch (`git push origin feat/amazing-feature`)
6. Open a Pull Request

For detailed information about our development workflow, code standards, and PR process, see [CONTRIBUTING.md](CONTRIBUTING.md).

---

## Made With Love

**Broomie** was created by **Nabraj Khadka** - Mobile Developer & Flutter Enthusiast

**Connect with me:**
- 🔗 [LinkedIn](https://linkedin.com/in/iamnabink)
- 💻 [GitHub](https://github.com/iamnabink)

*Building tools that make developers' lives easier, one app at a time!* ✨

---

**Version 6.0.0 • Build 6**

*Free up your disk space and focus on what matters - building amazing mobile apps!* 🚀
