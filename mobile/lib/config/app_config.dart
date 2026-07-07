/// Application configuration for different environments
class AppConfig {
  // Environment modes
  static const bool _isProduction = bool.fromEnvironment('PROD', defaultValue: true);
   
  // Base URLs
  // For physical devices, use your computer's local IP address
  // Find it with: ifconfig (Mac/Linux) or ipconfig (Windows)
  // static const String _devBaseUrl = 'http://10.0.2.2:8000';
  static const String _devBaseUrl = 'http://192.168.7.27:8000';
  // For emulator, use: 'http://10.0.2.2:8000' (Android) or 'http://localhost:8000' (iOS)
  // static const String _devBaseUrl = 'http://localhost:8000'; 
  static const String _prodBaseUrl = 'https://api.legacytable.app';

  // API prefix
  static const String apiPrefix = '/api';

  // Observability keys. PostHog project tokens and Sentry DSNs are both
  // publishable client-side values (like the RevenueCat keys in
  // subscription_service.dart), so the real ones ship as defaults — every
  // build has analytics + crash reporting with no --dart-define plumbing.
  // A dart-define still overrides either for testing, and an empty value
  // disables the respective SDK entirely.
  static const String posthogApiKey = String.fromEnvironment(
    'POSTHOG_API_KEY',
    defaultValue: 'phc_m3uewVirngKNvpwdZ6DYkwMaWXjCscBf5iPwCSpJGm68',
  );
  static const String posthogHost = String.fromEnvironment(
    'POSTHOG_HOST',
    defaultValue: 'https://eu.i.posthog.com', // project lives in PostHog EU
  );
  static const String sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue:
        'https://6673dabfdb3831f9277bb2c98dea72b9@o4511694752120832.ingest.us.sentry.io/4511694759395328',
  );
  
  // Get base URL based on environment
  static String get baseUrl => _isProduction ? _prodBaseUrl : _devBaseUrl;

  // Get full API base URL
  static String get apiBaseUrl => '$baseUrl$apiPrefix';
  
  // Environment getters
  static bool get isProduction => _isProduction;
  static bool get isDevelopment => !_isProduction;
}
