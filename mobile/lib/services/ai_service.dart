import '../config/api_config.dart';
import '../models/recipe.dart';
import 'api_client.dart';

class AiService {
  final ApiClient _apiClient;

  AiService(this._apiClient);

  Future<CreateRecipeRequest> scanRecipe(String imageDataUrl) async {
    final response = await _apiClient.post(
      ApiConfig.scanRecipe,
      data: {'image': imageDataUrl},
    );

    final recipe = response.data['recipe'];
    if (recipe is! Map) {
      throw Exception('Invalid scan response');
    }

    return CreateRecipeRequest.fromJson(Map<String, dynamic>.from(recipe));
  }

  Future<CreateRecipeRequest> saveFromLink(String url) async {
    final response = await _apiClient.post(
      ApiConfig.saveFromLink,
      data: {'url': url},
    );

    final recipe = response.data['recipe'];
    if (recipe is! Map) {
      throw Exception('Invalid link import response');
    }

    return CreateRecipeRequest.fromJson(Map<String, dynamic>.from(recipe));
  }
}
