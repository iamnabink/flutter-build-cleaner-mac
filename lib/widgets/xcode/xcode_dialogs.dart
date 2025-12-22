part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerDialogs on _XcodeCacheCleanerPageState {
  Future<void> _showPermissionDialog() async {
    final result = await showCupertinoModalPopup<bool>(
      context: context,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxWidth: 490,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        margin: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(9.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(14),
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
                    size: 16.8,
                  ),
                  const SizedBox(width: 8.4),
                  const Expanded(
                    child: Text(
                      'Permission Required',
                      style: TextStyle(
                        fontSize: 12.6,
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
                      size: 14,
                      color: CupertinoColors.secondaryLabel,
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
                    const Text(
                      'This app needs access to your Developer folder to scan and clean Xcode cache files.',
                      style: TextStyle(
                        fontSize: 10.5,
                        height: 1.6,
                        color: CupertinoColors.label,
                      ),
                    ),
                    const SizedBox(height: 16.8),
                    // Folder path highlight
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(8.4),
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
                                size: 15.4,
                              ),
                              const SizedBox(width: 7),
                              const Text(
                                'Select this folder:',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.label,
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
                              color: CupertinoColors.systemBackground,
                              borderRadius: BorderRadius.circular(5.6),
                            ),
                            child: const Text(
                              '~/Library/Developer',
                              style: TextStyle(
                                fontSize: 11.2,
                                fontFamily: 'Courier',
                                fontWeight: FontWeight.w600,
                                color: CupertinoColors.systemOrange,
                                letterSpacing: 0.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 19.6),
                    // What app will do
                    const Text(
                      'What this app will do:',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: CupertinoColors.label,
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
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            CupertinoIcons.info,
                            size: 12.6,
                            color: CupertinoColors.secondaryLabel,
                          ),
                          const SizedBox(width: 8.4),
                          Expanded(
                            child: Text(
                              'Click "Grant Access" to open the system dialog and select the Developer folder.',
                              style: TextStyle(
                                fontSize: 9.8,
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
              padding: const EdgeInsets.all(11.2),
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
                    child: const Text(
                      AppConstants.cancelButton,
                      style: TextStyle(fontSize: 9.8),
                    ),
                  ),
                  const SizedBox(width: 5.6),
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.folder, size: 12.6),
                        SizedBox(width: 4.2),
                        Text(
                          'Grant Access',
                          style: TextStyle(
                            fontSize: 9.8,
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
                Icon(CupertinoIcons.exclamationmark_triangle_fill, color: CupertinoColors.systemRed, size: 14),
                SizedBox(width: 5.6),
                Text('Confirm Deletion', style: TextStyle(fontSize: 12.6)),
              ],
            ),
            content: SizedBox(
              width: 280,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Are you sure you want to delete the selected Xcode cache files?',
                      style: TextStyle(fontSize: 9.8),
                    ),
                    const SizedBox(height: 8.4),
                    Container(
                      padding: const EdgeInsets.all(8.4),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(5.6),
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
                                style: TextStyle(fontSize: 9.8),
                              ),
                              Text(
                                '$itemCount',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 9.8,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total size:',
                                style: TextStyle(fontSize: 9.8),
                              ),
                              Text(
                                _formatFileSize(totalSize),
                                style: const TextStyle(
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
                    const Text(
                      '⚠️ This action cannot be undone!',
                      style: TextStyle(
                        color: CupertinoColors.systemRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  AppConstants.cancelButton,
                  style: TextStyle(fontSize: 9.8),
                ),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(fontSize: 9.8),
                ),
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
                Icon(CupertinoIcons.folder, size: 14),
                SizedBox(width: 5.6),
                Text('Open in Finder', style: TextStyle(fontSize: 10.5)),
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
                Icon(CupertinoIcons.info, size: 14),
                SizedBox(width: 5.6),
                Text('Show Details', style: TextStyle(fontSize: 10.5)),
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
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        margin: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(9.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
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
                    size: 16.8,
                  ),
                  const SizedBox(width: 8.4),
                  Expanded(
                    child: Text(
                      path.basename(result.path),
                      style: const TextStyle(
                        fontSize: 12.6,
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
                      size: 14,
                      color: CupertinoColors.secondaryLabel,
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
                    child: const Text(
                      AppConstants.closeButton,
                      style: TextStyle(fontSize: 9.8),
                    ),
                  ),
                  const SizedBox(width: 5.6),
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
                      padding: const EdgeInsets.symmetric(horizontal: 11.2, vertical: 7),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemRed,
                        borderRadius: BorderRadius.circular(5.6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.delete, size: 12.6, color: CupertinoColors.white),
                          SizedBox(width: 4.2),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 11.2,
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
            fontSize: 8.4,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.secondaryLabel,
            letterSpacing: 0.35,
          ),
        ),
        const SizedBox(height: 4.2),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.4),
          decoration: BoxDecoration(
            color: CupertinoColors.systemGrey6,
            borderRadius: BorderRadius.circular(5.6),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 10.5,
              fontFamily: label == 'Full Path' ? 'monospace' : null,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

