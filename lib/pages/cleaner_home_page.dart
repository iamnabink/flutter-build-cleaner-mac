import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cleaner/constants.dart';
import 'package:flutter_cleaner/pages/xcode_cache_cleaner_page.dart';
import 'package:flutter_cleaner/pages/paywall_page.dart';
import 'package:flutter_cleaner/scan_result.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

part '../utils/file_system_utils.dart';
part '../utils/scan_checks_utils.dart';
part '../services/scan_control_service.dart';
part '../services/directory_traversal_service.dart';
part '../services/permission_service.dart';
part '../services/clean_operations_service.dart';
part '../widgets/action_buttons.dart';
part '../widgets/progress_card.dart';
part '../widgets/results_summary_card.dart';
part '../widgets/results_list.dart';
part '../widgets/results_warnings.dart';
part '../widgets/header_section.dart';
part '../widgets/extras/dialogs_core.dart';
part '../widgets/extras/dialogs_about.dart';

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
  String _appVersionLabel = AppConstants.appVersion;
  String _buildNumberLabel = AppConstants.buildNumber;

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
    _loadAppMetadata();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _progressController.dispose();
    super.dispose();
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

    return CupertinoPageScaffold(
      navigationBar: _buildNavigationBar(),
      child: UpgradeAlert(
        child: SafeArea(
            child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 11.2, vertical: 8.4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                _buildHeaderSection(),
                const SizedBox(height: 11.2),
        
                // Xcode Cache Cleaner button (macOS only)
                if (Platform.isMacOS) ...[
                  _buildXcodeCacheCleanerButton(),
                  const SizedBox(height: 11.2),
                ],
        
                // Action buttons
                _buildActionButtons(),
                const SizedBox(height: 8.4),
        
                // Stats bar (only during scanning)
                if (_isScanning) ...[
                  _buildStatsBar(),
                  const SizedBox(height: 8.4),
                ],
        
                // Progress indicator
                _buildProgressCard(),
                if (_isScanning || _isDeleting) const SizedBox(height: 8.4),
        
                // Permission warnings
                _buildPermissionWarnings(),
                if (_permissionErrors.isNotEmpty) const SizedBox(height: 8.4),
        
                // Summary card
                _buildSummaryCard(),
                const SizedBox(height: 8.4),
        
                // Results list
                _buildResultsList(),
        
                // Footer spacing
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _loadAppMetadata() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _appVersionLabel = 'Version ${info.version}';
        _buildNumberLabel = 'Build ${info.buildNumber}';
      });
    } catch (_) {
      // Ignore errors and fall back to default labels.
    }
  }
}
