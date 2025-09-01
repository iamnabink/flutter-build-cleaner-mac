import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cleaner/scan_result.dart';
import 'package:path/path.dart' as path;
import 'package:file_picker/file_picker.dart';

class CleanerHomePage extends StatefulWidget {
  const CleanerHomePage({Key? key}) : super(key: key);

  @override
  State<CleanerHomePage> createState() => _CleanerHomePageState();
}

class _CleanerHomePageState extends State<CleanerHomePage>
    with TickerProviderStateMixin {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  bool _isDeleting = false;
  int _filesFound = 0;
  int _foldersFound = 0;
  int _totalSizeScanned = 0;
  double _scanProgress = 0.0;
  String _currentScanPath = '';
  List<String> _permissionErrors = [];
  int _directoriesScanned = 0;
  int _totalDirectories = 0;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;
  late Animation<double> _rotationAnimation;

  bool _hasPermission = false;

  String _selectedPath = '';

  static const platform = MethodChannel(
    'com.nabrajkhadka.flutterCleaner.macos/permissions',
  );

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _progressController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );
    _checkInitialPermissions();
  }

  Future<void> _checkInitialPermissions() async {
    try {
      final testDir = Directory(_selectedPath);
      await testDir.list().take(1).toList();
      setState(() {
        _hasPermission = true;
      });
    } catch (e) {
      setState(() {
        _hasPermission = false;
      });
    }
  }

  Future<bool> _requestFileAccess() async {
    try {
      // Use file_picker to trigger system permission dialog
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Grant access to scan your home directory',
        initialDirectory: _selectedPath,
      );

      if (selectedDirectory != null) {
        // Test if we can actually read the directory
        final testDir = Directory(selectedDirectory);
        await testDir.list().take(1).toList();

        setState(() {
          _hasPermission = true;
          _selectedPath = selectedDirectory;
        });
        return true;
      }
      return false;
    } catch (e) {
      _showSnackBar(
        'Failed to get directory access: ${e.toString()}',
        isError: true,
      );
      return false;
    }
  }

  Future<void> _showPermissionDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.security, color: Colors.orange),
            SizedBox(width: 8),
            Text('Permission Required'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This app needs permission to access your home directory to scan for files.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'What this app will do:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('• Scan for .apk and .aab files'),
                    const Text('• Find Flutter build/ folders'),
                    const Text('• Calculate file and folder sizes'),
                    const Text('• Allow you to delete unwanted files'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Click "Grant Access" to open the system dialog and select your home directory.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.folder_open),
            label: const Text('Grant Access'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _requestFileAccess();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

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
          } catch (e) {
            // Skip files we can't access
          }
        }
      }
    } catch (e) {
      // Skip directories we can't access
    }
    return totalSize;
  }

  Future<int> _countDirectories(String rootPath) async {
    int count = 0;
    try {
      final directory = Directory(rootPath);
      if (!await directory.exists()) return 0;

      await for (final entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is Directory &&
            !_shouldSkipDirectory(path.basename(entity.path))) {
          count++;
        }
      }
    } catch (e) {
      // Ignore errors during counting
    }
    return count;
  }

  Future<void> _scanSystem() async {
    if (_isScanning) return;

    // Check permissions first
    if (!_hasPermission) {
      await _showPermissionDialog();
      if (!_hasPermission) {
        _showSnackBar('Permission required to scan files', isError: true);
        return;
      }
    }

    // Check if the scan path exists and is accessible
    final scanDir = Directory(_selectedPath);
    if (!await scanDir.exists()) {
      _showSnackBar('Directory $_selectedPath does not exist', isError: true);
      return;
    }

    // Test access before starting scan
    try {
      await scanDir.list().take(1).toList();
    } catch (e) {
      _showSnackBar(
        'Cannot access $_selectedPath. Please grant permission.',
        isError: true,
      );
      setState(() {
        _hasPermission = false;
      });
      return;
    }

    setState(() {
      _isScanning = true;
      _scanResults.clear();
      _filesFound = 0;
      _foldersFound = 0;
      _totalSizeScanned = 0;
      _scanProgress = 0.0;
      _directoriesScanned = 0;
      _permissionErrors.clear();
    });

    _animationController.forward();
    _progressController.repeat();

    // First, count total directories for progress calculation
    _totalDirectories = await _countDirectories(_selectedPath);

    if (_totalDirectories == 0) {
      _totalDirectories = 1; // Prevent division by zero
    }

    await _scanDirectory(_selectedPath);

    if (mounted) {
      setState(() {
        _isScanning = false;
        _currentScanPath = '';
        _scanProgress = 1.0;
      });
      _progressController.stop();
    }
  }

  Future<void> _scanDirectory(String dirPath) async {
    if (!mounted || !_isScanning) return;

    try {
      final directory = Directory(dirPath);
      if (!await directory.exists()) return;

      setState(() {
        _currentScanPath = dirPath;
        _directoriesScanned++;
        _scanProgress = _directoriesScanned / _totalDirectories;
      });

      // Small delay to allow UI updates
      await Future.delayed(const Duration(milliseconds: 10));

      final entities = <FileSystemEntity>[];
      await for (final entity in directory.list(followLinks: false)) {
        if (!mounted || !_isScanning) break;
        entities.add(entity);
      }

      for (final entity in entities) {
        if (!mounted || !_isScanning) break;

        try {
          if (entity is File) {
            final fileName = path.basename(entity.path).toLowerCase();
            if (fileName.endsWith('.apk') || fileName.endsWith('.aab')) {
              final stat = await entity.stat();
              final result = ScanResult(
                path: entity.path,
                size: stat.size,
                isDirectory: false,
                type: fileName.endsWith('.apk') ? 'apk' : 'aab',
                lastModified: stat.modified,
              );

              setState(() {
                _scanResults.add(result);
                _filesFound++;
                _totalSizeScanned += stat.size;
              });
            }
          }
          if (entity is File) {
            final fileName = path.basename(entity.path).toLowerCase();
            if (fileName.endsWith('.ipa')) {
              final stat = await entity.stat();
              final result = ScanResult(
                path: entity.path,
                size: stat.size,
                isDirectory: false,
                type: fileName.endsWith('.ipa') ? 'ipa' : 'Unknown',
                lastModified: stat.modified,
              );

              setState(() {
                _scanResults.add(result);
                _filesFound++;
                _totalSizeScanned += stat.size;
              });
            }
          } else if (entity is Directory) {
            final dirName = path.basename(entity.path);
            if (dirName == 'build' && await _isFlutterBuildDirectory(entity)) {
              final size = await _getDirectorySize(entity);
              final stat = await entity.stat();
              final result = ScanResult(
                path: entity.path,
                size: size,
                isDirectory: true,
                type: 'build',
                lastModified: stat.modified,
              );

              setState(() {
                _scanResults.add(result);
                _foldersFound++;
                _totalSizeScanned += size;
              });
            } else if (!_shouldSkipDirectory(dirName)) {
              // Recursively scan subdirectories
              await _scanDirectory(entity.path);
            }
          }
        } catch (e) {
          // Handle permission errors
          if (e.toString().contains('Permission denied') ||
              e.toString().contains('Operation not permitted')) {
            if (!_permissionErrors.contains(entity.path)) {
              _permissionErrors.add('Permission denied: ${entity.path}');
            }
          }
        }
      }
    } catch (e) {
      // Handle directory access errors
      if (e.toString().contains('Permission denied') ||
          e.toString().contains('Operation not permitted')) {
        if (!_permissionErrors.contains(dirPath)) {
          _permissionErrors.add('Permission denied: $dirPath');
        }
      }
    }
  }

  bool _shouldSkipDirectory(String dirName) {
    const skipDirs = {
      '.git', '.svn', '.hg', // Version control
      'node_modules', '.npm', // Node.js
      '.dart_tool', '.pub-cache', '.flutter', // Dart/Flutter
      '.gradle', '.android', // Android
      '.vscode', '.idea', // IDEs
      'Library', 'Applications', 'System', // macOS system dirs
      '.Trash', '.cache', '.tmp', // Cache/temp
      '__pycache__', '.pytest_cache', // Python
      'target', // Rust/Java
      'dist', 'build', // General build dirs (except Flutter build)
    };
    return skipDirs.contains(dirName) || dirName.startsWith('.');
  }

  Future<bool> _isFlutterBuildDirectory(Directory buildDir) async {
    try {
      // Check if parent directory contains pubspec.yaml
      final parentDir = buildDir.parent;
      final pubspecFile = File(path.join(parentDir.path, 'pubspec.yaml'));

      if (await pubspecFile.exists()) {
        // Double-check by reading pubspec content
        final content = await pubspecFile.readAsString();
        return content.contains('flutter:') || content.contains('sdk: flutter');
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _cleanAll() async {
    if (_scanResults.isEmpty) return;

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() {
      _isDeleting = true;
    });

    int deletedCount = 0;
    int failedCount = 0;
    int totalSize = _scanResults.fold<int>(
      0,
      (sum, result) => sum + result.size,
    );

    for (int i = 0; i < _scanResults.length; i++) {
      if (!mounted) break;

      final result = _scanResults[i];
      try {
        if (result.isDirectory) {
          await Directory(result.path).delete(recursive: true);
        } else {
          await File(result.path).delete();
        }
        deletedCount++;
      } catch (e) {
        failedCount++;
      }

      // Update progress
      setState(() {
        _scanProgress = (i + 1) / _scanResults.length;
      });
    }

    setState(() {
      _isDeleting = false;
      _scanResults.clear();
      _filesFound = 0;
      _foldersFound = 0;
      _totalSizeScanned = 0;
      _scanProgress = 0.0;
    });

    _animationController.reverse();

    String message =
        'Successfully deleted $deletedCount items, freed ${_formatFileSize(totalSize)}';
    if (failedCount > 0) {
      message += '\n$failedCount items could not be deleted';
    }

    _showSnackBar(message, isError: failedCount > 0);
  }

  Future<bool> _showConfirmationDialog() async {
    final totalSize = _scanResults.fold<int>(
      0,
      (sum, result) => sum + result.size,
    );

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text('Confirm Deletion'),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Are you sure you want to delete the following items?',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.errorContainer.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Theme.of(
                          context,
                        ).colorScheme.error.withOpacity(0.5),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total items:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${_scanResults.length}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total size:',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              _formatFileSize(totalSize),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '⚠️ This action cannot be undone!',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Delete All'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: isError ? 5 : 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    return SizedBox(
      width: 200,
      height: 50,
      child: FilledButton.icon(
        onPressed: _isScanning || _isDeleting
            ? null
            : () async {
                if (!_hasPermission) {
                  await _showPermissionDialog();
                } else {
                  await _scanSystem();
                }
              },
        icon: _isScanning
            ? AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: const Icon(Icons.refresh, size: 20),
                  );
                },
              )
            : Icon(_hasPermission ? Icons.search : Icons.lock),
        label: Text(
          _isScanning
              ? 'Scanning...'
              : _hasPermission
              ? 'Scan Directory'
              : 'Grant Permission',
          style: const TextStyle(fontSize: 16),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: _hasPermission
              ? Theme.of(context).colorScheme.primary
              : Colors.orange,
        ),
      ),
    );
  }

  Widget _buildCleanButton() {
    return SizedBox(
      width: 200,
      height: 50,
      child: FilledButton.icon(
        onPressed: _scanResults.isEmpty || _isScanning || _isDeleting
            ? null
            : _cleanAll,
        icon: _isDeleting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.delete_sweep),
        label: Text(
          _isDeleting ? 'Deleting...' : 'Clean All',
          style: const TextStyle(fontSize: 16),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProgressCard() {
    if (!_isScanning && !_isDeleting) return const SizedBox.shrink();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 60,
                  height: 60,
                  child: Stack(
                    children: [
                      CircularProgressIndicator(
                        value: _scanProgress > 0 ? _scanProgress : null,
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surfaceVariant,
                      ),
                      Center(
                        child: Text(
                          '${(_scanProgress * 100).toInt()}%',
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isDeleting
                            ? 'Deleting Files...'
                            : 'Scanning System...',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.folder,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('Files: $_filesFound'),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.inventory,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('Folders: $_foldersFound'),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.storage,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text('Size: ${_formatFileSize(_totalSizeScanned)}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_currentScanPath.isNotEmpty && !_isDeleting) ...[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ${_currentScanPath.replaceFirst(_selectedPath, '~')}',
                style: Theme.of(context).textTheme.bodySmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    if (_scanResults.isEmpty && !_isScanning) {
      return Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(
                _hasPermission ? Icons.folder_outlined : Icons.lock,
                size: 64,
                color: _hasPermission
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.6)
                    : Colors.orange.withOpacity(0.6),
              ),
              const SizedBox(height: 16),
              Text(
                _hasPermission ? 'No scan results yet' : 'Permission Required',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _hasPermission
                    ? 'Click "Scan System" to find IPA files, APK files, AAB files, and Flutter build folders'
                    : 'Grant permission to access your home directory to start scanning',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _requestFileAccess,
                style: FilledButton.styleFrom(
                  backgroundColor: _hasPermission
                      ? Theme.of(context).colorScheme.primary
                      : Colors.orange,
                ),
                child: Text(
                  _selectedPath.isEmpty
                      ? "Select a directory/path to scan"
                      : 'Scan Path: $_selectedPath',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _hasPermission
                        ? Colors.white
                        : Colors.orange.shade700,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              if (!_hasPermission) ...[
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _requestFileAccess,
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Select Directory & Grant Access'),
                  style: FilledButton.styleFrom(backgroundColor: Colors.orange),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (_scanResults.isEmpty) return const SizedBox.shrink();

    final totalSize = _scanResults.fold<int>(
      0,
      (sum, result) => sum + result.size,
    );
    final apkCount = _scanResults.where((r) => r.type == 'apk').length;
    final aabCount = _scanResults.where((r) => r.type == 'aab').length;
    final ipaCount = _scanResults.where((r) => r.type == 'ipa').length;
    final buildCount = _scanResults.where((r) => r.type == 'build').length;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(
                'Scan Results',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSummaryItem(
                    'APK Files',
                    apkCount,
                    Icons.android,
                    Colors.green,
                  ),
                  _buildSummaryItem(
                    'AAB Files',
                    aabCount,
                    Icons.inventory,
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    'IPA Files',
                    ipaCount,
                    Icons.inventory,
                    Colors.blue,
                  ),
                  _buildSummaryItem(
                    'Build Folders',
                    buildCount,
                    Icons.folder,
                    Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(
                        context,
                      ).colorScheme.primaryContainer.withOpacity(0.7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cleaning_services,
                      size: 28,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Total space to free: ${_formatFileSize(totalSize)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    int count,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildResultsList() {
    // Sort by size (largest first)
    final sortedResults = List<ScanResult>.from(_scanResults)
      ..sort((a, b) => b.size.compareTo(a.size));

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.list,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Found Items (${sortedResults.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Sorted by size',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: const Text("No Flutter build folders/artifacts found."),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedResults.length,
              itemBuilder: (context, index) {
                final result = sortedResults[index];
                return _buildResultItem(result, index == 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(ScanResult result, bool isLargest) {
    IconData icon;
    Color iconColor;

    switch (result.type) {
      case 'apk':
        icon = Icons.android;
        iconColor = Colors.green;
        break;
      case 'aab':
        icon = Icons.inventory;
        iconColor = Colors.blue;
        break;
      case 'build':
        icon = Icons.folder;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.file_present;
        iconColor = Colors.grey;
    }

    final relativePath = result.path.replaceFirst(_selectedPath, '~');

    return Container(
      decoration: BoxDecoration(
        color: isLargest
            ? Theme.of(context).colorScheme.errorContainer.withOpacity(0.2)
            : null,
        border: isLargest
            ? Border.all(
                color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                width: 2,
              )
            : Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor.withOpacity(0.2),
                ),
              ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                path.basename(result.path),
                style: TextStyle(
                  fontWeight: isLargest ? FontWeight.bold : FontWeight.w500,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isLargest)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'LARGEST',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              relativePath,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    result.type.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: iconColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  result.isDirectory ? 'Folder' : 'File',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 8),
                Text(
                  '• Modified: ${_formatDate(result.lastModified)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              _formatFileSize(result.size),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isLargest
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
                fontSize: 16,
              ),
            ),
            Text(
              result.isDirectory ? 'FOLDER' : 'FILE',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
        onTap: () => _showItemDetails(result),
      ),
    );
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

  void _showItemDetails(ScanResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.isDirectory ? Icons.folder : Icons.file_present,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                path.basename(result.path),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Type', result.type.toUpperCase()),
              _buildDetailRow('Kind', result.isDirectory ? 'Folder' : 'File'),
              _buildDetailRow('Size', _formatFileSize(result.size)),
              _buildDetailRow('Last Modified', result.lastModified.toString()),
              _buildDetailRow('Full Path', result.path),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          FilledButton.icon(
            onPressed: () async {
              Navigator.of(context).pop();
              await _deleteItem(result);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SelectableText(
              value,
              style: TextStyle(
                fontFamily: label == 'Full Path' ? 'monospace' : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteItem(ScanResult result) async {
    try {
      if (result.isDirectory) {
        await Directory(result.path).delete(recursive: true);
      } else {
        await File(result.path).delete();
      }

      setState(() {
        _scanResults.remove(result);
        if (result.isDirectory) {
          _foldersFound--;
        } else {
          _filesFound--;
        }
        _totalSizeScanned -= result.size;
      });

      _showSnackBar(
        'Deleted ${path.basename(result.path)} (${_formatFileSize(result.size)})',
        isError: false,
      );
    } catch (e) {
      _showSnackBar(
        'Failed to delete ${path.basename(result.path)}: ${e.toString()}',
        isError: true,
      );
    }
  }

  Widget _buildPermissionWarnings() {
    if (_permissionErrors.isEmpty) return const SizedBox.shrink();

    return Card(
      color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                const SizedBox(width: 8),
                Text(
                  'Permission Warnings',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Some directories could not be accessed due to permission restrictions. '
              'Scan results may be incomplete.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
            if (_permissionErrors.length <= 5) ...[
              const SizedBox(height: 12),
              ..._permissionErrors
                  .take(5)
                  .map(
                    (error) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '• ${error.replaceFirst(_selectedPath, '~')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                  ),
            ] else ...[
              const SizedBox(height: 8),
              Text(
                '${_permissionErrors.length} directories could not be accessed',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onErrorContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.folder_outlined,
            'Scanned',
            _directoriesScanned.toString(),
            Theme.of(context).colorScheme.primary,
          ),
          _buildStatItem(
            Icons.error_outline,
            'Errors',
            _permissionErrors.length.toString(),
            Colors.orange,
          ),
          _buildStatItem(
            Icons.timer,
            'Progress',
            '${(_scanProgress * 100).toInt()}%',
            Theme.of(context).colorScheme.secondary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_scanResults.isNotEmpty && !_isScanning) {
      _animationController.forward();
    }

    if (_isScanning) {
      _progressController.repeat();
    } else {
      _progressController.stop();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.cleaning_services,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 8),
            const Text('Flutter Build Cleaner'),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        elevation: 0,
        centerTitle: false,
        actions: [
          if (_scanResults.isNotEmpty && !_isScanning)
            IconButton(
              onPressed: () {
                setState(() {
                  _scanResults.clear();
                  _filesFound = 0;
                  _foldersFound = 0;
                  _totalSizeScanned = 0;
                  _permissionErrors.clear();
                  _directoriesScanned = 0;
                  _scanProgress = 0.0;
                });
                _animationController.reverse();
              },
              icon: const Icon(Icons.clear),
              tooltip: 'Clear Results',
            ),
          IconButton(
            onPressed: () => _showAboutDialog(),
            icon: const Icon(Icons.info_outline),
            tooltip: 'About',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.computer,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'macOS System Cleaner',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Scans $_selectedPath for IPA/APK files, AAB files, and Flutter build folders',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildScanButton(),
                    const SizedBox(width: 20),
                    _buildCleanButton(),
                  ],
                ),
                const SizedBox(height: 24),

                // Stats bar (only during scanning)
                if (_isScanning) ...[
                  _buildStatsBar(),
                  const SizedBox(height: 16),
                ],

                // Progress indicator
                _buildProgressCard(),
                if (_isScanning || _isDeleting) const SizedBox(height: 20),

                // Permission warnings
                _buildPermissionWarnings(),
                if (_permissionErrors.isNotEmpty) const SizedBox(height: 20),

                // Summary card
                _buildSummaryCard(),
                const SizedBox(height: 20),

                // Results list
                _buildResultsList(),

                // Footer spacing
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.info),
            SizedBox(width: 8),
            Text('About Flutter Cleaner'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This app helps you find and remove unnecessary files from your macOS system:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              const Text('• APK files (Android packages)'),
              const Text('• IPA files (iOS Bundles)'),
              const Text('• AAB files (Android App Bundles)'),
              const Text('• Flutter build/ folders'),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Scan Location:',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _selectedPath.isEmpty ? 'N/A' : _selectedPath,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'The app safely skips system directories and handles permission errors gracefully.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 12),
              Center(child: Text("Build with Love by Nabraj Khadka ♥️")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
