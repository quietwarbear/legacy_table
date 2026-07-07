import '../config/api_config.dart';
import '../models/recipe.dart';
import 'analytics_service.dart';
import 'api_client.dart';

class AiResult {
  final CreateRecipeRequest recipe;
  final int? creditsRemaining;
  final String? transcription; // Only for voice-to-recipe

  AiResult({
    required this.recipe,
    this.creditsRemaining,
    this.transcription,
  });
}

class AiService {
  final ApiClient _apiClient;

  AiService(this._apiClient);

  /// Scan a recipe from a photo using GPT-4 Vision.
  /// Costs 1 AI credit.
  Future<AiResult> scanRecipe(String imageDataUrl) async {
    final response = await _apiClient.post(
      ApiConfig.scanRecipe,
      data: {'image': imageDataUrl},
    );

    final data = response.data;
    final recipe = data['recipe'];
    if (recipe is! Map) {
      throw Exception('Invalid scan response');
    }

    await analytics.capture('ai_scan_used');
    return AiResult(
      recipe: CreateRecipeRequest.fromJson(Map<String, dynamic>.from(recipe)),
      creditsRemaining: data['credits_remaining'],
    );
  }

  /// Extract a recipe from a TikTok, Instagram, YouTube, or recipe URL.
  /// Costs 1 AI credit.
  Future<AiResult> saveFromLink(String url) async {
    final response = await _apiClient.post(
      ApiConfig.saveFromLink,
      data: {'url': url},
    );

    final data = response.data;
    final recipe = data['recipe'];
    if (recipe is! Map) {
      throw Exception('Invalid link import response');
    }

    await analytics.capture('ai_link_used');
    return AiResult(
      recipe: CreateRecipeRequest.fromJson(Map<String, dynamic>.from(recipe)),
      creditsRemaining: data['credits_remaining'],
    );
  }

  /// Convert a voice recording into a structured recipe.
  /// Costs 2 AI credits (Whisper transcription + GPT-4 structuring).
  Future<AiResult> voiceToRecipe(String audioBase64, String format) async {
    final response = await _apiClient.post(
      ApiConfig.voiceToRecipe,
      data: {
        'audio': audioBase64,
        'format': format,
      },
    );

    final data = response.data;
    final recipe = data['recipe'];
    if (recipe is! Map) {
      throw Exception('Invalid voice recipe response');
    }

    await analytics.capture('ai_voice_used');
    return AiResult(
      recipe: CreateRecipeRequest.fromJson(Map<String, dynamic>.from(recipe)),
      creditsRemaining: data['credits_remaining'],
      transcription: data['transcription'],
    );
  }
}
