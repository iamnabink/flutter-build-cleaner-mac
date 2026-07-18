# MacOS Broomie - Mobile Development Artifact Cleaner

## 📥 Download Broomie

<div>

[![Download on the Mac App Store](https://tools.applemediaservices.com/api/badges/download-on-the-mac-app-store/black/en-us?size=250x83&releaseDate=1733011200)](https://apps.apple.com/us/app/broomie-appbuild-dev-cleaner/id6755060683?mt=12)

[![Download Broomie.dmg](https://img.shields.io/badge/⬇️%20Download-Broomie.dmg-blue?style=for-the-badge&logo=apple&logoColor=white)](https://raw.githubusercontent.com/iamnabink/flutter-build-cleaner-mac/main/Broomie.dmg)

**✅ Safety & Security Assurance:**
- 🔒 **Code-Signed** - The DMG file is signed with an Apple Developer ID Application certificate
- ✅ **Notarized by Apple** - The app has been notarized by Apple, ensuring it's free of malware
- 🛡️ **100% Safe** - No security warnings, no malware, completely safe to install
- ✨ **Verified** - The app bundle and DMG are both signed and verified

**Quick Install:**

**Option 1 - Mac App Store (Recommended):**
1. Click the "Download on the Mac App Store" button above
2. Install directly from the App Store
3. Launch from Applications or Spotlight

**Option 2 - Direct Download (DMG):**
1. Click the "Download Broomie.dmg" button above
2. Open the downloaded DMG file
3. Drag **Broomie** to your Applications folder
4. Launch from Applications - **No security warnings!**

---

</div>

<div align="center">
  <img src="assets/images/screenshot1.png" alt="App Screenshot 1" width="25%">
  <img src="assets/images/screenshot2.png" alt="App Screenshot 2" width="25%">
  <img src="assets/images/screenshot3.png" alt="App Screenshot 3" width="25%">
  <img src="assets/images/screenshot4.png" alt="App Screenshot 4" width="25%">
</div>

A powerful macOS desktop application built with Flutter that helps mobile developers clean up unnecessary build artifacts from their system to free up disk space.

## Why I Built This App

As a mobile developer working with Flutter and React Native, I constantly faced the problem of **massive build artifacts consuming gigabytes of disk space**. This app automatically scans your system, identifies build artifacts, and safely removes them to free up space.

### The Problem
- **Flutter builds** accumulate quickly across multiple projects
- **React Native node_modules** folders grow to hundreds of MBs each
- **iOS Archives** in DerivedData can reach several GBs
- **Android APK/AAB files** pile up in build folders
- **Manual cleanup** is tedious and error-prone

### The Solution
Broomie automatically scans, identifies, and safely removes build artifacts (never source code), saving hours of manual cleanup work.

## Installation

**From Mac App Store (Recommended):**
1. Click the "Download on the Mac App Store" button at the top
2. Install directly from the App Store
3. Launch from Applications or Spotlight
4. **Grant permission** when prompted to access your home directory

**Direct Download (DMG):**
1. **Download the latest DMG** from the [Releases](https://github.com/iamnabink/flutter-build-cleaner-mac/releases) page or click the DMG download button at the top
2. **Open the DMG file** and drag **Broomie** to your Applications folder
3. **Launch** from Applications or Spotlight
4. **Grant permission** when prompted to access your home directory

## What It Cleans

- **APK/AAB/IPA files** (Android/iOS packages)
- **Flutter build folders** (`build/` directories)
- **React Native build folders** (`android/app/build/`, `ios/build/`)
- **iOS Archives** (DerivedData `.xcarchive` files)
- **node_modules folders** (React Native dependencies)

## Safety Features

- ✅ **Never deletes source code** - Only targets build artifacts
- ✅ **Skips system directories** - Protects important system files
- ✅ **Preview before delete** - See exactly what will be removed
- ✅ **Open in Finder** - Right-click any item to inspect it

## System Requirements

- **macOS 10.15** or later
- **50MB** free disk space for the app
- **File system access** permission (granted on first launch)

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

## macOS Distribution & Code Signing Guide

### Distribution Formats

| Format | Best For | Signing | Notarization |
|--------|----------|---------|--------------|
| **DMG** | Direct downloads | Recommended | Required (10.15+) |
| **PKG** | Professional/Enterprise | Recommended | Required (10.15+) |
| **App Store** | Consumer apps | Required | Not needed |

### Code Signing Certificates

**For Local Distribution (Outside App Store):**
- ✅ **Developer ID Application** - Required for signing .app bundles (DMG files)
- ✅ **Developer ID Installer** - Required for signing .pkg installers

**For App Store Distribution:**
- ✅ **Apple Distribution** - For .app bundles
- ✅ **Mac Installer Distribution** - For .pkg installers

**Certificate Types:**
- 🍎 **Apple certificates** = App Store distribution
- 🆔 **Developer ID certificates** = External distribution

### How to Get Certificates

**In Xcode:**
1. Xcode → Preferences → Accounts
2. Select your Apple ID → "Manage Certificates"
3. Click "+" → Select:
   - **Developer ID Application** (for DMG)
   - **Developer ID Installer** (for PKG)

### Signing Commands

```bash
# Sign app (Developer ID)
codesign --force --deep --sign "Developer ID Application: Your Name (TEAM_ID)" \
         --options runtime --timestamp "YourApp.app"

# Verify signature
codesign --verify --verbose "YourApp.app"
codesign -dvv "YourApp.app"  # Show detailed signing info

# Check Gatekeeper
spctl --assess --verbose "YourApp.app"
```

### Notarization (Required for External Distribution)

```bash
# 1. Sign app with Developer ID
codesign --force --deep --sign "Developer ID Application: Your Name (TEAM_ID)" \
         --options runtime --timestamp "YourApp.app"

# 2. Create ZIP
ditto -c -k --keepParent "YourApp.app" "YourApp.zip"

# 3. Submit for notarization
xcrun notarytool submit YourApp.zip \
      --apple-id your@email.com \
      --team-id TEAM_ID \
      --password app-specific-password \
      --wait

# 4. Staple ticket
xcrun stapler staple "YourApp.app"
```

**App-Specific Password:** Create at appleid.apple.com → Security → App-Specific Passwords

### Creating DMG/PKG

**Using Scripts (Recommended):**
```bash
# Create DMG
./create_dmg.sh
```

**What `create_dmg.sh` Does Automatically:**

Your `create_dmg.sh` script handles everything for you:

- ✅ **Automatically notarizes each build** - If credentials are in `notarization.config`
- ✅ **Signs the app** - With your Developer ID certificate
- ✅ **Submits to Apple** - For automated notarization
- ✅ **Staples the notarization ticket** - To the app bundle
- ✅ **Creates the DMG** - With background text and proper layout
- ✅ **Signs the DMG** - Final DMG is signed and ready

**Each time you run `./create_dmg.sh`:**

1. It builds a new app
2. Signs it with your Developer ID certificate
3. Notarizes it (if credentials are configured in `notarization.config`)
4. Creates the DMG with all customizations
5. Signs the final DMG

**DMG Creation Process Flow:**

The `create_dmg.sh` script automates the entire process:

1. **🔨 Build** - Compiles the Flutter app for macOS release
2. **✍️ Sign** - Signs the app bundle with Developer ID certificate
3. **✅ Verify** - Verifies the app signature is valid
4. **📤 Notarize** - Submits app to Apple for automated notarization (2-5 minutes)
   - Scans for malware and security issues
   - Staples notarization ticket to app if accepted
5. **💿 Create DMG** - Creates DMG with app bundle and Applications alias
6. **🎨 Customize** - Adds background text with installation instructions
7. **🔒 Convert** - Converts to read-only compressed format (UDZO)
8. **✍️ Sign DMG** - Signs the final DMG file
9. **✅ Ready** - DMG is ready for distribution!

**Note:** Notarization is automated and requires no manual approval. Apple scans the app automatically (usually completes in 2-5 minutes). If notarization fails or times out, the script continues without it (app will still work but may show security warnings).

**From Xcode:**
1. Product → Archive
2. Distribute App → Developer ID (for external) or App Store Connect
3. Export signed .app bundle
4. Use `create-dmg` or `pkgbuild` to create DMG/PKG

**Manual DMG Creation:**
```bash
create-dmg \
  --volname "Your App Name" \
  --window-pos 200 120 \
  --window-size 800 500 \
  --icon-size 120 \
  --icon "YourApp.app" 200 200 \
  --hide-extension "YourApp.app" \
  --app-drop-link 600 200 \
  "YourApp.dmg" \
  "/path/to/YourApp.app"
```

**Manual PKG Creation:**
```bash
pkgbuild --root "$STAGING_DIR" \
         --identifier "com.yourcompany.yourapp" \
         --version "1.0.0" \
         --install-location "/Applications" \
         --component-plist "$COMPONENT_PLIST" \
         --sign "$SIGNING_IDENTITY" \
         "YourApp.pkg"
```

### Common Signing Errors

| Error | Cause | Fix |
|-------|-------|-----|
| "App is damaged" | Invalid signature | Re-sign the app |
| "Unidentified developer" | Not signed with Developer ID | Sign with Developer ID and notarize |
| "Certificate no longer valid" | Certificate expired | Renew certificate |
| "No signing certificate found" | No certificate in Keychain | Create certificate in Xcode |
| "Resource fork not allowed" | Extra metadata | Run `xattr -cr "YourApp.app"` |

### External Distribution vs App Store

**External Distribution (Developer ID):**
- ✅ Full control, no review, no revenue cut
- ❌ Must handle notarization, no auto-updates

**App Store:**
- ✅ Trusted, auto-updates, payment processing
- ❌ 30% revenue cut, review process, sandbox restrictions

### Quick Reference

**Check Signing Info:**
```bash
codesign -dvv "YourApp.app"           # Detailed signing info
codesign --verify --verbose "YourApp.app"  # Verify signature
spctl --assess --verbose "YourApp.app"     # Check Gatekeeper
```

**Distribution Comparison:**
| Feature | DMG | PKG | App Store |
|---------|-----|-----|-----------|
| User Experience | Good | Excellent | Excellent |
| Signing Required | Recommended | Recommended | Required |
| Notarization | Required | Required | Not needed |
| Revenue Cut | None | None | 30% |

### Resources

- [Apple Developer Documentation](https://developer.apple.com/documentation/)
- [Code Signing Guide](https://developer.apple.com/library/archive/documentation/Security/Conceptual/CodeSigningGuide/)
- [Notarization Guide](https://developer.apple.com/documentation/security/notarizing_macos_software_before_distribution)
- [create-dmg Tool](https://github.com/create-dmg/create-dmg)

---

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
