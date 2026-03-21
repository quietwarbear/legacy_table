import 'package:flutter/foundation.dart';
import '../config/api_config.dart';
import '../models/comment.dart';
import 'api_client.dart';
import 'session_manager.dart';

class CommentService {
  final ApiClient _apiClient;

  CommentService(this._apiClient);

  // Get all comments for a recipe
  // API: GET /api/recipes/:recipe_id/comments
  Future<List<Comment>> getComments(String recipeId) async {
    if (kDebugMode) {
      print('Getting comments for recipe: $recipeId');
      print('API endpoint: ${ApiConfig.recipeComments(recipeId)}');
    }
    
    final response =
        await _apiClient.get(ApiConfig.recipeComments(recipeId));
    
    if (response.data is List) {
      final comments = (response.data as List)
          .map((json) {
            if (kDebugMode) {
              print('Parsing comment JSON: $json');
            }
            
            final comment = Comment.fromJson(json);
            
            if ((comment.authorName == null || comment.authorName!.isEmpty) &&
                sessionManager.currentUser != null &&
                sessionManager.currentUser!.id == comment.authorId) {
              if (kDebugMode) {
                print('Using current user name for comment: ${sessionManager.currentUser!.name}');
              }
              return Comment(
                id: comment.id,
                text: comment.text,
                recipeId: comment.recipeId,
                authorId: comment.authorId,
                authorName: sessionManager.currentUser!.name,
                createdAt: comment.createdAt,
              );
            }
            
            if (kDebugMode && (comment.authorName == null || comment.authorName!.isEmpty)) {
              print('Warning: Comment ${comment.id} has no author name');
            }
            
            return comment;
          })
          .toList();
      
      if (kDebugMode) {
        print('Comments retrieved: ${comments.length}');
        for (var comment in comments) {
          print('  - Comment by ${comment.authorName ?? 'Unknown'} (${comment.authorId})');
        }
      }
      
      return comments;
    }
    return [];
  }

  // Create a comment
  // API: POST /api/recipes/:recipe_id/comments
  // Body: {"text": "comment text"}
  Future<Comment> createComment(
    String recipeId,
    CreateCommentRequest request,
  ) async {
    if (kDebugMode) {
      print('Creating comment for recipe: $recipeId');
      print('Comment text: ${request.text}');
      print('API endpoint: ${ApiConfig.recipeComments(recipeId)}');
    }
    
    final response = await _apiClient.post(
      ApiConfig.recipeComments(recipeId),
      data: request.toJson(),
    );
    
    final comment = Comment.fromJson(response.data);
    
    if (kDebugMode) {
      print('Comment created successfully: ${comment.id}');
      print('Comment author: ${comment.authorName ?? 'Unknown'} (ID: ${comment.authorId})');
      print('Full response data: ${response.data}');
    }
    
    if (comment.authorName == null || comment.authorName!.isEmpty) {
      if (sessionManager.currentUser != null &&
          sessionManager.currentUser!.id == comment.authorId) {
        return Comment(
          id: comment.id,
          text: comment.text,
          recipeId: comment.recipeId,
          authorId: comment.authorId,
          authorName: sessionManager.currentUser!.name,
          createdAt: comment.createdAt,
        );
      }
    }
    
    return comment;
  }

  // Delete a comment
  // API: DELETE /api/comments/:comment_id
  Future<void> deleteComment(String commentId) async {
    if (kDebugMode) {
      print('Deleting comment: $commentId');
      print('API endpoint: ${ApiConfig.commentById(commentId)}');
    }
    
    await _apiClient.delete(ApiConfig.commentById(commentId));
    
    if (kDebugMode) {
      print('Comment deleted successfully');
    }
  }
}
