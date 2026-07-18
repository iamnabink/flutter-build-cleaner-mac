part of '../pages/cleaner_home_page.dart';

extension CleanerHomePageWidgetsHeader on _CleanerHomePageState {
  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11.2, horizontal: 11.2),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Text(
        AppConstants.mainDescription,
        style: TextStyle(
          fontSize: 12,
          color: context.colors.secondaryLabel,
          height: 1.4,
          letterSpacing: -0.07,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  ToolBar _buildToolBar() {
    return ToolBar(
      title: const Text(AppConstants.appName),
      centerTitle: false,
      actions: [
        if (_scanResults.isNotEmpty && !_isScanning)
          ToolBarIconButton(
            label: AppConstants.clearResultsButtonText,
            icon: const MacosIcon(CupertinoIcons.xmark_circle),
            showLabel: false,
            tooltipMessage: AppConstants.clearResultsButtonText,
            onPressed: () {
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
          ),
        if (RevenueCatService.isConfigured)
          ToolBarIconButton(
            label: 'Support',
            icon: const MacosIcon(CupertinoIcons.heart_fill),
            showLabel: false,
            tooltipMessage: 'Support Broomie',
            onPressed: () => MainView.section.value = AppSection.pro,
          ),
        ToolBarIconButton(
          label: AppConstants.aboutButtonText,
          icon: const MacosIcon(CupertinoIcons.info_circle),
          showLabel: false,
          tooltipMessage: AppConstants.aboutTitle,
          onPressed: () => MainView.section.value = AppSection.about,
        ),
      ],
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
          style: TextStyle(
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
                color: context.colors.black.withValues(alpha: 0.1),
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

