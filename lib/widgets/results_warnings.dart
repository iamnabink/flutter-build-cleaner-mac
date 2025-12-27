part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsResultsWarnings on _CleanerHomePageState {
  Widget _buildPermissionWarnings() {
    if (_permissionErrors.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemRed.withOpacity(0.12),
            CupertinoColors.systemRed.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemRed.withOpacity(0.4),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemRed.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.exclamationmark_triangle,
                color: CupertinoColors.systemRed,
              ),
              const SizedBox(width: 8),
              Text(
                'Permission Warnings',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: CupertinoColors.systemRed,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Some directories could not be accessed due to permission restrictions. '
            'Scan results may be incomplete.',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: CupertinoColors.label,
            ),
          ),
          if (_permissionErrors.length <= 5) ...[
            const SizedBox(height: 12),
            ..._permissionErrors.take(5).map(
              (error) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '• ${error.replaceFirst(_selectedPath, '~')}',
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
              ),
            ),
          ] else ...[
            const SizedBox(height: 8),
            Text(
              '${_permissionErrors.length} directories could not be accessed',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

