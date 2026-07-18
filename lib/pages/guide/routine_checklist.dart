import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/data/manual_guide_data.dart';
import 'package:flutter_cleaner/pages/guide/guide_widgets.dart';
import 'package:flutter_cleaner/models/guide_models.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:macos_ui/macos_ui.dart';

/// Checkable "every 3–6 months" maintenance routine with persisted state.
class RoutineChecklist extends StatelessWidget {
  const RoutineChecklist({
    super.key,
    required this.checkedIds,
    required this.lastReset,
    required this.onToggle,
  });

  final Set<String> checkedIds;
  final DateTime? lastReset;
  final void Function(RoutineStep step, bool checked) onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = MacosTheme.of(context).typography;
    final steps = ManualGuideData.routine;
    final done = steps.where((s) => checkedIds.contains(s.id)).length;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: colors.separator),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Maintenance Routine (every 3–6 months)',
                  style:
                      typography.title3.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                '$done of ${steps.length} done',
                style: typography.caption1.copyWith(
                  color: done == steps.length
                      ? colors.success
                      : colors.secondaryLabel,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (lastReset != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Last reset: ${lastReset!.year}-${lastReset!.month.toString().padLeft(2, '0')}-${lastReset!.day.toString().padLeft(2, '0')}',
                style: typography.caption1
                    .copyWith(color: colors.tertiaryLabel),
              ),
            ),
          const SizedBox(height: 8),
          ProgressBar(
            value: steps.isEmpty ? 0 : (done / steps.length * 100),
          ),
          const SizedBox(height: 10),
          for (final step in steps) _RoutineRow(
            step: step,
            checked: checkedIds.contains(step.id),
            onToggle: onToggle,
          ),
        ],
      ),
    );
  }
}

class _RoutineRow extends StatelessWidget {
  const _RoutineRow({
    required this.step,
    required this.checked,
    required this.onToggle,
  });

  final RoutineStep step;
  final bool checked;
  final void Function(RoutineStep step, bool checked) onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = MacosTheme.of(context).typography;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              MacosCheckbox(
                value: checked,
                onChanged: (value) => onToggle(step, value),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onToggle(step, !checked),
                  child: Text(
                    step.title,
                    style: typography.body.copyWith(
                      color: checked ? colors.secondaryLabel : colors.label,
                      decoration:
                          checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (step.command != null)
            Padding(
              padding: const EdgeInsets.only(left: 24, top: 4),
              child: CommandRow(command: GuideCommand(step.command!)),
            ),
        ],
      ),
    );
  }
}
