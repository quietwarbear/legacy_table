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

  // Google Sign-In — send ID token to backend
  Future<LoginResponse> googleSignIn(String idToken) async {
    final response = await _apiClient.post(
      ApiConfig.googleAuth,
      data: {'credential': idToken},
    );
    final loginResponse = LoginResponse.fromJson(response.data);
    _apiClient.setAuthToken(loginResponse.token);
    return loginResponse;
  }

  // Apple Sign-In — send ID token to backend
  Future<LoginResponse> appleSignIn(String idToken, {String fullName = '', String email = ''}) async {
    final response = await _apiClient.post(
      ApiConfig.appleAuth,
      data: {'id_token': idToken, 'full_name': fullName, 'email': email},
    );
    final loginResponse = LoginResponse.fromJson(response.data);
    _apiClient.setAuthToken(loginResponse.token);
    return loginResponse;
  }

  // Facebook Sign-In — send access token to backend.
  // The backend re-verifies the token with Facebook's debug_token endpoint
  // (using FACEBOOK_APP_SECRET) and fetches /me?fields=id,email,name to
  // find or create the user.
  Future<LoginResponse> facebookSignIn(String accessToken) async {
    final response = await _apiClient.post(
      ApiConfig.facebookAuth,
      data: {'access_token': accessToken},
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
