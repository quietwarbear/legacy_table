import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_card_shimmer.dart';
import '../widgets/family_prompt_widget.dart';
import 'recipe_detail_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<Recipe> _recipes = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMyRecipes();
  }

  Future<void> _loadMyRecipes() async {
    if (!sessionManager.isLoggedIn) return;

    if (kDebugMode) {
      print('Loading my recipes from API...');
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = sessionManager.currentUser?.id;
      if (userId == null) {
        if (kDebugMode) {
          print('User ID is null, cannot load recipes');
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }

      if (kDebugMode) {
        print('Calling API: GET /api/recipes?author_id=$userId');
      }
      
      final recipes = await apiService.recipes.getRecipes(authorId: userId);
      
      if (kDebugMode) {
        print('My recipes loaded: ${recipes.length} recipes');
      }
      
      setState(() {
        _isLoading = false;
        _recipes = recipes;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading my recipes: $e');
      }
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load recipes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void refreshMyRecipes() {
    if (kDebugMode) {
      print('Refreshing my recipes - calling API...');
    }
    _loadMyRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        backgroundColor: isDark ? DarkColors.background : LightColors.background,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadMyRecipes,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMyRecipes,
        child: (!sessionManager.isLoggedIn || 
                sessionManager.currentUser?.hasFamily != true)
            ? SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    FamilyPromptWidget(
                      onFamilyJoined: () {
                        // Refresh recipes after joining family
                        _loadMyRecipes();
                      },
                    ),
                  ],
                ),
              )
            : _isLoading
            ? ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: 5, // Show 5 shimmer cards
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == 4 ? 0 : 16,
                    ),
                    child: const RecipeCardShimmer(),
                  );
                },
              )
            : _recipes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No recipes yet',
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Share your first family recipe!',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _recipes[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: RecipeCard(
                          recipe: recipe,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailScreen(
                                  recipeId: recipe.id,
                                  recipe: recipe,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
