import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.systemBlue.withOpacity(0.1)
              : CupertinoColors.systemGrey6,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? CupertinoColors.systemBlue
                : CupertinoColors.systemGrey4,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.systemGrey4,
              ),
              child: isSelected
                  ? const Icon(
                      CupertinoIcons.checkmark,
                      size: 16,
                      color: CupertinoColors.white,
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
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (package.storeProduct.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      package.storeProduct.description,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: CupertinoColors.secondaryLabel,
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
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? CupertinoColors.systemBlue
                    : CupertinoColors.label,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

