import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cleaner/pages/cleaner_home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_cleaner/constants.dart';
import 'package:flutter_cleaner/scan_result.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';

part '../utils/xcode/xcode_utils.dart';
part '../services/xcode/xcode_permission_service.dart';
part '../services/xcode/xcode_scan_service.dart';
part '../services/xcode/xcode_clean_service.dart';
part '../widgets/xcode/xcode_widgets.dart';
part '../widgets/xcode/xcode_dialogs.dart';

class XcodeCacheCleanerPage extends StatefulWidget {
  const XcodeCacheCleanerPage({super.key});

  @override
  State<XcodeCacheCleanerPage> createState() => _XcodeCacheCleanerPageState();
}

class _XcodeCacheCleanerPageState extends State<XcodeCacheCleanerPage>
    with TickerProviderStateMixin {
  // Cache categories with their items
  Map<String, XcodeCacheCategory> _cacheCategories = {};
  Set<String> _selectedItems = {}; // Set of selected item paths
  Set<String> _expandedCategories = {}; // Set of expanded category keys
  
  bool _isScanning = false;
  bool _isDeleting = false;
  bool _hasPermission = false;
  String? _grantedLibraryPath; // Stored path for persistent access
  double _scanProgress = 0.0;
  String _currentScanPath = '';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;
  late Animation<double> _rotationAnimation;

  // Xcode cache paths
  static const List<XcodeCachePath> _xcodePaths = [
    XcodeCachePath(
      path: '~/Library/Developer/Xcode/iOS DeviceSupport',
      type: AppConstants.xcodeDeviceSupportIndicator,
      typeLabel: AppConstants.xcodeDeviceSupportType,
    ),
    XcodeCachePath(
      path: '~/Library/Developer/Xcode/Archives',
      type: AppConstants.xcodeArchivesIndicator,
      typeLabel: AppConstants.xcodeArchivesType,
    ),
    XcodeCachePath(
      path: '~/Library/Developer/Xcode/DerivedData',
      type: AppConstants.xcodeDerivedDataIndicator,
      typeLabel: AppConstants.xcodeDerivedDataType,
    ),
    XcodeCachePath(
      path: '~/Library/Developer/Xcode/DocumentationCache',
      type: AppConstants.xcodeDocCacheIndicator,
      typeLabel: AppConstants.xcodeDocCacheType,
    ),
    XcodeCachePath(
      path: '~/Library/Logs/CoreSimulator',
      type: AppConstants.xcodeOldLogsIndicator,
      typeLabel: AppConstants.xcodeOldLogsType,
    ),
    XcodeCachePath(
      path: '~/Library/Developer/Shared/Documentation/DocSets',
      type: AppConstants.xcodeOldDocDownloadsIndicator,
      typeLabel: AppConstants.xcodeOldDocDownloadsType,
    ),
  ];

  // Get total size of all items
  int get _totalSize {
    int total = 0;
    for (final category in _cacheCategories.values) {
      for (final item in category.items) {
        total += item.size;
      }
    }
    return total;
  }

  // Get size of selected items
  int get _selectedSize {
    int total = 0;
    for (final category in _cacheCategories.values) {
      for (final item in category.items) {
        if (_selectedItems.contains(item.path)) {
          total += item.size;
        }
      }
    }
    return total;
  }

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
    _loadStoredPermissions();
    _checkInitialPermissions();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_cacheCategories.isNotEmpty && !_isScanning) {
      _animationController.forward();
    }

    if (_isScanning) {
      _progressController.repeat();
    } else {
      _progressController.stop();
    }

    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  // Header section with scan button
                  Padding(
                    padding: const EdgeInsets.all(11.2),
                    child: _buildHeaderSection(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 11.2),
                    child: _buildScanButton(),
                  ),
                  const SizedBox(height: 11.2),

                  // Permission prompt (if no permission)
                  if (!_hasPermission && !_isScanning) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.2),
                      child: _buildPermissionPrompt(),
                    ),
                    const SizedBox(height: 8.4),
                  ],

                  // Progress indicator (only during scanning)
                  if (_isScanning) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.2),
                      child: _buildProgressCard(),
                    ),
                    const SizedBox(height: 8.4),
                  ],

                  // Select All checkbox (if categories exist)
                  if (_cacheCategories.isNotEmpty && !_isScanning) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.2),
                      child: _buildSelectAllCheckbox(),
                    ),
                    const SizedBox(height: 8.4),
                  ],
                  
                  // Cache categories list
                  if (_cacheCategories.isNotEmpty || _isScanning)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 11.2),
                      child: _buildCacheCategoriesList(),
                    )
                  else if (!_isScanning)
                    Padding(
                      padding: const EdgeInsets.all(22.4),
                      child: _buildEmptyState(),
                    ),

                  // Summary (without clean button)
                  if (_cacheCategories.isNotEmpty) _buildBottomSummary(),
                  
                  // Footer spacing for floating button
                  const SizedBox(height: 70),
                ],
              ),
            ),
            // Floating Clean Button
            if (_cacheCategories.isNotEmpty && !_isScanning)
              _buildFloatingCleanButton(),
          ],
        ),
      ),
    );
  }
}

// Custom painter for circular progress
class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * 3.14159 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

// Data models
class XcodeCachePath {
  final String path;
  final String type;
  final String typeLabel;

  const XcodeCachePath({
    required this.path,
    required this.type,
    required this.typeLabel,
  });
}

class XcodeCacheCategory {
  final String key;
  final String label;
  final String type;
  final List<XcodeCacheItem> items;

  XcodeCacheCategory({
    required this.key,
    required this.label,
    required this.type,
    required this.items,
  });

  int get totalSize {
    return items.fold<int>(0, (sum, item) => sum + item.size);
  }
}

class XcodeCacheItem {
  final String path;
  final String name;
  final int size;
  final bool isDirectory;
  final DateTime lastModified;
  final String? workspacePath; // For DerivedData items, the workspace path

  XcodeCacheItem({
    required this.path,
    required this.name,
    required this.size,
    required this.isDirectory,
    required this.lastModified,
    this.workspacePath,
  });
}

