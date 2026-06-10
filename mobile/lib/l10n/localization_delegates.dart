import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';

/// flutter_localizations ships a fixed set of locales, and its OS-widget
/// strings/direction don't always match how we ship a language:
///
///  * Yoruba ('yo') isn't shipped at all — without a fallback, MaterialApp
///    asserts "No MaterialLocalizations found". We serve English.
///  * Punjabi ('pa') is shipped as Gurmukhi and treated as LTR, but we ship
///    Shahmukhi (Perso-Arabic, RTL) for Pakistani Punjab. We serve Urdu
///    OS-widget strings, which are Perso-Arabic and carry RTL direction.
///
/// App-level strings (AppLocalizations) still render in the real language;
/// only date pickers, tooltips, and other framework widgets use the fallback.
const Map<String, Locale> _widgetLocaleFallbacks = {
  'yo': Locale('en'),
  'pa': Locale('ur'),
};

class _FallbackMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialDelegate();
  @override
  bool isSupported(Locale locale) =>
      _widgetLocaleFallbacks.containsKey(locale.languageCode);
  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate
          .load(_widgetLocaleFallbacks[locale.languageCode]!);
  @override
  bool shouldReload(_) => false;
}

class _FallbackCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoDelegate();
  @override
  bool isSupported(Locale locale) =>
      _widgetLocaleFallbacks.containsKey(locale.languageCode);
  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate
          .load(_widgetLocaleFallbacks[locale.languageCode]!);
  @override
  bool shouldReload(_) => false;
}

class _FallbackWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsDelegate();
  @override
  bool isSupported(Locale locale) =>
      _widgetLocaleFallbacks.containsKey(locale.languageCode);
  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate
          .load(_widgetLocaleFallbacks[locale.languageCode]!);
  @override
  bool shouldReload(_) => false;
}

/// App localization delegates: our generated AppLocalizations, the fallback
/// delegates (which only claim the locales in [_widgetLocaleFallbacks]), then
/// the global delegates for every other supported locale. Used by
/// MaterialApp.localizationsDelegates.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  _FallbackMaterialDelegate(),
  _FallbackCupertinoDelegate(),
  _FallbackWidgetsDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];
