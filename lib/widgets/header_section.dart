part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsHeader on _CleanerHomePageState {
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11.2, horizontal: 11.2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBlue.withOpacity(0.08),
            CupertinoColors.systemPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(11.2),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        AppConstants.mainDescription,
        style: GoogleFonts.montserrat(
          fontSize: 12,
          color: CupertinoColors.secondaryLabel,
          height: 1.4,
          letterSpacing: -0.07,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  CupertinoNavigationBar _buildNavigationBar() {
    return CupertinoNavigationBar(
      backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
      border: null,
      leading: AppLogo(),
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
          if (Platform.isMacOS) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const PaywallPage(),
                  ),
                );
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
                  CupertinoIcons.heart_fill,
                  size: 18,
                  color: CupertinoColors.systemPink,
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
      padding: const EdgeInsets.symmetric(horizontal: 8.4, vertical: 5.6),
      onPressed: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.4, vertical: 5.6),
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(5.6),
          border: Border.all(
            color: CupertinoColors.systemGrey4,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11.2, color: CupertinoColors.systemBlue),
            const SizedBox(width: 4.2),
            Text(
              label,
              style: GoogleFonts.montserrat(
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
        borderRadius: BorderRadius.circular(11.2),
        border: Border.all(
          color: CupertinoColors.systemOrange.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemOrange.withOpacity(0.1),
            blurRadius: 5.6,
            offset: const Offset(0, 1.4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.all(11.2),
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
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemOrange,
                    CupertinoColors.systemOrange.darkColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(8.4),
                boxShadow: [
                  BoxShadow(
                    color: CupertinoColors.systemOrange.withOpacity(0.3),
                    blurRadius: 5.6,
                    offset: const Offset(0, 1.4),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.hammer,
                size: 16.8,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(width: 8.4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Xcode Cache Cleaner',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: CupertinoColors.label,
                    ),
                  ),
                  const SizedBox(height: 2.8),
                  Text(
                    'Clean Device Support, Archives, Derived Data, and more',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: CupertinoColors.systemOrange,
            ),
          ],
        ),
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Broomie',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: CupertinoColors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/icon.png',
              width: 32,
              height: 32,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }
}

