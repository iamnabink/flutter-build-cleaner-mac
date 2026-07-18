import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cleaner/config/env.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatService {
  static bool _configured = false;

  /// Whether Purchases was configured with an API key. When false (no
  /// REVENUECAT_API_KEY in .env), all Pro/paywall UI must stay hidden.
  static bool get isConfigured => _configured;

  static Future<void> initialize() async {
    final apiKey = EnvConfig.revenueCatApiKey;
    if (apiKey == null) {
      debugPrint(
        'RevenueCat: no REVENUECAT_API_KEY in .env — Pro features disabled.',
      );
      return;
    }
    try {
      await Purchases.configure(PurchasesConfiguration(apiKey));
      _configured = true;
    } catch (e) {
      debugPrint('RevenueCat: configure failed — Pro features disabled. $e');
    }
  }

  static void _ensureConfigured() {
    if (!_configured) {
      throw StateError('RevenueCat is not configured (missing API key)');
    }
  }

  static Future<bool> hasProAccess() async {
    if (!_configured) return false;
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      return customerInfo.entitlements.active.containsKey('lifetime_supporter');
    } catch (e) {
      // If there's an error, assume no pro access
      return false;
    }
  }

  static Future<CustomerInfo> getCustomerInfo() async {
    _ensureConfigured();
    return await Purchases.getCustomerInfo();
  }

  static Future<Offerings> getOfferings() async {
    _ensureConfigured();
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
    _ensureConfigured();
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
    _ensureConfigured();
    try {
      final customerInfo = await Purchases.restorePurchases();
      return customerInfo;
    } catch (e) {
      throw Exception('Failed to restore purchases: $e');
    }
  }
}
