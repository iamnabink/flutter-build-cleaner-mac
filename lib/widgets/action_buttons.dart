part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsActions on _CleanerHomePageState {
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Current path display (if selected)
          if (_selectedPath.isNotEmpty && _hasPermission) ...[
            _buildCurrentPathDisplay(),
            const SizedBox(height: 12),
            Container(
              height: 1,
              color: CupertinoColors.systemGrey4,
            ),
            const SizedBox(height: 12),
          ],
          
          // Permission state
          if (!_hasPermission) ...[
            _buildPermissionPrompt(),
            const SizedBox(height: 12),
            _buildGrantPermissionButton(),
          ] else if (_selectedPath.isEmpty) ...[
            _buildSelectDirectoryPrompt(),
            const SizedBox(height: 12),
            _buildSelectDirectoryButton(),
          ] else ...[
            // Primary action - Scan
            _buildScanButton(),
            if (_scanResults.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                height: 1,
                color: CupertinoColors.systemGrey4,
              ),
              const SizedBox(height: 12),
              // Secondary actions
              Row(
                children: [
                  Expanded(child: _buildChangeDirectoryButton()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildCleanButton()),
                ],
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentPathDisplay() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBackground,
            CupertinoColors.systemGrey6,
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: CupertinoColors.systemBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemBlue.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: CupertinoColors.systemBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              CupertinoIcons.folder_fill,
              size: 14,
              color: CupertinoColors.systemBlue,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _selectedPath,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
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

  Widget _buildPermissionPrompt() {
    return Column(
      children: [
        Icon(
          CupertinoIcons.lock_fill,
          size: 32,
          color: CupertinoColors.systemOrange,
        ),
        const SizedBox(height: 8),
        const Text(
          'Permission Required',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppConstants.grantPermissionMessage,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSelectDirectoryPrompt() {
    return Column(
      children: [
        Icon(
          CupertinoIcons.folder_fill,
          size: 32,
          color: CupertinoColors.systemBlue,
        ),
        const SizedBox(height: 8),
        const Text(
          'Select Directory',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppConstants.selectDirectoryMessage,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.secondaryLabel,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGrantPermissionButton() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      width: double.infinity,
      height: 44,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemOrange.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _showPermissionDialog,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.lock_fill,
              size: 18,
              color: isDisabled
                  ? CupertinoColors.secondaryLabel
                  : CupertinoColors.white,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppConstants.grantPermissionButtonText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? CupertinoColors.secondaryLabel
                      : CupertinoColors.white,
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectDirectoryButton() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      width: double.infinity,
      height: 44,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _requestFileAccess,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.folder_fill,
              size: 18,
              color: isDisabled
                  ? CupertinoColors.secondaryLabel
                  : CupertinoColors.white,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                AppConstants.selectDirectoryButtonText,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? CupertinoColors.secondaryLabel
                      : CupertinoColors.white,
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChangeDirectoryButton() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border.all(
          color: isDisabled
              ? CupertinoColors.systemGrey4
              : CupertinoColors.systemBlue.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.03),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _requestFileAccess,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.folder,
                size: 16,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.systemBlue,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDisabled
                        ? CupertinoColors.secondaryLabel
                        : CupertinoColors.systemBlue,
                    letterSpacing: -0.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScanButton() {
    final isDisabled = _isScanning || _isDeleting;
    return Container(
      width: double.infinity,
      height: 44,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _scanSystem,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _isScanning
                ? AnimatedBuilder(
                    animation: _rotationAnimation,
                    builder: (context, child) {
                      return Transform.rotate(
                        angle: _rotationAnimation.value * 2 * 3.14159,
                        child: const Icon(
                          CupertinoIcons.arrow_2_squarepath,
                          size: 18,
                          color: CupertinoColors.white,
                        ),
                      );
                    },
                  )
                : const Icon(
                    CupertinoIcons.search,
                    size: 18,
                    color: CupertinoColors.white,
                  ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _isScanning
                    ? AppConstants.scanningButtonText
                    : AppConstants.scanButtonText,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.white,
                  letterSpacing: -0.2,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanButton() {
    final isDisabled = _scanResults.isEmpty || _isScanning || _isDeleting;
    return Container(
      height: 40,
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
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemRed.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _cleanAll,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _isDeleting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CupertinoActivityIndicator(
                        radius: 8,
                        color: CupertinoColors.white,
                      ),
                    )
                  : const Icon(
                      CupertinoIcons.delete,
                      size: 16,
                      color: CupertinoColors.white,
                    ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  _isDeleting
                      ? AppConstants.deletingButtonText
                      : AppConstants.cleanAllButtonText,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isDisabled
                        ? CupertinoColors.secondaryLabel
                        : CupertinoColors.white,
                    letterSpacing: -0.1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


