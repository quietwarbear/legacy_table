import 'dart:io';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/app_config.dart';
import 'analytics_service.dart';

// Local instance rather than the main.dart singleton to avoid a
// service→main circular import; the plugin is a stateless method-channel
// wrapper, so instances are interchangeable.
final _fbEvents = FacebookAppEvents();

class SubscriptionService {
  // RevenueCat API keys — one per platform
  static const String _appleApiKey = 'appl_ESkZxQXdLyJjZGPyXwhMtegGhoC';
  static const String _androidApiKey = 'goog_ZxxXVaTzAedcvvJOEUHtjYuUyVE';

  // Entitlement identifiers (must match RevenueCat dashboard)
  static const String entitlementHeritage = 'heritage_access';
  static const String entitlementLegacy = 'legacy_access';

  // Offering identifiers
  static const String offeringHeritage = 'heritage_keeper';
  static const String offeringLegacy = 'legacy_collection';

  static bool _isConfigured = false;

  static bool get isConfigured => _isConfigured;

  /// Initialize RevenueCat — call once from main() before runApp
  static Future<void> initialize() async {
    if (_isConfigured) {
      return;
    }

    await Purchases.setLogLevel(
      AppConfig.isProduction ? LogLevel.error : LogLevel.debug,
    );

    final PurchasesConfiguration config;
    if (Platform.isIOS) {
      config = PurchasesConfiguration(_appleApiKey);
    } else {
      config = PurchasesConfiguration(_androidApiKey);
    }

    await Purchases.configure(config);
    _isConfigured = true;
  }

  /// Identify the logged-in user with RevenueCat
  static Future<void> identify(String userId) async {
    if (!_isConfigured) return;
    await Purchases.logIn(userId);
  }

  /// Reset (logout) — call on app logout
  static Future<void> reset() async {
    if (!_isConfigured) return;
    await Purchases.logOut();
  }

  /// Fetch all offerings from RevenueCat
  static Future<Offerings> getOfferings() async {
    return await Purchases.getOfferings();
  }

  /// Check whether the user has a specific entitlement
  static Future<bool> hasEntitlement(String entitlementId) async {
    final info = await Purchases.getCustomerInfo();
    return info.entitlements.active.containsKey(entitlementId);
  }

  /// Returns the active entitlement identifier, or null if no subscription
  static Future<String?> getActiveEntitlement() async {
    final info = await Purchases.getCustomerInfo();
    if (info.entitlements.active.containsKey(entitlementLegacy)) {
      return entitlementLegacy;
    }
    if (info.entitlements.active.containsKey(entitlementHeritage)) {
      return entitlementHeritage;
    }
    return null;
  }

  /// Purchase a specific package
  static Future<CustomerInfo> purchasePackage(Package package) async {
    // ignore: deprecated_member_use
    final result = await Purchases.purchasePackage(package);

    // Revenue events: PostHog for the funnel, Meta for ad attribution.
    // Both are best-effort — a logging failure must never look like a
    // failed purchase.
    try {
      final product = package.storeProduct;
      await analytics.capture('subscription_purchased', {
        'product_id': product.identifier,
        'price': product.price,
        'currency': product.currencyCode,
      });
      await _fbEvents.logPurchase(
        amount: product.price,
        currency: product.currencyCode,
        parameters: {'product_id': product.identifier},
      );
    } catch (e) {
      debugPrint('[Subscription] purchase event logging failed: $e');
    }

    return result.customerInfo;
  }

  /// Restore previous purchases
  static Future<CustomerInfo> restorePurchases() async {
    return await Purchases.restorePurchases();
  }

  /// Get CustomerInfo (subscription status)
  static Future<CustomerInfo> getCustomerInfo() async {
    return await Purchases.getCustomerInfo();
  }
}
