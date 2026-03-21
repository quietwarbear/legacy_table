import '../config/api_config.dart';
import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _apiClient;

  AuthService(this._apiClient);

  // Register a new user
  Future<LoginResponse> register(RegisterRequest request) async {
    final response = await _apiClient.post(
      ApiConfig.register,
      data: request.toJson(),
    );
    final loginResponse = LoginResponse.fromJson(response.data);
    _apiClient.setAuthToken(loginResponse.token);
    return loginResponse;
  }

  // Login user
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _apiClient.post(
      ApiConfig.login,
      data: request.toJson(),
    );
    final loginResponse = LoginResponse.fromJson(response.data);
    _apiClient.setAuthToken(loginResponse.token);
    return loginResponse;
  }

  // Get current user
  Future<User> getCurrentUser() async {
    final response = await _apiClient.get(ApiConfig.currentUser);
    return User.fromJson(response.data);
  }

  // Update user profile
  Future<User> updateProfile(UpdateProfileRequest request) async {
    final response = await _apiClient.put(
      ApiConfig.updateProfile,
      data: request.toJson(),
    );
    return User.fromJson(response.data);
  }

  // Logout (clear token)
  void logout() {
    _apiClient.clearAuthToken();
  }
}
