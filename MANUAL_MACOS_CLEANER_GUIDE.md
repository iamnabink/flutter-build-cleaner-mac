# macOS Developer Storage Cleanup & Diagnostic Guide

*A safe, repeatable workflow for Flutter, Android, iOS, and full-stack mobile development.*

---

# 1. Check Overall Disk Usage

## Purpose

Shows how much storage the filesystem is actually using. This is the first sanity check before trusting the macOS Storage UI.

```bash
df -h /
```

**Look for**

* Total Size
* Used
* Available

If disk usage looks reasonable but **System Data** is huge in Settings, macOS is likely miscategorizing storage.

---

# 2. Check Time Machine Local Snapshots

## Purpose

Time Machine can silently create local snapshots that consume tens or even hundreds of GB.

Inspect:

```bash
tmutil listlocalsnapshots /
```

If snapshots exist:

```text
com.apple.TimeMachine.2026-07-15-....
```

then investigate before deleting.

---

# 3. Check APFS Snapshots

## Purpose

APFS keeps system snapshots (usually macOS updates).

Inspect:

```bash
diskutil apfs listSnapshots /
```

Normally you'll only see a macOS update snapshot.

Do **not** delete unless you know exactly why.

---

# 4. Check Virtual Memory

## Purpose

Checks swap files and virtual memory.

Inspect:

```bash
du -sh /private/var/vm
```

Expected:

```
2–8 GB
```

If this folder is unexpectedly huge (50–100 GB), reboot first before investigating further.

---

# 5. Find Largest Folders in Your Home Directory

## Purpose

Shows where your own files are consuming space.

Inspect:

```bash
du -hd 1 ~ 2>/dev/null | sort -h
```

Typical output:

```
Library
Work
Downloads
Desktop
Documents
Office
```

Only investigate the largest folders.

---

# 6. Inspect Library

## Purpose

`~/Library` contains caches, SDKs, simulators, IDE data, application data, and developer tooling.

Inspect:

```bash
du -hd 1 ~/Library 2>/dev/null | sort -h
```

Large folders usually include:

* Android
* Developer
* Application Support
* Containers

These deserve further inspection before deleting anything.

---

# 7. Inspect Android SDK

## Purpose

Shows what parts of the Android SDK are consuming space.

Inspect:

```bash
du -hd 1 ~/Library/Android/sdk | sort -h
```

Typical folders:

```
platforms
build-tools
platform-tools
cmdline-tools
ndk
system-images
emulator
```

---

## Check NDK Versions

```bash
du -hd 1 ~/Library/Android/sdk/ndk | sort -h
```

Many developers accumulate multiple NDK versions over time.

---

## Before Removing NDK Versions

Check whether any project explicitly requires one.

```bash
grep -R "ndkVersion" ~/Work ~/Office 2>/dev/null
```

Only remove versions that are no longer required.

---

# 8. Inspect Xcode Developer Data

## Purpose

Xcode stores build artifacts, simulators, archives, and device support files.

Inspect:

```bash
du -hd 1 ~/Library/Developer 2>/dev/null | sort -h
```

Common folders:

```
Xcode
CoreSimulator
DeviceSupport
```

Investigate large folders before cleaning.

---

# 9. Inspect Application Support

## Purpose

Many applications store databases, backups, AI models, caches, Docker data, browser profiles, etc.

Inspect:

```bash
du -hd 1 ~/Library/Application\ Support 2>/dev/null | sort -h
```

Large entries may include:

* Docker
* Android Studio
* Chrome
* Cursor
* VS Code
* iPhone backups

Review before deleting.

---

# 10. Check Developer Caches

## Purpose

Shows temporary caches that are generally safe to clean.

Inspect:

```bash
du -hd 1 ~/Library/Caches 2>/dev/null | sort -h
```

---

# 11. Check Docker

## Purpose

Docker images and volumes often consume tens or hundreds of GB.

Inspect:

```bash
docker system df
```

Only clean Docker if you understand which images and volumes are still needed.

---

# Safe Cleanup Checklist

These are **cache/build artifacts**. They are recreated automatically.

---

## Gradle Cache

### Inspect

```bash
du -sh ~/.gradle
```

### Clean

```bash
rm -rf ~/.gradle/caches
```

**Effect**

* Frees downloaded Gradle artifacts.
* Automatically rebuilt.

---

## Dart Analysis Cache

### Inspect

```bash
du -sh ~/.dartServer
```

### Clean

```bash
rm -rf ~/.dartServer
```

**Effect**

* Removes analysis/index cache.
* IDE rebuilds it automatically.

---

## Xcode DerivedData

### Inspect

```bash
du -sh ~/Library/Developer/Xcode/DerivedData
```

### Clean

```bash
rm -rf ~/Library/Developer/Xcode/DerivedData
```

**Effect**

* Removes build cache only.
* No source code affected.

---

## iOS Simulators

### Inspect

```bash
xcrun simctl list devices
```

### Clean

```bash
xcrun simctl delete unavailable
```

Only removes obsolete simulators.

---

## Android Emulator (Only if you never use it)

### Inspect

```bash
du -sh ~/Library/Android/sdk/emulator
du -sh ~/Library/Android/sdk/system-images
ls ~/.android/avd
```

### Clean

```bash
rm -rf ~/Library/Android/sdk/emulator
rm -rf ~/Library/Android/sdk/system-images
rm -rf ~/.android/avd
```

Only if you exclusively use physical devices.

---

## Old Android NDK Versions

### Inspect

```bash
du -hd 1 ~/Library/Android/sdk/ndk | sort -h
```

Verify project requirements:

```bash
grep -R "ndkVersion" ~/Work ~/Office 2>/dev/null
```

Then remove only unused versions.

---

## Flutter Build Artifacts

Per project:

```bash
flutter clean
```

Or inspect first:

```bash
find ~/Work -type d -name build
```

Then remove:

```bash
find ~/Work -type d -name build -prune -exec rm -rf {} +
find ~/Office -type d -name build -prune -exec rm -rf {} +
```

---

# Things I Rarely Clean

These save relatively little space compared to the time required to restore them.

* `~/.pub-cache`
* `~/.cocoapods`
* Android SDK `platforms`
* Android SDK `platform-tools`
* Android SDK `build-tools`
* Android SDK `cmdline-tools`

---

# Things I Never Delete Manually

```
/System
/usr
/private
/Library
```

or any system directory unless I know exactly what it contains.

---

# Maintenance Routine (Every 3–6 Months)

1. Check disk usage (`df -h /`)
2. Review top-level folders (`du -hd 1 ~`)
3. Review `~/Library`
4. Clean Gradle cache if large.
5. Clean Dart analysis cache if large.
6. Remove Xcode `DerivedData`.
7. Delete unavailable simulators.
8. Review Android SDK and remove obsolete NDK versions.
9. Review Docker usage (if installed).
10. Empty Trash.

---

## Results from this cleanup (your case)

* ✅ Reclaimed approximately **100 GB**.
* ✅ No project source code removed.
* ✅ No Flutter SDK removed.
* ✅ No Android SDK essentials removed.
* ✅ No iOS SDK removed.
* ✅ Only caches, obsolete emulator assets, and unused NDK versions were deleted.

This workflow is safe, repeatable, and scales well for a professional mobile developer maintaining Flutter, Android, and iOS projects over many years.
