# Contributing to Broomie 🧹

Thanks for wanting to help! This guide will get you set up and ready to contribute. Don't worry, it's easier than it looks! 😊

## Quick Start 🚀

1. **Fork the repo** on GitHub
2. **Clone your fork:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/macOs-mobile-dev-cleaner.git
   cd macOs-mobile-dev-cleaner
   ```
3. **Add upstream** (to stay synced):
   ```bash
   git remote add upstream https://github.com/iamnabink/macOs-mobile-dev-cleaner.git
   ```

## Setup 💻

### What you need:
- macOS 10.14+ 
- Flutter 3.0+ ([install guide](https://flutter.dev/docs/get-started/install/macos))
- Xcode 12+ (for building)
- Git

### Get it running:
```bash
# Check Flutter is working
flutter doctor

# Enable macOS support
flutter config --enable-macos-desktop

# Get dependencies
flutter pub get

# Run it!
flutter run -d macos
```

## Making Changes ✏️

### 1. Create a branch
Pick a name that describes what you're doing:
```bash
git checkout -b feat/your-feature-name
# or
git checkout -b fix/your-bug-fix
```

### 2. Make your changes
- Write clear code
- Keep commits focused (one thing per commit)
- Write helpful commit messages like: `feat: add dark mode` or `fix: crash on empty scan`

### 3. Try it out
Run the app and make sure your changes work as expected!

### 4. Push and PR
```bash
git push origin your-branch-name
```
Then create a pull request on GitHub. The PR template will help you fill it out! See [`.github/pull_request_template.md`](.github/pull_request_template.md)

## Code Style 🎨

- Run `flutter format lib/` before committing
- Run `flutter analyze` to check for issues
- Write clear, readable code

That's it! No need to overthink it. 😄

## Found a Bug? Have an Idea? 🐛✨

We'd love to hear from you! Use our friendly templates:

- 🐛 **[Report a Bug](.github/ISSUE_TEMPLATE/bug_report.md)** – Something broken? Let us know!
- ✨ **[Request a Feature](.github/ISSUE_TEMPLATE/feature_request.md)** – Got a cool idea? Share it!

Just click "New Issue" on GitHub and pick a template!

## Code of Conduct 🤝

Be nice, be respectful, be helpful. That's it! We're all here to make Broomie better together.

## Need Help? 💬

- Check the [README](README.md) for setup info
- Search existing issues first
- Open a new issue if you can't find an answer

---

## Thanks! 🎉

Seriously, thank you for contributing! Every little bit helps make Broomie better. You're awesome! 🚀
