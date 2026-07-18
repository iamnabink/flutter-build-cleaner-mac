import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:flutter_cleaner/utils/purchase_utils.dart';

class PaywallSuccessView extends StatelessWidget {
  final DateTime subscriptionDate;
  final VoidCallback onContinue;

  const PaywallSuccessView({
    Key? key,
    required this.subscriptionDate,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate = PurchaseUtils.formatDate(subscriptionDate);
    final formattedTime = PurchaseUtils.formatTime(subscriptionDate);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Big checkmark
            _buildCheckmark(context),
            const SizedBox(height: 24),

            // Thank you message
            _buildThankYouMessage(context),
            const SizedBox(height: 12),

            // Subtitle
            _buildSubtitle(context),
            const SizedBox(height: 32),

            // Date and time container
            _buildDateContainer(context, formattedDate, formattedTime),
            const SizedBox(height: 32),

            // Continue button
            _buildContinueButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckmark(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: context.colors.success,
        shape: BoxShape.circle,
      ),
      child: MacosIcon(
        CupertinoIcons.checkmark,
        size: 45,
        color: context.colors.white,
      ),
    );
  }

  Widget _buildThankYouMessage(BuildContext context) {
    return Text(
      'Thank you for your support!',
      style: MacosTheme.of(context).typography.title1.copyWith(
            color: context.colors.label,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return Text(
      'You now have lifetime access to Broomie',
      style: MacosTheme.of(context).typography.body.copyWith(
            color: context.colors.secondaryLabel,
          ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDateContainer(BuildContext context, String formattedDate, String formattedTime) {
    final typography = MacosTheme.of(context).typography;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: context.colors.cardBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: context.colors.separator,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MacosIcon(
                CupertinoIcons.calendar,
                size: 18,
                color: context.colors.accent,
              ),
              const SizedBox(width: 8),
              Text(
                'Subscription Date',
                style: typography.caption1.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.colors.secondaryLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            formattedDate,
            style: typography.body.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.label,
            ),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   formattedTime,
          //   style: typography.body.copyWith(
          //     color: context.colors.secondaryLabel,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: PushButton(
        controlSize: ControlSize.large,
        onPressed: onContinue,
        child: const Text('Continue'),
      ),
    );
  }
}
