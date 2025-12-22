part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsActions on _CleanerHomePageState {
  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.all(11.2),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(11.2),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.06),
            blurRadius: 8.4,
            offset: const Offset(0, 1.4),
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
            const SizedBox(height: 8.4),
            Container(
              height: 1,
              color: CupertinoColors.systemGrey4,
            ),
            const SizedBox(height: 8.4),
          ],
          
          // Permission state
          if (!_hasPermission) ...[
            _buildPermissionPrompt(),
            const SizedBox(height: 8.4),
            _buildGrantPermissionButton(),
          ] else if (_selectedPath.isEmpty) ...[
            _buildSelectDirectoryPrompt(),
            const SizedBox(height: 8.4),
            _buildSelectDirectoryButton(),
          ] else ...[
            // Primary action - Scan
            _buildScanButton(),
            if (_scanResults.isNotEmpty) ...[
              const SizedBox(height: 8.4),
              Container(
                height: 1,
                color: CupertinoColors.systemGrey4,
              ),
              const SizedBox(height: 8.4),
              // Secondary actions
              Row(
                children: [
                  Expanded(child: _buildChangeDirectoryButton()),
                  const SizedBox(width: 8.4),
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
              style: const TextStyle(
                fontSize: 7.7,
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
          size: 22.4,
          color: CupertinoColors.systemOrange,
        ),
        const SizedBox(height: 5.6),
        const Text(
          'Permission Required',
          style: TextStyle(
            fontSize: 11.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4.2),
        Text(
          AppConstants.grantPermissionMessage,
          style: const TextStyle(
            fontSize: 8.4,
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
          size: 22.4,
          color: CupertinoColors.systemBlue,
        ),
        const SizedBox(height: 5.6),
        const Text(
          'Select Directory',
          style: TextStyle(
            fontSize: 11.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4.2),
        Text(
          AppConstants.selectDirectoryMessage,
          style: const TextStyle(
            fontSize: 8.4,
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
      height: 30.8,
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
        borderRadius: BorderRadius.circular(8.4),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemOrange.withOpacity(0.4),
                  blurRadius: 8.4,
                  offset: const Offset(0, 2.8),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _showPermissionDialog,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.lock_fill,
              size: 12.6,
              color: isDisabled
                  ? CupertinoColors.secondaryLabel
                  : CupertinoColors.white,
            ),
            const SizedBox(width: 5.6),
            Flexible(
              child: Text(
                AppConstants.grantPermissionButtonText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? CupertinoColors.secondaryLabel
                      : CupertinoColors.white,
                  letterSpacing: -0.14,
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
      height: 30.8,
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
        borderRadius: BorderRadius.circular(8.4),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.4),
                  blurRadius: 8.4,
                  offset: const Offset(0, 2.8),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _requestFileAccess,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8.4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              CupertinoIcons.folder_fill,
              size: 12.6,
              color: isDisabled
                  ? CupertinoColors.secondaryLabel
                  : CupertinoColors.white,
            ),
            const SizedBox(width: 5.6),
            Flexible(
              child: Text(
                AppConstants.selectDirectoryButtonText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: isDisabled
                      ? CupertinoColors.secondaryLabel
                      : CupertinoColors.white,
                  letterSpacing: -0.14,
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
      height: 28,
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        border: Border.all(
          color: isDisabled
              ? CupertinoColors.systemGrey4
              : CupertinoColors.systemBlue.withOpacity(0.3),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8.4),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.03),
            blurRadius: 2.8,
            offset: const Offset(0, 1.4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _requestFileAccess,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8.4, vertical: 8.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.folder,
                size: 11.2,
                color: isDisabled
                    ? CupertinoColors.secondaryLabel
                    : CupertinoColors.systemBlue,
              ),
              const SizedBox(width: 4.2),
              Flexible(
                child: Text(
                  'Change',
                  style: TextStyle(
                    fontSize: 9.1,
                    fontWeight: FontWeight.w600,
                    color: isDisabled
                        ? CupertinoColors.secondaryLabel
                        : CupertinoColors.systemBlue,
                    letterSpacing: -0.07,
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
      height: 30.8,
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
        borderRadius: BorderRadius.circular(8.4),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.4),
                  blurRadius: 8.4,
                  offset: const Offset(0, 2.8),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _scanSystem,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8.4),
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
                          size: 12.6,
                          color: CupertinoColors.white,
                        ),
                      );
                    },
                  )
                : const Icon(
                    CupertinoIcons.search,
                    size: 12.6,
                    color: CupertinoColors.white,
                  ),
            const SizedBox(width: 5.6),
            Flexible(
              child: Text(
                _isScanning
                    ? AppConstants.scanningButtonText
                    : AppConstants.scanButtonText,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: CupertinoColors.white,
                  letterSpacing: -0.14,
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
      height: 28,
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
        borderRadius: BorderRadius.circular(8.4),
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemRed.withOpacity(0.4),
                  blurRadius: 7,
                  offset: const Offset(0, 2.8),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : _cleanAll,
        color: isDisabled ? CupertinoColors.systemGrey4 : CupertinoColors.systemBlue.withOpacity(0),
        disabledColor: CupertinoColors.systemGrey4,
        borderRadius: BorderRadius.circular(8.4),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8.4, vertical: 8.4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _isDeleting
                  ? const SizedBox(
                      width: 11.2,
                      height: 11.2,
                      child: CupertinoActivityIndicator(
                        radius: 5.6,
                        color: CupertinoColors.white,
                      ),
                    )
                  : const Icon(
                      CupertinoIcons.delete,
                      size: 11.2,
                      color: CupertinoColors.white,
                    ),
              const SizedBox(width: 4.2),
              Flexible(
                child: Text(
                  _isDeleting
                      ? AppConstants.deletingButtonText
                      : AppConstants.cleanAllButtonText,
                  style: TextStyle(
                    fontSize: 9.1,
                    fontWeight: FontWeight.w700,
                    color: isDisabled
                        ? CupertinoColors.secondaryLabel
                        : CupertinoColors.white,
                    letterSpacing: -0.07,
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


