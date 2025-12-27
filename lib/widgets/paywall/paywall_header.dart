import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class PaywallHeader extends StatelessWidget {
  const PaywallHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBlue.withOpacity(0.1),
            CupertinoColors.systemPurple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemGrey4.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  CupertinoColors.systemBlue,
                  CupertinoColors.systemPurple,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              CupertinoIcons.heart_fill,
              size: 32,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Support Broomie',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Support independent development and unlock lifetime access',
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: CupertinoColors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

