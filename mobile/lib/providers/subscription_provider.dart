import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../services/subscription_service.dart';

enum SubscriptionTier { none, heritage, legacy }

class SubscriptionProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _isRestoring = false;
  String? _errorMessage;
  SubscriptionTier _tier = SubscriptionTier.none;
  Offerings? _offerings;

  bool get isLoading => _isLoading;
  bool get isRestoring => _isRestoring;
  String? get errorMessage => _errorMessage;
  SubscriptionTier get tier => _tier;
  Offerings? get offerings => _offerings;

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
    } catch (e) {
      _errorMessage = 'Unable to load subscription info. Please try again.';
      debugPrint('SubscriptionProvider.loadSubscriptionStatus error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
        _errorMessage = _friendlyError(errorCode);
      }
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

  String _friendlyError(PurchasesErrorCode? code) {
    switch (code) {
      case PurchasesErrorCode.purchaseNotAllowedError:
        return 'Purchases are not allowed on this device.';
      case PurchasesErrorCode.networkError:
        return 'Network error. Please check your connection.';
      case PurchasesErrorCode.productAlreadyPurchasedError:
        return 'You already have this subscription.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}
