import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PaywallButtons extends StatelessWidget {
  final Package? selectedPackage;
  final bool isPurchasing;
  final bool isRestoring;
  final VoidCallback onPurchase;
  final VoidCallback onRestore;

  const PaywallButtons({
    Key? key,
    this.selectedPackage,
    required this.isPurchasing,
    required this.isRestoring,
    required this.onPurchase,
    required this.onRestore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PurchaseButton(
          selectedPackage: selectedPackage,
          isPurchasing: isPurchasing,
          isRestoring: isRestoring,
          onPressed: onPurchase,
        ),
        const SizedBox(height: 12),
        _RestoreButton(
          isPurchasing: isPurchasing,
          isRestoring: isRestoring,
          onPressed: onRestore,
        ),
      ],
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  final Package? selectedPackage;
  final bool isPurchasing;
  final bool isRestoring;
  final VoidCallback onPressed;

  const _PurchaseButton({
    Key? key,
    this.selectedPackage,
    required this.isPurchasing,
    required this.isRestoring,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDisabled = isPurchasing || isRestoring || selectedPackage == null;
    
    return Container(
      height: 50,
      decoration: BoxDecoration(
        gradient: isDisabled
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.systemBlue,
                  CupertinoColors.systemPurple,
                ],
              ),
        borderRadius: BorderRadius.circular(12),
        color: isDisabled ? CupertinoColors.systemGrey4 : null,
        boxShadow: isDisabled
            ? null
            : [
                BoxShadow(
                  color: CupertinoColors.systemBlue.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: isDisabled ? null : onPressed,
        child: isPurchasing
            ? const CupertinoActivityIndicator(color: CupertinoColors.white)
            : Text(
                selectedPackage != null
                    ? 'Purchase ${selectedPackage!.storeProduct.priceString}'
                    : 'Select a package',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.white,
                ),
              ),
      ),
    );
  }
}

class _RestoreButton extends StatelessWidget {
  final bool isPurchasing;
  final bool isRestoring;
  final VoidCallback onPressed;

  const _RestoreButton({
    Key? key,
    required this.isPurchasing,
    required this.isRestoring,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      onPressed: (isPurchasing || isRestoring) ? null : onPressed,
      child: isRestoring
          ? const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(radius: 8),
                SizedBox(width: 8),
                Text('Restoring...'),
              ],
            )
          : const Text(
              'Restore Purchases',
              style: TextStyle(
                fontSize: 14,
                color: CupertinoColors.systemBlue,
              ),
            ),
    );
  }
}

