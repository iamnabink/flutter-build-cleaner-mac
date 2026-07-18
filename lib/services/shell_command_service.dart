import 'dart:io';

class ShellCommandResult {
  const ShellCommandResult({
    required this.command,
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final String command;
  final int exitCode;
  final String stdout;
  final String stderr;

  bool get succeeded => exitCode == 0;

  /// True when the output suggests the macOS sandbox denied file access.
  bool get looksPermissionDenied {
    final s = '$stdout\n$stderr'.toLowerCase();
    return s.contains('operation not permitted') ||
        s.contains('permission denied');
  }
}

/// Runs guide shell commands via `/bin/sh -c`.
///
/// The app is sandboxed, so `$HOME` points at the container; commands are run
/// with HOME overridden to the real user home so `~` expands correctly.
/// Access outside granted scopes may still be denied by the sandbox — callers
/// should surface [ShellCommandResult.looksPermissionDenied] to the user.
class ShellCommandService {
  ShellCommandService._();

  static String? _cachedHome;

  static Future<String> realHome() async {
    if (_cachedHome != null) return _cachedHome!;
    try {
      final result = await Process.run('sh', ['-c', r'echo $HOME']);
      if (result.exitCode == 0) {
        final home = result.stdout.toString().trim();
        if (home.isNotEmpty && !home.contains('Containers')) {
          return _cachedHome = home;
        }
      }
    } catch (_) {}
    try {
      final whoami = await Process.run('whoami', []);
      if (whoami.exitCode == 0) {
        final username = whoami.stdout.toString().trim();
        final home = '/Users/$username';
        if (await Directory(home).exists()) {
          return _cachedHome = home;
        }
      }
    } catch (_) {}
    return _cachedHome = Platform.environment['HOME'] ?? '';
  }

  static Future<ShellCommandResult> run(String command) async {
    final home = await realHome();
    try {
      final result = await Process.run(
        '/bin/sh',
        ['-c', command],
        environment: {...Platform.environment, 'HOME': home},
      );
      return ShellCommandResult(
        command: command,
        exitCode: result.exitCode,
        stdout: result.stdout.toString(),
        stderr: result.stderr.toString(),
      );
    } catch (e) {
      return ShellCommandResult(
        command: command,
        exitCode: -1,
        stdout: '',
        stderr: 'Failed to launch command: $e',
      );
    }
  }
}
