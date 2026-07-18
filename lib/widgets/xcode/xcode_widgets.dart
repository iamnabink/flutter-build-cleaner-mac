part of '../../pages/xcode_cache_cleaner_page.dart';

extension XcodeCacheCleanerWidgets on _XcodeCacheCleanerPageState {
  ToolBar _buildToolBar() {
    return ToolBar(
      title: const Text('Xcode Cache Cleaner'),
      centerTitle: false,
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11.2, horizontal: 11.2),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        children: [
          Center(child: const AppLogo()),
          const SizedBox(height: 8.4),
          Text(
            'Clean up Xcode caches: Device Support, Archives, Derived Data, Documentation Cache, Old Logs, and Documentation Downloads',
            style: TextStyle(
              fontSize: 12,
              color: context.colors.secondaryLabel,
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
    return SizedBox(
      width: double.infinity,
      child: PushButton(
        controlSize: ControlSize.large,
        onPressed: isDisabled ? null : _scanXcodeCaches,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isScanning)
              AnimatedBuilder(
                animation: _rotationAnimation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationAnimation.value * 2 * 3.14159,
                    child: const MacosIcon(
                      CupertinoIcons.arrow_2_squarepath,
                      size: 16,
                    ),
                  );
                },
              )
            else
              MacosIcon(
                CupertinoIcons.search,
                size: 16,
                color: context.colors.white,
              ),
            const SizedBox(width: 6),
            Text(
              _isScanning
                  ? AppConstants.scanningButtonText
                  : 'Scan Xcode Caches',
              style: TextStyle(
                color: isDisabled ? null : context.colors.white,
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
            MacosIcon(
              CupertinoIcons.hammer,
              size: 44.8,
              color: context.colors.grey3,
            ),
            const SizedBox(height: 11.2),
            Text(
              'No Xcode cache found',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: context.colors.label,
              ),
            ),
            const SizedBox(height: 5.6),
            Text(
              'Click "Scan Xcode Caches" to find cache files',
              style: TextStyle(
                fontSize: 12,
                color: context.colors.secondaryLabel,
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

    void toggleAll() {
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
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11.2, vertical: 8.4),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: toggleAll,
        child: Row(
          children: [
            MacosCheckbox(
              value: allSelected,
              onChanged: (_) => toggleAll(),
            ),
            const SizedBox(width: 8.4),
            Text(
              'Select All',
              style: TextStyle(
                fontSize: 11.2,
                fontWeight: FontWeight.w600,
                color: context.colors.label,
              ),
            ),
            const Spacer(),
            Text(
              '${_selectedItems.length} / ${allItems.length}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: context.colors.secondaryLabel,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _XcodeCacheCleanerPageState._xcodePaths.map((xcodePath) {
        final category = _cacheCategories[xcodePath.type];
        if (category == null) return const SizedBox.shrink();
        return _buildCategoryItem(category);
      }).toList(),
    );
  }

  Widget _buildPermissionPrompt() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        children: [
          MacosIcon(
            CupertinoIcons.lock_fill,
            size: 22.4,
            color: context.colors.warning,
          ),
          const SizedBox(height: 8.4),
          Text(
            'Permission Required',
            style: MacosTheme.of(context).typography.title3,
          ),
          const SizedBox(height: 5.6),
          Text(
            'This app needs permission to access your Developer folder (~/Library/Developer) to scan Xcode cache files.',
            style: TextStyle(
              fontSize: 12,
              color: context.colors.secondaryLabel,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 11.2),
          SizedBox(
            width: double.infinity,
            child: PushButton(
              controlSize: ControlSize.large,
              secondary: true,
              onPressed: _showPermissionDialog,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  MacosIcon(CupertinoIcons.folder, size: 16),
                  SizedBox(width: 6),
                  Text('Grant Access to Developer'),
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
    final allCategorySelected = category.items.isNotEmpty &&
        category.items.every(
          (item) => _selectedItems.contains(item.path),
        );

    void toggleCategory() {
      setState(() {
        if (allCategorySelected) {
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
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 5.6),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
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
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedCategories.remove(category.key);
                      } else {
                        _expandedCategories.add(category.key);
                      }
                    });
                  },
                  child: MacosIcon(
                    isExpanded
                        ? CupertinoIcons.chevron_down
                        : CupertinoIcons.chevron_right,
                    size: 11.2,
                    color: context.colors.secondaryLabel,
                  ),
                ),
                const SizedBox(width: 8.4),
                Expanded(
                  child: Text(
                    category.label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: context.colors.label,
                    ),
                  ),
                ),
                Text(
                  _formatFileSize(categorySize),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: context.colors.label,
                  ),
                ),
                const SizedBox(width: 8.4),
                // Category Select All checkbox
                MacosCheckbox(
                  value: allCategorySelected,
                  onChanged: (_) => toggleCategory(),
                ),
              ],
            ),
          ),

          // Category items (when expanded)
          if (isExpanded && category.items.isNotEmpty)
            ...category.items
                .map((item) => _buildCacheItem(item, category.key)),
        ],
      ),
    );
  }

  Widget _buildCacheItem(XcodeCacheItem item, String categoryKey) {
    final isSelected = _selectedItems.contains(item.path);
    final isDerivedData = categoryKey == AppConstants.xcodeDerivedDataIndicator;

    void toggleItem() {
      setState(() {
        if (isSelected) {
          _selectedItems.remove(item.path);
        } else {
          _selectedItems.add(item.path);
        }
      });
    }

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: context.colors.separator),
        ),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: toggleItem,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 11.2, vertical: 8.4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Checkbox
                  MacosCheckbox(
                    value: isSelected,
                    onChanged: (_) => toggleItem(),
                  ),
                  const SizedBox(width: 8.4),
                  // Item icon
                  MacosIcon(
                    item.isDirectory
                        ? CupertinoIcons.folder_fill
                        : CupertinoIcons.doc,
                    size: 14,
                    color: context.colors.accent,
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
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: context.colors.label,
                                ),
                              ),
                              const SizedBox(height: 1.4),
                              Text(
                                item.workspacePath!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.colors.secondaryLabel,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          )
                        : Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: context.colors.label,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                  ),
                  // Item size
                  Text(
                    _formatFileSize(item.size),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.colors.secondaryLabel,
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
                    PushButton(
                      controlSize: ControlSize.small,
                      secondary: true,
                      onPressed: () => _openInFinder(item.workspacePath!),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          MacosIcon(CupertinoIcons.folder, size: 12),
                          SizedBox(width: 4),
                          Text('Open in Finder'),
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
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selected:',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 2.8),
              Text(
                _formatFileSize(_selectedSize),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.colors.label,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Total:',
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.secondaryLabel,
                ),
              ),
              const SizedBox(height: 2.8),
              Text(
                _formatFileSize(_totalSize),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.colors.label,
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
                color: context.colors.cardBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: context.colors.separator),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Selected: ',
                        style: TextStyle(
                          color: context.colors.secondaryLabel,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$selectedCount',
                        style: TextStyle(
                          color: context.colors.danger,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2.8),
                  Text(
                    _formatFileSize(selectedSize),
                    style: TextStyle(
                      color: context.colors.label,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          // Clean button
          PushButton(
            controlSize: ControlSize.large,
            color: context.colors.danger,
            onPressed: isDisabled ? null : _cleanSelected,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isDeleting)
                  const ProgressCircle(value: null, radius: 8)
                else
                  MacosIcon(
                    CupertinoIcons.delete_solid,
                    size: 16,
                    color: isDisabled ? null : context.colors.white,
                  ),
                const SizedBox(width: 6),
                Text(
                  _isDeleting ? 'Deleting...' : 'Clean Selected',
                  style: TextStyle(
                    color: isDisabled ? null : context.colors.white,
                  ),
                ),
              ],
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
    final typography = MacosTheme.of(context).typography;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Circular progress indicator
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProgressCircle(
                    value: (progress * 100).clamp(0.0, 100.0),
                    radius: 22,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '$percentage%',
                    style: typography.caption1.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colors.label,
                    ),
                  ),
                  if (_isDeleting)
                    Text(
                      'Deleting',
                      style: typography.caption1.copyWith(
                        color: context.colors.secondaryLabel,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isDeleting
                          ? AppConstants.deletingFiles
                          : AppConstants.scanningSystem,
                      style: typography.title3.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _currentScanPath,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.secondaryLabel,
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
                color: context.colors.controlBackground,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: context.colors.separator),
              ),
              child: Row(
                children: [
                  MacosIcon(
                    CupertinoIcons.folder_fill,
                    size: 12,
                    color: context.colors.secondaryLabel,
                  ),
                  const SizedBox(width: 4.2),
                  Expanded(
                    child: Text(
                      _currentScanPath,
                      style: TextStyle(
                        fontSize: 12,
                        color: context.colors.secondaryLabel,
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
            color: context.colors.warning,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              height: 1.5,
              color: context.colors.secondaryLabel,
            ),
          ),
        ),
      ],
    );
  }
}
