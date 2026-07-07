import 'package:flutter/foundation.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../config/app_config.dart';

/// Product analytics wrapper around PostHog.
///
/// Entirely no-op unless a key is supplied at build time:
///   flutter build ipa --dart-define=POSTHOG_API_KEY=phc_xxx
/// so debug/dev builds and forks emit nothing.
///
/// Core funnel events (keep names stable — dashboards depend on them):
///   signup, login, family_created, family_joined, sample_family_created,
///   recipe_created, first_recipe_created, ai_scan_used, ai_voice_used,
///   ai_link_used, invite_shared, review_prompt_requested,
///   subscription_purchased
class AnalyticsService {
  AnalyticsService._();
  static final AnalyticsService instance = AnalyticsService._();

  bool get enabled => AppConfig.posthogApiKey.isNotEmpty;
  bool _initialized = false;

  Future<void> init() async {
    if (!enabled || _initialized) return;
    try {
      final config = PostHogConfig(AppConfig.posthogApiKey)
        ..host = AppConfig.posthogHost
        ..captureApplicationLifecycleEvents = true
        ..debug = kDebugMode;
      await Posthog().setup(config);
      _initialized = true;
    } catch (e) {
      debugPrint('[Analytics] init failed: $e');
    }
  }

  /// Tie events to the logged-in user (backend user id, never email).
  Future<void> identify(String userId) async {
    if (!_initialized) return;
    try {
      await Posthog().identify(userId: userId);
    } catch (e) {
      debugPrint('[Analytics] identify failed: $e');
    }
  }

  Future<void> capture(String event, [Map<String, Object>? properties]) async {
    if (!_initialized) return;
    try {
      await Posthog().capture(eventName: event, properties: properties ?? {});
    } catch (e) {
      debugPrint('[Analytics] capture($event) failed: $e');
    }
  }

  /// Clear identity on logout so the next signup isn't merged.
  Future<void> reset() async {
    if (!_initialized) return;
    try {
      await Posthog().reset();
    } catch (e) {
      debugPrint('[Analytics] reset failed: $e');
    }
  }
}

/// Convenience singleton accessor.
final analytics = AnalyticsService.instance;
