/// Data model for the in-app "Manual Cleanup Guide"
/// (sourced from MANUAL_MACOS_CLEANER_GUIDE.md).
library;

/// How risky it is to act on a guide item.
enum SafetyLevel {
  /// Cache/build artifacts — recreated automatically.
  safe('Safe to clean'),

  /// Look at the output and understand it before deleting anything.
  inspectFirst('Inspect first'),

  /// Never delete these manually.
  neverDelete('Never delete');

  const SafetyLevel(this.label);
  final String label;
}

/// A single shell command with an optional explanatory caption.
class GuideCommand {
  const GuideCommand(this.command, {this.caption});

  final String command;
  final String? caption;
}

/// One entry of the guide: a diagnostic or cleanup target.
class GuideItem {
  const GuideItem({
    required this.id,
    required this.title,
    required this.purpose,
    required this.safety,
    this.inspectCommands = const [],
    this.cleanCommands = const [],
    this.notes = const [],
  });

  final String id;
  final String title;
  final String purpose;
  final SafetyLevel safety;
  final List<GuideCommand> inspectCommands;
  final List<GuideCommand> cleanCommands;
  final List<String> notes;
}

/// A titled group of [GuideItem]s.
class GuideSection {
  const GuideSection({
    required this.id,
    required this.title,
    this.subtitle,
    required this.items,
  });

  final String id;
  final String title;
  final String? subtitle;
  final List<GuideItem> items;
}

/// One checkable step of the periodic maintenance routine.
class RoutineStep {
  const RoutineStep({required this.id, required this.title, this.command});

  final String id;
  final String title;
  final String? command;
}
