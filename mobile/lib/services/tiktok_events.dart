import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../config/app_config.dart';

/// TikTok App Events — ad attribution for TikTok App Promotion campaigns.
///
/// Thin wrapper over a MethodChannel into the official native SDKs
/// (TikTokBusinessSDK pod on iOS, tiktok-business-android-sdk on Android).
/// The native halves live in ios/Runner/AppDelegate.swift and
/// android/.../MainActivity.kt.
///
/// Entirely no-op unless an App Secret is supplied at build time:
///   --dart-define=TIKTOK_APP_SECRET_IOS=...      (iOS builds)
///   --dart-define=TIKTOK_APP_SECRET_ANDROID=...  (Android builds)
/// so debug builds and forks send nothing. See docs/tiktok-sdk.md.
///
/// Install and app-launch events are sent automatically by the native SDK.
/// The events fired from Dart (names are TikTok standard events — campaign
/// optimisation depends on them, keep them exact):
///   Registration — new account, any sign-up method
///   Subscribe    — a paid tier was purchased
class TikTokEvents {
  TikTokEvents._();
  static final TikTokEvents instance = TikTokEvents._();

  static const MethodChannel _channel =
      MethodChannel('app.legacytable/tiktok_events');

  bool _initialized = false;

  bool get _supported =>
      !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  String get _accessToken => Platform.isIOS
      ? AppConfig.tiktokAppSecretIos
      : AppConfig.tiktokAppSecretAndroid;

  bool get enabled => _supported && _accessToken.isNotEmpty;

  Future<void> init() async {
    if (!enabled || _initialized) return;
    try {
      await _channel.invokeMethod<void>('init', {
        'accessToken': _accessToken,
        'appId': Platform.isIOS
            ? AppConfig.tiktokStoreAppIdIos
            : AppConfig.tiktokStoreAppIdAndroid,
        'ttAppId': Platform.isIOS
            ? AppConfig.tiktokAppIdIos
            : AppConfig.tiktokAppIdAndroid,
        'debug': kDebugMode,
      });
      _initialized = true;
    } catch (e) {
      debugPrint('[TikTok] init failed: $e');
    }
  }

  /// iOS only: shows Apple's App Tracking Transparency prompt (once — the OS
  /// remembers the answer). No-op on Android and when TikTok is disabled.
  Future<void> requestTrackingAuthorization() async {
    if (!_initialized || !Platform.isIOS) return;
    try {
      await _channel.invokeMethod<void>('requestTrackingAuthorization');
    } catch (e) {
      debugPrint('[TikTok] ATT request failed: $e');
    }
  }

  Future<void> track(String event, [Map<String, Object>? properties]) async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod<void>('track', {
        'event': event,
        'properties': properties ?? const <String, Object>{},
      });
    } catch (e) {
      debugPrint('[TikTok] track($event) failed: $e');
    }
  }

  /// Backend user id only — never email or phone.
  Future<void> identify(String userId) async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod<void>('identify', {'externalId': userId});
    } catch (e) {
      debugPrint('[TikTok] identify failed: $e');
    }
  }

  Future<void> logout() async {
    if (!_initialized) return;
    try {
      await _channel.invokeMethod<void>('logout');
    } catch (e) {
      debugPrint('[TikTok] logout failed: $e');
    }
  }
}

/// Convenience singleton accessor.
final tiktokEvents = TikTokEvents.instance;
