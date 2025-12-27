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
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBackground,
            CupertinoColors.systemGrey6,
          ],
        ),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: CupertinoColors.systemBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemBlue.withOpacity(0.05),
            blurRadius: 4.2,
            offset: const Offset(0, 0.7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3.5),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4.2),
            ),
            child: Icon(
              CupertinoIcons.folder_fill,
              size: 9.8,
              color: CupertinoColors.systemBlue,
            ),
          ),
          const SizedBox(width: 5.6),
          Expanded(
            child: Text(
              _selectedPath,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: CupertinoColors.label,
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
    return GestureDetector(
      onTap: isDisabled ? null : _showPermissionDialog,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemOrange.withOpacity(0.15),
                    CupertinoColors.systemOrange.withOpacity(0.08),
                  ],
                ),
          color: isDisabled ? CupertinoColors.systemGrey6 : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? CupertinoColors.systemGrey4
                : CupertinoColors.systemOrange.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: CupertinoColors.systemOrange.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemOrange,
                          CupertinoColors.systemOrange.darkColor,
                        ],
                      ),
                color: isDisabled ? CupertinoColors.systemGrey4 : null,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.lock_fill,
                size: 24,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Permission Required',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.grantPermissionMessage,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap to grant permission',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.systemOrange,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectDirectoryCard() {
    final isDisabled = _isScanning || _isDeleting;
    return GestureDetector(
      onTap: isDisabled ? null : _requestFileAccess,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemBlue.withOpacity(0.15),
                    CupertinoColors.systemBlue.withOpacity(0.08),
                  ],
                ),
          color: isDisabled ? CupertinoColors.systemGrey6 : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? CupertinoColors.systemGrey4
                : CupertinoColors.systemBlue.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: CupertinoColors.systemBlue.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemBlue,
                          CupertinoColors.systemBlue.darkColor,
                        ],
                      ),
                color: isDisabled ? CupertinoColors.systemGrey4 : null,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.folder_fill,
                size: 24,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select Directory',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppConstants.selectDirectoryMessage,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap to select directory',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.systemBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeDirectoryCard() {
    final isDisabled = _isScanning || _isDeleting;
    return GestureDetector(
      onTap: isDisabled ? null : _requestFileAccess,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              CupertinoColors.systemBlue.withOpacity(0.1),
              CupertinoColors.systemBlue.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? CupertinoColors.systemGrey4
                : CupertinoColors.systemBlue.withOpacity(0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.folder,
                size: 20,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.systemBlue,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Change Directory',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanCard() {
    final isDisabled = _isScanning || _isDeleting;
    return GestureDetector(
      onTap: isDisabled ? null : _scanSystem,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemBlue.withOpacity(0.15),
                    CupertinoColors.systemBlue.withOpacity(0.08),
                  ],
                ),
          color: isDisabled ? CupertinoColors.systemGrey6 : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? CupertinoColors.systemGrey4
                : CupertinoColors.systemBlue.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: CupertinoColors.systemBlue.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemBlue,
                          CupertinoColors.systemBlue.darkColor,
                        ],
                      ),
                color: isDisabled ? CupertinoColors.systemGrey4 : null,
                shape: BoxShape.circle,
              ),
              child: _isScanning
                  ? AnimatedBuilder(
                      animation: _rotationAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _rotationAnimation.value * 2 * 3.14159,
                          child: const Icon(
                            CupertinoIcons.arrow_2_squarepath,
                            size: 24,
                            color: CupertinoColors.white,
                          ),
                        );
                      },
                    )
                  : const Icon(
                      CupertinoIcons.search,
                      size: 24,
                      color: CupertinoColors.white,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              _isScanning
                  ? AppConstants.scanningButtonText
                  : AppConstants.scanButtonText,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.label,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap to scan for artifacts',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.systemBlue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanCard() {
    final isDisabled = _scanResults.isEmpty || _isScanning || _isDeleting;
    return GestureDetector(
      onTap: isDisabled ? null : _cleanAll,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isDisabled
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CupertinoColors.systemRed.withOpacity(0.15),
                    CupertinoColors.systemRed.withOpacity(0.08),
                  ],
                ),
          color: isDisabled ? CupertinoColors.systemGrey6 : null,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDisabled
                ? CupertinoColors.systemGrey4
                : CupertinoColors.systemRed.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: CupertinoColors.systemRed.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: isDisabled
                    ? null
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          CupertinoColors.systemRed,
                          CupertinoColors.systemRed.darkColor,
                        ],
                      ),
                color: isDisabled ? CupertinoColors.systemGrey4 : null,
                shape: BoxShape.circle,
              ),
              child: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CupertinoActivityIndicator(
                        radius: 10,
                        color: CupertinoColors.white,
                      ),
                    )
                  : const Icon(
                      CupertinoIcons.delete,
                      size: 20,
                      color: CupertinoColors.white,
                    ),
            ),
            const SizedBox(height: 12),
            Text(
              _isDeleting
                  ? AppConstants.deletingButtonText
                  : AppConstants.cleanAllButtonText,
              style: GoogleFonts.montserrat(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


