import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../models/recipe.dart';

class CookbookRecipeCard extends StatelessWidget {
  final Recipe recipe;
  final bool isSelected;
  final VoidCallback onTap;

  const CookbookRecipeCard({
    super.key,
    required this.recipe,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: isDark ? DarkColors.surface : LightColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image with Selection Indicator
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: _buildRecipeImage(isDark),
                ),
                // Selection Indicator
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isSelected ? brandPrimary : Colors.transparent,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? brandPrimary : Colors.white,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 18,
                          )
                        : null,
                  ),
                ),
              ],
            ),
Spacer(),
            // Recipe Content
            Align(child:Container(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Difficulty
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            recipe.title,
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        _buildDifficultyTag(recipe.difficulty, isDark),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Cooking Time and Servings
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (recipe.cookingTime != null)
                          _buildMetaItem(
                            icon: Icons.access_time,
                            text: '${recipe.cookingTime} min',
                            isDark: isDark,
                          ),
                        if (recipe.servings != null)
                          _buildMetaItem(
                            icon: Icons.people_outline,
                            text: '${recipe.servings} servings',
                            isDark: isDark,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Category and Author in a Row
                    Row(
                      children: [
                        if (recipe.category != null) ...[
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              decoration: BoxDecoration(
                                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                recipe.category!,
                                style: const TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (recipe.authorName != null) const SizedBox(width: 6),
                        ],
                        if (recipe.authorName != null)
                          Expanded(
                            child: Text(
                              'by ${recipe.authorName!}',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                 fontSize: 10,
                                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeImage(bool isDark) {
    final firstPhoto = recipe.photos != null && recipe.photos!.isNotEmpty
        ? recipe.photos!.first
        : null;

    if (firstPhoto != null) {
      // Check if it's a base64 encoded image or a URL
      if (firstPhoto.startsWith('data:image') || 
          (firstPhoto.length > 100 && !firstPhoto.startsWith('http'))) {
        // Base64 encoded image
        try {
          final base64Data = firstPhoto.contains(',')
              ? firstPhoto.split(',').last
              : firstPhoto;
          final imageBytes = base64Decode(base64Data);
          
          return Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
            ),
            child: Image.memory(
              imageBytes,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder(isDark);
              },
            ),
          );
        } catch (e) {
          // If base64 decode fails, show placeholder
          return _buildPlaceholder(isDark);
        }
      } else if (firstPhoto.startsWith('http://') || firstPhoto.startsWith('https://')) {
        // Network image
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            color: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
          ),
          child: Image.network(
            firstPhoto,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                    color: brandPrimary,
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return _buildPlaceholder(isDark);
            },
          ),
        );
      }
    }

    return _buildPlaceholder(isDark);
  }

  Widget _buildPlaceholder(bool isDark) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/Utensils.svg',
          width: 48,
          height: 48,
          colorFilter: ColorFilter.mode(
            isDark ? DarkColors.textMuted : LightColors.textMuted,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyTag(String? difficulty, bool isDark) {
    if (difficulty == null) return const SizedBox.shrink();

    Color backgroundColor;
    Color textColor;

    switch (difficulty.toUpperCase()) {
      case 'EASY':
        backgroundColor = const Color(0xFF4CAF50); // Green
        textColor = Colors.white;
        break;
      case 'MEDIUM':
        backgroundColor = const Color(0xFFFFC107); // Yellow/Amber
        textColor = const Color(0xFFF57C00); // Dark orange
        break;
      case 'HARD':
        backgroundColor = const Color(0xFFF44336); // Red
        textColor = Colors.white;
        break;
      default:
        backgroundColor = isDark ? DarkColors.textMuted : LightColors.textMuted;
        textColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        difficulty.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 11,
            color: isDark ? DarkColors.textMuted : LightColors.textMuted,
          ),
        ),
      ],
    );
  }
}
