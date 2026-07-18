part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageCoreUtils on _CleanerHomePageState {
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

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()}y ago';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()}mo ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inMinutes}m ago';
    }
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
}


