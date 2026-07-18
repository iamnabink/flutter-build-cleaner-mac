part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsProgress on _CleanerHomePageState {
  Widget _buildProgressCard() {
    if (!_isScanning && !_isDeleting) return const SizedBox.shrink();

    final progress = _isDeleting ? 1.0 : _scanProgress;
    final percentage = (progress * 100).toInt();
    final typography = MacosTheme.of(context).typography;

    return Container(
      padding: const EdgeInsets.all(16.0),
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
              // Title and stats
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
                    const SizedBox(height: 10),
                    // Stats with icons
                    _buildStatRow(
                      icon: CupertinoIcons.folder,
                      label: AppConstants.filesLabel,
                      value: '$_filesFound',
                    ),
                    const SizedBox(height: 6),
                    _buildStatRow(
                      icon: CupertinoIcons.square_stack,
                      label: AppConstants.foldersLabel,
                      value: '$_foldersFound',
                    ),
                    const SizedBox(height: 6),
                    _buildStatRow(
                      icon: CupertinoIcons.floppy_disk,
                      label: AppConstants.sizeLabel,
                      value: _formatFileSize(_totalSizeScanned),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Current path section
          if (_currentScanPath.isNotEmpty && !_isDeleting) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
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
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _currentScanPath.replaceFirst(_selectedPath, '~'),
                      style: typography.caption1.copyWith(
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

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        MacosIcon(
          icon,
          size: 14,
          color: context.colors.accent,
        ),
        const SizedBox(width: 6),
        Text(
          '$label $value',
          style: MacosTheme.of(context).typography.caption1.copyWith(
                color: context.colors.label,
              ),
        ),
      ],
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            CupertinoIcons.folder,
            'Scanned',
            _directoriesScanned.toString(),
            context.colors.accent,
          ),
          _buildStatItem(
            CupertinoIcons.exclamationmark_triangle,
            'Errors',
            _permissionErrors.length.toString(),
            context.colors.warning,
          ),
          _buildStatItem(
            CupertinoIcons.timer,
            'Progress',
            '${(_scanProgress * 100).toInt()}%',
            context.colors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    final typography = MacosTheme.of(context).typography;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MacosIcon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: typography.caption1.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: typography.caption1.copyWith(
                color: context.colors.secondaryLabel,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
