import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Typed access to values from the bundled `.env` file.
///
/// The `.env` file is gitignored; copy `.env.example` to `.env` before
/// building. All values are optional — the app runs without them.
class EnvConfig {
  EnvConfig._();

  /// RevenueCat public Apple SDK key (`appl_...`), or null when unset.
  static String? get revenueCatApiKey {
    final value = dotenv.maybeGet('REVENUECAT_API_KEY');
    if (value == null || value.trim().isEmpty) return null;
    return value.trim();
  }
}
