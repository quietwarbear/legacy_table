import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/subscription_service.dart';
import '../services/api_service.dart';

enum SubscriptionTier { none, heritage, legacy }

class SubscriptionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRestoring = false;
  String? _errorMessage;
  SubscriptionTier _tier = SubscriptionTier.none;
  Offerings? _offerings;
  int _creditsBalance = 0;
  int _monthlyAllowance = 3;

  bool get isLoading => _isLoading;
  bool get isRestoring => _isRestoring;
  String? get errorMessage => _errorMessage;
  SubscriptionTier get tier => _tier;
  Offerings? get offerings => _offerings;
  int get creditsBalance => _creditsBalance;
  int get monthlyAllowance => _monthlyAllowance;

  bool get hasAnySubscription => _tier != SubscriptionTier.none;
  bool get hasHeritage =>
      _tier == SubscriptionTier.heritage || _tier == SubscriptionTier.legacy;
  bool get hasLegacy => _tier == SubscriptionTier.legacy;

  /// Load current subscription status and offerings from RevenueCat
  Future<void> loadSubscriptionStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final activeEntitlement =
          await SubscriptionService.getActiveEntitlement();
      _tier = _entitlementToTier(activeEntitlement);

      _offerings = await SubscriptionService.getOfferings();

      // Also fetch credit balance from backend
      await loadCredits();
    } catch (e) {
      _errorMessage = 'Unable to load subscription info. Please try again.';
      debugPrint('SubscriptionProvider.loadSubscriptionStatus error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load AI credit balance from the backend
  Future<void> loadCredits() async {
    try {
      final response = await apiService.apiClient.get('/subscriptions/status');
      final data = response.data;
      _creditsBalance = data['credits_balance'] ?? 0;
      _monthlyAllowance = data['monthly_allowance'] ?? 3;

      // The backend tier is authoritative for entitlements RevenueCat can't
      // see: Stripe web subscriptions and redeemed Family Legacy gifts.
      // Treat it as a floor — never downgrade below what RevenueCat says.
      final serverTier = _serverTierFromString(data['subscription_tier']);
      if (serverTier.index > _tier.index) {
        _tier = serverTier;
      }
      notifyListeners();
    } catch (e) {
      debugPrint('SubscriptionProvider.loadCredits error: $e');
    }
  }

  /// Update credits after an AI action (called after scan/voice/link)
  void updateCredits(int remaining) {
    _creditsBalance = remaining;
    notifyListeners();
  }

  /// Purchase a package and refresh subscription status
  Future<bool> purchase(Package package) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final info = await SubscriptionService.purchasePackage(package);
      _updateTierFromCustomerInfo(info);
      return _tier != SubscriptionTier.none;
    } on PlatformException catch (e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        _errorMessage = _friendlyError(errorCode, e.message);
      }
      debugPrint(
        'SubscriptionProvider.purchase platform error: code=${e.code} purchasesCode=$errorCode message=${e.message} details=${e.details}',
      );
      return false;
    } catch (e) {
      _errorMessage = 'Purchase failed. Please try again.';
      debugPrint('SubscriptionProvider.purchase error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Restore previous purchases
  Future<bool> restore() async {
    _isRestoring = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final info = await SubscriptionService.restorePurchases();
      _updateTierFromCustomerInfo(info);
      return _tier != SubscriptionTier.none;
    } catch (e) {
      _errorMessage = 'Restore failed. Please try again.';
      debugPrint('SubscriptionProvider.restore error: $e');
      return false;
    } finally {
      _isRestoring = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  void _updateTierFromCustomerInfo(CustomerInfo info) {
    final active = info.entitlements.active;
    if (active.containsKey(SubscriptionService.entitlementLegacy)) {
      _tier = SubscriptionTier.legacy;
    } else if (active.containsKey(SubscriptionService.entitlementHeritage)) {
      _tier = SubscriptionTier.heritage;
    } else {
      _tier = SubscriptionTier.none;
    }
  }

  SubscriptionTier _serverTierFromString(dynamic tier) {
    switch (tier) {
      case 'legacy':
      case 'family_legacy': // gift redeemers get Legacy-level benefits
        return SubscriptionTier.legacy;
      case 'heritage':
        return SubscriptionTier.heritage;
      default:
        return SubscriptionTier.none;
    }
  }

  SubscriptionTier _entitlementToTier(String? entitlement) {
    switch (entitlement) {
      case SubscriptionService.entitlementLegacy:
        return SubscriptionTier.legacy;
      case SubscriptionService.entitlementHeritage:
        return SubscriptionTier.heritage;
      default:
        return SubscriptionTier.none;
    }
  }

  String _friendlyError(PurchasesErrorCode? code, [String? message]) {
    switch (code) {
      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Purchases are not allowed on this device.';
      case PurchasesErrorCode.networkError:
        return 'Network error. Please check your connection.';
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return 'You already have this subscription.';
      case PurchasesErrorCode.storeProblemError:
        return 'The App Store is having trouble completing this purchase right now.';
      case PurchasesErrorCode.purchaseInvalidError:
        return 'This product is not ready for purchase yet in App Store Connect.';
      case PurchasesErrorCode.configurationError:
        return 'Subscription configuration is incomplete. Please verify the RevenueCat offering and App Store product mapping.';
      case PurchasesErrorCode.invalidCredentialsError:
        return 'RevenueCat credentials are invalid for this app build.';
      default:
        if (message != null && message.isNotEmpty) {
          return message;
        }
        return 'Something went wrong. Please try again.';
    }
  }
}
