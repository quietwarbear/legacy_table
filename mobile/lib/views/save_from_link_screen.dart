import 'package:flutter/material.dart';

import '../config/app_theme.dart';
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
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      StyledSnackBar.showWarning(
        context,
        'Paste a cooking video or recipe link first',
      );
      return;
    }

    setState(() {
      _isImporting = true;
    });

    try {
      final draft = await apiService.ai.saveFromLink(url);
      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AddRecipeScreen(initialDraft: draft),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Save From Link')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Paste a TikTok, Instagram, YouTube, or recipe link and turn it into a shareable Legacy Table draft.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
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
                'The imported recipe opens as a draft first, so you can clean up ingredients, adjust instructions, and add your own story before sharing it.',
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
                  _isImporting ? 'Importing...' : 'Create Draft From Link',
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
