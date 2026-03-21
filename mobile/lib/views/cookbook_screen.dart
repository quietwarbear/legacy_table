
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../models/recipe.dart';
import '../widgets/cookbook_recipe_card.dart';
import '../widgets/cookbook_recipe_card_shimmer.dart';
import '../services/api_service.dart';
import '../services/pdf_service.dart';
import '../widgets/styled_snackbar.dart';

class CookbookScreen extends StatefulWidget {
  const CookbookScreen({super.key});

  @override
  State<CookbookScreen> createState() => _CookbookScreenState();
}

class _CookbookScreenState extends State<CookbookScreen> {
  final Set<String> _selectedRecipeIds = {};
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  final PdfService _pdfService = PdfService();

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  } 

  Future<void> _loadRecipes() async {
    if (kDebugMode) {
      print('Loading cookbook recipes from API...');
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API to get all recipes for cookbook
      final recipes = await apiService.recipes.getRecipes();
      
      if (kDebugMode) {
        print('Cookbook recipes loaded: ${recipes.length} recipes');
      }
      
      setState(() {
        _isLoading = false;
        _recipes = recipes;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading cookbook recipes: $e');
      }
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        StyledSnackBar.showError(context, 'Failed to load recipes. Please try again.');
      }
    }
  }

  void refreshRecipes() {
    if (kDebugMode) {
      print('Refreshing cookbook recipes - calling API...');
    }
    _loadRecipes();
  }

  void _toggleRecipeSelection(String recipeId) {
    setState(() {
      if (_selectedRecipeIds.contains(recipeId)) {
        _selectedRecipeIds.remove(recipeId);
      } else {
        _selectedRecipeIds.add(recipeId);
      }
    });
  }

  void _deselectAll() {
    setState(() {
      _selectedRecipeIds.clear();
    });
  }

  Future<void> _exportPDF() async {
    if (_selectedRecipeIds.isEmpty) {
      StyledSnackBar.showWarning(context, 'Please select at least one recipe');
      return;
    }

    try {
      // Get selected recipes
      final selectedRecipes = _recipes
          .where((recipe) => _selectedRecipeIds.contains(recipe.id))
          .toList();

      String? progressMessage;
      // Show progress dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      progressMessage ?? 'Generating PDF...',
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Generate PDF bytes
      final pdfBytes = await _pdfService.generateCookbookPDF(
        recipes: selectedRecipes,
        onProgress: (message) {
          if (kDebugMode) {
            print('PDF Generation Progress: $message');
          }
        },
      );

      // Close progress dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show action dialog (Download, Share, Preview)
      await _showPDFActionDialog(pdfBytes, selectedRecipes.length);
    } catch (e) {
      // Close progress dialog if still open
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        String errorMessage = 'Failed to generate PDF';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  Future<void> _showPDFActionDialog(Uint8List pdfBytes, int recipeCount) async {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    // Generate filename with timestamp
    final now = DateTime.now();
    final timestamp = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_'
        '${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';
    final fileName = 'Family_Cookbook_$timestamp.pdf';

    if (!mounted) return;

    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          'PDF Generated Successfully!',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: Text(
          'Your cookbook with $recipeCount recipe${recipeCount == 1 ? '' : 's'} is ready. What would you like to do?',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        actions: [
          // Download/Save button
          TextButton.icon(
            onPressed: () => Navigator.pop(context, 'save'),
            icon: Icon(Icons.download, color: brandPrimary),
            label: Text(
              'Save to Device',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: brandPrimary,
              ),
            ),
          ),
          // Share button
          TextButton.icon(
            onPressed: () => Navigator.pop(context, 'share'),
            icon: Icon(Icons.share, color: brandPrimary),
            label: Text(
              'Share',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: brandPrimary,
              ),
            ),
          ),
          // Preview/Print button
          TextButton.icon(
            onPressed: () => Navigator.pop(context, 'preview'),
            icon: Icon(Icons.preview, color: brandPrimary),
            label: Text(
              'Preview/Print',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: brandPrimary,
              ),
            ),
          ),
          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );

    if (action == null || !mounted) return;

    try {
      switch (action) {
        case 'save':
          // Show saving dialog
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => PopScope(
                canPop: false,
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      const Text(
                        'Saving PDF...',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          await _pdfService.savePDFToDevice(pdfBytes, fileName);

          // Close saving dialog
          if (mounted) {
            Navigator.of(context).pop();
          }

          if (mounted) {
            StyledSnackBar.showSuccess(
              context,
              'PDF saved successfully to Downloads folder!',
            );
          }
          break;

        case 'share':
          // Share PDF
          await _pdfService.sharePDF(pdfBytes, fileName);

          if (mounted) {
            StyledSnackBar.showSuccess(context, 'PDF shared successfully!');
          }
          break;

        case 'preview':
          // Preview/Print PDF
          await _pdfService.previewPDF(pdfBytes);
          break;
      }
    } catch (e) {
      // Close any open dialogs
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        String errorMessage = 'Failed to ${action == 'save' ? 'save' : action == 'share' ? 'share' : 'preview'} PDF';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final selectedCount = _selectedRecipeIds.length;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Family Cookbook',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Select recipes to create a printable PDF cookbook',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
          ],
        ),
        backgroundColor: isDark ? DarkColors.background : LightColors.background,
        elevation: 0,
        actions: [
          if (selectedCount > 0)
            TextButton(
              onPressed: _deselectAll,
              child: Text(
                'Clear',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Selection Status Bar with Export Button
          if (selectedCount > 0)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: brandPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: brandPrimary.withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: brandPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SvgPicture.asset(
                          'assets/icons/BookOpen.svg',
                          width: 20,
                          height: 20,
                          colorFilter: ColorFilter.mode(
                            brandPrimary,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$selectedCount recipe${selectedCount == 1 ? '' : 's'} selected',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Ready to create your cookbook',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _exportPDF,
                      icon: SvgPicture.asset(
                        'assets/icons/Download.svg',
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      ),
                      label: Text(
                        'Export PDF Cookbook',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Recipe Grid
          Expanded(
            child: _isLoading
                ? GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.77,
                    ),
                    itemCount: 6, // Show 6 shimmer cards
                    itemBuilder: (context, index) {
                      return const CookbookRecipeCardShimmer();
                    },
                  )
                : _recipes.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.menu_book,
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
                              'Add recipes to create your cookbook',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 16,
                                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: _recipes.length,
                        itemBuilder: (context, index) {
                          final recipe = _recipes[index];
                          return CookbookRecipeCard(
                            recipe: recipe,
                            isSelected: _selectedRecipeIds.contains(recipe.id),
                            onTap: () => _toggleRecipeSelection(recipe.id),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
