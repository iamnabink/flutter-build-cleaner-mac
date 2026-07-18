import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';

/// Semantic color tokens, resolved against the active [MacosTheme] brightness.
///
/// This is the single place where dynamic colors are resolved — widgets must
/// use `context.colors.*` instead of raw `CupertinoColors`/`MacosColors` so
/// dark mode stays correct everywhere.
extension AppColorsX on BuildContext {
  AppColors get colors => AppColors._(MacosTheme.of(this));
}

class AppColors {
  const AppColors._(this._theme);

  final MacosThemeData _theme;

  bool get isDark => _theme.brightness == Brightness.dark;

  Color _byBrightness(Color light, Color dark) => isDark ? dark : light;

  // Accents
  Color get accent => _byBrightness(
        MacosColors.systemBlueColor.color,
        MacosColors.systemBlueColor.darkColor,
      );
  Color get success => _byBrightness(
        MacosColors.systemGreenColor.color,
        MacosColors.systemGreenColor.darkColor,
      );
  Color get warning => _byBrightness(
        MacosColors.systemOrangeColor.color,
        MacosColors.systemOrangeColor.darkColor,
      );
  Color get danger => _byBrightness(
        MacosColors.systemRedColor.color,
        MacosColors.systemRedColor.darkColor,
      );
  Color get highlight => _byBrightness(
        MacosColors.systemPurpleColor.color,
        MacosColors.systemPurpleColor.darkColor,
      );
  Color get love => _byBrightness(
        MacosColors.systemPinkColor.color,
        MacosColors.systemPinkColor.darkColor,
      );
  Color get info => _byBrightness(
        MacosColors.systemTealColor.color,
        MacosColors.systemTealColor.darkColor,
      );
  Color get special => _byBrightness(
        MacosColors.systemIndigoColor.color,
        MacosColors.systemIndigoColor.darkColor,
      );

  // Text
  Color get label => _byBrightness(
        MacosColors.labelColor.color,
        MacosColors.labelColor.darkColor,
      );
  Color get secondaryLabel => _byBrightness(
        MacosColors.secondaryLabelColor.color,
        MacosColors.secondaryLabelColor.darkColor,
      );
  Color get tertiaryLabel => _byBrightness(
        MacosColors.tertiaryLabelColor.color,
        MacosColors.tertiaryLabelColor.darkColor,
      );

  Color get brown => _byBrightness(
        MacosColors.systemBrownColor.color,
        MacosColors.systemBrownColor.darkColor,
      );

  // Greys (Apple systemGrey scale, light/dark)
  Color get grey => const Color(0xFF8E8E93);
  Color get grey3 => _byBrightness(
        const Color(0xFFC7C7CC),
        const Color(0xFF48484A),
      );
  Color get border => _byBrightness(
        const Color(0xFFD1D1D6),
        const Color(0xFF3A3A3C),
      );
  Color get grey5 => _byBrightness(
        const Color(0xFFE5E5EA),
        const Color(0xFF2C2C2E),
      );
  Color get controlBackground => _byBrightness(
        const Color(0xFFF2F2F7),
        const Color(0xFF2C2C2E),
      );

  // Surfaces
  Color get background => _byBrightness(
        const Color(0xFFFFFFFF),
        const Color(0xFF1E1E1E),
      );
  Color get cardBackground => _byBrightness(
        const Color(0xFFF5F5F7),
        const Color(0xFF2B2B2B),
      );
  Color get chipBackground => _byBrightness(
        const Color(0xFFEBEBED),
        const Color(0xFF363636),
      );
  Color get separator => _byBrightness(
        const Color(0x1A000000),
        MacosColors.separatorColor,
      );
  Color get shadow =>
      _byBrightness(const Color(0x0D000000), const Color(0x33000000));

  Color get white => MacosColors.white;
  Color get black => MacosColors.black;
}
