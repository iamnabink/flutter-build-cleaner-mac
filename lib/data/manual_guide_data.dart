import 'package:flutter_cleaner/models/guide_models.dart';

/// Content of the in-app Manual Cleanup Guide, mirroring
/// MANUAL_MACOS_CLEANER_GUIDE.md (keep the two in sync when editing).
class ManualGuideData {
  ManualGuideData._();

  static const String intro =
      'A safe, repeatable workflow for reclaiming disk space on a Flutter, '
      'Android, iOS, and full-stack mobile development Mac. Inspect before '
      'you delete — only caches and rebuildable artifacts are safe targets.';

  static const List<GuideSection> sections = [
    GuideSection(
      id: 'diagnose',
      title: 'Diagnose',
      subtitle:
          'Find out where the space actually went before deleting anything.',
      items: [
        GuideItem(
          id: 'disk-usage',
          title: 'Overall Disk Usage',
          purpose:
              'Shows how much storage the filesystem is actually using — the '
              'first sanity check before trusting the macOS Storage UI.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('df -h /',
                caption: 'Look at Total Size, Used, and Available.'),
          ],
          notes: [
            'If usage looks reasonable here but "System Data" is huge in '
                'Settings, macOS is likely miscategorizing storage.',
          ],
        ),
        GuideItem(
          id: 'tm-snapshots',
          title: 'Time Machine Local Snapshots',
          purpose:
              'Time Machine can silently create local snapshots that consume '
              'tens or even hundreds of GB.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('tmutil listlocalsnapshots /'),
          ],
          notes: [
            'If snapshots like "com.apple.TimeMachine.2026-07-15-..." exist, '
                'investigate before deleting.',
          ],
        ),
        GuideItem(
          id: 'apfs-snapshots',
          title: 'APFS Snapshots',
          purpose: 'APFS keeps system snapshots (usually macOS updates).',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('diskutil apfs listSnapshots /'),
          ],
          notes: [
            'Normally you will only see a macOS update snapshot.',
            'Do NOT delete unless you know exactly why.',
          ],
        ),
        GuideItem(
          id: 'virtual-memory',
          title: 'Virtual Memory / Swap',
          purpose: 'Checks swap files and virtual memory usage.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -sh /private/var/vm',
                caption: 'Expected: roughly 2–8 GB.'),
          ],
          notes: [
            'If this folder is unexpectedly huge (50–100 GB), reboot first '
                'before investigating further.',
          ],
        ),
        GuideItem(
          id: 'home-folders',
          title: 'Largest Folders in Home Directory',
          purpose: 'Shows where your own files are consuming space.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -hd 1 ~ 2>/dev/null | sort -h'),
          ],
          notes: ['Only investigate the largest folders.'],
        ),
        GuideItem(
          id: 'library',
          title: '~/Library',
          purpose:
              'Contains caches, SDKs, simulators, IDE data, application data, '
              'and developer tooling.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -hd 1 ~/Library 2>/dev/null | sort -h'),
          ],
          notes: [
            'Large folders usually include Android, Developer, Application '
                'Support, and Containers — inspect further before deleting.',
          ],
        ),
        GuideItem(
          id: 'android-sdk',
          title: 'Android SDK',
          purpose: 'Shows what parts of the Android SDK are consuming space.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -hd 1 ~/Library/Android/sdk | sort -h'),
            GuideCommand('du -hd 1 ~/Library/Android/sdk/ndk | sort -h',
                caption:
                    'Many developers accumulate multiple NDK versions over time.'),
            GuideCommand(
                'grep -R "ndkVersion" ~/Projects 2>/dev/null',
                caption:
                    'Check whether any project explicitly requires an NDK '
                    'version (point this at your projects folder).'),
          ],
        ),
        GuideItem(
          id: 'xcode-dev-data',
          title: 'Xcode Developer Data',
          purpose:
              'Xcode stores build artifacts, simulators, archives, and device '
              'support files.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -hd 1 ~/Library/Developer 2>/dev/null | sort -h'),
          ],
          notes: [
            'Common folders: Xcode, CoreSimulator, DeviceSupport — '
                'investigate large ones before cleaning.',
          ],
        ),
        GuideItem(
          id: 'app-support',
          title: 'Application Support',
          purpose:
              'Many applications store databases, backups, AI models, caches, '
              'Docker data, and browser profiles here.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand(
                'du -hd 1 ~/Library/Application\\ Support 2>/dev/null | sort -h'),
          ],
          notes: [
            'Large entries may include Docker, Android Studio, Chrome, '
                'VS Code, and iPhone backups — review before deleting.',
          ],
        ),
        GuideItem(
          id: 'dev-caches',
          title: 'Developer Caches',
          purpose:
              'Temporary caches that are generally safe to clean once inspected.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -hd 1 ~/Library/Caches 2>/dev/null | sort -h'),
          ],
        ),
        GuideItem(
          id: 'docker',
          title: 'Docker',
          purpose:
              'Docker images and volumes often consume tens or hundreds of GB.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('docker system df'),
          ],
          notes: [
            'Only clean Docker if you understand which images and volumes '
                'are still needed.',
          ],
        ),
      ],
    ),
    GuideSection(
      id: 'safe-cleanup',
      title: 'Safe Cleanup Checklist',
      subtitle:
          'Cache and build artifacts — they are recreated automatically.',
      items: [
        GuideItem(
          id: 'gradle-cache',
          title: 'Gradle Cache',
          purpose: 'Downloaded Gradle artifacts; automatically rebuilt.',
          safety: SafetyLevel.safe,
          inspectCommands: [GuideCommand('du -sh ~/.gradle')],
          cleanCommands: [
            GuideCommand('rm -rf ~/.gradle/caches',
                caption: 'Frees downloaded artifacts; rebuilt on next build.'),
          ],
        ),
        GuideItem(
          id: 'dart-analysis-cache',
          title: 'Dart Analysis Cache',
          purpose: 'Analysis/index cache; the IDE rebuilds it automatically.',
          safety: SafetyLevel.safe,
          inspectCommands: [GuideCommand('du -sh ~/.dartServer')],
          cleanCommands: [GuideCommand('rm -rf ~/.dartServer')],
        ),
        GuideItem(
          id: 'xcode-derived-data',
          title: 'Xcode DerivedData',
          purpose: 'Build cache only — no source code affected.',
          safety: SafetyLevel.safe,
          inspectCommands: [
            GuideCommand('du -sh ~/Library/Developer/Xcode/DerivedData'),
          ],
          cleanCommands: [
            GuideCommand('rm -rf ~/Library/Developer/Xcode/DerivedData'),
          ],
        ),
        GuideItem(
          id: 'ios-simulators',
          title: 'iOS Simulators',
          purpose: 'Removes only obsolete/unavailable simulators.',
          safety: SafetyLevel.safe,
          inspectCommands: [GuideCommand('xcrun simctl list devices')],
          cleanCommands: [GuideCommand('xcrun simctl delete unavailable')],
        ),
        GuideItem(
          id: 'android-emulator',
          title: 'Android Emulator & System Images',
          purpose:
              'Emulator binaries, system images, and AVDs — only remove if '
              'you exclusively use physical devices.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -sh ~/Library/Android/sdk/emulator'),
            GuideCommand('du -sh ~/Library/Android/sdk/system-images'),
            GuideCommand('ls ~/.android/avd'),
          ],
          cleanCommands: [
            GuideCommand('rm -rf ~/Library/Android/sdk/emulator'),
            GuideCommand('rm -rf ~/Library/Android/sdk/system-images'),
            GuideCommand('rm -rf ~/.android/avd'),
          ],
          notes: ['Only if you never use the Android emulator.'],
        ),
        GuideItem(
          id: 'old-ndk',
          title: 'Old Android NDK Versions',
          purpose: 'Unused NDK versions accumulate over the years.',
          safety: SafetyLevel.inspectFirst,
          inspectCommands: [
            GuideCommand('du -hd 1 ~/Library/Android/sdk/ndk | sort -h'),
            GuideCommand('grep -R "ndkVersion" ~/Projects 2>/dev/null',
                caption:
                    'Verify project requirements first (point at your '
                    'projects folder). Remove only unused versions.'),
          ],
        ),
        GuideItem(
          id: 'flutter-builds',
          title: 'Flutter Build Artifacts',
          purpose: 'Per-project build folders; recreated by the next build.',
          safety: SafetyLevel.safe,
          inspectCommands: [
            GuideCommand('flutter clean',
                caption: 'Per project, from the project directory.'),
            GuideCommand('find ~/Projects -type d -name build',
                caption: 'Or list all build folders under your projects folder.'),
          ],
          cleanCommands: [
            GuideCommand(
                'find ~/Projects -type d -name build -prune -exec rm -rf {} +',
                caption:
                    'Removes every build folder under your projects folder.'),
          ],
        ),
      ],
    ),
    GuideSection(
      id: 'rarely-clean',
      title: 'Rarely Worth Cleaning',
      subtitle:
          'These save relatively little space compared to the time required '
          'to restore them.',
      items: [
        GuideItem(
          id: 'low-value-targets',
          title: 'Low-value cleanup targets',
          purpose:
              'Deleting these forces slow re-downloads for little gain — '
              'leave them alone unless desperate.',
          safety: SafetyLevel.inspectFirst,
          notes: [
            '~/.pub-cache (Dart/Flutter packages)',
            '~/.cocoapods',
            'Android SDK platforms',
            'Android SDK platform-tools',
            'Android SDK build-tools',
            'Android SDK cmdline-tools',
          ],
        ),
      ],
    ),
    GuideSection(
      id: 'never-delete',
      title: 'Never Delete Manually',
      items: [
        GuideItem(
          id: 'system-dirs',
          title: 'System directories',
          purpose:
              'Deleting from these can break macOS. Never touch them manually '
              'unless you know exactly what a path contains.',
          safety: SafetyLevel.neverDelete,
          notes: ['/System', '/usr', '/private', '/Library'],
        ),
      ],
    ),
  ];

  /// The "every 3–6 months" maintenance routine.
  static const List<RoutineStep> routine = [
    RoutineStep(id: 'routine-01', title: 'Check disk usage', command: 'df -h /'),
    RoutineStep(
        id: 'routine-02',
        title: 'Review top-level home folders',
        command: 'du -hd 1 ~ 2>/dev/null | sort -h'),
    RoutineStep(
        id: 'routine-03',
        title: 'Review ~/Library',
        command: 'du -hd 1 ~/Library 2>/dev/null | sort -h'),
    RoutineStep(
        id: 'routine-04',
        title: 'Clean Gradle cache if large',
        command: 'rm -rf ~/.gradle/caches'),
    RoutineStep(
        id: 'routine-05',
        title: 'Clean Dart analysis cache if large',
        command: 'rm -rf ~/.dartServer'),
    RoutineStep(
        id: 'routine-06',
        title: 'Remove Xcode DerivedData',
        command: 'rm -rf ~/Library/Developer/Xcode/DerivedData'),
    RoutineStep(
        id: 'routine-07',
        title: 'Delete unavailable simulators',
        command: 'xcrun simctl delete unavailable'),
    RoutineStep(
        id: 'routine-08',
        title: 'Review Android SDK & remove obsolete NDK versions',
        command: 'du -hd 1 ~/Library/Android/sdk/ndk | sort -h'),
    RoutineStep(
        id: 'routine-09',
        title: 'Review Docker usage (if installed)',
        command: 'docker system df'),
    RoutineStep(id: 'routine-10', title: 'Empty Trash'),
  ];
}
