import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:family_recipe_app/l10n/app_localizations.dart';
import 'package:family_recipe_app/l10n/localization_delegates.dart';
import 'package:family_recipe_app/providers/locale_provider.dart';

void main() {
  group('Localization', () {
    test('every supported locale has a native display name', () {
      for (final locale in LocaleProvider.supportedLocales) {
        expect(
          LocaleProvider.languageNames[locale.languageCode],
          isNotNull,
          reason: 'Missing display name for ${locale.languageCode}',
        );
      }
    });

    // Languages we ship as right-to-left. Note 'pa' is RTL for us (Shahmukhi)
    // even though Flutter's built-in list treats it as LTR Gurmukhi — the
    // fallback delegates in localization_delegates.dart provide the override.
    const rtlCodes = {'ar', 'fa', 'ur', 'pa'};

    // Pumps a real MaterialApp for each locale. This is the key guard: a
    // supportedLocale that flutter_localizations can't resolve (e.g. Yoruba)
    // throws "No MaterialLocalizations found" here. It also forces each
    // generated AppLocalizations_<code> to load and resolve a string.
    for (final locale in LocaleProvider.supportedLocales) {
      testWidgets('MaterialApp builds and resolves strings for ${locale.languageCode}',
          (tester) async {
        late AppLocalizations l10n;
        late TextDirection direction;
        await tester.pumpWidget(
          MaterialApp(
            locale: locale,
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                l10n = AppLocalizations.of(context);
                // Touch MaterialLocalizations too — this is what asserts for yo.
                MaterialLocalizations.of(context);
                direction = Directionality.of(context);
                return Text(l10n.settingsLanguage);
              },
            ),
          ),
        );
        await tester.pumpAndSettle();

        // The string resolved and is non-empty for this locale.
        expect(l10n.settingsLanguage, isNotEmpty);
        // A placeholder method works (compile + runtime) for this locale.
        expect(l10n.settingsShareInviteJoin('Smith'), contains('Smith'));
        // Layout direction matches how we ship the language.
        expect(
          direction,
          rtlCodes.contains(locale.languageCode)
              ? TextDirection.rtl
              : TextDirection.ltr,
          reason: '${locale.languageCode} has the wrong text direction',
        );
      });
    }
  });
}
