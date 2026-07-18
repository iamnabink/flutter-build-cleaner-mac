import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';

class PaywallHeader extends StatelessWidget {
  const PaywallHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = MacosTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colors.separator,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: context.colors.accent,
              shape: BoxShape.circle,
            ),
            child: MacosIcon(
              CupertinoIcons.heart_fill,
              size: 32,
              color: context.colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Support Broomie',
            style: typography.title1,
          ),
          const SizedBox(height: 8),
          Text(
            'Support independent development and unlock lifetime access',
            style: typography.body.copyWith(
              color: context.colors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
