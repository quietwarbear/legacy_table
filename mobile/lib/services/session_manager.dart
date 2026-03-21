import 'package:flutter/foundation.dart';
import '../models/user.dart';
import 'api_service.dart';
import 'storage_service.dart';
import 'auth_service.dart';

class SessionManager extends ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;
  final AuthService _authService;

  User? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  SessionManager({
    ApiService? apiService,
    StorageService? storageService,
  })  : _apiService = apiService ?? _getGlobalApiService(),
        _storageService = storageService ?? StorageService(),
        _authService = (apiService ?? _getGlobalApiService()).auth {
    _initialize();
  }

  // Get the global API service singleton
  static ApiService _getGlobalApiService() {
    // Import the global apiService from api_service.dart
    return apiService;
  }

  // Getters
  User? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  /// Initialize session - check if user is already logged in
  Future<void> _initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await _storageService.getAuthToken();
      final isLoggedIn = await _storageService.isLoggedIn();

      if (token != null && isLoggedIn) {
        // Set token in API client
        _apiService.setAuthToken(token);

        // Try to get current user to validate token
        try {
          _currentUser = await _authService.getCurrentUser();
          _isLoggedIn = true;
        } catch (e) {
          // Token might be invalid, clear storage
          if (kDebugMode) {
            print('Token validation failed: $e');
          }
          await _storageService.clearAll();
          _apiService.clearAuthToken();
          _isLoggedIn = false;
          _currentUser = null;
        }
      } else {
        _isLoggedIn = false;
        _currentUser = null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Session initialization error: $e');
      }
      _isLoggedIn = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login user and save session
  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final loginResponse = await _authService.login(
        LoginRequest(email: email, password: password),
      );

      // Save token and user data
      await _storageService.saveAuthToken(loginResponse.token);
      await _storageService.saveUserId(loginResponse.user.id);
      await _storageService.saveUserEmail(loginResponse.user.email);
      await _storageService.setLoggedIn(true);
      
      // Save family data if available
      if (loginResponse.user.familyId != null) {
        await _storageService.saveFamilyId(loginResponse.user.familyId);
      }
      if (loginResponse.user.role != null) {
        await _storageService.saveUserRole(loginResponse.user.role);
      }

      _apiService.setAuthToken(loginResponse.token);

      // Update state
      _currentUser = loginResponse.user;
      _isLoggedIn = true;
    } catch (e) {
      if (kDebugMode) {
        print('Login error: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register user and auto-login
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? nickname,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final registerResponse = await _authService.register(
        RegisterRequest(
          name: name,
          email: email,
          password: password,
          nickname: nickname,
        ),
      );

      // Save token and user data
      await _storageService.saveAuthToken(registerResponse.token);
      await _storageService.saveUserId(registerResponse.user.id);
      await _storageService.saveUserEmail(registerResponse.user.email);
      await _storageService.setLoggedIn(true);
      
      // Save family data if available
      if (registerResponse.user.familyId != null) {
        await _storageService.saveFamilyId(registerResponse.user.familyId);
      }
      if (registerResponse.user.role != null) {
        await _storageService.saveUserRole(registerResponse.user.role);
      }

      _apiService.setAuthToken(registerResponse.token);

      // Update state
      _currentUser = registerResponse.user;
      _isLoggedIn = true;
    } catch (e) {
      if (kDebugMode) {
        print('Registration error: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout user and clear session
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Update state first to prevent any race conditions
      _currentUser = null;
      _isLoggedIn = false;
      
      // Clear API token
      _authService.logout();

      // Clear all stored data
      await _storageService.clearAll();
      
      // Ensure login state is cleared in storage
      await _storageService.setLoggedIn(false);

      if (kDebugMode) {
        print('Logout completed successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
      // Even if there's an error, clear the state
      _currentUser = null;
      _isLoggedIn = false;
      await _storageService.setLoggedIn(false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresh current user data
  Future<void> refreshUser() async {
    if (!_isLoggedIn) return;

    try {
      _currentUser = await _authService.getCurrentUser();
      
      // Update stored family data
      if (_currentUser?.familyId != null) {
        await _storageService.saveFamilyId(_currentUser!.familyId);
      } else {
        await _storageService.saveFamilyId(null);
      }
      
      if (_currentUser?.role != null) {
        await _storageService.saveUserRole(_currentUser!.role);
      } else {
        await _storageService.saveUserRole(null);
      }
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Refresh user error: $e');
      }
      // If token is invalid, logout
      if (e.toString().contains('401') || e.toString().contains('403')) {
        await logout();
      }
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? nickname,
    String? avatar,
  }) async {
    if (!_isLoggedIn) return;

    _isLoading = true;
    notifyListeners();

    try {
      _currentUser = await _authService.updateProfile(
        UpdateProfileRequest(nickname: nickname, avatar: avatar),
      );
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Update profile error: $e');
      }
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Check if session is valid
  Future<bool> validateSession() async {
    try {
      final token = await _storageService.getAuthToken();
      if (token == null) return false;

      // Try to get current user to validate token
      await _authService.getCurrentUser();
      return true;
    } catch (e) {
      return false;
    }
  }
}

// Singleton instance
SessionManager? _sessionManagerInstance;

SessionManager get sessionManager {
  _sessionManagerInstance ??= SessionManager();
  return _sessionManagerInstance!;
}
