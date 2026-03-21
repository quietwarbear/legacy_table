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
  
  // Get base URL based on environment
  static String get baseUrl => _isProduction ? _prodBaseUrl : _devBaseUrl;

  // Get full API base URL
  static String get apiBaseUrl => '$baseUrl$apiPrefix';
  
  // Environment getters
  static bool get isProduction => _isProduction;
  static bool get isDevelopment => !_isProduction;
}
