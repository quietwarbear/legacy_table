import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../models/recipe.dart';
import '../widgets/recipe_card.dart';
import '../widgets/recipe_card_shimmer.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../widgets/family_prompt_widget.dart';
import 'recipe_detail_screen.dart';
import 'notifications_screen.dart';

class RecipeFeedScreen extends StatefulWidget {
  const RecipeFeedScreen({super.key});

  @override
  State<RecipeFeedScreen> createState() => _RecipeFeedScreenState();
}

class _RecipeFeedScreenState extends State<RecipeFeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _recipes = [];
  List<Category> _categories = [];
  bool _isLoading = false;
  bool _isLoadingCategories = false;
  String _searchQuery = '';
  String? _selectedCategory; // null means "All"
  int _unreadNotificationCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadRecipes();
    _loadUnreadNotificationCount();
  }

  Future<void> _loadUnreadNotificationCount() async {
    try {
      final response = await apiService.notifications.getUnreadCount();
      setState(() {
        _unreadNotificationCount = response.count;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading unread notification count: $e');
      }
    }
  }

  Future<void> _openNotifications() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const NotificationsScreen(),
      ),
    );
    _loadUnreadNotificationCount();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    if (kDebugMode) {
      print('Loading categories from API...');
    }
    
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final categories = await apiService.recipes.getCategories();
      
      if (kDebugMode) {
        print('Categories loaded: ${categories.length} categories');
      }
      
      setState(() {
        _isLoadingCategories = false;
        _categories = categories;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading categories: $e');
      }
      setState(() {
        _isLoadingCategories = false;
      });
    }
  }

  Future<void> _loadRecipes() async {
    if (kDebugMode) {
      print('Loading recipes from API...');
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      final recipes = await apiService.recipes.getRecipes(
        category: _selectedCategory,
      );
      
      if (kDebugMode) {
        print('Recipes loaded: ${recipes.length} recipes (category: $_selectedCategory)');
      }
      
      setState(() {
        _isLoading = false;
        _recipes = recipes;
      });
      // Also refresh notification count when recipes load
      _loadUnreadNotificationCount();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading recipes: $e');
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

  void _onCategorySelected(String? category) {
    setState(() {
      _selectedCategory = category;
    });
    _loadRecipes();
  }

  // Public method to refresh recipes from outside
  // This will call the API to get the latest recipes
  void refreshRecipes() {
    if (kDebugMode) {
      print('Refreshing recipes - calling API...');
    }
    _loadRecipes();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    // Client-side filtering for now
    // TODO: Implement server-side search if API supports it
  }

  List<Recipe> get _filteredRecipes {
    if (_searchQuery.isEmpty) {
      return _recipes;
    }
    final query = _searchQuery.toLowerCase();
    return _recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(query) ||
          (recipe.category != null && recipe.category!.toLowerCase().contains(query)) ||
          (recipe.authorName != null && recipe.authorName!.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await _loadRecipes();
            await _loadUnreadNotificationCount();
          },
          color: brandPrimary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Family Recipes',
                                  style: TextStyle(
                                    fontFamily: 'Playfair Display',
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Discover and share your favorite family dishes',
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 14,
                                    color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Notification Icon
                          IconButton(
                            onPressed: _openNotifications,
                            icon: Stack(
                              children: [
                                Icon(
                                  Icons.notifications_outlined,
                                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                                  size: 28,
                                ),
                                if (_unreadNotificationCount > 0)
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isDark ? DarkColors.background : LightColors.background,
                                          width: 2,
                                        ),
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth: 16,
                                        minHeight: 16,
                                      ),
                                      child: Text(
                                        _unreadNotificationCount > 99
                                            ? '99+'
                                            : '$_unreadNotificationCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Manrope',
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            tooltip: 'Notifications',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildSearchBar(isDark),
                ),
              ),

              // Category Filter
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: _buildCategoryFilter(isDark),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),

              // Family Prompt (if user has no family)
              if (!sessionManager.isLoggedIn || 
                  sessionManager.currentUser?.hasFamily != true)
                SliverToBoxAdapter(
                  child: FamilyPromptWidget(
                    onFamilyJoined: () {
                      // Refresh recipes after joining family
                      _loadRecipes();
                    },
                  ),
                ),

              // Recipe List
              if (_isLoading)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == 4 ? 24 : 20,
                          ),
                          child: const RecipeCardShimmer(),
                        );
                      },
                      childCount: 5, // Show 5 shimmer cards
                    ),
                  ),
                )
              else if (_filteredRecipes.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _buildEmptyState(isDark),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final recipe = _filteredRecipes[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == _filteredRecipes.length - 1 ? 24 : 20,
                          ),
                          child: RecipeCard(
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
                              // If recipe was deleted, refresh the list
                              if (result == true && mounted) {
                                _loadRecipes();
                              }
                            },
                          ),
                        );
                      },
                      childCount: _filteredRecipes.length,
                    ),
                  ),
                ), 
            ],
          ),
        ),
      ),
    ); 
  }

  Widget _buildSearchBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surface : LightColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? DarkColors.border : LightColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        style: TextStyle(
          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          fontFamily: 'Manrope',
          fontSize: 15,
        ),
        decoration: InputDecoration(
          hintText: 'Search recipes, ingredients, or categories...',
          hintStyle: TextStyle(
            color: isDark ? DarkColors.textMuted : LightColors.textMuted,
            fontFamily: 'Manrope',
            fontSize: 15,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(14),
            child: SvgPicture.asset(
              'assets/icons/Search.svg',
              width: 20,
              height: 20,
              colorFilter: ColorFilter.mode(
                isDark ? DarkColors.textMuted : LightColors.textMuted,
                BlendMode.srcIn,
              ),
            ),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                      color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                    ),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  ),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: brandPrimary,
              width: 2,
            ),
          ),
          filled: true,
          fillColor: isDark ? DarkColors.surface : LightColors.surface,
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDark) {
    if (_isLoadingCategories) {
      return const SizedBox(
        height: 40,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    return SizedBox(
      height: 40,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // "All" button
          _buildCategoryButton(
            label: 'All',
            isSelected: _selectedCategory == null,
            isDark: isDark,
            onTap: () => _onCategorySelected(null),
          ),
          const SizedBox(width: 8),
          // Category buttons
          ..._categories.map((category) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildCategoryButton(
                label: category.name,
                isSelected: _selectedCategory == category.name,
                isDark: isDark,
                onTap: () => _onCategorySelected(category.name),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryButton({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF396646) : const Color(0xFF396646))
              : (isDark 
                  ? DarkColors.surfaceMuted.withValues(alpha: 0.5)
                  : const Color(0xFFE0F2E5)),
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? null
              : Border.all(
                  color: isDark ? DarkColors.border : const Color(0xFFC8E6D3),
                  width: 1,
                ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark 
                      ? DarkColors.textPrimary 
                      : const Color(0xFF396646)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? DarkColors.surface : LightColors.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(
              _searchQuery.isNotEmpty ? Icons.search_off : Icons.restaurant_menu,
              size: 64,
              color: isDark ? DarkColors.textMuted : LightColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _searchQuery.isNotEmpty ? 'No recipes found' : 'No recipes yet',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or browse all recipes'
                : 'Share your first family recipe and start building your collection!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 16,
              height: 1.5,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: brandPrimary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Clear Search',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
