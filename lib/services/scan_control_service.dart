part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageScanControl on _CleanerHomePageState {
  Future<void> _scanSystem() async {
    if (_isScanning) return;

    if (!_hasPermission) {
      await _showPermissionDialog();
      if (!_hasPermission) {
        _showSnackBar('Permission required to scan files', isError: true);
        return;
      }
    }

    final scanDir = Directory(_selectedPath);
    if (!await scanDir.exists()) {
      _showSnackBar('Directory $_selectedPath does not exist', isError: true);
      return;
    }

    try {
      await scanDir.list().take(1).toList();
    } catch (_) {
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

    _totalDirectories = await _countDirectories(_selectedPath);
    if (_totalDirectories == 0) _totalDirectories = 1;

    await _scanDirectory(_selectedPath);

    if (mounted) {
      setState(() {
        _isScanning = false;
        _currentScanPath = '';
        _scanProgress = 1.0;
      });
      _progressController.stop();
      
      // Request review on first scan
      await _requestReviewIfFirstScan();
    }
  }

  Future<void> _requestReviewIfFirstScan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasRequestedReview = prefs.getBool('has_requested_review') ?? false;
      
      if (!hasRequestedReview) {
        final review = InAppReview.instance;
        if (await review.isAvailable()) {
          await review.requestReview();
          await prefs.setBool('has_requested_review', true);
        }
      }
    } catch (_) {
      // Silently fail if review request fails
    }
  }
}


