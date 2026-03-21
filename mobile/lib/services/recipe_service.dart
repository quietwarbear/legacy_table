import 'package:flutter/foundation.dart' hide Category;
import '../config/api_config.dart';
import '../models/recipe.dart';
import 'api_client.dart';

class RecipeService {
  final ApiClient _apiClient;

  RecipeService(this._apiClient);

  // Get all recipes with optional filters
  Future<List<Recipe>> getRecipes({
    String? category,
    String? authorId,
  }) async {
    final queryParams = <String, dynamic>{};
    if (category != null) queryParams['category'] = category;
    if (authorId != null) {
      queryParams['author_id'] = authorId;
      if (kDebugMode) {
        print('Filtering recipes by author_id: $authorId');
      }
    }

    if (kDebugMode) {
      print('Getting recipes with query params: $queryParams');
    }

    final response = await _apiClient.get(
      ApiConfig.recipes,
      queryParameters: queryParams.isEmpty ? null : queryParams,
    );

    if (response.data is List) {
      return (response.data as List)
          .map((json) => Recipe.fromJson(json))
          .toList();
    }
    return [];
  }

  // Get recipe by ID
  Future<Recipe> getRecipeById(String recipeId) async {
    final response = await _apiClient.get(ApiConfig.recipeById(recipeId));
    return Recipe.fromJson(response.data);
  }

  // Create a new recipe
  Future<Recipe> createRecipe(CreateRecipeRequest request) async {
    final response = await _apiClient.post(
      ApiConfig.recipes,
      data: request.toJson(),
    );
    return Recipe.fromJson(response.data);
  }

  // Update a recipe
  Future<Recipe> updateRecipe(
    String recipeId,
    UpdateRecipeRequest request,
  ) async {
    final response = await _apiClient.put(
      ApiConfig.recipeById(recipeId),
      data: request.toJson(),
    );
    return Recipe.fromJson(response.data);
  }

  // Delete a recipe
  Future<void> deleteRecipe(String recipeId) async {
    await _apiClient.delete(ApiConfig.recipeById(recipeId));
  }

  // Get all categories
  Future<List<Category>> getCategories() async {
    try {
      final response = await _apiClient.get(ApiConfig.categories);
      
      if (kDebugMode) {
        print('Categories API response type: ${response.data.runtimeType}');
        print('Categories API response: ${response.data}');
      }
      
      if (response.data is List) {
        final dataList = response.data as List;
        
        if (kDebugMode) {
          print('Categories list length: ${dataList.length}');
          if (dataList.isNotEmpty) {
            print('First category item type: ${dataList[0].runtimeType}');
            print('First category item: ${dataList[0]}');
          }
        }
        
        // Handle both string array and object array formats
        final categories = dataList.map((item) {
          if (item is String) {
            // API returns array of strings: ["Appetizer", "Beverage", ...]
            return Category(
              id: item.toLowerCase().replaceAll(' ', '-'),
              name: item,
            );
          } else if (item is Map) {
            // API returns array of objects: [{"id": "...", "name": "..."}, ...]
            return Category.fromJson(item as Map<String, dynamic>);
          } else {
            // Fallback: convert to string
            return Category(
              id: item.toString().toLowerCase().replaceAll(' ', '-'),
              name: item.toString(),
            );
          }
        }).toList();
        
        if (kDebugMode) {
          print('Parsed ${categories.length} categories');
        }
        
        return categories;
      }
      
      if (kDebugMode) {
        print('Categories API response is not a List');
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching categories: $e');
      }
      rethrow;
    }
  }
}
