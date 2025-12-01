part of '../../pages/cleaner_home_page.dart';

extension CleanerHomePageDialogsAbout on _CleanerHomePageState {
  void _showAboutDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        margin: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
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
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      AppConstants.aboutTitle,
                      style: TextStyle(
                        fontSize: 18,
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
                      size: 20,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            // Scrollable content
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text(
                  AppConstants.aboutContent,
                  style: const TextStyle(fontSize: 14),
                  softWrap: true,
                ),
                const SizedBox(height: 12),
                const Text(
                  AppConstants.apkFiles,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.ipaFiles,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.aabFiles,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.flutterBuildFolders,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.reactNativeBuildFolders,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.androidBuildFolders,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.iosBuildFolders,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.archivesFolders,
                  style: TextStyle(fontSize: 14),
                ),
                const Text(
                  AppConstants.reactNativeNodeModules,
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstants.currentScanLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _selectedPath.isEmpty
                            ? AppConstants.notAvailable
                            : _selectedPath,
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  AppConstants.safetyMessage,
                  style: const TextStyle(
                    fontSize: 12,
                    color: CupertinoColors.secondaryLabel,
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Column(
                    children: [
                      Text(
                        AppConstants.madeWithLove,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.developerTitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.secondaryLabel,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemGrey6,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$_appVersionLabel • $_buildNumberLabel',
                          style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.label,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 12,
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
              padding: const EdgeInsets.all(16),
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
                    child: const Text(AppConstants.closeButton),
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

