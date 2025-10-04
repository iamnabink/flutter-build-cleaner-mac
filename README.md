# AppBuild Dev Cleaner - Mobile Development Artifact Cleaner

<div align="center">
  <img src="assets/images/screenshot1.png" alt="App Screenshot 1" width="45%">
  <img src="assets/images/screenshot2.png" alt="App Screenshot 2" width="45%">
</div>

A powerful macOS desktop application built with Flutter that helps mobile developers clean up unnecessary build artifacts from their system to free up disk space.

## Why I Built This App

As a mobile developer working with Flutter and React Native, I constantly faced the problem of **massive build artifacts consuming gigabytes of disk space**. Here's why this app was necessary:

### The Problem
- **Flutter builds** accumulate quickly across multiple projects
- **React Native node_modules** folders grow to hundreds of MBs each
- **iOS Archives** in DerivedData can reach several GBs
- **Android APK/AAB files** pile up in build folders
- **Manual cleanup** is tedious and error-prone
- **Developers forget** to run `flutter clean` or `npm clean`
- **Disk space** becomes a constant concern

### The Solution
AppBuild Dev Cleaner automatically:
- **Scans** your entire system for mobile development artifacts
- **Identifies** Flutter builds, React Native builds, iOS Archives, Android builds, and more
- **Shows** exactly how much space each artifact consumes
- **Safely removes** only build artifacts (never source code)
- **Saves hours** of manual cleanup work

## Installation

### Download & Install

1. **Download the latest DMG** from the [Releases](https://github.com/iamnabink/flutter-build-cleaner-mac/releases) page
2. **Open the DMG file**
3. **Drag AppBuild Dev Cleaner** to your Applications folder
4. **Launch** from Applications or Spotlight

### First Launch

1. **Grant permission** when prompted to access your home directory
2. **Select a directory** to scan (or scan your entire home directory)
3. **Review** the found artifacts and their sizes
4. **Clean** unwanted files with one click

## What It Cleans

- **APK files** (Android packages)
- **AAB files** (Android App Bundles)  
- **IPA files** (iOS app bundles)
- **Flutter build folders** (`build/` directories)
- **React Native build folders** (`android/app/build/`, `ios/build/`)
- **Android build folders** (`build/` directories)
- **iOS build folders** (`build/` directories)
- **iOS Archives** (DerivedData `.xcarchive` files)
- **node_modules folders** (React Native dependencies)

## Safety Features

- ✅ **Never deletes source code** - Only targets build artifacts
- ✅ **Skips system directories** - Protects important system files
- ✅ **Permission handling** - Graceful error handling
- ✅ **Preview before delete** - See exactly what will be removed
- ✅ **Open in Finder** - Right-click any item to inspect it

## System Requirements

- **macOS 10.14** or later
- **50MB** free disk space for the app
- **File system access** permission (granted on first launch)

## Made With Love

**AppBuild Dev Cleaner** was created by **Nabraj Khadka** - Mobile Developer & Flutter Enthusiast

### About the Developer

I'm a passionate mobile developer who loves building apps that solve real-world problems. As someone who works extensively with Flutter and React Native, I understand the pain points of managing build artifacts across multiple projects. This app was born out of my own frustration with constantly running out of disk space due to accumulated build files.

**My Expertise:**
- 🚀 **Flutter Development** - Cross-platform mobile apps
- 📱 **React Native** - Native mobile development
- 🎨 **UI/UX Design** - Creating beautiful, intuitive interfaces
- 🔧 **DevOps** - CI/CD pipelines and automation
- ☁️ **Cloud Technologies** - AWS, Firebase, and more

**Connect with me:**
- 🔗 [LinkedIn](https://linkedin.com/in/iamnabink) - Professional networking
- 💻 [GitHub](https://github.com/iamnabink) - Open source projects
- 📧 **Email** - Available through LinkedIn

*Building tools that make developers' lives easier, one app at a time!* ✨

---

**Version 1.0.0 • Build 1**

*Free up your disk space and focus on what matters - building amazing mobile apps!* 🚀