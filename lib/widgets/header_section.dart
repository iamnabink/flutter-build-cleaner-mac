part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsHeader on _CleanerHomePageState {
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBlue.withOpacity(0.08),
            CupertinoColors.systemPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.systemBlue,
                  CupertinoColors.systemBlue.darkColor,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              CupertinoIcons.desktopcomputer,
              size: 32,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppConstants.appName,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            AppConstants.mainDescription,
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.secondaryLabel,
              height: 1.4,
              letterSpacing: -0.1,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
      border: null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_scanResults.isNotEmpty && !_isScanning) ...[
            GestureDetector(
              onTap: () {
                setState(() {
                  _scanResults.clear();
                  _filesFound = 0;
                  _foldersFound = 0;
                  _totalSizeScanned = 0;
                  _permissionErrors.clear();
                  _directoriesScanned = 0;
                  _scanProgress = 0.0;
                });
                _animationController.reverse();
              },
              child: Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  CupertinoIcons.xmark,
                  size: 18,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          GestureDetector(
            onTap: () => _showAboutDialog(),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.info_circle,
                size: 18,
                color: CupertinoColors.systemBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CupertinoColors.systemGrey4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: CupertinoColors.systemBlue),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: CupertinoColors.systemBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildXcodeCacheCleanerButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemOrange.withOpacity(0.1),
            CupertinoColors.systemOrange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemOrange.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemOrange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(16),
        onPressed: () {
          Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (context) => const XcodeCacheCleanerPage(),
            ),
          );
        },
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemOrange,
                    CupertinoColors.systemOrange.darkColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemOrange.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.hammer,
                size: 24,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Xcode Cache Cleaner',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Clean Device Support, Archives, Derived Data, and more',
                    style: TextStyle(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              color: CupertinoColors.systemOrange,
            ),
          ],
        ),
      ),
    );
  }
}

