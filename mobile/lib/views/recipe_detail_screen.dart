import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../models/comment.dart';
import '../models/recipe.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../widgets/styled_snackbar.dart';
import 'add_recipe_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;
  final Recipe? recipe; // Optional - if passed, use it, otherwise fetch

  const RecipeDetailScreen({super.key, required this.recipeId, this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Recipe? _recipe;
  List<Comment> _comments = [];
  bool _isLoading = true;
  bool _isLoadingComments = false;
  bool _isSubmittingComment = false;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PageController _imagePageController = PageController();
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.recipe != null) {
      _recipe = widget.recipe;
      _isLoading = false;
    } else {
      _loadRecipe();
    }
    _loadComments();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipe() async {
    try {
      final recipe = await apiService.recipes.getRecipeById(widget.recipeId);
      setState(() {
        _recipe = recipe;
        _isLoading = false;
        _currentImageIndex = 0; // Reset to first image
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        StyledSnackBar.showError(
          context,
          'Failed to load recipe. Please try again.',
        );
      }
    }
  }

  Future<void> _loadComments() async {
    setState(() {
      _isLoadingComments = true;
    });

    try {
      if (kDebugMode) {
        print('Loading comments for recipe: ${widget.recipeId}');
      }

      final comments = await apiService.comments.getComments(widget.recipeId);

      if (kDebugMode) {
        print('Comments loaded: ${comments.length} comments');
      }

      // Sort comments by creation date (newest first)
      comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));

      setState(() {
        _comments = comments;
        _isLoadingComments = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading comments: $e');
      }
      setState(() {
        _isLoadingComments = false;
      });
      if (mounted) {
        StyledSnackBar.showError(
          context,
          'Failed to load comments. Please try again.',
        );
      }
    }
  }

  Future<void> _submitComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    // Check if user is logged in
    if (!sessionManager.isLoggedIn) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please log in to post a comment'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isSubmittingComment = true;
    });

    try {
      if (kDebugMode) {
        print('Submitting comment: $text');
      }

      final comment = await apiService.comments.createComment(
        widget.recipeId,
        CreateCommentRequest(text: text),
      );

      if (kDebugMode) {
        print('Comment submitted successfully');
      }

      // Add new comment at the beginning (newest first)
      setState(() {
        _comments = [comment, ..._comments];
        _commentController.clear();
        _isSubmittingComment = false;
      });

      // Show success message
      if (mounted) {
        StyledSnackBar.showSuccess(context, 'Comment posted successfully!');
      }

      // Scroll to show the new comment
      if (_scrollController.hasClients) {
        await Future.delayed(const Duration(milliseconds: 100));
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting comment: $e');
      }
      setState(() {
        _isSubmittingComment = false;
      });
      if (mounted) {
        String errorMessage = 'Failed to post comment';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = 'Failed to post comment: ${e.toString()}';
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  Future<void> _deleteComment(String commentId) async {
    // Check if user is logged in
    if (!sessionManager.isLoggedIn) {
      return;
    }

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Comment'),
        content: const Text('Are you sure you want to delete this comment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (kDebugMode) {
        print('Deleting comment: $commentId');
      }

      await apiService.comments.deleteComment(commentId);

      // Remove comment from list
      setState(() {
        _comments = _comments.where((c) => c.id != commentId).toList();
      });

      if (mounted) {
        StyledSnackBar.showSuccess(context, 'Comment deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting comment: $e');
      }
      if (mounted) {
        String errorMessage = 'Failed to delete comment';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = 'Failed to delete comment: ${e.toString()}';
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  Future<void> _editRecipe() async {
    if (_recipe == null) return;

    // Navigate to edit recipe screen
    final result = await Navigator.of(context).push<Recipe>(
      MaterialPageRoute(builder: (context) => AddRecipeScreen(recipe: _recipe)),
    );

    // If recipe was updated, reload it
    if (result != null && mounted) {
      setState(() {
        _recipe = result;
      });
      StyledSnackBar.showSuccess(context, 'Recipe updated successfully!');
    }
  }

  Future<void> _deleteRecipe() async {
    if (_recipe == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Recipe'),
        content: Text(
          'Are you sure you want to delete "${_recipe!.title}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      if (kDebugMode) {
        print('Deleting recipe: ${_recipe!.id}');
      }

      await apiService.recipes.deleteRecipe(_recipe!.id);

      if (mounted) {
        StyledSnackBar.showSuccess(context, 'Recipe deleted successfully');
        // Navigate back to previous screen
        Navigator.of(
          context,
        ).pop(true); // Pass true to indicate recipe was deleted
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting recipe: $e');
      }
      if (mounted) {
        String errorMessage = 'Failed to delete recipe';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else {
          errorMessage = 'Failed to delete recipe: ${e.toString()}';
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  Color _getDifficultyColor(String? difficulty) {
    switch (difficulty?.toLowerCase()) {
      case 'easy':
        return const Color(0xFF22C55E); // Green
      case 'medium':
        return const Color(0xFFF59E0B); // Orange/Amber
      case 'hard':
        return const Color(0xFFEF4444); // Red
      default:
        return const Color(0xFF6B7280); // Gray
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final secondaryTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;
    final surfaceColor = isDark ? DarkColors.surface : LightColors.surface;
    final borderColor = isDark ? DarkColors.border : LightColors.border;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_recipe == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: secondaryTextColor),
              const SizedBox(height: 16),
              Text(
                'Recipe not found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeroImage(isDark),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Meta Info
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        _recipe!.title,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontFamily: 'Playfair Display',
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Author and Difficulty
                      Row(
                        children: [
                          // Author
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: brandPrimary.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.person,
                                    size: 18,
                                    color: brandPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Shared by',
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: secondaryTextColor,
                                              fontFamily: 'Manrope',
                                            ),
                                      ),
                                      Text(
                                        _recipe!.authorName ?? 'Unknown',
                                        style: theme.textTheme.bodyMedium
                                            ?.copyWith(
                                              fontFamily: 'Manrope',
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Difficulty Badge
                          if (_recipe!.difficulty != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(
                                  _recipe!.difficulty,
                                ).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getDifficultyColor(
                                    _recipe!.difficulty,
                                  ),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: _getDifficultyColor(
                                        _recipe!.difficulty,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    _recipe!.difficulty!.toUpperCase(),
                                    style: TextStyle(
                                      color: _getDifficultyColor(
                                        _recipe!.difficulty,
                                      ),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Manrope',
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Edit and Delete Buttons (only for recipe owner)
                      if (sessionManager.isLoggedIn &&
                          sessionManager.currentUser?.id == _recipe!.authorId)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: _editRecipe,
                                icon: const Icon(Icons.edit_outlined, size: 18),
                                label: const Text('Edit'),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: _deleteRecipe,
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                                label: const Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                // Recipe Stats Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      if (_recipe!.cookingTime != null)
                        Expanded(
                          child: _StatCard(
                            icon: Icons.access_time_rounded,
                            label: 'Time',
                            value: '${_recipe!.cookingTime} min',
                            isDark: isDark,
                          ),
                        ),
                      if (_recipe!.cookingTime != null &&
                          _recipe!.servings != null)
                        const SizedBox(width: 12),
                      if (_recipe!.servings != null)
                        Expanded(
                          child: _StatCard(
                            icon: Icons.people_rounded,
                            label: 'Serves',
                            value: '${_recipe!.servings}',
                            isDark: isDark,
                          ),
                        ),
                      if (_recipe!.servings != null &&
                          _recipe!.category != null)
                        const SizedBox(width: 12),
                      if (_recipe!.category != null)
                        Expanded(
                          child: _StatCard(
                            icon: Icons.restaurant_menu_rounded,
                            label: 'Category',
                            value: _recipe!.category!,
                            isDark: isDark,
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Ingredients Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: brandPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.shopping_basket_rounded,
                              color: brandPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Ingredients',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _recipe!.ingredients.asMap().entries.map((
                            entry,
                          ) {
                            final index = entry.key;
                            final ingredient = entry.value;
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: index == _recipe!.ingredients.length - 1
                                    ? 0
                                    : 16,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                      top: 6,
                                      right: 12,
                                    ),
                                    width: 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color: brandPrimary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      ingredient,
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                            fontFamily: 'Manrope',
                                            height: 1.6,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Instructions Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: brandSecondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.menu_book_rounded,
                              color: brandSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Instructions',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Text(
                          _recipe!.instructions,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontFamily: 'Manrope',
                            height: 1.8,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Story Section
                if (_recipe!.story != null && _recipe!.story!.isNotEmpty) ...[
                  const SizedBox(height: 40),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [
                                brandAccent.withValues(alpha: 0.15),
                                brandPrimary.withValues(alpha: 0.1),
                              ]
                            : [
                                brandAccent.withValues(alpha: 0.1),
                                brandPrimary.withValues(alpha: 0.05),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: brandAccent.withValues(alpha: 0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.favorite_rounded,
                              color: brandPrimary,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'The Story Behind This Recipe',
                                maxLines: 3,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontFamily: 'Playfair Display',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _recipe!.story!,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontFamily: 'Manrope',
                            height: 1.8,
                            fontStyle: FontStyle.italic,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: brandPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Shared by ${_recipe!.authorName ?? 'Unknown'}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: brandPrimary,
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 40),

                // Comments Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: brandSecondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.chat_bubble_outline_rounded,
                              color: brandSecondary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Family Comments',
                                    maxLines: 2,
                                    style: theme.textTheme.headlineMedium
                                        ?.copyWith(
                                          fontFamily: 'Playfair Display',
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: brandPrimary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${_comments.length}',
                                    style: TextStyle(
                                      color: brandPrimary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Manrope',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: _isLoadingComments
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(
                                    Icons.refresh_rounded,
                                    color: secondaryTextColor,
                                  ),
                            onPressed: _isLoadingComments
                                ? null
                                : _loadComments,
                            tooltip: 'Refresh comments',
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Comment Input
                      Container(
                        decoration: BoxDecoration(
                          color: surfaceColor,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: borderColor, width: 1),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: _commentController,
                              maxLines: 3,
                              enabled:
                                  !_isSubmittingComment &&
                                  sessionManager.isLoggedIn,
                              onChanged: (value) => setState(
                                () {},
                              ), // Update UI when text changes
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontFamily: 'Manrope',
                              ),
                              decoration: InputDecoration(
                                hintText: sessionManager.isLoggedIn
                                    ? 'Share your thoughts about this recipe...'
                                    : 'Please log in to post a comment',
                                hintStyle: TextStyle(
                                  color: secondaryTextColor,
                                  fontFamily: 'Manrope',
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.all(20),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color: borderColor, width: 1),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (_commentController.text.isNotEmpty)
                                    TextButton(
                                      onPressed: _isSubmittingComment
                                          ? null
                                          : () => _commentController.clear(),
                                      child: Text(
                                        'Clear',
                                        style: TextStyle(
                                          color: secondaryTextColor,
                                          fontFamily: 'Manrope',
                                        ),
                                      ),
                                    ),
                                  if (_commentController.text.isNotEmpty)
                                    const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed:
                                        (_isSubmittingComment ||
                                            !sessionManager.isLoggedIn ||
                                            _commentController.text
                                                .trim()
                                                .isEmpty)
                                        ? null
                                        : _submitComment,
                                    icon: _isSubmittingComment
                                        ? const SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.send_rounded,
                                            size: 18,
                                          ),
                                    label: Text(
                                      _isSubmittingComment
                                          ? 'Posting...'
                                          : 'Post',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: brandPrimary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Comments List
                      if (_isLoadingComments)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      else if (_comments.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: surfaceColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: borderColor, width: 1),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 48,
                                  color: secondaryTextColor,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No comments yet',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Be the first to share your thoughts!',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: secondaryTextColor,
                                    fontFamily: 'Manrope',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        ..._comments.map((comment) {
                          return _CommentCard(
                            comment: comment,
                            secondaryTextColor: secondaryTextColor,
                            surfaceColor: surfaceColor,
                            borderColor: borderColor,
                            theme: theme,
                            onDelete: () => _deleteComment(comment.id),
                            canDelete:
                                sessionManager.isLoggedIn &&
                                sessionManager.currentUser?.id ==
                                    comment.authorId,
                          );
                        }),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openFullScreenGallery(int initialIndex) {
    if (_recipe?.photos == null || _recipe!.photos!.isEmpty) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenGalleryView(
          photos: _recipe!.photos!,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  Widget _buildHeroImage(bool isDark) {
    if (_recipe!.photos != null && _recipe!.photos!.isNotEmpty) {
      final photos = _recipe!.photos!;
      final hasMultipleImages = photos.length > 1;

      return GestureDetector(
        onTap: () => _openFullScreenGallery(_currentImageIndex),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // PageView for multiple images
            PageView.builder(
              controller: _imagePageController,
              onPageChanged: (index) {
                setState(() {
                  _currentImageIndex = index;
                });
              },
              itemCount: photos.length,
              itemBuilder: (context, index) {
                final photo = photos[index];
                return photo.startsWith('data:image')
                    ? Image.memory(
                        _decodeBase64(photo),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage(isDark);
                        },
                      )
                    : Image.network(
                        photo,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholderImage(isDark);
                        },
                      );
              },
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),
            // Page indicators (only show if multiple images)
            if (hasMultipleImages)
              Positioned(
                bottom: 16,

                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_currentImageIndex + 1} / ${photos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Manrope',
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ),
            // Image counter (only show if multiple images)
            // if (hasMultipleImages)
            //   Positioned(
            //     top: MediaQuery.of(context).padding.top,
            //     right: 16,
            //     child: Container(
            //       padding: const EdgeInsets.symmetric(
            //         horizontal: 12,
            //         vertical: 6,
            //       ),
            //       decoration: BoxDecoration(
            //         color: Colors.black.withValues(alpha: 0.6),
            //         borderRadius: BorderRadius.circular(20),
            //       ),
            //       child: Text(
            //         '${_currentImageIndex + 1} / ${photos.length}',
            //         style: const TextStyle(
            //           color: Colors.white,
            //           fontSize: 14,
            //           fontWeight: FontWeight.w600,
            //           fontFamily: 'Manrope',
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      );
    } else {
      return _buildPlaceholderImage(isDark);
    }
  }

  Widget _buildPlaceholderImage(bool isDark) {
    return Container(
      color: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 80,
              color: isDark ? DarkColors.textMuted : LightColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No image available',
              style: TextStyle(
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                fontFamily: 'Manrope',
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Uint8List _decodeBase64(String base64String) {
    try {
      // Remove data URI prefix if present
      final base64Data = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      return base64Decode(base64Data);
    } catch (e) {
      return Uint8List(0);
    }
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = isDark ? DarkColors.surface : LightColors.surface;
    final borderColor = isDark ? DarkColors.border : LightColors.border;
    final secondaryTextColor = isDark
        ? DarkColors.textSecondary
        : LightColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: brandPrimary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: brandPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: secondaryTextColor,
              fontFamily: 'Manrope',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CommentCard extends StatelessWidget {
  final Comment comment;
  final Color secondaryTextColor;
  final Color surfaceColor;
  final Color borderColor;
  final ThemeData theme;
  final VoidCallback? onDelete;
  final bool canDelete;

  const _CommentCard({
    required this.comment,
    required this.secondaryTextColor,
    required this.surfaceColor,
    required this.borderColor,
    required this.theme,
    this.onDelete,
    this.canDelete = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: brandPrimary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (comment.authorName ?? 'U')[0].toUpperCase(),
                    style: TextStyle(
                      color: brandPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Manrope',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment.authorName ?? 'Unknown',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontFamily: 'Manrope',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (canDelete && onDelete != null)
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              size: 18,
                              color: secondaryTextColor,
                            ),
                            onPressed: onDelete,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            tooltip: 'Delete comment',
                          ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatDate(comment.createdAt),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: secondaryTextColor,
                        fontFamily: 'Manrope',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            comment.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontFamily: 'Manrope',
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
      }
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class FullScreenGalleryView extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;

  const FullScreenGalleryView({
    super.key,
    required this.photos,
    required this.initialIndex,
  });

  @override
  State<FullScreenGalleryView> createState() => _FullScreenGalleryViewState();
}

class _FullScreenGalleryViewState extends State<FullScreenGalleryView> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Uint8List _decodeBase64(String base64String) {
    try {
      final base64Data = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      return base64Decode(base64Data);
    } catch (e) {
      return Uint8List(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} / ${widget.photos.length}',
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: widget.photos.length,
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              return Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: photo.startsWith('data:image')
                      ? Image.memory(
                          _decodeBase64(photo),
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 64,
                              ),
                            );
                          },
                        )
                      : Image.network(
                          photo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 64,
                              ),
                            );
                          },
                        ),
                ),
              );
            },
          ),
          // Page indicators at the bottom
          if (widget.photos.length > 1)
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.photos.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
