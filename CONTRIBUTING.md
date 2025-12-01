# Contributing to Broomie

Thank you for your interest in contributing to **Broomie**! This document outlines how to get started, our development workflow, and our community standards.

## Table of Contents
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Workflow](#workflow)
- [Code Standards](#code-standards)
- [Submitting Changes](#submitting-changes)
- [Code of Conduct](#code-of-conduct)

---

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR_USERNAME/macOs-mobile-dev-cleaner.git
   cd macOs-mobile-dev-cleaner
   ```
3. **Add upstream remote** to stay synced:
   ```bash
   git remote add upstream https://github.com/iamnabink/macOs-mobile-dev-cleaner.git
   ```

---

## Development Setup

### Prerequisites
- **macOS 10.14** or later
- **Flutter 3.0+** (with Dart)
- **Xcode 12+** (for iOS/macOS builds)
- **Git**

### Install Flutter & Dependencies
```bash
# Install Flutter (if not already installed)
# Visit: https://flutter.dev/docs/get-started/install/macos

# Verify installation
flutter doctor

# Enable macOS desktop support
flutter config --enable-macos-desktop

# Get project dependencies
cd macOs-mobile-dev-cleaner
flutter pub get
```

### Run Locally (Debug)
```bash
# Run on macOS
flutter run -d macos

# Or open in Xcode for detailed debugging
open macos/Runner.xcworkspace
```

### Run Tests
```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# View coverage report
open coverage/index.html
```

### Analyze Code
```bash
# Check for issues
flutter analyze

# Format code
flutter format lib/ test/

# Check format without modifying
flutter format --set-exit-if-changed lib/ test/
```

---

## Workflow

### 1. Create a Feature Branch
Use descriptive branch names following this pattern:
```bash
# Feature
git checkout -b feat/description-of-feature

# Bug fix
git checkout -b fix/description-of-bug

# Improvement
git checkout -b improve/description-of-improvement

# Documentation
git checkout -b docs/description
```

### 2. Make Changes
- Keep commits **focused and atomic**
- Write clear, descriptive commit messages
- Reference issues when relevant: `Fixes #123` or `Related to #456`

### 3. Keep Your Branch Updated
```bash
# Fetch latest from upstream
git fetch upstream

# Rebase on upstream/main
git rebase upstream/main
```

### 4. Push to Your Fork
```bash
git push origin YOUR_BRANCH_NAME
```

### 5. Create a Pull Request
- Visit https://github.com/iamnabink/macOs-mobile-dev-cleaner
- Click "Compare & pull request" for your branch
- Fill in the PR template with:
  - **Summary** – What does this change do?
  - **Why** – Why is this change needed?
  - **Testing** – How did you test this?
  - **Screenshots/GIFs** (if UI changes)
  - **Checklist** – See below

---

## Code Standards

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`  
**Scope:** `ui`, `core`, `services`, `docs`, etc.

**Examples:**
```
feat(ui): add dark mode support
fix(scan): handle permission denial gracefully
docs(readme): update installation steps
```

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` to auto-format:
  ```bash
  flutter format lib/
  ```
- Run `flutter analyze` before committing:
  ```bash
  flutter analyze
  ```

### Testing
- Add tests for new features and bug fixes
- Keep test coverage above **70%**
- Use descriptive test names

```dart
test('should return correct file size when scanning', () {
  // arrange
  final service = ScanService();
  
  // act
  final result = service.calculateSize(testDir);
  
  // assert
  expect(result, greaterThan(0));
});
```

---

## Submitting Changes

### Pre-Submission Checklist
- [ ] Code follows style guidelines (`flutter format`)
- [ ] No linting errors (`flutter analyze`)
- [ ] Tests pass (`flutter test`)
- [ ] Commit messages are clear and descriptive
- [ ] Branch is up-to-date with `upstream/main`
- [ ] PR description is detailed and helpful

### PR Template
```markdown
## Summary
Brief description of what this PR does.

## Related Issue
Fixes #123 (or "Related to #456" if no issue)

## Changes
- Change 1
- Change 2
- Change 3

## Testing
How did you test this? (e.g., "Tested on macOS 12 simulator", "Unit tests added")

## Screenshots/GIFs (if applicable)
[Attach any relevant screenshots]

## Checklist
- [ ] Code follows style guidelines
- [ ] Tests added/updated
- [ ] Documentation updated (if needed)
- [ ] Commit messages are clear
```

---

## Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors.

### Expected Behavior
- Be respectful and constructive in all interactions
- Welcome diverse perspectives and experiences
- Provide and accept feedback graciously
- Focus on what is best for the community

### Unacceptable Behavior
- Harassment, discrimination, or intimidation
- Offensive language or personal attacks
- Unwelcome sexual advances or attention
- Other conduct harmful to the project community

### Reporting Issues
If you encounter behavior that violates this Code of Conduct, please report it to the maintainers via email or a private GitHub issue.

---

## Questions or Need Help?

- **Ask in an issue** – Search existing issues first, then open a new one if needed
- **Start a discussion** – Use GitHub Discussions for questions or ideas
- **Check the README** – It has setup and feature information

---

## Thank You! 🎉

Your contributions make Broomie better for everyone. We appreciate your time and effort!

**Happy coding!** 🚀
