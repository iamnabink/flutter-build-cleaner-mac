import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

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
            const Icon(
              CupertinoIcons.exclamationmark_triangle,
              size: 48,
              color: CupertinoColors.systemOrange,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? 'Failed to load offerings',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: CupertinoColors.secondaryLabel,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CupertinoButton.filled(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

