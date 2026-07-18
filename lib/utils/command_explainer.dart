/// Plain-English explanations for the shell commands in the Manual Guide,
/// shown by the info button so users know what they are about to run.
library;

enum CommandRisk {
  readOnly('Read-only — makes no changes'),
  cleansRebuildable('Deletes caches/build artifacts — rebuilt automatically'),
  destructive('Deletes data permanently — cannot be undone');

  const CommandRisk(this.label);
  final String label;
}

class CommandExplanation {
  const CommandExplanation({
    required this.summary,
    required this.risk,
    this.details = const [],
  });

  final String summary;
  final CommandRisk risk;
  final List<String> details;
}

CommandExplanation explainCommand(String command) {
  final cmd = command.trim();
  final details = <String>[];

  if (cmd.contains('| sort -h')) {
    details.add('"| sort -h" sorts the output by human-readable size, '
        'smallest to largest — the biggest entries end up at the bottom.');
  }
  if (cmd.contains('2>/dev/null')) {
    details.add('"2>/dev/null" hides permission-error noise from folders '
        'that cannot be read.');
  }

  CommandExplanation result(String summary, CommandRisk risk,
      [List<String> extra = const []]) {
    return CommandExplanation(
        summary: summary, risk: risk, details: [...extra, ...details]);
  }

  if (cmd.startsWith('df ')) {
    return result(
      'Reports how much disk space the filesystem is using and how much is '
      'free.',
      CommandRisk.readOnly,
      ['"-h" prints sizes in human-readable units (GB/TB).'],
    );
  }
  if (cmd.startsWith('du ')) {
    final target = cmd.split(RegExp(r'\s+')).firstWhere(
        (part) => part.startsWith('~') || part.startsWith('/'),
        orElse: () => 'the given folder');
    return result(
      'Measures how much disk space $target takes up. Nothing is modified.',
      CommandRisk.readOnly,
      [
        if (cmd.contains('-s'))
          '"-s" shows only the total for the folder.',
        if (cmd.contains('-d 1'))
          '"-d 1" lists each immediate subfolder with its size.',
        '"-h" prints sizes in human-readable units.',
      ],
    );
  }
  if (cmd.startsWith('tmutil listlocalsnapshots')) {
    return result(
      'Lists Time Machine local snapshots stored on this disk. Snapshots can '
      'silently hold tens of GB.',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('diskutil apfs listSnapshots')) {
    return result(
      'Lists APFS filesystem snapshots (usually created by macOS updates).',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('docker system df')) {
    return result(
      'Shows how much disk space Docker images, containers, and volumes use.',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('ls ')) {
    return result(
      'Lists the contents of the folder. Nothing is modified.',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('grep ')) {
    return result(
      'Searches your project files for "ndkVersion" to find which NDK '
      'versions your projects still require. Nothing is modified.',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('xcrun simctl list')) {
    return result(
      'Lists all iOS simulators known to Xcode, including obsolete ones.',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('xcrun simctl delete unavailable')) {
    return result(
      'Deletes only simulators that are no longer usable with the installed '
      'Xcode runtimes. Active simulators are untouched.',
      CommandRisk.cleansRebuildable,
    );
  }
  if (cmd == 'flutter clean') {
    return result(
      'Deletes the current project\'s build/ and .dart_tool/ folders. The '
      'next build recreates them.',
      CommandRisk.cleansRebuildable,
    );
  }
  if (cmd.startsWith('find ') && cmd.contains('rm -rf')) {
    return result(
      'Finds every "build" folder under your projects folder and permanently '
      'deletes each one. Builds are recreated on the next compile, but any '
      'unsaved artifacts inside them are gone.',
      CommandRisk.destructive,
      [
        '"-type d -name build" matches folders named "build".',
        '"-prune" stops find from descending into matched folders.',
        '"-exec rm -rf {} +" permanently deletes every match (bypasses '
            'the Trash).',
      ],
    );
  }
  if (cmd.startsWith('find ')) {
    return result(
      'Lists every "build" folder under the given path so you can review '
      'them first. Nothing is modified.',
      CommandRisk.readOnly,
    );
  }
  if (cmd.startsWith('rm -rf ')) {
    final target = cmd.substring('rm -rf '.length).trim();
    return result(
      'Permanently deletes $target and everything inside it. This bypasses '
      'the Trash and cannot be undone.',
      CommandRisk.destructive,
      ['"-r" deletes recursively; "-f" skips confirmation prompts.'],
    );
  }

  return result('Shell command — review it before running.',
      CommandRisk.readOnly);
}
