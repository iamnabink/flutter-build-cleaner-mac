part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsActions on _CleanerHomePageState {
  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Current path display (if selected)
        if (_selectedPath.isNotEmpty && _hasPermission) ...[
          _buildCurrentPathDisplay(),
          const SizedBox(height: 12),
        ],

        // Permission state
        if (!_hasPermission) ...[
          _buildPermissionCard(),
        ] else if (_selectedPath.isEmpty) ...[
          _buildSelectDirectoryCard(),
        ] else ...[
          // Primary action - Scan
          _buildScanCard(),
          if (_scanResults.isNotEmpty) ...[
            const SizedBox(height: 12),
            // Secondary actions
            Row(
              children: [
                Expanded(child: _buildChangeDirectoryCard()),
                const SizedBox(width: 12),
                Expanded(child: _buildCleanCard()),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildCurrentPathDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Row(
        children: [
          MacosIcon(
            CupertinoIcons.folder_fill,
            size: 14,
            color: context.colors.accent,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedPath,
              style: TextStyle(
                fontSize: 12,
                color: context.colors.label,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPermissionCard() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        children: [
          MacosIcon(
            CupertinoIcons.lock_fill,
            size: 28,
            color: isDisabled
                ? context.colors.secondaryLabel
                : context.colors.warning,
          ),
          const SizedBox(height: 12),
          Text(
            'Permission Required',
            style: MacosTheme.of(context).typography.title3,
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.grantPermissionMessage,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.secondaryLabel,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          PushButton(
            controlSize: ControlSize.large,
            secondary: true,
            onPressed: isDisabled ? null : _showPermissionDialog,
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectDirectoryCard() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        children: [
          MacosIcon(
            CupertinoIcons.folder_fill,
            size: 28,
            color: isDisabled
                ? context.colors.secondaryLabel
                : context.colors.accent,
          ),
          const SizedBox(height: 12),
          Text(
            'Select Directory',
            style: MacosTheme.of(context).typography.title3,
          ),
          const SizedBox(height: 8),
          Text(
            AppConstants.selectDirectoryMessage,
            style: TextStyle(
              fontSize: 12,
              color: context.colors.secondaryLabel,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          PushButton(
            controlSize: ControlSize.large,
            secondary: true,
            onPressed: isDisabled ? null : _requestFileAccess,
            child: const Text('Select Directory'),
          ),
        ],
      ),
    );
  }

  Widget _buildChangeDirectoryCard() {
    final isDisabled = _isScanning || _isDeleting;
    return SizedBox(
      width: double.infinity,
      child: PushButton(
        controlSize: ControlSize.large,
        secondary: true,
        onPressed: isDisabled ? null : _requestFileAccess,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const MacosIcon(CupertinoIcons.folder, size: 16),
            const SizedBox(width: 6),
            const Text('Change Directory'),
          ],
        ),
      ),
    );
  }

  Widget _buildScanCard() {
    final isDisabled = _isScanning || _isDeleting;
    return SizedBox(
      width: double.infinity,
      child: PushButton(
        controlSize: ControlSize.large,
        onPressed: isDisabled ? null : _scanSystem,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isScanning) ...[
              const ProgressCircle(value: null, radius: 8),
            ] else ...[
              const MacosIcon(CupertinoIcons.search, size: 16),
            ],
            const SizedBox(width: 6),
            Text(
              _isScanning
                  ? AppConstants.scanningButtonText
                  : AppConstants.scanButtonText,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanCard() {
    final isDisabled = _scanResults.isEmpty || _isScanning || _isDeleting;
    return SizedBox(
      width: double.infinity,
      child: PushButton(
        controlSize: ControlSize.large,
        color: context.colors.danger,
        onPressed: isDisabled ? null : _cleanAll,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isDeleting) ...[
              const ProgressCircle(value: null, radius: 8),
            ] else ...[
              MacosIcon(
                CupertinoIcons.delete,
                size: 16,
                color: isDisabled ? null : context.colors.white,
              ),
            ],
            const SizedBox(width: 6),
            Text(
              _isDeleting
                  ? AppConstants.deletingButtonText
                  : AppConstants.cleanAllButtonText,
              style: TextStyle(
                color: isDisabled ? null : context.colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
