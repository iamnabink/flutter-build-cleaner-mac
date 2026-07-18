import 'package:shared_preferences/shared_preferences.dart';

/// Persists the checked state of the Manual Guide maintenance routine.
class GuideProgressService {
  GuideProgressService._();

  static const String _checkedKey = 'guide_routine_checked_v1';
  static const String _lastResetKey = 'guide_routine_last_reset_v1';

  static Future<Set<String>> loadCheckedSteps() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_checkedKey) ?? const []).toSet();
  }

  static Future<void> saveCheckedSteps(Set<String> stepIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_checkedKey, stepIds.toList()..sort());
  }

  static Future<DateTime?> loadLastReset() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_lastResetKey);
    return raw == null ? null : DateTime.tryParse(raw);
  }

  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_checkedKey);
    await prefs.setString(_lastResetKey, DateTime.now().toIso8601String());
  }
}
