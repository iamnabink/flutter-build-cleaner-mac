part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerDialogs on _XcodeCacheCleanerPageState {
  Future<void> _showPermissionDialog() async {
    final result = await showMacosSheet<bool>(
      context: context,
      builder: (context) => MacosSheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    MacosIcon(
                      CupertinoIcons.lock,
                      color: context.colors.warning,
                      size: 16.8,
                    ),
                    const SizedBox(width: 8.4),
                    Expanded(
                      child: Text(
                        'Permission Required',
                        style: MacosTheme.of(context).typography.title3,
                      ),
                    ),
                    MacosIconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(false),
                      icon: MacosIcon(
                        CupertinoIcons.xmark,
                        size: 14,
                        color: context.colors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This app needs access to your Developer folder to scan and clean Xcode cache files.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.6,
                          color: context.colors.label,
                        ),
                      ),
                      const SizedBox(height: 16.8),
                      // Folder path highlight
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: context.colors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: context.colors.separator,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                MacosIcon(
                                  CupertinoIcons.folder_fill,
                                  color: context.colors.warning,
                                  size: 15.4,
                                ),
                                const SizedBox(width: 7),
                                Text(
                                  'Select this folder:',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: context.colors.label,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 9.8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 11.2,
                                vertical: 9.8,
                              ),
                              decoration: BoxDecoration(
                                color: context.colors.background,
                                borderRadius: BorderRadius.circular(5.6),
                              ),
                              child: Text(
                                '~/Library/Developer',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.warning,
                                  letterSpacing: 0.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 19.6),
                      // What app will do
                      Text(
                        'What this app will do:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: context.colors.label,
                        ),
                      ),
                      const SizedBox(height: 11.2),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildFeatureItem('Scan Xcode cache directories'),
                            const SizedBox(height: 7),
                            _buildFeatureItem('Find Device Support files'),
                            const SizedBox(height: 7),
                            _buildFeatureItem('Find Archives and Derived Data'),
                            const SizedBox(height: 7),
                            _buildFeatureItem('Calculate file and folder sizes'),
                            const SizedBox(height: 7),
                            _buildFeatureItem('Allow you to delete unwanted cache files'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.8),
                      Container(
                        padding: const EdgeInsets.all(11.2),
                        decoration: BoxDecoration(
                          color: context.colors.cardBackground,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: context.colors.separator,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MacosIcon(
                              CupertinoIcons.info,
                              size: 12.6,
                              color: context.colors.secondaryLabel,
                            ),
                            const SizedBox(width: 8.4),
                            Expanded(
                              child: Text(
                                'Click "Grant Access" to open the system dialog and select the Developer folder.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.colors.secondaryLabel,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Footer with action buttons
              Container(
                padding: const EdgeInsets.all(11.2),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.colors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PushButton(
                      controlSize: ControlSize.large,
                      secondary: true,
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(AppConstants.cancelButton),
                    ),
                    const SizedBox(width: 5.6),
                    PushButton(
                      controlSize: ControlSize.large,
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          MacosIcon(CupertinoIcons.folder, size: 12.6),
                          SizedBox(width: 4.2),
                          Text('Grant Access'),
                        ],
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

    if (result == true) {
      await _requestFileAccess();
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final totalSize = _selectedSize;
    final itemCount = _selectedItems.length;

    return await showMacosAlertDialog<bool>(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: Image.asset(
              'assets/images/icon.png',
              width: 56,
              height: 56,
            ),
            title: Text(
              'Confirm Deletion',
              style: MacosTheme.of(context).typography.title3,
            ),
            message: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are you sure you want to delete the selected Xcode cache files?',
                  style: TextStyle(fontSize: 11),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(height: 8.4),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8.4),
                  decoration: BoxDecoration(
                    color: context.colors.cardBackground,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: context.colors.separator,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Selected items:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '$itemCount',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 9.8,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total size:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            _formatFileSize(totalSize),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 9.8,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.4),
                Text(
                  '⚠️ This action cannot be undone!',
                  style: TextStyle(
                    color: context.colors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.8,
                  ),
                ),
              ],
            ),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              color: context.colors.danger,
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('Delete'),
            ),
            secondaryButton: PushButton(
              controlSize: ControlSize.large,
              secondary: true,
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(AppConstants.cancelButton),
            ),
          ),
        ) ??
        false;
  }

  void _showItemDetails(ScanResult result) {
    final xcodePath = _XcodeCacheCleanerPageState._xcodePaths.firstWhere(
      (p) => p.type == result.type,
      orElse: () => _XcodeCacheCleanerPageState._xcodePaths[0],
    );

    showMacosSheet(
      context: context,
      builder: (context) => MacosSheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    MacosIcon(
                      result.isDirectory ? CupertinoIcons.folder : CupertinoIcons.doc,
                      color: context.colors.accent,
                      size: 16.8,
                    ),
                    const SizedBox(width: 8.4),
                    Expanded(
                      child: Text(
                        path.basename(result.path),
                        style: MacosTheme.of(context).typography.title3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    MacosIconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.of(context).pop(),
                      icon: MacosIcon(
                        CupertinoIcons.xmark,
                        size: 14,
                        color: context.colors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Type', xcodePath.typeLabel),
                      const SizedBox(height: 2.8),
                      _buildDetailRow('Kind', result.isDirectory ? 'Folder' : 'File'),
                      const SizedBox(height: 2.8),
                      _buildDetailRow('Size', _formatFileSize(result.size)),
                      const SizedBox(height: 2.8),
                      _buildDetailRow('Last Modified', result.lastModified.toString()),
                      const SizedBox(height: 2.8),
                      _buildDetailRow('Full Path', result.path),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(11.2),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.colors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PushButton(
                      controlSize: ControlSize.large,
                      secondary: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(AppConstants.closeButton),
                    ),
                    const SizedBox(width: 5.6),
                    PushButton(
                      controlSize: ControlSize.large,
                      color: context.colors.danger,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        // Delete the item
                        try {
                          if (result.isDirectory) {
                            await Directory(result.path).delete(recursive: true);
                          } else {
                            await File(result.path).delete();
                          }
                          // Remove from categories
                          setState(() {
                            for (final category in _cacheCategories.values) {
                              category.items.removeWhere((item) => item.path == result.path);
                            }
                            _selectedItems.remove(result.path);
                          });
                          _showSnackBar(
                            '${AppConstants.cleanedItem} ${path.basename(result.path)}',
                            isError: false,
                          );
                        } catch (e) {
                          _showSnackBar(
                            '${AppConstants.failedToClean} ${path.basename(result.path)}: ${e.toString()}',
                            isError: true,
                          );
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MacosIcon(CupertinoIcons.delete, size: 12.6, color: context.colors.white),
                          const SizedBox(width: 4.2),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: context.colors.white,
                              fontSize: 11.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.secondaryLabel,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 4.2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.4),
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: context.colors.separator,
            ),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
