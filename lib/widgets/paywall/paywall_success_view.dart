import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
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
            _buildCheckmark(),
            const SizedBox(height: 24),
            
            // Thank you message
            _buildThankYouMessage(),
            const SizedBox(height: 12),
            
            // Subtitle
            _buildSubtitle(),
            const SizedBox(height: 32),
            
            // Date and time container
            _buildDateContainer(formattedDate, formattedTime),
            const SizedBox(height: 32),
            
            // Continue button
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckmark() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemGreen,
            CupertinoColors.systemGreen.darkColor,
          ],
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGreen.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Icon(
        CupertinoIcons.checkmark,
        size: 45,
        color: CupertinoColors.white,
      ),
    );
  }

  Widget _buildThankYouMessage() {
    return Text(
      'Thank you for your support!',
      style: GoogleFonts.montserrat(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: CupertinoColors.label,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'You now have lifetime access to Broomie',
      style: GoogleFonts.montserrat(
        fontSize: 12,
        color: CupertinoColors.secondaryLabel,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDateContainer(String formattedDate, String formattedTime) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: CupertinoColors.systemGrey4,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.calendar,
                size: 18,
                color: CupertinoColors.systemBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Subscription Date',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            formattedDate,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: CupertinoColors.label,
            ),
          ),
          // const SizedBox(height: 8),
          // Text(
          //   formattedTime,
          //   style: GoogleFonts.montserrat(
          //     fontSize: 16,
          //     color: CupertinoColors.secondaryLabel,
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            CupertinoColors.systemBlue,
            CupertinoColors.systemPurple,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemBlue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onContinue,
        child: Text(
          'Continue',
          style: GoogleFonts.montserrat(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.white,
          ),
        ),
      ),
    );
  }
}

