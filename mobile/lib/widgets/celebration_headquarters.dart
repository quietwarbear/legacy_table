import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';

/// Celebration Headquarters widget — mirrors the website's seasonal section.
/// Shows current season, upcoming holidays, and recipe counts per holiday.
class CelebrationHeadquarters extends StatefulWidget {
  const CelebrationHeadquarters({super.key});

  @override
  State<CelebrationHeadquarters> createState() =>
      _CelebrationHeadquartersState();
}

class _CelebrationHeadquartersState extends State<CelebrationHeadquarters> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHolidays();
  }

  Future<void> _loadHolidays() async {
    try {
      final response =
          await apiService.apiClient.get('/holidays');
      if (mounted) {
        setState(() {
          _data = Map<String, dynamic>.from(response.data as Map);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading holidays: $e');
      }
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    if (_isLoading || _data == null) {
      return const SizedBox.shrink();
    }

    final upcoming = (_data!['upcoming'] as List?) ?? [];
    final season = _data!['season'] as String? ?? '';
    final seasonTheme =
        _data!['season_theme'] as Map<String, dynamic>? ?? {};
    final holidayRecipeCounts =
        (_data!['holiday_recipe_counts'] as Map<String, dynamic>?) ?? {};

    if (upcoming.isEmpty) return const SizedBox.shrink();

    final nextHoliday = upcoming[0] as Map<String, dynamic>;
    final gradientColors = (seasonTheme['gradient'] as List?)
            ?.map((c) => _parseColor(c.toString()))
            .toList() ??
        [brandSecondary.withValues(alpha: 0.2), brandSecondary.withValues(alpha: 0.1)];
    final seasonLabel = seasonTheme['label'] as String? ?? season;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Season Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradientColors.length >= 2
                    ? gradientColors
                    : [brandSecondary.withValues(alpha: 0.2), brandSecondary.withValues(alpha: 0.1)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 18,
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Celebration Headquarters',
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DarkColors.textPrimary
                            : LightColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      seasonLabel,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary,
                      ),
                    ),
                    Text(
                      ' — Next up: ',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${nextHoliday['emoji'] ?? ''} ${nextHoliday['name'] ?? ''} in ${nextHoliday['days_away'] ?? '?'} day${(nextHoliday['days_away'] ?? 0) != 1 ? 's' : ''}',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? DarkColors.textPrimary
                              : LightColors.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? DarkColors.border
                            : LightColors.border,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      season[0].toUpperCase() + season.substring(1),
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Upcoming holidays cards
          SizedBox(
            height: 95,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: upcoming.length > 3 ? 3 : upcoming.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final h = upcoming[index] as Map<String, dynamic>;
                final recipeCount =
                    holidayRecipeCounts[h['name']]?.toString() ?? '0';
                return Container(
                  width: 160,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:
                        isDark ? DarkColors.surface : LightColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color:
                          isDark ? DarkColors.border : LightColors.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            h['emoji']?.toString() ?? '',
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              h['name']?.toString() ?? '',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? DarkColors.textPrimary
                                    : LightColors.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${h['days_away']} day${(h['days_away'] ?? 0) != 1 ? 's' : ''} away  •  $recipeCount recipes',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 11,
                          color: isDark
                              ? DarkColors.textMuted
                              : LightColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      hex = hex.replaceFirst('#', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    } catch (_) {
      return brandSecondary;
    }
  }
}
