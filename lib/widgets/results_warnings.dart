part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsResultsWarnings on _CleanerHomePageState {
  Widget _buildPermissionWarnings() {
    if (_permissionErrors.isEmpty) return const SizedBox.shrink();

    final typography = MacosTheme.of(context).typography;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: context.colors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colors.warning.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MacosIcon(
                CupertinoIcons.exclamationmark_triangle,
                color: context.colors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                'Permission Warnings',
                style: typography.caption1.copyWith(
                  color: context.colors.warning,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Some directories could not be accessed due to permission restrictions. '
            'Scan results may be incomplete.',
            style: typography.caption1.copyWith(
              color: context.colors.label,
            ),
          ),
          if (_permissionErrors.length <= 5) ...[
            const SizedBox(height: 12),
            ..._permissionErrors.take(5).map(
              (error) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${error.replaceFirst(_selectedPath, '~')}',
                  style: typography.caption1.copyWith(
                    color: context.colors.secondaryLabel,
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              '${_permissionErrors.length} directories could not be accessed',
              style: typography.caption1.copyWith(
                color: context.colors.secondaryLabel,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
