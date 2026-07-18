import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/constants.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

/// "About" sidebar section — replaces the old Cupertino modal about dialog.
class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  String _versionLabel = AppConstants.appVersion;
  String _buildLabel = AppConstants.buildNumber;

  static const List<String> _artifactBullets = [
    AppConstants.apkFiles,
    AppConstants.ipaFiles,
    AppConstants.aabFiles,
    AppConstants.flutterBuildFolders,
    AppConstants.reactNativeBuildFolders,
    AppConstants.androidBuildFolders,
    AppConstants.iosBuildFolders,
    AppConstants.archivesFolders,
    AppConstants.reactNativeNodeModules,
  ];

  @override
  void initState() {
    super.initState();
    _loadAppMetadata();
  }

  Future<void> _loadAppMetadata() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      setState(() {
        _versionLabel = 'Version ${info.version}';
        _buildLabel = 'Build ${info.buildNumber}';
      });
    } catch (_) {
      // Fall back to default labels.
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = MacosTheme.of(context).typography;

    return MacosScaffold(
      toolBar: const ToolBar(
        title: Text(AppConstants.aboutTitle),
        centerTitle: false,
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/icon.png',
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(AppConstants.appName, style: typography.title1),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: context.colors.chipBackground,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          '$_versionLabel • $_buildLabel',
                          style: typography.caption1,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _AboutCard(
                      children: [
                        Text(AppConstants.aboutContent, style: typography.body),
                        const SizedBox(height: 8),
                        for (final bullet in _artifactBullets)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Text(bullet, style: typography.body),
                          ),
                        const SizedBox(height: 8),
                        Text(
                          AppConstants.safetyMessage,
                          style: typography.caption1.copyWith(
                            color: context.colors.secondaryLabel,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _AboutCard(
                      children: [
                        Center(
                          child: Text(
                            AppConstants.madeWithLove,
                            style: typography.body.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Center(
                          child: Text(
                            AppConstants.developerTitle,
                            style: typography.caption1.copyWith(
                              color: context.colors.secondaryLabel,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PushButton(
                              controlSize: ControlSize.regular,
                              secondary: true,
                              onPressed: () =>
                                  _launchUrl(AppConstants.linkedinUrl),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MacosIcon(CupertinoIcons.link, size: 14),
                                  SizedBox(width: 6),
                                  Text('LinkedIn'),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            PushButton(
                              controlSize: ControlSize.regular,
                              secondary: true,
                              onPressed: () =>
                                  _launchUrl(AppConstants.githubUrl),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MacosIcon(
                                    CupertinoIcons.square_stack_3d_up,
                                    size: 14,
                                  ),
                                  SizedBox(width: 6),
                                  Text('GitHub'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.colors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
