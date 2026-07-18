import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/models/guide_models.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
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

/// Monospace command chip with a copy-to-clipboard button.
class CommandRow extends StatefulWidget {
  const CommandRow({super.key, required this.command});

  final GuideCommand command;

  @override
  State<CommandRow> createState() => _CommandRowState();
}

class _CommandRowState extends State<CommandRow> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.command.command));
    if (!mounted) return;
    setState(() => _copied = true);
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _copied = false);
    });
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
                    _copied
                        ? CupertinoIcons.checkmark_circle_fill
                        : CupertinoIcons.doc_on_doc,
                    size: 15,
                    color: _copied ? colors.success : null,
                  ),
                  padding: const EdgeInsets.all(2),
                  onPressed: _copy,
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

/// Collapsible card for one [GuideItem].
class GuideItemTile extends StatefulWidget {
  const GuideItemTile({super.key, required this.item});

  final GuideItem item;

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
                      CommandRow(command: cmd),
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
                      CommandRow(command: cmd),
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
