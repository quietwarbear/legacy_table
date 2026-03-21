import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final VoidCallback? onTap;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? DarkColors.border : LightColors.border,
          width: 1,
        ),
      ),
      color: isDark ? DarkColors.surface : LightColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _buildRecipeImage(isDark),
            ),

            // Recipe Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    recipe.title,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Meta Information
                  Row(
                    children: [
                      if (recipe.cookingTime != null) ...[
                        _buildMetaItem(
                          icon: 'assets/icons/Clock.svg',
                          text: '${recipe.cookingTime} min',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (recipe.servings != null) ...[
                        _buildMetaItem(
                          icon: 'assets/icons/Users.svg',
                          text: '${recipe.servings} servings',
                          isDark: isDark,
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (recipe.difficulty != null)
                        _buildMetaItem(
                          icon: 'assets/icons/Flame.svg',
                          text: recipe.difficulty!,
                          isDark: isDark,
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Category Chip
                  if (recipe.category != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? DarkColors.chipBackground : LightColors.chipBackground,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        recipe.category!,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                        ),
                      ),
                    ),

                  // Author
                  if (recipe.authorName != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 16,
                          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          recipe.authorName!,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 12,
                            color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
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
            height: 200,
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
        // URL-based image
        return Container(
          height: 200,
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
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
      ),
      child: Center(
        child: Icon(
          Icons.restaurant_menu,
          size: 48,
          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildMetaItem({
    required String icon,
    required String text,
    required bool isDark,
  }) {
    return Row(
      children: [
        SvgPicture.asset(
          icon,
          width: 16,
          height: 16,
          colorFilter: ColorFilter.mode(
            isDark ? DarkColors.textMuted : LightColors.textMuted,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 12,
            color: isDark ? DarkColors.textMuted : LightColors.textMuted,
          ),
        ),
      ],
    );
  }
}
