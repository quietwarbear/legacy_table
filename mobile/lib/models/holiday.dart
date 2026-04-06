class HolidayInfo {
  final String name;
  final int month;
  final int day;
  final String season;
  final int? daysAway;

  HolidayInfo({
    required this.name,
    required this.month,
    required this.day,
    required this.season,
    this.daysAway,
  });

  factory HolidayInfo.fromJson(Map<String, dynamic> json) {
    return HolidayInfo(
      name: json['name'] ?? '',
      month: json['month'] ?? 1,
      day: json['day'] ?? 1,
      season: json['season'] ?? '',
      daysAway: json['days_away'],
    );
  }
}

class HolidaySummary {
  final List<HolidayInfo> upcoming;
  final String season;
  final String seasonTheme;
  final Map<String, int> holidayRecipeCounts;

  HolidaySummary({
    required this.upcoming,
    required this.season,
    required this.seasonTheme,
    required this.holidayRecipeCounts,
  });

  factory HolidaySummary.fromJson(Map<String, dynamic> json) {
    final counts = <String, int>{};
    final rawCounts = json['holiday_recipe_counts'];
    if (rawCounts is Map) {
      for (final entry in rawCounts.entries) {
        counts[entry.key.toString()] = entry.value is int
            ? entry.value as int
            : int.tryParse(entry.value.toString()) ?? 0;
      }
    }

    return HolidaySummary(
      upcoming: (json['upcoming'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => HolidayInfo.fromJson(Map<String, dynamic>.from(item)))
          .toList(),
      season: json['season'] ?? '',
      seasonTheme: json['season_theme'] ?? '',
      holidayRecipeCounts: counts,
    );
  }
}
