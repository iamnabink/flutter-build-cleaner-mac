part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerPermissions on _XcodeCacheCleanerPageState {
  Future<void> _loadStoredPermissions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedPath = prefs.getString('xcode_developer_path');
      if (storedPath != null && storedPath.isNotEmpty) {
        setState(() {
          _grantedLibraryPath = storedPath;
        });
      }
    } catch (e) {
      // Ignore errors when loading preferences
    }
  }

  Future<void> _saveLibraryPath(String developerPath) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('xcode_developer_path', developerPath);
      setState(() {
        _grantedLibraryPath = developerPath;
      });
    } catch (e) {
      // Ignore errors when saving preferences
    }
  }

  Future<void> _checkInitialPermissions() async {
    try {
      // First, try the stored path if available
      if (_grantedLibraryPath != null && _grantedLibraryPath!.isNotEmpty) {
        final storedDir = Directory(_grantedLibraryPath!);
        if (await storedDir.exists()) {
          try {
            await storedDir.list().take(1).toList();
            setState(() {
              _hasPermission = true;
            });
            return;
          } catch (e) {
            // Stored path no longer accessible, clear it
            setState(() {
              _grantedLibraryPath = null;
              _hasPermission = false;
            });
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('xcode_developer_path');
          }
        }
      }

      // Fallback: Test access to Developer directory
      final homeDir = await _expandPath('~/');
      final developerDir = Directory('$homeDir/Library/Developer');
      if (await developerDir.exists()) {
        try {
          await developerDir.list().take(1).toList();
          setState(() {
            _hasPermission = true;
            _grantedLibraryPath = developerDir.path;
          });
          await _saveLibraryPath(developerDir.path);
        } catch (e) {
          setState(() {
            _hasPermission = false;
          });
        }
      } else {
        setState(() {
          _hasPermission = false;
        });
      }
    } catch (e) {
      setState(() {
        _hasPermission = false;
      });
    }
  }

  Future<bool> _requestFileAccess() async {
    try {
      final homeDir = await _expandPath('~/');
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Select ~/Library/Developer folder to scan Xcode cache files',
        initialDirectory: '$homeDir/Library/Developer',
      );

      if (selectedDirectory != null) {
        final testDir = Directory(selectedDirectory);
        try {
          await testDir.list().take(1).toList();
          // Store the granted path for persistent access
          await _saveLibraryPath(selectedDirectory);
          setState(() {
            _hasPermission = true;
          });
          return true;
        } catch (e) {
          _showSnackBar(
            'Cannot access $selectedDirectory. Please try again.',
            isError: true,
          );
          return false;
        }
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
}

