part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerWidgets on _XcodeCacheCleanerPageState {
  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
      border: null,
      middle: const Text(
        'Xcode Cache Cleaner',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11.2, horizontal: 11.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBlue.withOpacity(0.08),
            CupertinoColors.systemPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(11.2),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8.4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.systemBlue,
                  CupertinoColors.systemBlue.darkColor,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.3),
                  blurRadius: 8.4,
                  offset: const Offset(0, 2.8),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.hammer,
              size: 22.4,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 8.4),
          const Text(
            'Clean up Xcode caches: Device Support, Archives, Derived Data, Documentation Cache, Old Logs, and Documentation Downloads',
            style: TextStyle(
              fontSize: 9.1,
              color: CupertinoColors.secondaryLabel,
              height: 1.4,
              letterSpacing: -0.07,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildScanButton() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      width: double.infinity,
      height: 30.8,
      decoration: BoxDecoration(
        gradient: isDisabled
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.systemBlue,
                  CupertinoColors.systemBlue.darkColor,
                ],
              ),
        borderRadius: BorderRadius.circular(8.4),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.4),
                  blurRadius: 8.4,
                  offset: const Offset(0, 2.8),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _scanXcodeCaches,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _isScanning
                ? AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: const Icon(
                          CupertinoIcons.arrow_2_squarepath,
                          size: 12.6,
                          color: CupertinoColors.white,
                        ),
                      );
                    },
                  )
                : const Icon(
                    CupertinoIcons.search,
                    size: 12.6,
                    color: CupertinoColors.white,
                  ),
            const SizedBox(width: 5.6),
            Flexible(
              child: Text(
                _isScanning
                    ? AppConstants.scanningButtonText
                    : 'Scan Xcode Caches',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.white,
                  letterSpacing: -0.14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              CupertinoIcons.hammer,
              size: 44.8,
              color: CupertinoColors.systemGrey3,
            ),
            const SizedBox(height: 11.2),
            const Text(
              'No Xcode cache found',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 5.6),
            Text(
              'Click "Scan Xcode Caches" to find cache files',
              style: TextStyle(
                fontSize: 9.8,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectAllCheckbox() {
    // Get all items from all categories
    final allItems = <XcodeCacheItem>[];
    for (final category in _cacheCategories.values) {
      allItems.addAll(category.items);
    }
    
    if (allItems.isEmpty) return const SizedBox.shrink();
    
    final allSelected = allItems.every(
      (item) => _selectedItems.contains(item.path),
    );
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11.2, vertical: 8.4),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8.4),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (allSelected) {
              // Deselect all
              _selectedItems.clear();
            } else {
              // Select all
              for (final item in allItems) {
                _selectedItems.add(item.path);
              }
            }
          });
        },
        child: Row(
          children: [
            Container(
              width: 15.4,
              height: 15.4,
              decoration: BoxDecoration(
                color: allSelected
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey5,
                borderRadius: BorderRadius.circular(3.5),
                border: Border.all(
                  color: allSelected
                      ? CupertinoColors.systemBlue
                      : CupertinoColors.systemGrey4,
                  width: 2,
                ),
              ),
              child: allSelected
                  ? const Icon(
                      CupertinoIcons.checkmark,
                      size: 11.2,
                      color: CupertinoColors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 8.4),
            const Text(
              'Select All',
              style: TextStyle(
                fontSize: 11.2,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.label,
              ),
            ),
            const Spacer(),
            Text(
              '${_selectedItems.length} / ${allItems.length}',
              style: const TextStyle(
                fontSize: 9.8,
                fontWeight: FontWeight.w500,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheCategoriesList() {
    if (_cacheCategories.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: _XcodeCacheCleanerPageState._xcodePaths.map((xcodePath) {
        final category = _cacheCategories[xcodePath.type];
        if (category == null) return const SizedBox.shrink();
        return _buildCategoryItem(category);
      }).toList(),
    );
  }

  Widget _buildPermissionPrompt() {
    return Container(
      padding: const EdgeInsets.all(11.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemOrange.withOpacity(0.1),
            CupertinoColors.systemOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(11.2),
        border: Border.all(
          color: CupertinoColors.systemOrange.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.lock_fill,
            size: 22.4,
            color: CupertinoColors.systemOrange,
          ),
          const SizedBox(height: 8.4),
          const Text(
            'Permission Required',
            style: TextStyle(
              fontSize: 12.6,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          const SizedBox(height: 5.6),
          const Text(
            'This app needs permission to access your Developer folder (~/Library/Developer) to scan Xcode cache files.',
            style: TextStyle(
              fontSize: 9.8,
              color: CupertinoColors.secondaryLabel,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 11.2),
          SizedBox(
            width: double.infinity,
            height: 30.8,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              color: CupertinoColors.systemOrange,
              borderRadius: BorderRadius.circular(8.4),
              onPressed: _showPermissionDialog,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.folder, size: 12.6, color: CupertinoColors.white),
                  SizedBox(width: 5.6),
                  Text(
                    'Grant Access to Developer',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: CupertinoColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(XcodeCacheCategory category) {
    final isExpanded = _expandedCategories.contains(category.key);
    final categorySize = category.totalSize;

    return Container(
      margin: const EdgeInsets.only(bottom: 5.6),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8.4),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Category header
          Container(
            padding: const EdgeInsets.all(11.2),
            child: Row(
              children: [
                // Expand/collapse button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedCategories.remove(category.key);
                      } else {
                        _expandedCategories.add(category.key);
                      }
                    });
                  },
                  child: Icon(
                    isExpanded
                        ? CupertinoIcons.chevron_down
                        : CupertinoIcons.chevron_right,
                    size: 11.2,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(width: 8.4),
                Expanded(
                  child: Text(
                    category.label,
                    style: const TextStyle(
                      fontSize: 11.2,
                      fontWeight: FontWeight.w600,
                      color: CupertinoColors.label,
                    ),
                  ),
                ),
                Text(
                  _formatFileSize(categorySize),
                  style: const TextStyle(
                    fontSize: 9.8,
                    fontWeight: FontWeight.w500,
                    color: CupertinoColors.label,
                  ),
                ),
                const SizedBox(width: 8.4),
                // Category Select All checkbox
                GestureDetector(
                  onTap: () {
                    setState(() {
                      final allCategoryItemsSelected = category.items.every(
                        (item) => _selectedItems.contains(item.path),
                      );
                      
                      if (allCategoryItemsSelected) {
                        // Deselect all items in this category
                        for (final item in category.items) {
                          _selectedItems.remove(item.path);
                        }
                      } else {
                        // Select all items in this category
                        for (final item in category.items) {
                          _selectedItems.add(item.path);
                        }
                      }
                    });
                  },
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: category.items.isNotEmpty &&
                              category.items.every(
                                (item) => _selectedItems.contains(item.path),
                              )
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(2.8),
                      border: Border.all(
                        color: category.items.isNotEmpty &&
                                category.items.every(
                                  (item) => _selectedItems.contains(item.path),
                                )
                            ? CupertinoColors.systemBlue
                            : CupertinoColors.systemGrey4,
                        width: 2,
                      ),
                    ),
                    child: category.items.isNotEmpty &&
                            category.items.every(
                              (item) => _selectedItems.contains(item.path),
                            )
                        ? const Icon(
                            CupertinoIcons.checkmark,
                            size: 9.8,
                            color: CupertinoColors.white,
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
          
          // Category items (when expanded)
          if (isExpanded && category.items.isNotEmpty)
            ...category.items.map((item) => _buildCacheItem(item, category.key)),
        ],
      ),
    );
  }

  Widget _buildCacheItem(XcodeCacheItem item, String categoryKey) {
    final isSelected = _selectedItems.contains(item.path);
    final isDerivedData = categoryKey == AppConstants.xcodeDerivedDataIndicator;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey4.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              _selectedItems.remove(item.path);
            } else {
              _selectedItems.add(item.path);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11.2, vertical: 8.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Checkbox
                  Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? CupertinoColors.systemBlue
                          : CupertinoColors.systemGrey5,
                      borderRadius: BorderRadius.circular(2.8),
                      border: Border.all(
                        color: isSelected
                            ? CupertinoColors.systemBlue
                            : CupertinoColors.systemGrey4,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            CupertinoIcons.checkmark,
                            size: 9.8,
                            color: CupertinoColors.white,
                          )
                        : null,
                  ),
                  const SizedBox(width: 8.4),
                  // Item icon
                  Icon(
                    item.isDirectory
                        ? CupertinoIcons.folder_fill
                        : CupertinoIcons.doc,
                    size: 14,
                    color: CupertinoColors.systemBlue,
                  ),
                  const SizedBox(width: 8.4),
                  // Item name or full path for DerivedData
                  Expanded(
                    child: isDerivedData && item.workspacePath != null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _getProjectNameFromPath(item.workspacePath!),
                                style: const TextStyle(
                                  fontSize: 9.8,
                                  fontWeight: FontWeight.w600,
                                  color: CupertinoColors.label,
                                ),
                              ),
                              const SizedBox(height: 1.4),
                              Text(
                                item.workspacePath!,
                                style: const TextStyle(
                                  fontSize: 8.4,
                                  color: CupertinoColors.secondaryLabel,
                                  fontFamily: 'Courier',
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          )
                        : Text(
                            item.name,
                            style: const TextStyle(
                              fontSize: 9.8,
                              color: CupertinoColors.label,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  // Item size
                  Text(
                    _formatFileSize(item.size),
                    style: const TextStyle(
                      fontSize: 9.8,
                      fontWeight: FontWeight.w500,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
              // Open in Finder button for DerivedData
              if (isDerivedData && item.workspacePath != null) ...[
                const SizedBox(height: 5.6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      onPressed: () => _openInFinder(item.workspacePath!),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            CupertinoIcons.folder,
                            size: 9.8,
                            color: CupertinoColors.systemBlue,
                          ),
                          SizedBox(width: 2.8),
                          Text(
                            'Open in Finder',
                            style: TextStyle(
                              fontSize: 8.4,
                              color: CupertinoColors.systemBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSummary() {
    return Container(
      padding: const EdgeInsets.all(11.2),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border(
          top: BorderSide(
            color: CupertinoColors.systemGrey4.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Selected:',
                style: TextStyle(
                  fontSize: 8.4,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 2.8),
              Text(
                _formatFileSize(_selectedSize),
                style: const TextStyle(
                  fontSize: 11.2,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Total:',
                style: TextStyle(
                  fontSize: 8.4,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 2.8),
              Text(
                _formatFileSize(_totalSize),
                style: const TextStyle(
                  fontSize: 11.2,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCleanButton() {
    final isDisabled = _selectedItems.isEmpty || _isDeleting;
    final selectedCount = _selectedItems.length;
    final selectedSize = _selectedSize;
    
    return Positioned(
      bottom: 14,
      right: 14,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Info card showing selected count and size
          if (selectedCount > 0 && !isDisabled)
            Container(
              margin: const EdgeInsets.only(bottom: 8.4),
              padding: const EdgeInsets.symmetric(horizontal: 9.8, vertical: 7),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBackground,
                borderRadius: BorderRadius.circular(11.2),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.15),
                    blurRadius: 8.4,
                    offset: const Offset(0, 2.8),
                    spreadRadius: 1,
                  ),
                ],
                border: Border.all(
                  color: CupertinoColors.systemGrey4.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Selected: ',
                        style: TextStyle(
                          color: CupertinoColors.secondaryLabel,
                          fontSize: 8.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$selectedCount',
                        style: const TextStyle(
                          color: CupertinoColors.systemRed,
                          fontSize: 9.8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.8),
                  Text(
                    _formatFileSize(selectedSize),
                    style: const TextStyle(
                      color: CupertinoColors.label,
                      fontSize: 9.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          // Floating button
          GestureDetector(
            onTap: isDisabled ? null : _cleanSelected,
            child: Container(
              width: 44.8,
              height: 44.8,
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemRed,
                          CupertinoColors.systemRed.darkColor,
                        ],
                      ),
                color: isDisabled ? CupertinoColors.systemGrey4 : null,
                shape: BoxShape.circle,
                boxShadow: isDisabled
                    ? null
                    : [
                        BoxShadow(
                          color: CupertinoColors.systemRed.withOpacity(0.4),
                          blurRadius: 11.2,
                          offset: const Offset(0, 4.2),
                          spreadRadius: 1.4,
                        ),
                      ],
              ),
              child: _isDeleting
                  ? const Center(
                      child: CupertinoActivityIndicator(
                        color: CupertinoColors.white,
                      ),
                    )
                  : const Icon(
                      CupertinoIcons.delete_solid,
                      size: 19.6,
                      color: CupertinoColors.white,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    if (!_isScanning && !_isDeleting) return const SizedBox.shrink();

    final progress = _isDeleting ? 1.0 : _scanProgress;
    final percentage = (progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(11.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemGrey6,
            CupertinoColors.systemGrey5,
          ],
        ),
        borderRadius: BorderRadius.circular(11.2),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 2.8),
          ),
        ],
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 42,
                height: 42,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 42,
                      height: 42,
                      child: CustomPaint(
                        painter: _CircularProgressPainter(
                          progress: progress,
                          backgroundColor: CupertinoColors.systemGrey4.withOpacity(0.3),
                          progressColor: CupertinoColors.systemBlue,
                          strokeWidth: 3.5,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$percentage%',
                          style: const TextStyle(
                            fontSize: 11.2,
                            fontWeight: FontWeight.bold,
                            color: CupertinoColors.label,
                            letterSpacing: -0.21,
                          ),
                        ),
                        if (_isDeleting)
                          const Text(
                            'Deleting',
                            style: TextStyle(
                              fontSize: 5.6,
                              color: CupertinoColors.secondaryLabel,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 11.2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isDeleting
                          ? AppConstants.deletingFiles
                          : AppConstants.scanningSystem,
                      style: const TextStyle(
                        fontSize: 12.6,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.35,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _currentScanPath,
                      style: const TextStyle(
                        fontSize: 8.4,
                        color: CupertinoColors.secondaryLabel,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_currentScanPath.isNotEmpty && !_isDeleting) ...[
            const SizedBox(height: 8.4),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemBackground,
                    CupertinoColors.systemGrey6,
                  ],
                ),
                borderRadius: BorderRadius.circular(5.6),
                border: Border.all(
                  color: CupertinoColors.systemGrey4.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.folder_fill,
                    size: 8.4,
                    color: CupertinoColors.secondaryLabel,
                  ),
                  const SizedBox(width: 4.2),
                  Expanded(
                    child: Text(
                      _currentScanPath,
                      style: const TextStyle(
                        fontSize: 7.7,
                        color: CupertinoColors.secondaryLabel,
                        fontFamily: 'monospace',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4.2, right: 8.4),
          width: 4.2,
          height: 4.2,
          decoration: BoxDecoration(
            color: CupertinoColors.systemOrange,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 10.5,
              height: 1.5,
              color: CupertinoColors.secondaryLabel,
            ),
          ),
        ),
      ],
    );
  }
}

