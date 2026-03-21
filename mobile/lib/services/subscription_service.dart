import 'dart:io';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../config/app_config.dart';

class SubscriptionService {
  // RevenueCat API keys — one per platform
  static const String _appleApiKey = 'appl_ESkZxQXdLyJjZGPyXwhMtegGhoC';
  // Google key will be added after Play Store connection is set up in RevenueCat
  static const String _googleApiKey = 'goog_REPLACE_WITH_YOUR_GOOGLE_RC_KEY';

  // Entitlement identifiers (must match RevenueCat dashboard)
  static const String entitlementHeritage = 'heritage_access';
  static const String entitlementLegacy = 'legacy_access';

  // Offering identifiers
  static const String offeringHeritage = 'heritage_keeper';
  static const String offeringLegacy = 'legacy_collection';

  /// Initialize RevenueCat — call once from main() before runApp
  static Future<void> initialize() async {
    await Purchases.setLogLevel(
      AppConfig.isProduction ? LogLevel.error : LogLevel.debug,
    );

    final PurchasesConfiguration config;
    if (Platform.isIOS) {
      config = PurchasesConfiguration(_appleApiKey);
    } else {
      config = PurchasesConfiguration(_googleApiKey);
    }

    await Purchases.configure(config);
  }

  /// Identify the logged-in user with RevenueCat
  static Future<void> identify(String userId) async {
    await Purchases.logIn(userId);
  }

  /// Reset (logout) — call on app logout
  static Future<void> reset() async {
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
