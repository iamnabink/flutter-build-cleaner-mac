import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
import 'package:macos_ui/macos_ui.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_cleaner/theme/app_colors.dart';

class PaywallPackageList extends StatelessWidget {
  final List<Package> packages;
  final Package? selectedPackage;
  final ValueChanged<Package> onPackageSelected;

  const PaywallPackageList({
    Key? key,
    required this.packages,
    this.selectedPackage,
    required this.onPackageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: packages.map((package) {
        final isSelected = selectedPackage?.identifier == package.identifier;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _PackageItem(
            package: package,
            isSelected: isSelected,
            onTap: () => onPackageSelected(package),
          ),
        );
      }).toList(),
    );
  }
}

class _PackageItem extends StatelessWidget {
  final Package package;
  final bool isSelected;
  final VoidCallback onTap;

  const _PackageItem({
    Key? key,
    required this.package,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typography = MacosTheme.of(context).typography;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colors.accent.withValues(alpha: 0.08)
              : context.colors.cardBackground,
          borderRadius: BorderRadius.circular(10),
          border: isSelected
              ? Border.all(color: context.colors.accent, width: 2)
              : Border.all(color: context.colors.separator),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? context.colors.accent
                    : context.colors.border,
              ),
              child: isSelected
                  ? MacosIcon(
                      CupertinoIcons.checkmark,
                      size: 16,
                      color: context.colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package.storeProduct.title,
                    style: typography.body.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (package.storeProduct.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      package.storeProduct.description,
                      style: typography.caption1.copyWith(
                        color: context.colors.secondaryLabel,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              package.storeProduct.priceString,
              style: typography.body.copyWith(
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? context.colors.accent
                    : context.colors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
