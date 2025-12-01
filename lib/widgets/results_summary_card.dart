part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsResultsSummary on _CleanerHomePageState {
  Widget _buildSummaryCard() {
    if (_scanResults.isEmpty && !_isScanning) {
      return Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              _hasPermission ? CupertinoIcons.folder : CupertinoIcons.lock,
              size: 64,
              color: _hasPermission
                  ? CupertinoColors.systemBlue.withOpacity(0.6)
                  : CupertinoColors.systemOrange.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              _hasPermission
                  ? AppConstants.noScanResultsYet
                  : AppConstants.permissionRequired,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _hasPermission
                  ? AppConstants.clickToScanMessage
                  : AppConstants.grantPermissionMessage,
              style: const TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            CupertinoButton.filled(
              onPressed: _requestFileAccess,
              color: _hasPermission
                  ? CupertinoColors.systemBlue
                  : CupertinoColors.systemOrange,
              child: Text(
                _selectedPath.isEmpty
                    ? AppConstants.selectDirectoryMessage
                    : 'Scan Path: $_selectedPath',
                style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
              ),
            ),
            if (!_hasPermission) ...[
              const SizedBox(height: 16),
              CupertinoButton.filled(
                onPressed: _requestFileAccess,
                color: CupertinoColors.systemOrange,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(CupertinoIcons.folder, size: 16),
                    const SizedBox(width: 8),
                    const Text(AppConstants.selectDirectoryButtonText),
                  ],
                ),
              ),
            ],
          ],
        ),
      );
    }

    if (_scanResults.isEmpty) return const SizedBox.shrink();

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
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            const Text(
              'Scan Results',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (apkCount > 0)
                      _buildSummaryItem(
                        AppConstants.apkType,
                        apkCount,
                        CupertinoIcons.device_phone_portrait,
                        CupertinoColors.systemGreen,
                      ),
                    if (aabCount > 0)
                      _buildSummaryItem(
                        AppConstants.aabType,
                        aabCount,
                        CupertinoIcons.square_stack,
                        CupertinoColors.systemBlue,
                      ),
                    if (ipaCount > 0)
                      _buildSummaryItem(
                        AppConstants.ipaType,
                        ipaCount,
                        CupertinoIcons.device_phone_portrait,
                        CupertinoColors.systemPurple,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (flutterBuildCount > 0)
                      _buildSummaryItem(
                        AppConstants.flutterBuildType,
                        flutterBuildCount,
                        CupertinoIcons.hammer,
                        CupertinoColors.systemBlue,
                      ),
                    if (reactNativeBuildCount > 0)
                      _buildSummaryItem(
                        AppConstants.reactNativeBuildType,
                        reactNativeBuildCount,
                        CupertinoIcons.hammer,
                        CupertinoColors.activeBlue,
                      ),
                    if (androidBuildCount > 0)
                      _buildSummaryItem(
                        AppConstants.androidBuildType,
                        androidBuildCount,
                        CupertinoIcons.hammer,
                        CupertinoColors.systemGreen,
                      ),
                    if (iosBuildCount > 0)
                      _buildSummaryItem(
                        AppConstants.iosBuildType,
                        iosBuildCount,
                        CupertinoIcons.hammer,
                        CupertinoColors.systemGrey,
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (nodeModulesCount > 0)
                      _buildSummaryItem(
                        AppConstants.nodeModulesType,
                        nodeModulesCount,
                        CupertinoIcons.folder,
                        CupertinoColors.systemOrange,
                      ),
                    if (archivesCount > 0)
                      _buildSummaryItem(
                        AppConstants.archivesType,
                        archivesCount,
                        CupertinoIcons.archivebox,
                        CupertinoColors.systemBrown,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Subtle informational panel — not tappable. Reduced emphasis
            // so users don't think this is a primary action button.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: CupertinoColors.secondarySystemFill,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.systemGrey4.withOpacity(0.8),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      CupertinoIcons.delete_solid,
                      size: 22,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.spaceToFreeUp,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatFileSize(totalSize),
                        style: const TextStyle(
                          fontSize: 18,
                          color: CupertinoColors.label,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Small hint to clarify there's no immediate tap action here.
                  Text(
                    'Review items below to delete',
                    style: const TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
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
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 32, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    );
  }
}
