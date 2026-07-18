import 'package:macos_ui/macos_ui.dart';

/// App-wide macos_ui themes. Keep customization minimal — the goal is the
/// native macOS look, so stock [MacosThemeData] is the baseline.
class AppTheme {
  AppTheme._();

  static final MacosThemeData light = MacosThemeData.light();
  static final MacosThemeData dark = MacosThemeData.dark();
}
