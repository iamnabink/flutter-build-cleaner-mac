part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsResultsList on _CleanerHomePageState {
  Widget _buildResultsList() {
    final sortedResults = List<ScanResult>.from(_scanResults)
      ..sort((a, b) => b.size.compareTo(a.size));

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: context.colors.separator,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  MacosIcon(
                    CupertinoIcons.list_bullet,
                    color: context.colors.label,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Found Items (${sortedResults.length})',
                    style: MacosTheme.of(context).typography.caption1.copyWith(
                          color: context.colors.label,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.3,
                        ),
                  ),
                  const Spacer(),
                  Text(
                    'Sorted by size',
                    style: MacosTheme.of(context).typography.caption1.copyWith(
                          color: context.colors.secondaryLabel,
                        ),
                  ),
                ],
              ),
            ),
            if (sortedResults.isEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Center(
                  child: Text(
                    AppConstants.noArtifactsFound,
                    style: MacosTheme.of(context).typography.caption1.copyWith(
                          color: context.colors.secondaryLabel,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            if (sortedResults.isNotEmpty)
              ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedResults.length,
              itemBuilder: (context, index) {
                final result = sortedResults[index];
                return _buildResultItem(result, index == 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(ScanResult result, bool isLargest) {
    IconData icon;
    Color iconColor;

    switch (result.type) {
      case 'apk':
        icon = CupertinoIcons.device_phone_portrait;
        iconColor = context.colors.success;
        break;
      case 'aab':
        icon = CupertinoIcons.square_stack;
        iconColor = context.colors.accent;
        break;
      case 'ipa':
        icon = CupertinoIcons.device_phone_portrait;
        iconColor = context.colors.highlight;
        break;
      case AppConstants.flutterBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = context.colors.accent;
        break;
      case AppConstants.reactNativeBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = context.colors.accent;
        break;
      case AppConstants.androidBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = context.colors.success;
        break;
      case AppConstants.iosBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = context.colors.grey;
        break;
      case AppConstants.nodeModulesIndicator:
        icon = CupertinoIcons.folder;
        iconColor = context.colors.warning;
        break;
      case AppConstants.archivesIndicator:
        icon = CupertinoIcons.archivebox;
        iconColor = context.colors.brown;
        break;
      default:
        icon = CupertinoIcons.doc;
        iconColor = context.colors.grey;
    }

    final relativePath = result.path.replaceFirst(_selectedPath, '~');

    return Container(
      decoration: BoxDecoration(
        color: isLargest
            ? context.colors.danger.withValues(alpha: 0.08)
            : context.colors.cardBackground,
        border: isLargest
            ? Border.all(
                color: context.colors.danger.withValues(alpha: 0.4),
                width: 2,
              )
            : Border(
                bottom: BorderSide(
                  color: context.colors.separator,
                  width: 1,
                ),
              ),
      ),
      child: GestureDetector(
        onSecondaryTap: () => _showContextMenu(context, result),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: MacosIcon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            path.basename(result.path),
                            style: MacosTheme.of(context)
                                .typography
                                .caption1
                                .copyWith(
                                  fontWeight: isLargest
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLargest)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: context.colors.danger
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'LARGEST',
                              style: MacosTheme.of(context)
                                  .typography
                                  .caption1
                                  .copyWith(
                                    color: context.colors.danger,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      relativePath,
                      style: MacosTheme.of(context)
                          .typography
                          .caption1
                          .copyWith(
                            color: context.colors.secondaryLabel,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: iconColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            result.type.toUpperCase(),
                            style: MacosTheme.of(context)
                                .typography
                                .caption1
                                .copyWith(
                                  color: iconColor,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.3,
                                ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          result.isDirectory ? 'Folder' : 'File',
                          style: MacosTheme.of(context)
                              .typography
                              .caption1
                              .copyWith(
                                color: context.colors.secondaryLabel,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• Modified: ${_formatDate(result.lastModified)}',
                          style: MacosTheme.of(context)
                              .typography
                              .caption1
                              .copyWith(
                                color: context.colors.secondaryLabel,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatFileSize(result.size),
                        style: MacosTheme.of(context)
                            .typography
                            .caption1
                            .copyWith(
                              fontWeight: FontWeight.bold,
                              color: isLargest
                                  ? context.colors.danger
                                  : context.colors.accent,
                            ),
                      ),
                      const SizedBox(width: 6),
                      MacosIcon(
                        CupertinoIcons.ellipsis,
                        size: 14,
                        color: context.colors.secondaryLabel,
                      ),
                    ],
                  ),
                  Text(
                    result.isDirectory ? 'FOLDER' : 'FILE',
                    style: MacosTheme.of(context)
                        .typography
                        .caption1
                        .copyWith(
                          color: context.colors.secondaryLabel,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => _showItemDetails(result),
      ),
    );
  }
}
