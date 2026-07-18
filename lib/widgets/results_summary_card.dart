part of '../pages/cleaner_home_page.dart';

extension _CleanerHomePageWidgetsResultsSummary on _CleanerHomePageState {
  Widget _buildSummaryCard() {
    if (_scanResults.isEmpty && !_isScanning) {
      return const SizedBox.shrink();
    }

    if (_scanResults.isEmpty) return const SizedBox.shrink();

    final typography = MacosTheme.of(context).typography;

    final totalSize = _scanResults.fold<int>(
      0,
      (sum, result) => sum + result.size,
    );
    final apkCount = _scanResults
        .where((r) => r.type == AppConstants.apkIndicator)
        .length;
    final aabCount = _scanResults
        .where((r) => r.type == AppConstants.aabIndicator)
        .length;
    final ipaCount = _scanResults
        .where((r) => r.type == AppConstants.ipaIndicator)
        .length;
    final flutterBuildCount = _scanResults
        .where((r) => r.type == AppConstants.flutterBuildIndicator)
        .length;
    final reactNativeBuildCount = _scanResults
        .where((r) => r.type == AppConstants.reactNativeBuildIndicator)
        .length;
    final androidBuildCount = _scanResults
        .where((r) => r.type == AppConstants.androidBuildIndicator)
        .length;
    final iosBuildCount = _scanResults
        .where((r) => r.type == AppConstants.iosBuildIndicator)
        .length;
    final nodeModulesCount = _scanResults
        .where((r) => r.type == AppConstants.nodeModulesIndicator)
        .length;
    final archivesCount = _scanResults
        .where((r) => r.type == AppConstants.archivesIndicator)
        .length;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: context.colors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: context.colors.separator),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Scan Results',
              style: typography.title3.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            AlignedGridView.count(
              crossAxisCount: 3,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: [
                if (apkCount > 0) _SummaryItemData(AppConstants.apkType, apkCount, CupertinoIcons.device_phone_portrait, context.colors.success),
                if (aabCount > 0) _SummaryItemData(AppConstants.aabType, aabCount, CupertinoIcons.square_stack, context.colors.accent),
                if (ipaCount > 0) _SummaryItemData(AppConstants.ipaType, ipaCount, CupertinoIcons.device_phone_portrait, context.colors.highlight),
                if (flutterBuildCount > 0) _SummaryItemData(AppConstants.flutterBuildType, flutterBuildCount, CupertinoIcons.hammer, context.colors.accent),
                if (reactNativeBuildCount > 0) _SummaryItemData(AppConstants.reactNativeBuildType, reactNativeBuildCount, CupertinoIcons.hammer, context.colors.accent),
                if (androidBuildCount > 0) _SummaryItemData(AppConstants.androidBuildType, androidBuildCount, CupertinoIcons.hammer, context.colors.success),
                if (iosBuildCount > 0) _SummaryItemData(AppConstants.iosBuildType, iosBuildCount, CupertinoIcons.hammer, context.colors.grey),
                if (nodeModulesCount > 0) _SummaryItemData(AppConstants.nodeModulesType, nodeModulesCount, CupertinoIcons.folder, context.colors.warning),
                if (archivesCount > 0) _SummaryItemData(AppConstants.archivesType, archivesCount, CupertinoIcons.archivebox, context.colors.brown),
              ].length,
              itemBuilder: (context, index) {
                final items = [
                  if (apkCount > 0) _SummaryItemData(AppConstants.apkType, apkCount, CupertinoIcons.device_phone_portrait, context.colors.success),
                  if (aabCount > 0) _SummaryItemData(AppConstants.aabType, aabCount, CupertinoIcons.square_stack, context.colors.accent),
                  if (ipaCount > 0) _SummaryItemData(AppConstants.ipaType, ipaCount, CupertinoIcons.device_phone_portrait, context.colors.highlight),
                  if (flutterBuildCount > 0) _SummaryItemData(AppConstants.flutterBuildType, flutterBuildCount, CupertinoIcons.hammer, context.colors.accent),
                  if (reactNativeBuildCount > 0) _SummaryItemData(AppConstants.reactNativeBuildType, reactNativeBuildCount, CupertinoIcons.hammer, context.colors.accent),
                  if (androidBuildCount > 0) _SummaryItemData(AppConstants.androidBuildType, androidBuildCount, CupertinoIcons.hammer, context.colors.success),
                  if (iosBuildCount > 0) _SummaryItemData(AppConstants.iosBuildType, iosBuildCount, CupertinoIcons.hammer, context.colors.grey),
                  if (nodeModulesCount > 0) _SummaryItemData(AppConstants.nodeModulesType, nodeModulesCount, CupertinoIcons.folder, context.colors.warning),
                  if (archivesCount > 0) _SummaryItemData(AppConstants.archivesType, archivesCount, CupertinoIcons.archivebox, context.colors.brown),
                ];
                final item = items[index];
                return _buildSummaryItem(item.label, item.count, item.icon, item.color);
              },
            ),

            const SizedBox(height: 12),
            // Subtle informational panel — not tappable. Reduced emphasis
            // so users don't think this is a primary action button.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: context.colors.danger.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: context.colors.danger.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.colors.danger.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: MacosIcon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                      color: context.colors.danger,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.spaceToFreeUp,
                        style: typography.caption1.copyWith(
                          color: context.colors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatFileSize(totalSize),
                        style: typography.caption1.copyWith(
                          color: context.colors.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Small hint to clarify there's no immediate tap action here.
                  Text(
                    'Review items below to delete',
                    style: typography.caption1.copyWith(
                      color: context.colors.secondaryLabel,
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

  Widget _buildSummaryItem(
    String label,
    int count,
    IconData icon,
    Color color,
  ) {
    final typography = MacosTheme.of(context).typography;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
            ),
          ),
          child: MacosIcon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          count.toString(),
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
    );
  }
}
