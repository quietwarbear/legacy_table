import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/api_config.dart';
import 'config/app_config.dart';
import 'config/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'l10n/localization_delegates.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/subscription_provider.dart';
import 'services/subscription_service.dart';
import 'views/splash_screen.dart';
import 'views/onboarding_screen.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/register_screen.dart';
import 'views/subscription_screen.dart';
import 'views/join_family_screen.dart';

/// Singleton instance of Facebook App Events for ad attribution.
/// Use this everywhere events are logged (sign-up, purchase, etc.) rather
/// than constructing a new FacebookAppEvents() per call.
final facebookAppEvents = FacebookAppEvents();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Print the active API base URL once at startup so it's easy to confirm
  // (via `flutter logs` or device console) which backend the build is
  // pointing at. Critical for debugging "auth fails on Android" — a
  // wrong base URL or unreachable host accounts for most of those.
  debugPrint('[Boot] API base URL: ${ApiConfig.apiBaseUrl}');
  debugPrint('[Boot] isProduction: ${AppConfig.isProduction}');

  try {
    await SubscriptionService.initialize();
  } catch (e, stackTrace) {
    debugPrint('Subscription initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }

  // Meta App Events — the iOS SDK auto-activates from the FacebookAppID /
  // FacebookClientToken keys in Info.plist on launch, so we don't need
  // an explicit logActivatedApp() call here (that method only exists in
  // facebook_app_events ^0.28; we're pinned to 0.20.1 via pubspec.lock).
  // Custom events (e.g. fb_mobile_login on successful auth) still fire
  // through `facebookAppEvents.logEvent(...)` from the login screen.

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// Global navigator key so deep link handler can push routes
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _deepLinkSub;
  String? _pendingInviteCode;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    super.dispose();
  }

  /// Extract an invite code from a URI.
  /// Handles:
  ///   legacytable://invite/ABC12345
  ///   https://api.legacytable.app/invite/ABC12345
  String? _extractInviteCode(Uri uri) {
    // Custom scheme: legacytable://invite/CODE
    if (uri.scheme == 'legacytable' && uri.host == 'invite') {
      final segments = uri.pathSegments;
      if (segments.isNotEmpty) return segments.first.toUpperCase();
    }
    // HTTPS universal/app link: https://api.legacytable.app/invite/CODE
    if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'invite') {
      return uri.pathSegments[1].toUpperCase();
    }
    return null;
  }

  void _handleDeepLink(Uri uri) {
    debugPrint('Deep link received: $uri');
    final code = _extractInviteCode(uri);
    if (code != null && code.length == 8) {
      final nav = MyApp.navigatorKey.currentState;
      if (nav != null) {
        nav.push(
          MaterialPageRoute(
            builder: (_) => JoinFamilyScreen(prefilledCode: code),
          ),
        );
      } else {
        // App not fully initialised yet — store for later
        setState(() {
          _pendingInviteCode = code;
        });
      }
    }
  }

  Future<void> _initDeepLinks() async {
    try {
      // Check if app was launched via a deep link
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }

      // Listen for deep links while app is running
      _deepLinkSub = _appLinks.uriLinkStream.listen(
        _handleDeepLink,
        onError: (e) => debugPrint('Deep link stream error: $e'),
      );
    } catch (e) {
      debugPrint('Deep link init error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => SubscriptionProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          if (!themeProvider.isInitialized || !localeProvider.isInitialized) {
            return MaterialApp(
              navigatorKey: MyApp.navigatorKey,
              debugShowCheckedModeBanner: false,
              title: 'Legacy Table',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              locale: localeProvider.locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            navigatorKey: MyApp.navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Legacy Table',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            locale: localeProvider.locale,
            localizationsDelegates: appLocalizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: _pendingInviteCode != null
                ? Builder(builder: (ctx) {
                    final code = _pendingInviteCode!;
                    _pendingInviteCode = null;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.of(ctx).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              JoinFamilyScreen(prefilledCode: code),
                        ),
                      );
                    });
                    return const SplashScreen();
                  })
                : const SplashScreen(),
            routes: {
              '/onboarding': (context) => const OnboardingScreen(),
              '/login': (context) => const LoginScreen(),
              '/register': (context) => const RegisterScreen(),
              '/home': (context) => const HomeScreen(),
              '/subscription': (context) => const SubscriptionScreen(),
            },
          );
        },
      ),
    );
  }
}
