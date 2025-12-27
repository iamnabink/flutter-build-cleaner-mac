part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsResultsList on _CleanerHomePageState {
  Widget _buildResultsList() {
    final sortedResults = List<ScanResult>.from(_scanResults)
      ..sort((a, b) => b.size.compareTo(a.size));

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CupertinoColors.systemGrey6,
              CupertinoColors.systemGrey5,
            ],
          ),
          borderRadius: BorderRadius.circular(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemGrey5,
                    CupertinoColors.systemGrey6,
                  ],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: CupertinoColors.systemGrey4.withOpacity(0.3),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.list_bullet,
                    color: CupertinoColors.label,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Found Items (${sortedResults.length})',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: CupertinoColors.label,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Sorted by size',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ),
            if (sortedResults.isEmpty) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Center(
                  child: Text(
                    AppConstants.noArtifactsFound,
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
            if (sortedResults.isNotEmpty)
              ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sortedResults.length,
              itemBuilder: (context, index) {
                final result = sortedResults[index];
                return _buildResultItem(result, index == 0);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultItem(ScanResult result, bool isLargest) {
    IconData icon;
    Color iconColor;

    switch (result.type) {
      case 'apk':
        icon = CupertinoIcons.device_phone_portrait;
        iconColor = CupertinoColors.systemGreen;
        break;
      case 'aab':
        icon = CupertinoIcons.square_stack;
        iconColor = CupertinoColors.systemBlue;
        break;
      case 'ipa':
        icon = CupertinoIcons.device_phone_portrait;
        iconColor = CupertinoColors.systemPurple;
        break;
      case AppConstants.flutterBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = CupertinoColors.systemBlue;
        break;
      case AppConstants.reactNativeBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = CupertinoColors.activeBlue;
        break;
      case AppConstants.androidBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = CupertinoColors.systemGreen;
        break;
      case AppConstants.iosBuildIndicator:
        icon = CupertinoIcons.hammer;
        iconColor = CupertinoColors.systemGrey;
        break;
      case AppConstants.nodeModulesIndicator:
        icon = CupertinoIcons.folder;
        iconColor = CupertinoColors.systemOrange;
        break;
      case AppConstants.archivesIndicator:
        icon = CupertinoIcons.archivebox;
        iconColor = CupertinoColors.systemBrown;
        break;
      default:
        icon = CupertinoIcons.doc;
        iconColor = CupertinoColors.systemGrey;
    }

    final relativePath = result.path.replaceFirst(_selectedPath, '~');

    return Container(
      decoration: BoxDecoration(
        gradient: isLargest
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.systemRed.withOpacity(0.12),
                  CupertinoColors.systemRed.withOpacity(0.06),
                ],
              )
            : null,
        color: isLargest ? null : CupertinoColors.systemGrey6,
        border: isLargest
            ? Border.all(
                color: CupertinoColors.systemRed.withOpacity(0.4),
                width: 2,
              )
            : Border(
                bottom: BorderSide(
                  color: CupertinoColors.systemGrey4.withOpacity(0.3),
                  width: 1,
                ),
              ),
      ),
      child: GestureDetector(
        onSecondaryTap: () => _showContextMenu(context, result),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
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
                      iconColor.withOpacity(0.2),
                      iconColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: iconColor.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            path.basename(result.path),
                            style: GoogleFonts.montserrat(
                              fontWeight: isLargest
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isLargest)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  CupertinoColors.systemRed,
                                  CupertinoColors.systemRed.darkColor,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: CupertinoColors.systemRed.withOpacity(0.4),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              'LARGEST',
                              style: GoogleFonts.montserrat(
                                color: CupertinoColors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      relativePath,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                iconColor.withOpacity(0.25),
                                iconColor.withOpacity(0.15),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              color: iconColor.withOpacity(0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            result.type.toUpperCase(),
                            style: GoogleFonts.montserrat(
                              color: iconColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          result.isDirectory ? 'Folder' : 'File',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• Modified: ${_formatDate(result.lastModified)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatFileSize(result.size),
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          color: isLargest
                              ? CupertinoColors.systemRed
                              : CupertinoColors.systemBlue,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        CupertinoIcons.ellipsis,
                        size: 14,
                        color: CupertinoColors.secondaryLabel,
                      ),
                    ],
                  ),
                  Text(
                    result.isDirectory ? 'FOLDER' : 'FILE',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      color: CupertinoColors.secondaryLabel,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        onTap: () => _showItemDetails(result),
      ),
    );
  }
}

