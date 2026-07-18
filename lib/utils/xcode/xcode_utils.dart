part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerUtils on _XcodeCacheCleanerPageState {
  String _formatFileSize(int bytes) {
    if (bytes == 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();

    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }

    return '${size.toStringAsFixed(size < 10 && i > 0 ? 2 : 1)} ${suffixes[i]}';
  }

  Future<int> _getDirectorySize(Directory directory) async {
    int totalSize = 0;
    try {
      await for (final entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (!mounted || !_isScanning) break;

        if (entity is File) {
          try {
            final stat = await entity.stat();
            totalSize += stat.size;
          } catch (_) {}
        }
      }
    } catch (_) {}
    return totalSize;
  }

  Future<String?> _findWorkspacePathForDerivedData(String derivedDataPath) async {
    try {
      // Xcode stores project info in Info.plist
      final infoPlist = File('$derivedDataPath/Info.plist');
      if (await infoPlist.exists()) {
        try {
          final content = await infoPlist.readAsString();
          // Look for workspace path patterns in the plist
          // Xcode stores it as "WorkspacePath" or "ProjectPath"
          final workspaceMatch = RegExp(r'<key>WorkspacePath</key>\s*<string>(.*?)</string>').firstMatch(content);
          if (workspaceMatch != null) {
            final workspacePath = workspaceMatch.group(1);
            if (workspacePath != null && workspacePath.endsWith('.xcworkspace')) {
              return workspacePath;
            }
          }
          
          final projectMatch = RegExp(r'<key>ProjectPath</key>\s*<string>(.*?)</string>').firstMatch(content);
          if (projectMatch != null) {
            final projectPath = projectMatch.group(1);
            if (projectPath != null) {
              // Try to find .xcworkspace in the same directory
              final projectDir = Directory(path.dirname(projectPath));
              if (await projectDir.exists()) {
                try {
                  await for (final entity in projectDir.list()) {
                    if (entity.path.endsWith('.xcworkspace')) {
                      return entity.path;
                    }
                  }
                } catch (_) {}
              }
            }
          }
        } catch (_) {}
      }
      
      // Fallback: Try to find .xcworkspace based on folder name
      // DerivedData folders are typically: ProjectName-XXXXX
      final folderName = path.basename(derivedDataPath);
      final projectNameMatch = RegExp(r'^(.+?)-[A-Z0-9]+$').firstMatch(folderName);
      if (projectNameMatch != null) {
        final projectName = projectNameMatch.group(1);
        if (projectName != null && projectName.toLowerCase().contains('runner')) {
          // Try common locations for Flutter projects
          final homeDir = await _expandPath('~/');
          final commonPaths = [
            '$homeDir/Projects',
            '$homeDir/Development',
            '$homeDir/Desktop',
            '$homeDir/Documents',
            '/Users/${Platform.environment['USER'] ?? ''}/Projects',
            '/Users/${Platform.environment['USER'] ?? ''}/Development',
          ];
          
          for (final basePath in commonPaths) {
            try {
              final baseDir = Directory(basePath);
              if (await baseDir.exists()) {
                await for (final entity in baseDir.list(recursive: false)) {
                  if (entity is Directory) {
                    final iosDir = Directory('${entity.path}/ios');
                    if (await iosDir.exists()) {
                      final workspaceFile = File('${iosDir.path}/Runner.xcworkspace');
                      if (await workspaceFile.exists()) {
                        return workspaceFile.path;
                      }
                    }
                  }
                }
              }
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return null;
  }

  Future<void> _openInFinder(String targetPath) async {
    try {
      if (Platform.isMacOS) {
        await Process.run('open', ['-R', targetPath]);
      } else if (Platform.isWindows) {
        await Process.run('explorer', ['/select,', targetPath]);
      } else if (Platform.isLinux) {
        await Process.run('xdg-open', [targetPath]);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to open in Finder: $e', isError: true);
      }
    }
  }

  void _showSnackBar(String message, {required bool isError}) {
    HapticFeedback.mediumImpact();
    showMacosAlertDialog(
      context: context,
      builder: (dialogContext) => MacosAlertDialog(
        appIcon: Image.asset('assets/images/icon.png', width: 56, height: 56),
        title: Text(isError ? 'Error' : 'Success'),
        message: Text(message),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('OK'),
        ),
      ),
    );
  }

  String _getProjectNameFromPath(String workspacePath) {
    // Extract project name from workspace path
    // e.g., "/Users/nex/Office/sb-customer-app/ios/Runner.xcworkspace" -> "Runner"
    final fileName = path.basename(workspacePath);
    if (fileName.endsWith('.xcworkspace')) {
      return fileName.replaceAll('.xcworkspace', '');
    }
    return path.basename(path.dirname(workspacePath));
  }

  Future<String> _expandPath(String pathWithTilde) async {
    if (pathWithTilde.startsWith('~/')) {
      // On macOS, Platform.environment['HOME'] returns sandboxed path
      // Use shell command to get real user home directory
      try {
        final result = await Process.run('sh', ['-c', 'echo \$HOME']);
        if (result.exitCode == 0) {
          final homeDir = result.stdout.toString().trim();
          if (homeDir.isNotEmpty && !homeDir.contains('Containers')) {
            return pathWithTilde.replaceFirst('~/', '$homeDir/');
          }
        }
      } catch (e) {
        // Fallback: try to get from user's actual home
      }
      
      // Try using whoami to get username and construct path
      try {
        final whoamiResult = await Process.run('whoami', []);
        if (whoamiResult.exitCode == 0) {
          final username = whoamiResult.stdout.toString().trim();
          final homeDir = '/Users/$username';
          final testDir = Directory(homeDir);
          if (await testDir.exists()) {
            return pathWithTilde.replaceFirst('~/', '$homeDir/');
          }
        }
      } catch (e) {
        // Fallback to environment variable if all else fails
      }
      
      // Last resort: try environment variable (might be sandboxed)
      final homeDir = Platform.environment['HOME'] ?? '';
      return pathWithTilde.replaceFirst('~/', '$homeDir/');
    }
    return pathWithTilde;
  }
}

