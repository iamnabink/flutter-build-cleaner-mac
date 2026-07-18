import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';
import 'package:flutter_cleaner/widgets/paywall/paywall_header.dart';
import 'package:flutter_cleaner/widgets/paywall/paywall_package_list.dart';
import 'package:flutter_cleaner/widgets/paywall/paywall_buttons.dart';

class PaywallContent extends StatelessWidget {
  final Offering? offering;
  final Package? selectedPackage;
  final String? errorMessage;
  final bool isPurchasing;
  final bool isRestoring;
  final ValueChanged<Package> onPackageSelected;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;

  const PaywallContent({
    Key? key,
    this.offering,
    this.selectedPackage,
    this.errorMessage,
    required this.isPurchasing,
    required this.isRestoring,
    required this.onPackageSelected,
    required this.onPurchase,
    required this.onRestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (offering == null || offering!.availablePackages.isEmpty) {
      return _buildEmptyState(context);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PaywallHeader(),
          const SizedBox(height: 32),

          PaywallPackageList(
            packages: offering!.availablePackages,
            selectedPackage: selectedPackage,
            onPackageSelected: onPackageSelected,
          ),
          const SizedBox(height: 24),

          if (errorMessage != null) _buildErrorMessage(context),

          PaywallButtons(
            selectedPackage: selectedPackage,
            isPurchasing: isPurchasing,
            isRestoring: isRestoring,
            onPurchase: onPurchase,
            onRestore: onRestore,
          ),
          const SizedBox(height: 20),

          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final typography = MacosTheme.of(context).typography;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MacosIcon(
              CupertinoIcons.info,
              size: 48,
              color: context.colors.accent,
            ),
            const SizedBox(height: 16),
            Text(
              'No packages available',
              style: typography.title3,
            ),
            const SizedBox(height: 8),
            Text(
              'Please check your RevenueCat configuration',
              style: typography.caption1.copyWith(
                color: context.colors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.colors.danger.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: context.colors.danger.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          MacosIcon(
            CupertinoIcons.exclamationmark_circle,
            color: context.colors.danger,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage!,
              style: MacosTheme.of(context).typography.caption1.copyWith(
                    color: context.colors.danger,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Your support directly helps fund development time, allowing me to add new features, fix bugs, and improve Broomie. Thank you for being part of this journey!',
        style: MacosTheme.of(context).typography.caption1.copyWith(
              color: context.colors.secondaryLabel,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
