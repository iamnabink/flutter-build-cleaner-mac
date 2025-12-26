import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseUtils {
  /// Parses the purchase date from an entitlement
  /// Returns null if the date cannot be parsed
  static DateTime? parsePurchaseDate(EntitlementInfo? entitlement) {
    if (entitlement == null) return null;
    
    try {
      // latestPurchaseDate is a String in RevenueCat SDK, need to parse it
      final dateStr = entitlement.latestPurchaseDate;
      if (dateStr.isEmpty) return null;
      
      // Try parsing as ISO 8601 format
      final parsed = DateTime.tryParse(dateStr);
      return parsed;
    } catch (e) {
      return null;
    }
  }

  /// Formats a DateTime to a readable date string (DD/MM/YYYY)
  static String formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  /// Formats a DateTime to a readable time string (HH:MM)
  static String formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

