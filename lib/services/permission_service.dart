part of '../pages/cleaner_home_page.dart';

extension CleanerHomePagePermissions on _CleanerHomePageState {
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
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
        dialogTitle: 'Grant access to scan your home directory',
        initialDirectory: _selectedPath,
      );

      if (selectedDirectory != null) {
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
    final result = await showCupertinoDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(CupertinoIcons.lock, color: CupertinoColors.systemOrange),
            SizedBox(width: 8),
            Text('Permission Required'),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This app needs permission to access your home directory to scan for files.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'What this app will do:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('• Scan for APK, AAB, and IPA files'),
                      Text('• Find Flutter build folders'),
                      Text('• Find React Native node_modules folders'),
                      Text('• Calculate file and folder sizes'),
                      Text('• Allow you to delete unwanted files'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Click "Grant Access" to open the system dialog and select your home directory.',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text(AppConstants.cancelButton),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.of(context).pop(true),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.folder, size: 16),
                SizedBox(width: 4),
                Text('Grant Access'),
              ],
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await _requestFileAccess();
    }
  }
}

