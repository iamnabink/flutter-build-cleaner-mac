import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
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

    return SizedBox(
      width: double.infinity,
      child: PushButton(
        controlSize: ControlSize.large,
        onPressed: isDisabled ? null : onPressed,
        child: isPurchasing
            ? const ProgressCircle(value: null, radius: 8)
            : Text(
                selectedPackage != null
                    ? 'Purchase ${selectedPackage!.storeProduct.priceString}'
                    : 'Select a package',
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
    return PushButton(
      controlSize: ControlSize.large,
      secondary: true,
      onPressed: (isPurchasing || isRestoring) ? null : onPressed,
      child: isRestoring
          ? const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProgressCircle(value: null, radius: 8),
                SizedBox(width: 8),
                Text('Restoring...'),
              ],
            )
          : const Text('Restore Purchases'),
    );
  }
}
