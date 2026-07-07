import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/api_config.dart';
import '../firebase_options.dart';
import '../views/voice_recipe_screen.dart';
import 'analytics_service.dart';
import 'api_service.dart';

/// Push notifications (FCM) — the retention channel.
///
/// Design:
/// - Initialized lazily from HomeScreen (post-login), never at cold boot,
///   so the permission prompt lands after the user has seen value.
/// - Tokens are registered with OUR backend (Mongo `push_tokens`); Firebase
///   is delivery only.
/// - Notification taps carry a `route` in the data payload; currently
///   `/voice-recipe` (the weekly prompt) is supported.
class PushService {
  PushService._();
  static final PushService instance = PushService._();

  /// Set once from main() so notification taps can navigate without this
  /// service importing main.dart (avoids an import cycle).
  static GlobalKey<NavigatorState>? navigatorKey;

  bool _initialized = false;

  /// Idempotent. Safe to call on every HomeScreen build.
  Future<void> ensureRegistered() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        await analytics.capture('push_permission_denied');
        return;
      }
      await analytics.capture('push_permission_granted');

      // iOS: make sure the APNs token exists before asking for the FCM one.
      if (Platform.isIOS) {
        await messaging.getAPNSToken();
      }

      final token = await messaging.getToken();
      if (token != null) {
        await _registerToken(token);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen(_registerToken);

      // Tap on a notification while the app was in background.
      FirebaseMessaging.onMessageOpenedApp.listen(_handleTap);
      // Tap that cold-started the app.
      final initial = await messaging.getInitialMessage();
      if (initial != null) _handleTap(initial);
    } catch (e) {
      // Push is an enhancement — never let it break the session.
      debugPrint('[Push] init failed: $e');
      _initialized = false;
    }
  }

  Future<void> _registerToken(String token) async {
    try {
      await apiService.apiClient.post(
        ApiConfig.pushRegister,
        data: {
          'token': token,
          'platform': Platform.isIOS ? 'ios' : 'android',
        },
      );
    } catch (e) {
      debugPrint('[Push] token registration failed: $e');
    }
  }

  void _handleTap(RemoteMessage message) {
    final route = message.data['route'];
    analytics.capture('push_opened', {'route': route ?? 'none'});
    if (route == '/voice-recipe') {
      navigatorKey?.currentState?.push(
        MaterialPageRoute(builder: (_) => const VoiceRecipeScreen()),
      );
    }
  }
}

final pushService = PushService.instance;
