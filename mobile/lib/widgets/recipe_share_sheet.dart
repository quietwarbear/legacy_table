import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../models/recipe.dart';
import '../services/analytics_service.dart';

/// Bottom sheet that shares a recipe outside the family — the app's main
/// external-visibility surface. Offers a rendered brand card (image) or
/// plain text; both carry the legacytable.app link.
///
/// The card intentionally shows the title + story, never the full method:
/// it's an invitation to the family table, not a recipe leak.
class RecipeShareSheet extends StatefulWidget {
  final Recipe recipe;

  const RecipeShareSheet({super.key, required this.recipe});

  static Future<void> show(BuildContext context, Recipe recipe) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecipeShareSheet(recipe: recipe),
    );
  }

  @override
  State<RecipeShareSheet> createState() => _RecipeShareSheetState();
}

class _RecipeShareSheetState extends State<RecipeShareSheet> {
  final GlobalKey _cardKey = GlobalKey();
  bool _sharing = false;

  String get _shareLink => 'https://legacytable.app';

  String get _shareText {
    final story = widget.recipe.story;
    final storyPart =
        (story != null && story.isNotEmpty) ? '\n\n"$story"' : '';
    return '${widget.recipe.title}$storyPart\n\n'
        'Preserved on Legacy Table — $_shareLink';
  }

  Future<void> _shareAsText() async {
    await Share.share(_shareText);
    await analytics.capture('recipe_shared', {'format': 'text'});
    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _shareAsCard() async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final boundary = _cardKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/legacy_table_${widget.recipe.id.substring(0, 8)}.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: _shareLink,
      );
      await analytics.capture('recipe_shared', {'format': 'card'});
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      // Sharing is best-effort; fall back silently to keeping the sheet open.
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? DarkColors.surface : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.shareRecipeTitle,
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color:
                    isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Card preview — this exact widget tree is what gets rasterized.
            Flexible(
              child: SingleChildScrollView(
                child: RepaintBoundary(
                  key: _cardKey,
                  child: RecipeShareCard(recipe: widget.recipe),
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _sharing ? null : _shareAsText,
                    icon: const Icon(Icons.notes, size: 18),
                    label: Text(l10n.shareRecipeAsText),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: brandPrimary,
                      side: BorderSide(color: brandPrimary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sharing ? null : _shareAsCard,
                    icon: _sharing
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.image_outlined, size: 18),
                    label: Text(l10n.shareRecipeAsCard),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
    );
  }
}

/// The rendered share card. Fixed brand-light palette regardless of app
/// theme so shared images are consistent everywhere they land.
/// Public so the raster path is coverable by widget tests.
class RecipeShareCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeShareCard({super.key, required this.recipe});

  static const _cream = Color(0xFFF8F5F1);
  static const _ink = Color(0xFF2B2B2B);
  static const _inkSoft = Color(0xFF6F6F6F);

  @override
  Widget build(BuildContext context) {
    final photos = recipe.photos;
    ImageProvider? photo;
    if (photos != null && photos.isNotEmpty) {
      try {
        final raw = photos.first;
        final b64 = raw.contains(',') ? raw.split(',').last : raw;
        photo = MemoryImage(base64Decode(b64));
      } catch (_) {
        photo = null;
      }
    }

    final story = recipe.story;

    return Container(
      width: 340,
      decoration: BoxDecoration(
        color: _cream,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3DED7)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (photo != null)
            Image(
              image: photo,
              width: 340,
              height: 180,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  recipe.title,
                  style: const TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _ink,
                    height: 1.2,
                  ),
                ),
                if (recipe.authorName != null &&
                    recipe.authorName!.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    recipe.authorName!,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: _inkSoft,
                    ),
                  ),
                ],
                if (story != null && story.isNotEmpty) ...[
                  const SizedBox(height: 14),
                  Text(
                    '"$story"',
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: _ink,
                      height: 1.5,
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Container(height: 1, color: const Color(0xFFE3DED7)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.restaurant, size: 14, color: brandPrimary),
                    const SizedBox(width: 6),
                    const Expanded(
                      child: Text(
                        'Made with Legacy Table',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: brandPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Flexible(
                      child: Text(
                        'legacytable.app',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 12,
                          color: _inkSoft,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
