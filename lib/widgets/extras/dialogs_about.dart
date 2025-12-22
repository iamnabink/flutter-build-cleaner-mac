part of '../../pages/cleaner_home_page.dart';

extension CleanerHomePageDialogsAbout on _CleanerHomePageState {
  void _showAboutDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxWidth: 420,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        margin: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(9.8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.info,
                    color: CupertinoColors.systemBlue,
                    size: 16.8,
                  ),
                  const SizedBox(width: 5.6),
                  const Expanded(
                    child: Text(
                      AppConstants.aboutTitle,
                      style: TextStyle(
                        fontSize: 12.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      size: 14,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  AppConstants.aboutContent,
                  style: const TextStyle(fontSize: 9.8),
                  softWrap: true,
                ),
                const SizedBox(height: 8.4),
                const Text(
                  AppConstants.apkFiles,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.ipaFiles,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.aabFiles,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.flutterBuildFolders,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.reactNativeBuildFolders,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.androidBuildFolders,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.iosBuildFolders,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.archivesFolders,
                  style: TextStyle(fontSize: 9.8),
                ),
                const Text(
                  AppConstants.reactNativeNodeModules,
                  style: TextStyle(fontSize: 9.8),
                ),
                const SizedBox(height: 8.4),
                Container(
                  padding: const EdgeInsets.all(8.4),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(5.6),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.currentScanLocation,
                        style: const TextStyle(
                          fontSize: 8.4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedPath.isEmpty
                            ? AppConstants.notAvailable
                            : _selectedPath,
                        style: const TextStyle(
                          fontSize: 8.4,
                          fontFamily: 'monospace',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8.4),
                Text(
                  AppConstants.safetyMessage,
                  style: const TextStyle(
                    fontSize: 8.4,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 8.4),
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppConstants.madeWithLove,
                        style: const TextStyle(
                          fontSize: 9.8,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5.6),
                      Text(
                        AppConstants.developerTitle,
                        style: const TextStyle(
                          fontSize: 8.4,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 5.6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.6,
                          vertical: 2.8,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(4.2),
                        ),
                        child: Text(
                          '$_appVersionLabel • $_buildNumberLabel',
                          style: const TextStyle(
                            fontSize: 8.4,
                            color: CupertinoColors.label,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.4),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8.4,
                        runSpacing: 8.4,
                        children: [
                          _buildSocialButton(
                            icon: CupertinoIcons.link,
                            label: 'LinkedIn',
                            onTap: () => _launchUrl(AppConstants.linkedinUrl),
                          ),
                          _buildSocialButton(
                            icon: CupertinoIcons.square_stack_3d_up,
                            label: 'GitHub',
                            onTap: () => _launchUrl(AppConstants.githubUrl),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                    ],
                  ),
                ),
              ),
            // Footer with action button
            Container(
              padding: const EdgeInsets.all(11.2),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: CupertinoColors.separator,
                    width: 0.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      AppConstants.closeButton,
                      style: TextStyle(fontSize: 9.8),
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
}

