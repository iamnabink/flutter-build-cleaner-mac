class AppConstants {
  // App Information
  static const String appName = 'AppBuild Dev Cleaner';
  static const String appDescription =
      'Clean up mobile development artifacts for Flutter and React Native developers';

  static const String mainDescription =
      'Clean up mobile development artifacts: APK, AAB, IPA files, Flutter builds, React Native builds, Android builds, iOS builds, iOS Archives (DerivedData), and node_modules';

  // Buttons
  static const String scanButtonText = 'Scan Directory';
  static const String scanningButtonText = 'Scanning...';
  static const String selectDirectoryButtonText = 'Select Directory';
  static const String changeDirectoryButtonText = 'Change Directory';
  static const String grantPermissionButtonText = 'Grant Permission';
  static const String cleanAllButtonText = 'Clean All';
  static const String deletingButtonText = 'Deleting...';
  static const String clearResultsButtonText = 'Clear Results';
  static const String aboutButtonText = 'About';

  // Messages
  static const String noScanResultsYet = 'No scan results yet';
  static const String permissionRequired = 'Permission Required';
  static const String noArtifactsFound =
      'No mobile development artifacts found (APK, AAB, IPA, Flutter builds, React Native builds, Android builds, iOS builds, iOS Archives in DerivedData, node_modules).';
  static const String clickToScanMessage =
      'Click "Scan Directory" to find mobile development artifacts: APK, AAB, IPA files, Flutter builds, React Native builds, Android builds, iOS builds, iOS Archives in DerivedData, and node_modules';
  static const String grantPermissionMessage =
      'Grant permission to access your home directory to start scanning';
  static const String selectDirectoryMessage =
      'Select a directory/path to scan';
  static const String changeDirectoryMessage = 'Tap to change scan location';

  // Permission Dialog
  static const String permissionDialogTitle = 'Permission Required';
  static const String permissionDialogContent =
      'This app needs permission to access your home directory to scan for files.';
  static const String whatAppWillDo = 'What this app will do:';
  static const String scanForFiles = '• Scan for APK, AAB, and IPA files';
  static const String findFlutterBuilds = '• Find Flutter build folders';
  static const String findNodeModules =
      '• Find React Native node_modules folders';
  static const String calculateSizes = '• Calculate file and folder sizes';
  static const String allowDeletion = '• Allow you to delete unwanted files';
  static const String grantAccessMessage =
      'Click "Grant Access" to open the system dialog and select your home directory.';
  static const String grantAccessButton = 'Grant Access';
  static const String cancelButton = 'Cancel';

  // Confirmation Dialog
  static const String confirmDeletionTitle = 'Confirm Deletion';
  static const String confirmDeletionContent =
      'Are you sure you want to delete these mobile development artifacts?';
  static const String totalItems = 'Total items:';
  static const String totalSize = 'Total size:';
  static const String warningMessage = '⚠️ This action cannot be undone!';
  static const String deleteAllButton = 'Delete All';

  // Progress Messages
  static const String scanningSystem = 'Scanning System...';
  static const String deletingFiles = 'Deleting Files...';
  static const String currentScanPath = 'Current:';

  // Success Messages
  static const String successfullyCleaned = 'Successfully cleaned';
  static const String itemsFreed = 'items, freed';
  static const String itemsCouldNotBeDeleted = 'items could not be deleted';
  static const String cleanedItem = 'Cleaned';
  static const String failedToClean = 'Failed to clean';

  // About Dialog
  static const String aboutTitle = 'About AppBuild Dev Cleaner';
  static const String aboutContent =
      'This app helps mobile developers clean up unnecessary build artifacts:';
  static const String apkFiles = '• APK files (Android packages)';
  static const String ipaFiles = '• IPA files (iOS app bundles)';
  static const String aabFiles = '• AAB files (Android App Bundles)';
  static const String flutterBuildFolders = '• Flutter build folders';
  static const String reactNativeBuildFolders = '• React Native build folders';
  static const String androidBuildFolders = '• Android build folders';
  static const String iosBuildFolders = '• iOS build folders';
  static const String archivesFolders = '• iOS Archives in DerivedData';
  static const String reactNativeNodeModules =
      '• React Native node_modules folders';
  static const String currentScanLocation = 'Current Scan Location:';
  static const String notAvailable = 'N/A';
  static const String safetyMessage =
      'The app safely skips system directories and handles permission errors gracefully.';
  static const String madeWithLove = 'Made with Love by Nabraj Khadka ♥️';
  static const String developerTitle = 'Mobile Developer & Flutter Enthusiast';
  static const String linkedinUrl = 'https://linkedin.com/in/iamnabink';
  static const String githubUrl = 'https://github.com/iamnabink';
  static const String appVersion = 'Version 1.0.0';
  static const String buildNumber = 'Build 1';
  static const String closeButton = 'Close';

  // File Types
  static const String apkType = 'APK Files';
  static const String aabType = 'AAB Files';
  static const String ipaType = 'IPA Files';
  static const String flutterBuildType = 'Flutter Build';
  static const String reactNativeBuildType = 'React Native Build';
  static const String androidBuildType = 'Android Build';
  static const String iosBuildType = 'iOS Build';
  static const String nodeModulesType = 'Node Modules';
  static const String archivesType = 'iOS Archives (DerivedData)';

  // Labels
  static const String filesLabel = 'Files:';
  static const String foldersLabel = 'Folders:';
  static const String sizeLabel = 'Size:';
  static const String scannedLabel = 'Scanned';
  static const String errorsLabel = 'Errors';
  static const String progressLabel = 'Progress';
  static const String spaceToFreeUp = 'Space to free up:';
  static const String foundItems = 'Found Items';
  static const String sortedBySize = 'Sorted by size';
  static const String largestLabel = 'LARGEST';
  static const String folderLabel = 'Folder';
  static const String fileLabel = 'File';
  static const String modifiedLabel = 'Modified:';

  // Permission Warnings
  static const String permissionWarningsTitle = 'Permission Warnings';
  static const String permissionWarningsContent =
      'Some directories could not be accessed due to permission restrictions. Scan results may be incomplete.';
  static const String directoriesNotAccessed =
      'directories could not be accessed';

  // Actions
  static const String deleteAction = 'Delete';
  static const String dismissAction = 'Dismiss';

  // File Type Indicators
  static const String apkIndicator = 'APK';
  static const String aabIndicator = 'AAB';
  static const String ipaIndicator = 'IPA';
  static const String flutterBuildIndicator = 'FLUTTER_BUILD';
  static const String reactNativeBuildIndicator = 'RN_BUILD';
  static const String androidBuildIndicator = 'ANDROID_BUILD';
  static const String iosBuildIndicator = 'IOS_BUILD';
  static const String nodeModulesIndicator = 'NODE_MODULES';
  static const String archivesIndicator = 'ARCHIVES';

  // Detail Labels
  static const String typeLabel = 'Type';
  static const String kindLabel = 'Kind';
  static const String lastModifiedLabel = 'Last Modified';
  static const String fullPathLabel = 'Full Path';
}
