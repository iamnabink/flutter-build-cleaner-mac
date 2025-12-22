part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerScanControl on _XcodeCacheCleanerPageState {
  Future<void> _scanXcodeCaches() async {
    if (_isScanning) return;

    if (!_hasPermission) {
      await _showPermissionDialog();
      if (!_hasPermission) {
        _showSnackBar('Permission required to scan Xcode cache files', isError: true);
        return;
      }
    }

    setState(() {
      _isScanning = true;
      _cacheCategories.clear();
      _selectedItems.clear();
      _scanProgress = 0.0;
    });

    _animationController.forward();
    _progressController.repeat();

    int totalPaths = _XcodeCacheCleanerPageState._xcodePaths.length;
    if (totalPaths == 0) totalPaths = 1;

    for (int i = 0; i < _XcodeCacheCleanerPageState._xcodePaths.length; i++) {
      if (!mounted || !_isScanning) break;

      final xcodePath = _XcodeCacheCleanerPageState._xcodePaths[i];
      final expandedPath = await _expandPath(xcodePath.path);
      final directory = Directory(expandedPath);

      setState(() {
        _currentScanPath = expandedPath;
        _scanProgress = (i + 1) / totalPaths;
      });

      // Debug: Print the path being scanned
      print('Scanning Xcode cache: $expandedPath');
      
      final exists = await directory.exists();
      print('Directory exists: $exists for $expandedPath');
      
      if (exists) {
        try {
          final items = await _scanXcodeDirectory(directory, xcodePath.type);
          
          // Always create the category, even if empty
          if (mounted) {
            setState(() {
              _cacheCategories[xcodePath.type] = XcodeCacheCategory(
                key: xcodePath.type,
                label: xcodePath.typeLabel,
                type: xcodePath.type,
                items: items,
              );
            });
          }
        } catch (e) {
          // Create empty category on error, but log the error
          if (mounted) {
            setState(() {
              _cacheCategories[xcodePath.type] = XcodeCacheCategory(
                key: xcodePath.type,
                label: xcodePath.typeLabel,
                type: xcodePath.type,
                items: [],
              );
            });
            
          }
        }
      } else {
        // Directory doesn't exist, create empty category
        setState(() {
          _cacheCategories[xcodePath.type] = XcodeCacheCategory(
            key: xcodePath.type,
            label: xcodePath.typeLabel,
            type: xcodePath.type,
            items: [],
          );
        });
      }
    }

    if (mounted) {
      setState(() {
        _isScanning = false;
        _currentScanPath = '';
        _scanProgress = 1.0;
      });
      _progressController.stop();
      _animationController.forward();
      await _requestReviewIfFirstScan();
    }
  }

  Future<List<XcodeCacheItem>> _scanXcodeDirectory(Directory directory, String cacheType) async {
    final items = <XcodeCacheItem>[];
    
    if (!mounted || !_isScanning) return items;

    try {
      setState(() {
        _currentScanPath = directory.path;
      });

      // Check if directory exists
      if (!await directory.exists()) {
        return items;
      }

      await Future.delayed(const Duration(milliseconds: 10));

      // Try to list directory contents - use toList() to get all items at once
      // This is more reliable than await for
      try {
        final entities = await directory.list(followLinks: false).toList();
        print('Found ${entities.length} items in ${directory.path}');
        
        // For DerivedData, we'll filter items after collecting them
        final isDerivedData = cacheType == AppConstants.xcodeDerivedDataIndicator;
        const minSizeForDerivedData = 100 * 1024 * 1024; // 100 MB in bytes
        
        for (final entity in entities) {
          if (!mounted || !_isScanning) break;

          try {
            // Check if it's a file or directory
            final entityType = await FileSystemEntity.type(entity.path);
            
            if (entityType == FileSystemEntityType.file) {
              try {
                final stat = await File(entity.path).stat();
                final item = XcodeCacheItem(
                  path: entity.path,
                  name: path.basename(entity.path),
                  size: stat.size,
                  isDirectory: false,
                  lastModified: stat.modified,
                );
                
                // For DerivedData, filter: must be 100MB+ and (Runner or .xcworkspace related)
                if (isDerivedData) {
                  final itemName = item.name.toLowerCase();
                  final itemPath = item.path.toLowerCase();
                  final isRunner = itemName.contains('runner');
                  final isXcworkspace = itemName.contains('.xcworkspace') || 
                                         itemPath.contains('.xcworkspace');
                  
                  if (item.size >= minSizeForDerivedData && (isRunner || isXcworkspace)) {
                    items.add(item);
                  }
                } else {
                  items.add(item);
                }
              } catch (e) {
                // Skip files we can't access
                continue;
              }
            } else if (entityType == FileSystemEntityType.directory) {
              try {
                final stat = await Directory(entity.path).stat();
                // Calculate directory size (this may take time for large directories)
                final size = await _getDirectorySize(Directory(entity.path));
                
                // For DerivedData, try to find the workspace path
                String? workspacePath;
                if (isDerivedData) {
                  workspacePath = await _findWorkspacePathForDerivedData(entity.path);
                }
                
                final item = XcodeCacheItem(
                  path: entity.path,
                  name: path.basename(entity.path),
                  size: size,
                  isDirectory: true,
                  lastModified: stat.modified,
                  workspacePath: workspacePath,
                );
                
                // For DerivedData, filter: must be 100MB+ and (Runner or .xcworkspace related)
                if (isDerivedData) {
                  final itemName = item.name.toLowerCase();
                  final itemPath = item.path.toLowerCase();
                  final isRunner = itemName.contains('runner');
                  final isXcworkspace = itemName.contains('.xcworkspace') || 
                                         itemPath.contains('.xcworkspace') ||
                                         (workspacePath != null && workspacePath.toLowerCase().contains('.xcworkspace'));
                  
                  if (item.size >= minSizeForDerivedData && (isRunner || isXcworkspace)) {
                    items.add(item);
                  }
                } else {
                  items.add(item);
                }
              } catch (e) {
                // Try to add directory even if we can't get size
                try {
                  final stat = await Directory(entity.path).stat();
                  final item = XcodeCacheItem(
                    path: entity.path,
                    name: path.basename(entity.path),
                    size: 0,
                    isDirectory: true,
                    lastModified: stat.modified,
                  );
                  
                  // For DerivedData, only add if it's Runner or .xcworkspace related
                  // (even if size is 0, we'll check the name)
                  if (isDerivedData) {
                    final workspacePath = await _findWorkspacePathForDerivedData(entity.path);
                    final itemWithWorkspace = XcodeCacheItem(
                      path: item.path,
                      name: item.name,
                      size: item.size,
                      isDirectory: item.isDirectory,
                      lastModified: item.lastModified,
                      workspacePath: workspacePath,
                    );
                    
                    final itemName = itemWithWorkspace.name.toLowerCase();
                    final itemPath = itemWithWorkspace.path.toLowerCase();
                    final isRunner = itemName.contains('runner');
                    final isXcworkspace = itemName.contains('.xcworkspace') || 
                                           itemPath.contains('.xcworkspace') ||
                                           (workspacePath != null && workspacePath.toLowerCase().contains('.xcworkspace'));
                    
                    if (isRunner || isXcworkspace) {
                      items.add(itemWithWorkspace);
                    }
                  } else {
                    items.add(item);
                  }
                } catch (_) {
                  // Skip if we can't even get basic info
                  continue;
                }
              }
            }
          } catch (e) {
            // Skip items we can't access
            continue;
          }
        }
      } catch (e) {
        // If list() fails, try alternative approach
      }
    } catch (e) {
    }

    return items;
  }

  Future<void> _requestReviewIfFirstScan() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hasRequestedReview = prefs.getBool('has_requested_review_xcode') ?? false;
      
      if (!hasRequestedReview) {
        final review = InAppReview.instance;
        if (await review.isAvailable()) {
          await review.requestReview();
          await prefs.setBool('has_requested_review_xcode', true);
        }
      }
    } catch (_) {
      // Silently fail if review request fails
    }
  }
}

