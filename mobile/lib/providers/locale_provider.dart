import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Holds the app's active [Locale] and persists the user's choice.
///
/// Mirrors [ThemeProvider]: a ChangeNotifier loaded from SharedPreferences on
/// construction, read by MaterialApp, and updated from the settings screen.
class LocaleProvider extends ChangeNotifier {
  static const String _localeKey = 'locale_code';

  /// Languages the app ships translations for. Keep in sync with the ARB
  /// files in lib/l10n/ and MaterialApp.supportedLocales.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('yo'),
    Locale('fa'),
    Locale('pt'),
    Locale('fr'),
  ];

  /// Display label for each supported language, written in that language so it
  /// reads natively in the picker regardless of the current app locale.
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Español',
    'hi': 'हिन्दी',
    'yo': 'Yorùbá',
    'fa': 'فارسی',
    'pt': 'Português (Brasil)',
    'fr': 'Français',
  };

  Locale? _locale;
  bool _isInitialized = false;

  /// The active locale, or null to follow the device locale.
  Locale? get locale => _locale;
  bool get isInitialized => _isInitialized;

  LocaleProvider() {
    _loadLocale();
  }

  // Load the saved language code from storage, falling back to the device
  // locale (if supported) and finally English.
  Future<void> _loadLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_localeKey);
      if (code != null && _isSupported(code)) {
        _locale = Locale(code);
      } else {
        _locale = _deviceLocaleOrNull();
      }
    } catch (e) {
      _locale = null;
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Persist the chosen language code.
  Future<void> _saveLocale(String code) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localeKey, code);
    } catch (e) {
      // Handle error silently.
    }
  }

  /// Switch the app to [locale] (must be one of [supportedLocales]).
  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale.languageCode)) return;
    if (_locale?.languageCode == locale.languageCode) return;
    _locale = locale;
    await _saveLocale(locale.languageCode);
    notifyListeners();
  }

  static bool _isSupported(String code) =>
      supportedLocales.any((l) => l.languageCode == code);

  // The device's preferred locale if we support it, else null.
  static Locale? _deviceLocaleOrNull() {
    final device = PlatformDispatcher.instance.locale;
    return _isSupported(device.languageCode)
        ? Locale(device.languageCode)
        : null;
  }
}
