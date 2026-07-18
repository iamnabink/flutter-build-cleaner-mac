import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';

class PaywallErrorView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback onRetry;

  const PaywallErrorView({
    Key? key,
    this.errorMessage,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MacosIcon(
              CupertinoIcons.exclamationmark_triangle,
              size: 48,
              color: context.colors.warning,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Failed to load offerings',
              style: MacosTheme.of(context).typography.body.copyWith(
                    color: context.colors.secondaryLabel,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PushButton(
              controlSize: ControlSize.large,
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
