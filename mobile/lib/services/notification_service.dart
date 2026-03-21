import '../config/api_config.dart';
import '../models/notification.dart';
import 'api_client.dart';

class NotificationService {
  final ApiClient _apiClient;

  NotificationService(this._apiClient);

  // Get all notifications
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _apiClient.get(ApiConfig.notifications);
    if (response.data is List) {
      return (response.data as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    }
    return [];
  }

  // Get unread notification count
  Future<UnreadCountResponse> getUnreadCount() async {
    final response = await _apiClient.get(ApiConfig.unreadCount);
    return UnreadCountResponse.fromJson(response.data);
  }

  // Mark notification as read
  Future<NotificationModel> markAsRead(String notificationId) async {
    final response = await _apiClient.put(
      ApiConfig.markNotificationRead(notificationId),
    );
    return NotificationModel.fromJson(response.data);
  }

  // Mark all notifications as read
  Future<void> markAllAsRead() async {
    await _apiClient.put(ApiConfig.markAllRead);
  }
}
