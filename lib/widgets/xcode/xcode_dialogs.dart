part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerDialogs on _XcodeCacheCleanerPageState {
  Future<void> _showPermissionDialog() async {
    final result = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxWidth: 700,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.lock,
                    color: CupertinoColors.systemOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Permission Required',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      size: 20,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'This app needs access to your Developer folder to scan and clean Xcode cache files.',
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Folder path highlight
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: CupertinoColors.systemOrange.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                CupertinoIcons.folder_fill,
                                color: CupertinoColors.systemOrange,
                                size: 22,
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Select this folder:',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '~/Library/Developer',
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Courier',
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.systemOrange,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    // What app will do
                    const Text(
                      'What this app will do:',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFeatureItem('Scan Xcode cache directories'),
                          const SizedBox(height: 10),
                          _buildFeatureItem('Find Device Support files'),
                          const SizedBox(height: 10),
                          _buildFeatureItem('Find Archives and Derived Data'),
                          const SizedBox(height: 10),
                          _buildFeatureItem('Calculate file and folder sizes'),
                          const SizedBox(height: 10),
                          _buildFeatureItem('Allow you to delete unwanted cache files'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.info,
                            size: 18,
                            color: CupertinoColors.secondaryLabel,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Click "Grant Access" to open the system dialog and select the Developer folder.',
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.secondaryLabel,
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
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text(AppConstants.cancelButton),
                  ),
                  const SizedBox(width: 8),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.folder, size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Grant Access',
                          style: TextStyle(
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
    );

    if (result == true) {
      await _requestFileAccess();
    }
  }

  Future<bool> _showConfirmationDialog() async {
    final totalSize = _selectedSize;
    final itemCount = _selectedItems.length;

    return await showCupertinoDialog<bool>(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(CupertinoIcons.exclamationmark_triangle_fill, color: CupertinoColors.systemRed),
                SizedBox(width: 8),
                Text('Confirm Deletion'),
              ],
            ),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Are you sure you want to delete the selected Xcode cache files?',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: CupertinoColors.systemRed.withOpacity(0.5),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Selected items:',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '$itemCount',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total size:',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                _formatFileSize(totalSize),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '⚠️ This action cannot be undone!',
                      style: TextStyle(
                        color: CupertinoColors.systemRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showContextMenu(BuildContext context, ScanResult result) async {
    await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, 'open');
              _openInFinder(result.path);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.folder, size: 20),
                SizedBox(width: 8),
                Text('Open in Finder'),
              ],
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context, 'details');
              _showItemDetails(result);
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(CupertinoIcons.info, size: 20),
                SizedBox(width: 8),
                Text('Show Details'),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void _showItemDetails(ScanResult result) {
    final xcodePath = _XcodeCacheCleanerPageState._xcodePaths.firstWhere(
      (p) => p.type == result.type,
      orElse: () => _XcodeCacheCleanerPageState._xcodePaths[0],
    );

    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    result.isDirectory ? CupertinoIcons.folder : CupertinoIcons.doc,
                    color: CupertinoColors.systemBlue,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      path.basename(result.path),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      size: 20,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Type', xcodePath.typeLabel),
                    const SizedBox(height: 4),
                    _buildDetailRow('Kind', result.isDirectory ? 'Folder' : 'File'),
                    const SizedBox(height: 4),
                    _buildDetailRow('Size', _formatFileSize(result.size)),
                    const SizedBox(height: 4),
                    _buildDetailRow('Last Modified', result.lastModified.toString()),
                    const SizedBox(height: 4),
                    _buildDetailRow('Full Path', result.path),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(AppConstants.closeButton),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
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
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.delete, size: 18, color: CupertinoColors.white),
                          SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.secondaryLabel,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontFamily: label == 'Full Path' ? 'monospace' : null,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

