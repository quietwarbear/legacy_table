class NotificationModel {
  final String id;
  final String type;
  final String message;
  final String? recipeId;
  final String? commentId;
  final bool read;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.type,
    required this.message,
    this.recipeId,
    this.commentId,
    required this.read,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? json['_id'] ?? '',
      type: json['type'] ?? '',
      message: json['message'] ?? '',
      recipeId: json['recipe_id'] ?? json['recipeId'],
      commentId: json['comment_id'] ?? json['commentId'],
      read: json['read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}

class UnreadCountResponse {
  final int count;

  UnreadCountResponse({
    required this.count,
  });

  factory UnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return UnreadCountResponse(
      count: json['count'] ?? 0,
    );
  }
}
