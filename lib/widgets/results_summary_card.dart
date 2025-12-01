part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsResultsSummary on _CleanerHomePageState {
  Widget _buildSummaryCard() {
    if (_scanResults.isEmpty && !_isScanning) {
      return const SizedBox.shrink();
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
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CupertinoColors.systemGrey6,
              CupertinoColors.systemGrey5,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.black.withOpacity(0.06),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: CupertinoColors.systemGrey4.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Scan Results',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 12),
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
                const SizedBox(height: 12),
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
                const SizedBox(height: 12),
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
            const SizedBox(height: 12),
            // Subtle informational panel — not tappable. Reduced emphasis
            // so users don't think this is a primary action button.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemRed.withOpacity(0.08),
                    CupertinoColors.systemRed.withOpacity(0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: CupertinoColors.systemRed.withOpacity(0.2),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemRed.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemRed.withOpacity(0.15),
                          CupertinoColors.systemRed.withOpacity(0.08),
                        ],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemRed.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                      color: CupertinoColors.systemRed,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.spaceToFreeUp,
                        style: const TextStyle(
                          fontSize: 10,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _formatFileSize(totalSize),
                        style: const TextStyle(
                          fontSize: 16,
                          color: CupertinoColors.systemRed,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Small hint to clarify there's no immediate tap action here.
                  Text(
                    'Review items below to delete',
                    style: const TextStyle(
                      fontSize: 10,
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
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.15),
                color.withOpacity(0.08),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 24, color: color),
        ),
        const SizedBox(height: 6),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
      ],
    );
  }
}
