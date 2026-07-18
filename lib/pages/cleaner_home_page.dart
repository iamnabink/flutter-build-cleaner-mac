import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:flutter_cleaner/constants.dart';
import 'package:flutter_cleaner/pages/main_view.dart';
import 'package:flutter_cleaner/scan_result.dart';
import 'package:flutter_cleaner/services/revenue_cat_service.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:macos_ui/macos_ui.dart';

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

class _SummaryItemData {
  final String label;
  final int count;
  final IconData icon;
  final Color color;

  const _SummaryItemData(this.label, this.count, this.icon, this.color);
}

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

  bool _hasPermission = false;
  String _selectedPath = '';

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
    if (_scanResults.isNotEmpty && !_isScanning) {
      _animationController.forward();
    }

    if (_isScanning) {
      _progressController.repeat();
    } else {
      _progressController.stop();
    }

    return MacosScaffold(
      toolBar: _buildToolBar(),
      children: [
        ContentArea(
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header section
                _buildHeaderSection(),
                const SizedBox(height: 11.2),

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
      ],
    );
  }
}
