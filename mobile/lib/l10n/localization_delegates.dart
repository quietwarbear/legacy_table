import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'app_localizations.dart';

/// flutter_localizations ships a fixed set of locales and does NOT include
/// Yoruba ('yo'). Without a MaterialLocalizations for 'yo', MaterialApp asserts
/// "No MaterialLocalizations found". These fallback delegates claim only 'yo'
/// and serve the English OS-level widget strings (date pickers, tooltips, etc.)
/// while the app's own AppLocalizations strings still render in Yoruba.
class _FallbackMaterialDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _FallbackMaterialDelegate();
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';
  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      GlobalMaterialLocalizations.delegate.load(const Locale('en'));
  @override
  bool shouldReload(_) => false;
}

class _FallbackCupertinoDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _FallbackCupertinoDelegate();
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';
  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      GlobalCupertinoLocalizations.delegate.load(const Locale('en'));
  @override
  bool shouldReload(_) => false;
}

class _FallbackWidgetsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _FallbackWidgetsDelegate();
  @override
  bool isSupported(Locale locale) => locale.languageCode == 'yo';
  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      GlobalWidgetsLocalizations.delegate.load(const Locale('en'));
  @override
  bool shouldReload(_) => false;
}

/// App localization delegates: our generated AppLocalizations, the 'yo'
/// fallbacks (which only claim Yoruba), then the global delegates for every
/// other supported locale. Used by MaterialApp.localizationsDelegates.
const List<LocalizationsDelegate<dynamic>> appLocalizationsDelegates = [
  AppLocalizations.delegate,
  _FallbackMaterialDelegate(),
  _FallbackCupertinoDelegate(),
  _FallbackWidgetsDelegate(),
  GlobalMaterialLocalizations.delegate,
  GlobalCupertinoLocalizations.delegate,
  GlobalWidgetsLocalizations.delegate,
];
