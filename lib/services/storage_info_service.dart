import 'dart:io';

import 'package:flutter/services.dart';

class StorageInfo {
  const StorageInfo({required this.totalBytes, required this.availableBytes});

  final int totalBytes;
  final int availableBytes;

  String get availableLabel => formatBytes(availableBytes);
  String get totalLabel => formatBytes(totalBytes);

  static String formatBytes(int bytes) {
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double size = bytes.toDouble();
    int i = 0;
    while (size >= 1000 && i < suffixes.length - 1) {
      size /= 1000;
      i++;
    }
    return '${size.toStringAsFixed(size >= 100 ? 0 : 1)} ${suffixes[i]}';
  }
}

/// Reads root-volume storage.
///
/// Primary source is the native `com.broomie/storage` channel
/// (`volumeAvailableCapacityForImportantUsage`), which includes purgeable
/// space and therefore matches the number Finder/System Settings show.
/// `df -k /` is only a fallback — it undercounts by excluding purgeable
/// space (snapshots, evictable caches).
class StorageInfoService {
  StorageInfoService._();

  static const MethodChannel _channel = MethodChannel('com.broomie/storage');

  static Future<StorageInfo?> fetch() async {
    final native = await _fetchNative();
    if (native != null) return native;
    return _fetchViaDf();
  }

  static Future<StorageInfo?> _fetchNative() async {
    try {
      final result =
          await _channel.invokeMapMethod<String, dynamic>('getStorageInfo');
      if (result == null) return null;
      final total = (result['total'] as num?)?.toInt();
      final available = (result['available'] as num?)?.toInt();
      if (total == null || available == null || total <= 0) return null;
      return StorageInfo(totalBytes: total, availableBytes: available);
    } catch (_) {
      return null;
    }
  }

  static Future<StorageInfo?> _fetchViaDf() async {
    try {
      final result = await Process.run('df', ['-k', '/']);
      if (result.exitCode != 0) return null;
      final lines = result.stdout.toString().trim().split('\n');
      if (lines.length < 2) return null;
      // Filesystem 1024-blocks Used Available Capacity ... Mounted on
      final fields = lines[1].split(RegExp(r'\s+'));
      if (fields.length < 4) return null;
      final totalKb = int.tryParse(fields[1]);
      final availableKb = int.tryParse(fields[3]);
      if (totalKb == null || availableKb == null) return null;
      return StorageInfo(
        totalBytes: totalKb * 1024,
        availableBytes: availableKb * 1024,
      );
    } catch (_) {
      return null;
    }
  }
}
