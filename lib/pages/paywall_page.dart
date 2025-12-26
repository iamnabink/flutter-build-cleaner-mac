import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter_cleaner/services/revenue_cat_service.dart';
import 'package:flutter_cleaner/utils/purchase_utils.dart';
import 'package:flutter_cleaner/widgets/paywall/paywall_success_view.dart';
import 'package:flutter_cleaner/widgets/paywall/paywall_error_view.dart';
import 'package:flutter_cleaner/widgets/paywall/paywall_content.dart';

class PaywallPage extends StatefulWidget {
  const PaywallPage({Key? key}) : super(key: key);

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  Offerings? _offerings;
  bool _isLoading = true;
  bool _isPurchasing = false;
  bool _isRestoring = false;
  String? _errorMessage;
  Package? _selectedPackage;
  bool _showSuccess = false;
  DateTime? _subscriptionDate;

  @override
  void initState() {
    super.initState();
    _checkSubscriptionStatus();
  }

  Future<void> _checkSubscriptionStatus() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // First check if user is already subscribed
      final hasPro = await RevenueCatService.hasProAccess();
      
      if (hasPro) {
        // User is already subscribed, get customer info for date
        try {
          final customerInfo = await RevenueCatService.getCustomerInfo();
          final entitlement = customerInfo.entitlements.active['lifetime_supporter'];
          final purchaseDate = PurchaseUtils.parsePurchaseDate(entitlement);
          
          if (mounted) {
            setState(() {
              _showSuccess = true;
              _subscriptionDate = purchaseDate ?? DateTime.now();
              _isLoading = false;
            });
            return;
          }
        } catch (e) {
          // If we can't get customer info, just use current date
          if (mounted) {
            setState(() {
              _showSuccess = true;
              _subscriptionDate = DateTime.now();
              _isLoading = false;
            });
            return;
          }
        }
      }
      
      // Not subscribed, fetch offerings for paywall
      await _fetchOfferings();
    } catch (e) {
      // If check fails, still try to show paywall
      await _fetchOfferings();
    }
  }

  Future<void> _fetchOfferings() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final offerings = await RevenueCatService.getOfferings();
      setState(() {
        _offerings = offerings;
        _isLoading = false;
        // Select the first available package by default
        if (offerings.current != null && offerings.current!.availablePackages.isNotEmpty) {
          _selectedPackage = offerings.current!.availablePackages.first;
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load offerings: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _handlePurchase() async {
    if (_selectedPackage == null) {
      setState(() {
        _errorMessage = 'Please select a package';
      });
      return;
    }

    setState(() {
      _isPurchasing = true;
      _errorMessage = null;
    });

    try {
      final customerInfo = await RevenueCatService.purchasePackage(_selectedPackage!);
      
      // Check if purchase was successful
      final hasPro = customerInfo.entitlements.active.containsKey('lifetime_supporter');
      
      if (hasPro && mounted) {
        // Get actual purchase date from entitlement
        final entitlement = customerInfo.entitlements.active['lifetime_supporter'];
        final purchaseDate = PurchaseUtils.parsePurchaseDate(entitlement);
        
        // Show success view
        setState(() {
          _isPurchasing = false;
          _showSuccess = true;
          _subscriptionDate = purchaseDate ?? DateTime.now();
        });
      } else {
        setState(() {
          _errorMessage = 'Purchase completed but entitlement not active';
          _isPurchasing = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isPurchasing = false;
      });
    }
  }

  Future<void> _handleRestore() async {
    setState(() {
      _isRestoring = true;
      _errorMessage = null;
    });

    try {
      final customerInfo = await RevenueCatService.restorePurchases();
      final hasPro = customerInfo.entitlements.active.containsKey('lifetime_supporter');
      
      if (hasPro && mounted) {
        // Get actual purchase date from entitlement
        final entitlement = customerInfo.entitlements.active['lifetime_supporter'];
        final purchaseDate = PurchaseUtils.parsePurchaseDate(entitlement);
        
        // Show success view
        setState(() {
          _isRestoring = false;
          _showSuccess = true;
          _subscriptionDate = purchaseDate ?? DateTime.now();
        });
      } else {
        setState(() {
          _errorMessage = 'No active purchases found to restore';
          _isRestoring = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isRestoring = false;
      });
    }
  }

  void _handlePackageSelected(Package package) {
    setState(() {
      _selectedPackage = package;
      _errorMessage = null;
    });
  }

  void _handleSuccessClose() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Support Broomie'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          minSize: 0,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(CupertinoIcons.xmark, size: 20),
        ),
      ),
      child: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    if (_showSuccess && _subscriptionDate != null) {
      return PaywallSuccessView(
        subscriptionDate: _subscriptionDate!,
        onContinue: _handleSuccessClose,
      );
    }

    if (_isLoading) {
      return const Center(
        child: CupertinoActivityIndicator(radius: 15),
      );
    }

    if (_errorMessage != null && _offerings == null) {
      return PaywallErrorView(
        errorMessage: _errorMessage,
        onRetry: _fetchOfferings,
      );
    }

    return PaywallContent(
      offering: _offerings?.current,
      selectedPackage: _selectedPackage,
      errorMessage: _errorMessage,
      isPurchasing: _isPurchasing,
      isRestoring: _isRestoring,
      onPackageSelected: _handlePackageSelected,
      onPurchase: _handlePurchase,
      onRestore: _handleRestore,
    );
  }
}
