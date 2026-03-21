import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/notification.dart';
import '../services/api_service.dart';
import '../widgets/styled_snackbar.dart';
import 'recipe_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  bool _isMarkingAllAsRead = false;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final notifications = await apiService.notifications.getNotifications();
      // Sort notifications: unread first, then by date (newest first)
      notifications.sort((a, b) {
        if (a.read != b.read) {
          return a.read ? 1 : -1; // Unread first
        }
        return b.createdAt.compareTo(a.createdAt); // Newest first
      });

      final unreadCountResponse = await apiService.notifications.getUnreadCount();

      setState(() {
        _notifications = notifications;
        _unreadCount = unreadCountResponse.count;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notifications: $e');
      }
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        StyledSnackBar.showError(context, 'Failed to load notifications. Please try again.');
      }
    }
  }

  Future<void> _markAllAsRead() async {
    if (_unreadCount == 0) return;

    setState(() {
      _isMarkingAllAsRead = true;
    });

    try {
      await apiService.notifications.markAllAsRead();
      // Reload notifications to get updated read status
      await _loadNotifications();

      if (mounted) {
        StyledSnackBar.showSuccess(context, 'All notifications marked as read');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error marking all as read: $e');
      }
      if (mounted) {
        StyledSnackBar.showError(context, 'Failed to mark all as read. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isMarkingAllAsRead = false;
        });
      }
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await apiService.notifications.markAsRead(notificationId);
      // Update local state
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          _notifications[index] = NotificationModel(
            id: _notifications[index].id,
            type: _notifications[index].type,
            message: _notifications[index].message,
            recipeId: _notifications[index].recipeId,
            commentId: _notifications[index].commentId,
            read: true,
            createdAt: _notifications[index].createdAt,
          );
          if (_unreadCount > 0) {
            _unreadCount--;
          }
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error marking notification as read: $e');
      }
    }
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read if not already read
    if (!notification.read) {
      _markAsRead(notification.id);
    }

    // Navigate based on notification type
    if (notification.recipeId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => RecipeDetailScreen(
            recipeId: notification.recipeId!,
          ),
        ),
      ).then((_) {
        // Refresh notifications when returning
        _loadNotifications();
      });
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks${weeks == 1 ? ' week' : ' weeks'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'comment':
        return Icons.comment_outlined;
      case 'like':
        return Icons.favorite_outline;
      case 'recipe':
        return Icons.restaurant_menu_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final secondaryTextColor = isDark ? DarkColors.textSecondary : LightColors.textSecondary;
    final surfaceColor = isDark ? DarkColors.surface : LightColors.surface;
    final borderColor = isDark ? DarkColors.border : LightColors.border;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        backgroundColor: isDark ? DarkColors.background : LightColors.background,
        elevation: 0,
        actions: [
          if (_unreadCount > 0)
            TextButton.icon(
              onPressed: _isMarkingAllAsRead ? null : _markAllAsRead,
              icon: _isMarkingAllAsRead
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.done_all, size: 18),
              label: const Text(
                'Mark all as read',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_none_outlined,
                        size: 64,
                        color: secondaryTextColor,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notifications',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'You\'re all caught up!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: secondaryTextColor,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadNotifications,
                  color: brandPrimary,
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: _notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notification = _notifications[index];
                      return _NotificationCard(
                        notification: notification,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                        surfaceColor: surfaceColor,
                        borderColor: borderColor,
                        isDark: isDark,
                        theme: theme,
                        onTap: () => _handleNotificationTap(notification),
                        formatDate: _formatDate,
                        getIcon: _getNotificationIcon,
                      );
                    },
                  ),
                ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final Color textColor;
  final Color secondaryTextColor;
  final Color surfaceColor;
  final Color borderColor;
  final bool isDark;
  final ThemeData theme;
  final VoidCallback onTap;
  final String Function(DateTime) formatDate;
  final IconData Function(String) getIcon;

  const _NotificationCard({
    required this.notification,
    required this.textColor,
    required this.secondaryTextColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.isDark,
    required this.theme,
    required this.onTap,
    required this.formatDate,
    required this.getIcon,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.read ? surfaceColor : brandPrimary.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notification.read ? borderColor : brandPrimary.withValues(alpha: 0.3),
            width: notification.read ? 1 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon with unread indicator
            Stack(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: brandPrimary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getIcon(notification.type),
                    color: brandPrimary,
                    size: 24,
                  ),
                ),
                if (!notification.read)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: brandPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? DarkColors.background : LightColors.background,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.message,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontFamily: 'Manrope',
                      fontWeight: notification.read ? FontWeight.w400 : FontWeight.w600,
                      color: textColor,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDate(notification.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Manrope',
                      color: secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
