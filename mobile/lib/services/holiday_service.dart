import '../config/api_config.dart';
import '../models/holiday.dart';
import '../models/recipe.dart';
import 'api_client.dart';

class HolidayService {
  final ApiClient _apiClient;

  HolidayService(this._apiClient);

  Future<HolidaySummary> getHolidaySummary() async {
    final response = await _apiClient.get(ApiConfig.holidays);
    return HolidaySummary.fromJson(Map<String, dynamic>.from(response.data));
  }

  Future<List<Recipe>> getHolidayRecipes(String holidayName) async {
    final encodedName = Uri.encodeComponent(holidayName);
    final response = await _apiClient.get(
      ApiConfig.holidayRecipes(encodedName),
    );
    final recipes = response.data['recipes'];
    if (recipes is! List) {
      return [];
    }

    return recipes
        .whereType<Map>()
        .map((json) => Recipe.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  }
}
