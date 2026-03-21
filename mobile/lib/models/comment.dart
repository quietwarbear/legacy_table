class Comment {
  final String id;
  final String text;
  final String recipeId;
  final String authorId;
  final String? authorName;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.text,
    required this.recipeId,
    required this.authorId,
    this.authorName,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    String? authorName;
    
    authorName = json['user_name'] ?? 
                 json['userName'] ?? 
                 json['author_name'] ?? 
                 json['authorName'];
    
    // Check nested author object
    if (authorName == null && json['author'] != null) {
      final author = json['author'];
      if (author is Map) {
        authorName = author['name'] ?? 
                     author['user_name'] ?? 
                     author['author_name'];
      }
    }
    
    // Check nested user object
    if (authorName == null && json['user'] != null) {
      final user = json['user'];
      if (user is Map) {
        authorName = user['name'] ?? 
                     user['user_name'] ?? 
                     user['author_name'];
      }
    }
    
    // Get author ID - API uses user_id (not author_id)
    final authorId = json['user_id'] ?? 
                     json['userId'] ?? 
                     json['author_id'] ?? 
                     json['authorId'] ?? 
                     '';
    
    return Comment(
      id: json['id'] ?? json['_id'] ?? '',
      text: json['text'] ?? '',
      recipeId: json['recipe_id'] ?? json['recipeId'] ?? '',
      authorId: authorId,
      authorName: authorName,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}

class CreateCommentRequest {
  final String text;

  CreateCommentRequest({
    required this.text,
  });

  Map<String, dynamic> toJson() {
    return {
      'text': text,
    };
  }
}
