part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerCleanOperations on _XcodeCacheCleanerPageState {
  Future<void> _cleanSelected() async {
    if (_selectedItems.isEmpty) return;

    final confirmed = await _showConfirmationDialog();
    if (!confirmed) return;

    setState(() {
      _isDeleting = true;
    });

    int deletedCount = 0;
    int failedCount = 0;
    final selectedItemsList = _selectedItems.toList();
    final totalSize = _selectedSize;

    for (int i = 0; i < selectedItemsList.length; i++) {
      if (!mounted) break;

      final itemPath = selectedItemsList[i];
      try {
        final item = FileSystemEntity.typeSync(itemPath);
        if (item == FileSystemEntityType.directory) {
          await Directory(itemPath).delete(recursive: true);
        } else if (item == FileSystemEntityType.file) {
          await File(itemPath).delete();
        }
        deletedCount++;
        
        // Remove from selected items and from categories
        setState(() {
          _selectedItems.remove(itemPath);
          // Remove item from category
          for (final category in _cacheCategories.values) {
            category.items.removeWhere((item) => item.path == itemPath);
          }
        });
      } catch (e) {
        failedCount++;
      }

      setState(() {
        _scanProgress = (i + 1) / selectedItemsList.length;
      });
    }

    setState(() {
      _isDeleting = false;
      _scanProgress = 0.0;
    });

    String message =
        '${AppConstants.successfullyCleaned} $deletedCount ${AppConstants.itemsFreed} ${_formatFileSize(totalSize)}';
    if (failedCount > 0) {
      message += '\n$failedCount items could not be deleted';
    }

    _showSnackBar(message, isError: failedCount > 0);
  }
}

