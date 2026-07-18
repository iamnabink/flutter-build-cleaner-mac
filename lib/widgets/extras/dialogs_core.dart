part of '../../pages/cleaner_home_page.dart';

extension CleanerHomePageDialogsCore on _CleanerHomePageState {
  Future<void> _showContextMenu(BuildContext context, ScanResult result) async {
    await showMacosSheet<String>(
      context: context,
      builder: (context) => MacosSheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  path.basename(result.path),
                  style: MacosTheme.of(context).typography.title3,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                PushButton(
                  controlSize: ControlSize.large,
                  secondary: true,
                  onPressed: () {
                    Navigator.pop(context, 'open');
                    _openInFinder(result.path);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MacosIcon(CupertinoIcons.folder, size: 20),
                      SizedBox(width: 8),
                      Text('Open in Finder'),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                PushButton(
                  controlSize: ControlSize.large,
                  secondary: true,
                  onPressed: () {
                    Navigator.pop(context, 'details');
                    _showItemDetails(result);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MacosIcon(CupertinoIcons.info, size: 20),
                      SizedBox(width: 8),
                      Text('Show Details'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                PushButton(
                  controlSize: ControlSize.large,
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showConfirmationDialog() async {
    final totalSize = _scanResults.fold<int>(
      0,
      (sum, result) => sum + result.size,
    );

    return await showMacosAlertDialog<bool>(
          context: context,
          builder: (context) => MacosAlertDialog(
            appIcon: Image.asset(
              'assets/images/icon.png',
              width: 56,
              height: 56,
            ),
            title: Text(
              AppConstants.confirmDeletionTitle,
              style: MacosTheme.of(context).typography.title3,
            ),
            message: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.confirmDeletionContent,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: context.colors.controlBackground,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: context.colors.danger.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total items:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            '${_scanResults.length}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total size:',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            _formatFileSize(totalSize),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '⚠️ This action cannot be undone!',
                  style: TextStyle(
                    color: context.colors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            primaryButton: PushButton(
              controlSize: ControlSize.large,
              color: context.colors.danger,
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete All'),
            ),
            secondaryButton: PushButton(
              controlSize: ControlSize.large,
              secondary: true,
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(AppConstants.cancelButton),
            ),
          ),
        ) ??
        false;
  }

  void _showItemDetails(ScanResult result) {
    showMacosSheet(
      context: context,
      builder: (context) => MacosSheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.colors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    MacosIcon(
                      result.isDirectory ? CupertinoIcons.folder : CupertinoIcons.doc,
                      color: context.colors.accent,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        path.basename(result.path),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: MacosIcon(
                        CupertinoIcons.xmark,
                        size: 20,
                        color: context.colors.secondaryLabel,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow('Type', result.type.toUpperCase()),
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
              // Footer with action buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: context.colors.separator,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PushButton(
                      controlSize: ControlSize.large,
                      secondary: true,
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(AppConstants.closeButton),
                    ),
                    const SizedBox(width: 8),
                    PushButton(
                      controlSize: ControlSize.large,
                      color: context.colors.danger,
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await _deleteItem(result);
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MacosIcon(CupertinoIcons.delete, size: 18, color: context.colors.white),
                          const SizedBox(width: 6),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: context.colors.white,
                              fontSize: 12,
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
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: context.colors.secondaryLabel,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: context.colors.cardBackground,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: context.colors.separator),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(String message, {required bool isError}) {
    showMacosAlertDialog(
      context: context,
      builder: (context) => MacosAlertDialog(
        appIcon: Image.asset(
          'assets/images/icon.png',
          width: 56,
          height: 56,
        ),
        title: Text(
          isError ? 'Error' : 'Success',
          style: MacosTheme.of(context).typography.title3,
        ),
        message: Text(message),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ),
    );
  }
}
