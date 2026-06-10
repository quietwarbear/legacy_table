import 'package:flutter/material.dart';

import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../widgets/styled_snackbar.dart';
import 'add_recipe_screen.dart';

class SaveFromLinkScreen extends StatefulWidget {
  const SaveFromLinkScreen({super.key});

  @override
  State<SaveFromLinkScreen> createState() => _SaveFromLinkScreenState();
}

class _SaveFromLinkScreenState extends State<SaveFromLinkScreen> {
  final TextEditingController _urlController = TextEditingController();
  bool _isImporting = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _importRecipe() async {
    final l10n = AppLocalizations.of(context);
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      StyledSnackBar.showWarning(
        context,
        l10n.saveFromLinkEmptyUrlWarning,
      );
      return;
    }

    // Basic URL validation
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      StyledSnackBar.showWarning(
        context,
        l10n.saveFromLinkInvalidUrlWarning,
      );
      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      final result = await apiService.ai.saveFromLink(url);

      if (!mounted) return;

      // Show success with credits remaining
      if (result.creditsRemaining != null) {
        StyledSnackBar.showSuccess(
          context,
          l10n.saveFromLinkImportSuccess(result.creditsRemaining!),
        );
      }

      // Navigate to AddRecipeScreen with the imported recipe pre-filled
      final recipe = result.recipe;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddRecipeScreen(
            recipe: null,
            initialTitle: recipe.title,
            initialIngredients: recipe.ingredients,
            initialInstructions: recipe.instructions,
            initialCookingTime: recipe.cookingTime,
            initialServings: recipe.servings,
            initialCategory: recipe.category,
            initialDifficulty: recipe.difficulty,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        StyledSnackBar.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isImporting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(l10n.saveFromLinkAppBarTitle)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.saveFromLinkIntro,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: brandPrimary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome, size: 16, color: brandPrimary),
                  const SizedBox(width: 8),
                  Text(
                    l10n.saveFromLinkCreditCost,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: brandPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _urlController,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(
                hintText: 'https://www.tiktok.com/@chef/video/...',
                filled: true,
                fillColor: isDark ? DarkColors.surface : LightColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: isDark ? DarkColors.border : LightColors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: brandPrimary, width: 2),
                ),
              ),
              minLines: 3,
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surface : LightColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: Text(
                l10n.saveFromLinkDraftInfo,
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isImporting ? null : _importRecipe,
                icon: _isImporting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.link_outlined),
                label: Text(
                  _isImporting
                      ? l10n.saveFromLinkImportingLabel
                      : l10n.saveFromLinkCreateDraftButton,
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
