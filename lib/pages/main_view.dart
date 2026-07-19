import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/constants.dart';
import 'package:flutter_cleaner/pages/about_page.dart';
import 'package:flutter_cleaner/pages/cleaner_home_page.dart';
import 'package:flutter_cleaner/pages/guide/manual_guide_page.dart';
import 'package:flutter_cleaner/pages/paywall_page.dart';
import 'package:flutter_cleaner/pages/xcode_cache_cleaner_page.dart';
import 'package:flutter_cleaner/services/revenue_cat_service.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:upgrader/upgrader.dart';

/// Top-level sections shown in the sidebar.
enum AppSection {
  home(CupertinoIcons.house_fill, 'Home'),
  xcode(CupertinoIcons.hammer_fill, 'Xcode Cleaner'),
  guide(CupertinoIcons.checkmark_shield_fill, 'Deep Cleanup'),
  pro(CupertinoIcons.heart_fill, 'Support / Pro'),
  about(CupertinoIcons.info_circle_fill, 'About');

  const AppSection(this.icon, this.label);
  final IconData icon;
  final String label;
}

/// App shell: MacosWindow with sidebar navigation over an IndexedStack.
///
/// Pages are built lazily on first visit and kept alive afterwards so an
/// in-flight scan survives switching sections.
class MainView extends StatefulWidget {
  const MainView({super.key});

  /// Global section selector so deep widgets (e.g. toolbar buttons) can jump
  /// to a section without threading callbacks through the part-file pages.
  static final ValueNotifier<AppSection> section =
      ValueNotifier(AppSection.home);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  final Set<AppSection> _builtSections = {MainView.section.value};

  /// Sidebar entries; Pro is hidden when no RevenueCat key is configured.
  List<AppSection> get _sections => [
        AppSection.home,
        AppSection.xcode,
        AppSection.guide,
        if (RevenueCatService.isConfigured) AppSection.pro,
        AppSection.about,
      ];

  @override
  void initState() {
    super.initState();
    MainView.section.addListener(_onSectionChanged);
  }

  @override
  void dispose() {
    MainView.section.removeListener(_onSectionChanged);
    super.dispose();
  }

  void _onSectionChanged() {
    setState(() => _builtSections.add(MainView.section.value));
  }

  Widget _buildSection(AppSection section) {
    if (!_builtSections.contains(section)) return const SizedBox.shrink();
    switch (section) {
      case AppSection.home:
        return const CleanerHomePage();
      case AppSection.xcode:
        return const XcodeCacheCleanerPage();
      case AppSection.guide:
        return const ManualGuidePage();
      case AppSection.pro:
        return const PaywallPage();
      case AppSection.about:
        return const AboutPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = _sections;
    final current = MainView.section.value;

    return MacosWindow(
      sidebar: Sidebar(
        minWidth: 200,
        top: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  'assets/images/icon.png',
                  width: 28,
                  height: 28,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppConstants.appName,
                style: MacosTheme.of(context).typography.title3.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
        ),
        builder: (context, scrollController) => SidebarItems(
          currentIndex: sections.indexOf(current).clamp(0, sections.length - 1),
          scrollController: scrollController,
          onChanged: (index) => MainView.section.value = sections[index],
          items: [
            for (final section in sections)
              SidebarItem(
                leading: MacosIcon(section.icon),
                label: Text(section.label),
              ),
          ],
        ),
      ),
      child: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: IndexedStack(
          index: AppSection.values.indexOf(current),
          children: [
            for (final section in AppSection.values) _buildSection(section),
          ],
        ),
      ),
    );
  }
}
