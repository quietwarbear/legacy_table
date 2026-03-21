import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Keys for storage
  static const String _keyAuthToken = 'auth_token';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyFamilyId = 'family_id';
  static const String _keyUserRole = 'user_role';

  // Secure storage methods (for sensitive data like tokens)

  /// Store authentication token securely
  Future<void> saveAuthToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  /// Get authentication token from secure storage
  Future<String?> getAuthToken() async {
    return await _storage.read(key: _keyAuthToken);
  }

  /// Store user ID securely
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _keyUserId, value: userId);
  }

  /// Get user ID from secure storage
  Future<String?> getUserId() async {
    return await _storage.read(key: _keyUserId);
  }

  /// Store user email securely
  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _keyUserEmail, value: email);
  }

  /// Get user email from secure storage
  Future<String?> getUserEmail() async {
    return await _storage.read(key: _keyUserEmail);
  }

  /// Clear all secure storage data (logout)
  Future<void> clearSecureStorage() async {
    await _storage.deleteAll();
  }

  // Shared preferences methods (for non-sensitive data)

  /// Save login state
  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, isLoggedIn);
  }

  /// Get login state
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  /// Save onboarding completion status
  Future<void> setOnboardingCompleted(bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Get onboarding completion status
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Store family ID
  Future<void> saveFamilyId(String? familyId) async {
    if (familyId == null) {
      await _storage.delete(key: _keyFamilyId);
    } else {
      await _storage.write(key: _keyFamilyId, value: familyId);
    }
  }

  /// Get family ID from secure storage
  Future<String?> getFamilyId() async {
    return await _storage.read(key: _keyFamilyId);
  }

  /// Store user role
  Future<void> saveUserRole(String? role) async {
    if (role == null) {
      await _storage.delete(key: _keyUserRole);
    } else {
      await _storage.write(key: _keyUserRole, value: role);
    }
  }

  /// Get user role from secure storage
  Future<String?> getUserRole() async {
    return await _storage.read(key: _keyUserRole);
  }

  /// Clear all preferences (except theme preference)
  Future<void> clearPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    const themeKey = 'theme_mode';
    final themeValue = prefs.getInt(themeKey);
    
    // Clear all preferences
    await prefs.clear();
    
    // Restore theme preference if it existed
    if (themeValue != null) {
      await prefs.setInt(themeKey, themeValue);
    }
  }

  /// Clear all storage (secure + preferences)
  Future<void> clearAll() async {
    await clearSecureStorage();
    await clearPreferences();
  }
}
