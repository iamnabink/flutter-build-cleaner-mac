import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/data/manual_guide_data.dart';
import 'package:flutter_cleaner/models/guide_models.dart';
import 'package:flutter_cleaner/pages/guide/guide_widgets.dart';
import 'package:flutter_cleaner/pages/guide/routine_checklist.dart';
import 'package:flutter_cleaner/services/guide_progress_service.dart';
import 'package:flutter_cleaner/services/storage_info_service.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:macos_ui/macos_ui.dart';

/// Interactive version of MANUAL_MACOS_CLEANER_GUIDE.md: diagnostics and
/// cleanup commands with copy buttons, safety badges, and a persisted
/// maintenance-routine checklist.
class ManualGuidePage extends StatefulWidget {
  const ManualGuidePage({super.key});

  @override
  State<ManualGuidePage> createState() => _ManualGuidePageState();
}

class _ManualGuidePageState extends State<ManualGuidePage> {
  Set<String> _checkedIds = {};
  DateTime? _lastReset;
  StorageInfo? _storage;
  bool _loadingStorage = false;

  @override
  void initState() {
    super.initState();
    _load();
    _refreshStorage();
  }

  Future<void> _refreshStorage() async {
    if (_loadingStorage) return;
    setState(() => _loadingStorage = true);
    final info = await StorageInfoService.fetch();
    if (!mounted) return;
    setState(() {
      _storage = info;
      _loadingStorage = false;
    });
  }

  Future<void> _load() async {
    final checked = await GuideProgressService.loadCheckedSteps();
    final lastReset = await GuideProgressService.loadLastReset();
    if (!mounted) return;
    setState(() {
      _checkedIds = checked;
      _lastReset = lastReset;
    });
  }

  void _toggleStep(RoutineStep step, bool checked) {
    setState(() {
      if (checked) {
        _checkedIds.add(step.id);
      } else {
        _checkedIds.remove(step.id);
      }
    });
    GuideProgressService.saveCheckedSteps(_checkedIds);
  }

  Future<void> _confirmReset() async {
    await showMacosAlertDialog(
      context: context,
      builder: (dialogContext) => MacosAlertDialog(
        appIcon: Image.asset('assets/images/icon.png', width: 56, height: 56),
        title: const Text('Reset routine?'),
        message: const Text(
          'This unchecks all maintenance-routine steps and records a new '
          'reset date.',
        ),
        primaryButton: PushButton(
          controlSize: ControlSize.large,
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await GuideProgressService.reset();
            await _load();
          },
          child: const Text('Reset'),
        ),
        secondaryButton: PushButton(
          controlSize: ControlSize.large,
          secondary: true,
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = MacosTheme.of(context).typography;

    return MacosScaffold(
      toolBar: ToolBar(
        title: const Text('Manual Cleanup Guide'),
        centerTitle: false,
        actions: [
          CustomToolbarItem(
            tooltipMessage: 'Available storage on this Mac',
            inToolbarBuilder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: context.colors.chipBackground,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: context.colors.separator),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MacosIcon(
                      CupertinoIcons.floppy_disk,
                      size: 13,
                      color: context.colors.secondaryLabel,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _storage == null
                          ? '— free'
                          : '${_storage!.availableLabel} free of ${_storage!.totalLabel}',
                      style: MacosTheme.of(context).typography.caption1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          ToolBarIconButton(
            label: 'Refresh storage',
            icon: _loadingStorage
                ? const MacosIcon(CupertinoIcons.arrow_2_circlepath_circle)
                : const MacosIcon(CupertinoIcons.arrow_2_circlepath),
            showLabel: false,
            tooltipMessage: 'Refresh available storage',
            onPressed: _refreshStorage,
          ),
          const ToolBarDivider(),
          ToolBarIconButton(
            label: 'Reset routine',
            icon: const MacosIcon(CupertinoIcons.arrow_counterclockwise),
            showLabel: false,
            tooltipMessage: 'Reset maintenance routine',
            onPressed: _confirmReset,
          ),
        ],
      ),
      children: [
        ContentArea(
          builder: (context, scrollController) => ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                ManualGuideData.intro,
                style: typography.body
                    .copyWith(color: context.colors.secondaryLabel),
              ),
              const SizedBox(height: 14),
              RoutineChecklist(
                checkedIds: _checkedIds,
                lastReset: _lastReset,
                onToggle: _toggleStep,
                onCommandExecuted: _refreshStorage,
              ),
              const SizedBox(height: 18),
              for (final section in ManualGuideData.sections) ...[
                Text(
                  section.title,
                  style:
                      typography.title2.copyWith(fontWeight: FontWeight.w700),
                ),
                if (section.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      section.subtitle!,
                      style: typography.caption1
                          .copyWith(color: context.colors.secondaryLabel),
                    ),
                  ),
                const SizedBox(height: 8),
                for (final item in section.items)
                  GuideItemTile(
                    item: item,
                    onCommandExecuted: _refreshStorage,
                  ),
                const SizedBox(height: 14),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
