import 'api_client.dart';
import 'auth_service.dart';
import 'recipe_service.dart';
import 'comment_service.dart';
import 'notification_service.dart';
import 'family_service.dart';

/// Main API service class that provides access to all API services
class ApiService {
  late final ApiClient _apiClient;
  late final AuthService auth;
  late final RecipeService recipes;
  late final CommentService comments;
  late final NotificationService notifications;
  late final FamilyService families;

  ApiService() {
    _apiClient = ApiClient();
    auth = AuthService(_apiClient);
    recipes = RecipeService(_apiClient);
    comments = CommentService(_apiClient);
    notifications = NotificationService(_apiClient);
    families = FamilyService(_apiClient);
  } 
 
  // Set authentication token (used after login)
  void setAuthToken(String? token) {
    _apiClient.setAuthToken(token);
  }

  // Clear authentication token (used for logout)
  void clearAuthToken() {
    _apiClient.clearAuthToken();
  }

  // Get the API client instance (for advanced usage)
  ApiClient get apiClient => _apiClient;
}

// Singleton instance
final apiService = ApiService();
