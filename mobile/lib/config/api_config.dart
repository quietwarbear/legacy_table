import 'app_config.dart';

class ApiConfig {
  // Base URL for the API (uses environment-based config)
  static String get baseUrl => AppConfig.baseUrl;
  static String get apiPrefix => AppConfig.apiPrefix;

  // Full API base URL (used for Dio baseUrl configuration)
  static String get apiBaseUrl => AppConfig.apiBaseUrl;

  // Authentication endpoints (relative paths)
  static String get register => '/auth/register';
  static String get login => '/auth/login';
  static String get currentUser => '/auth/me';
  static String get updateProfile => '/auth/profile';
  static String get googleAuth => '/auth/google';
  static String get appleAuth => '/auth/apple';

  // Recipe endpoints (relative paths)
  static String get recipes => '/recipes';
  static String recipeById(String id) => '/recipes/$id';
  static String get categories => '/categories';
  static String get holidays => '/holidays';
  static String holidayRecipes(String holidayName) =>
      '/holidays/$holidayName/recipes';

  // Comment endpoints (relative paths)
  static String recipeComments(String recipeId) =>
      '/recipes/$recipeId/comments';
  static String commentById(String commentId) =>
      '/comments/$commentId';

  // Notification endpoints (relative paths)
  static String get notifications => '/notifications';
  static String get unreadCount => '/notifications/unread-count';
  static String markNotificationRead(String notificationId) =>
      '/notifications/$notificationId/read';
  static String get markAllRead => '/notifications/read-all';

  // Family endpoints (relative paths)
  static String get families => '/families';
  static String familyById(String id) => '/families/$id';
  static String get joinFamily => '/families/join';
  static String familyMembers(String familyId) => '/families/$familyId/members';
  static String leaveFamily(String familyId) => '/families/$familyId/leave';
  static String transferKeeper(String familyId) => '/families/$familyId/transfer-keeper';

  // Subscription endpoints (relative paths)
  static String get subscriptionStatus => '/subscriptions/status';
  static String get subscriptionWebhook => '/subscriptions/webhook';
  static String get subscriptionPortal => '/subscriptions/portal';

  // AI endpoints (relative paths)
  static String get scanRecipe => '/ai/scan-recipe';
  static String get voiceToRecipe => '/ai/voice-to-recipe';
  static String get saveFromLink => '/ai/save-from-link';

  // Health check endpoints (relative paths)
  static String get healthCheck => '/health';
  static String get apiRoot => '/';
}
