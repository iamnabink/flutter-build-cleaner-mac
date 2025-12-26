import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cleaner/config/revenue_cat_config.dart';

class RevenueCatService {
  static Future<void> initialize() async {
    // API key from local config file (gitignored)
    await Purchases.configure(PurchasesConfiguration(RevenueCatConfig.apiKey));
  }

  static Future<bool> hasProAccess() async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('lifetime_supporter');
    } catch (e) {
      // If there's an error, assume no pro access
      return false;
    }
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }

  static Future<Offerings> getOfferings() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (offerings.current == null) {
        throw Exception('No current offering available');
      }
      return offerings;
    } catch (e) {
      rethrow;
    }
  }

  static Future<CustomerInfo> purchasePackage(Package package) async {
    try {
      // Purchases.purchase() returns PurchaseResult which contains CustomerInfo
      final purchaseResult = await Purchases.purchase(PurchaseParams.package(package));
      return purchaseResult.customerInfo;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
        throw Exception('Purchase cancelled');
      } else if (errorCode == PurchasesErrorCode.purchaseNotAllowedError) {
        throw Exception('Purchase not allowed');
      } else if (errorCode == PurchasesErrorCode.purchaseInvalidError) {
        throw Exception('Purchase invalid');
      } else {
        throw Exception('Purchase failed: ${e.message}');
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<CustomerInfo> restorePurchases() async {
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo;
    } catch (e) {
      throw Exception('Failed to restore purchases: $e');
    }
  }
}

