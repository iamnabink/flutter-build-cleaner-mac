import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
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
      return _buildEmptyState();
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
          
          if (errorMessage != null) _buildErrorMessage(),
          
          PaywallButtons(
            selectedPackage: selectedPackage,
            isPurchasing: isPurchasing,
            isRestoring: isRestoring,
            onPurchase: onPurchase,
            onRestore: onRestore,
          ),
          const SizedBox(height: 20),
          
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.info,
              size: 48,
              color: CupertinoColors.systemBlue,
            ),
            const SizedBox(height: 16),
            const Text(
              'No packages available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your RevenueCat configuration',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.secondaryLabel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: CupertinoColors.systemRed.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            CupertinoIcons.exclamationmark_circle,
            color: CupertinoColors.systemRed,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              errorMessage!,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Your purchase helps support the development of Broomie. Thank you!',
        style: TextStyle(
          fontSize: 11,
          color: CupertinoColors.secondaryLabel,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

