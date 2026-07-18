import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/models/guide_models.dart';
import 'package:flutter_cleaner/services/shell_command_service.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:flutter_cleaner/utils/command_explainer.dart';
import 'package:macos_ui/macos_ui.dart';

/// Colored capsule showing an item's [SafetyLevel].
class SafetyBadge extends StatelessWidget {
  const SafetyBadge({super.key, required this.level});

  final SafetyLevel level;

  Color _color(BuildContext context) {
    switch (level) {
      case SafetyLevel.safe:
        return context.colors.success;
      case SafetyLevel.inspectFirst:
        return context.colors.warning;
      case SafetyLevel.neverDelete:
        return context.colors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        level.label,
        style: MacosTheme.of(context)
            .typography
            .caption1
            .copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Monospace command chip with copy-to-clipboard and run buttons.
class CommandRow extends StatefulWidget {
  const CommandRow({super.key, required this.command, this.onExecuted});

  final GuideCommand command;

  /// Called after the command has been executed (e.g. to refresh the
  /// storage readout).
  final VoidCallback? onExecuted;

  @override
  State<CommandRow> createState() => _CommandRowState();
}

class _CommandRowState extends State<CommandRow> {
  bool _copied = false;
  bool _running = false;

  CommandExplanation get _explanation =>
      explainCommand(widget.command.command);

  /// Anything that deletes data needs a confirmation before running.
  bool get _needsConfirm => _explanation.risk != CommandRisk.readOnly;

  bool get _destructive => _explanation.risk == CommandRisk.destructive;

  Color _riskColor(BuildContext context, CommandRisk risk) {
    switch (risk) {
      case CommandRisk.readOnly:
        return context.colors.success;
      case CommandRisk.cleansRebuildable:
        return context.colors.warning;
      case CommandRisk.destructive:
        return context.colors.danger;
    }
  }

  Future<void> _showInfo() async {
    final explanation = _explanation;
    await showMacosSheet(
      context: context,
      builder: (sheetContext) {
        final colors = sheetContext.colors;
        final typography = MacosTheme.of(sheetContext).typography;
        final riskColor = _riskColor(sheetContext, explanation.risk);

        return MacosSheet(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 520,
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.8,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'About this command',
                    style:
                        typography.title3.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.chipBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.separator),
                    ),
                    child: Text(
                      widget.command.command,
                      style:
                          const TextStyle(fontFamily: 'Menlo', fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: riskColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        MacosIcon(
                          explanation.risk == CommandRisk.readOnly
                              ? CupertinoIcons.eye
                              : explanation.risk ==
                                      CommandRisk.cleansRebuildable
                                  ? CupertinoIcons.refresh_circled
                                  : CupertinoIcons.exclamationmark_triangle,
                          size: 14,
                          color: riskColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            explanation.risk.label,
                            style: typography.caption1.copyWith(
                              color: riskColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(explanation.summary, style: typography.body),
                          if (widget.command.caption != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              widget.command.caption!,
                              style: typography.body
                                  .copyWith(color: colors.secondaryLabel),
                            ),
                          ],
                          if (explanation.details.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            for (final detail in explanation.details)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('•  ',
                                        style: typography.caption1.copyWith(
                                            color: colors.secondaryLabel)),
                                    Expanded(
                                      child: Text(
                                        detail,
                                        style: typography.caption1.copyWith(
                                            color: colors.secondaryLabel),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      PushButton(
                        controlSize: ControlSize.large,
                        secondary: true,
                        onPressed: () => Navigator.of(sheetContext).pop(),
                        child: const Text('Close'),
                      ),
                      const SizedBox(width: 8),
                      PushButton(
                        controlSize: ControlSize.large,
                        color: _destructive ? colors.danger : null,
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                          _run();
                        },
                        child: const Text('Run Command'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.command.command));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  Future<void> _run() async {
    if (_running) return;

    if (_needsConfirm) {
      final confirmed = await showMacosAlertDialog<bool>(
        context: context,
        builder: (dialogContext) => MacosAlertDialog(
          appIcon:
              Image.asset('assets/images/icon.png', width: 56, height: 56),
          title: Text(_destructive
              ? 'Run destructive command?'
              : 'Run cleanup command?'),
          message: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _destructive
                    ? 'This command deletes data and cannot be undone:'
                    : 'This command deletes caches/build artifacts (they are '
                        'recreated automatically):',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                widget.command.command,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Menlo', fontSize: 12),
              ),
            ],
          ),
          primaryButton: PushButton(
            controlSize: ControlSize.large,
            color: _destructive ? dialogContext.colors.danger : null,
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Run'),
          ),
          secondaryButton: PushButton(
            controlSize: ControlSize.large,
            secondary: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    setState(() => _running = true);
    final result = await ShellCommandService.run(widget.command.command);
    if (!mounted) return;
    setState(() => _running = false);
    widget.onExecuted?.call();
    await showCommandResultSheet(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.chipBackground,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.separator),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.command.command,
                    style: const TextStyle(fontFamily: 'Menlo', fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                MacosIconButton(
                  icon: MacosIcon(
                    CupertinoIcons.info_circle,
                    size: 15,
                    color: colors.secondaryLabel,
                  ),
                  padding: const EdgeInsets.all(2),
                  onPressed: _showInfo,
                ),
                const SizedBox(width: 2),
                MacosIconButton(
                  icon: MacosIcon(
                    _copied
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.doc_on_doc,
                    size: 15,
                    color: _copied ? colors.success : null,
                  ),
                  padding: const EdgeInsets.all(2),
                  onPressed: _copy,
                ),
                const SizedBox(width: 2),
                if (_running)
                  const Padding(
                    padding: EdgeInsets.all(2),
                    child: ProgressCircle(value: null, radius: 7),
                  )
                else
                  MacosIconButton(
                    icon: MacosIcon(
                      CupertinoIcons.play_circle,
                      size: 15,
                      color: _destructive ? colors.danger : colors.success,
                    ),
                    padding: const EdgeInsets.all(2),
                    onPressed: _run,
                  ),
              ],
            ),
          ),
          if (widget.command.caption != null)
            Padding(
              padding: const EdgeInsets.only(top: 2, left: 2),
              child: Text(
                widget.command.caption!,
                style: MacosTheme.of(context)
                    .typography
                    .caption1
                    .copyWith(color: colors.secondaryLabel),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shows the output of an executed guide command in a sheet.
Future<void> showCommandResultSheet(
  BuildContext context,
  ShellCommandResult result,
) {
  return showMacosSheet(
    context: context,
    builder: (sheetContext) {
      final colors = sheetContext.colors;
      final typography = MacosTheme.of(sheetContext).typography;
      final output = [
        if (result.stdout.trim().isNotEmpty) result.stdout.trim(),
        if (result.stderr.trim().isNotEmpty) result.stderr.trim(),
      ].join('\n');

      return MacosSheet(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 560,
            maxHeight: MediaQuery.of(sheetContext).size.height * 0.8,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    MacosIcon(
                      result.succeeded
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons.xmark_circle_fill,
                      size: 18,
                      color:
                          result.succeeded ? colors.success : colors.danger,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        result.succeeded
                            ? 'Command finished'
                            : 'Command failed (exit ${result.exitCode})',
                        style: typography.title3
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  result.command,
                  style: const TextStyle(fontFamily: 'Menlo', fontSize: 12),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.chipBackground,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: colors.separator),
                    ),
                    child: SingleChildScrollView(
                      child: Text(
                        output.isEmpty ? '(no output)' : output,
                        style: const TextStyle(
                            fontFamily: 'Menlo', fontSize: 11.5),
                      ),
                    ),
                  ),
                ),
                if (result.looksPermissionDenied) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: colors.warning.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: colors.warning.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'macOS blocked access to some paths (app sandbox). '
                      'Grant folder access from the Home tab, or copy the '
                      'command and run it in Terminal for full access.',
                      style: typography.caption1,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PushButton(
                      controlSize: ControlSize.large,
                      secondary: true,
                      onPressed: () => Clipboard.setData(
                        ClipboardData(text: output),
                      ),
                      child: const Text('Copy Output'),
                    ),
                    const SizedBox(width: 8),
                    PushButton(
                      controlSize: ControlSize.large,
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

/// Collapsible card for one [GuideItem].
class GuideItemTile extends StatefulWidget {
  const GuideItemTile({super.key, required this.item, this.onCommandExecuted});

  final GuideItem item;
  final VoidCallback? onCommandExecuted;

  @override
  State<GuideItemTile> createState() => _GuideItemTileState();
}

class _GuideItemTileState extends State<GuideItemTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = MacosTheme.of(context).typography;
    final item = widget.item;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _expanded = !_expanded),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 150),
                    child: MacosIcon(
                      CupertinoIcons.chevron_right,
                      size: 12,
                      color: colors.secondaryLabel,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item.title,
                      style: typography.body
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  SafetyBadge(level: item.safety),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 150),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(32, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.purpose,
                    style: typography.body
                        .copyWith(color: colors.secondaryLabel),
                  ),
                  if (item.inspectCommands.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text('Inspect',
                        style: typography.caption1.copyWith(
                            fontWeight: FontWeight.w700,
                            color: colors.secondaryLabel)),
                    const SizedBox(height: 4),
                    for (final cmd in item.inspectCommands)
                      CommandRow(
                        command: cmd,
                        onExecuted: widget.onCommandExecuted,
                      ),
                  ],
                  if (item.cleanCommands.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('Clean',
                        style: typography.caption1.copyWith(
                            fontWeight: FontWeight.w700,
                            color: item.safety == SafetyLevel.safe
                                ? colors.success
                                : colors.warning)),
                    const SizedBox(height: 4),
                    for (final cmd in item.cleanCommands)
                      CommandRow(
                        command: cmd,
                        onExecuted: widget.onCommandExecuted,
                      ),
                  ],
                  if (item.notes.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    for (final note in item.notes)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('•  ',
                                style: typography.caption1
                                    .copyWith(color: colors.secondaryLabel)),
                            Expanded(
                              child: Text(
                                note,
                                style: typography.caption1
                                    .copyWith(color: colors.secondaryLabel),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
