
class ScanResult {
  final String path;
  final int size;
  final bool isDirectory;
  final String type; // 'apk', 'aab', 'build'
  final DateTime lastModified;

  ScanResult({
    required this.path,
    required this.size,
    required this.isDirectory,
    required this.type,
    required this.lastModified,
  });
}
