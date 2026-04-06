import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_card_shimmer.dart';
import 'recipe_detail_screen.dart';

class HolidayRecipesScreen extends StatefulWidget {
  final String holidayName;

  const HolidayRecipesScreen({super.key, required this.holidayName});

  @override
  State<HolidayRecipesScreen> createState() => _HolidayRecipesScreenState();
}

class _HolidayRecipesScreenState extends State<HolidayRecipesScreen> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    try {
      final recipes = await apiService.holidays.getHolidayRecipes(
        widget.holidayName,
      );
      if (!mounted) return;
      setState(() {
        _recipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(widget.holidayName)),
      body: _isLoading
          ? ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (_, __) => const RecipeCardShimmer(),
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemCount: 4,
            )
          : _recipes.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.celebration_outlined,
                      size: 56,
                      color: brandPrimary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No recipes tagged for ${widget.holidayName} yet',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tag a family favorite for this holiday from the web app or upcoming mobile detail enhancements.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(24),
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return RecipeCard(
                  recipe: recipe,
                  onTap: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => RecipeDetailScreen(
                          recipeId: recipe.id,
                          recipe: recipe,
                        ),
                      ),
                    );
                    if (result == true && mounted) {
                      _loadRecipes();
                    }
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemCount: _recipes.length,
            ),
    );
  }
}
