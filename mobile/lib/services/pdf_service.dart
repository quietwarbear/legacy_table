import 'dart:convert';

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/foundation.dart';
import '../models/recipe.dart';

class PdfService {
  // Generate PDF from selected recipes
  Future<Uint8List> generateCookbookPDF({
    required List<Recipe> recipes,
    required Function(String) onProgress,
  }) async {
    try {
      onProgress('Generating PDF...');
      
      final pdf = pw.Document();
      final now = DateTime.now();
      
      // Cover Page
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(0),
          build: (pw.Context context) => _buildCoverPage(recipes.length, now),
        ),
      );

      // Table of Contents
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(72),
          build: (pw.Context context) => _buildTableOfContents(recipes),
        ),
      );

      // Preload images for all recipes
      final Map<String, pw.ImageProvider?> imageCache = {};
      for (int i = 0; i < recipes.length; i++) {
        final recipe = recipes[i];
        if (recipe.photos != null && recipe.photos!.isNotEmpty) {
          onProgress('Loading images for recipe ${i + 1} of ${recipes.length}...');
          for (final photoUrl in recipe.photos!) {
            if (!imageCache.containsKey(photoUrl)) {
              imageCache[photoUrl] = await _loadImage(photoUrl);
            }
          }
        }
      }

      // Recipe Pages
      for (int i = 0; i < recipes.length; i++) {
        onProgress('Adding recipe ${i + 1} of ${recipes.length}...');
        final recipe = recipes[i];
        final List<pw.ImageProvider?> recipeImages = [];
        if (recipe.photos != null && recipe.photos!.isNotEmpty) {
          for (final photoUrl in recipe.photos!) {
            final image = imageCache[photoUrl];
            if (image != null) {
              recipeImages.add(image);
            }
          }
        }
        // Use MultiPage to automatically handle page breaks
        pdf.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(72),
            build: (pw.Context context) => _buildRecipePages(recipes[i], recipeImages),
          ),
        );
      }

      onProgress('Finalizing PDF...');
      
      // Generate PDF bytes
      final pdfBytes = await pdf.save();
      
      return pdfBytes;
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  /// Save PDF to device storage and return the file path
  Future<String> savePDFToDevice(Uint8List pdfBytes, String fileName) async {
    try {
      // Get the documents directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getApplicationDocumentsDirectory();
        }
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      // Ensure directory exists
      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Create file
      final file = File('${directory.path}/$fileName');
      
      // Write PDF bytes to file
      await file.writeAsBytes(pdfBytes);
      
      if (kDebugMode) {
        print('PDF saved to: ${file.path}');
      }
      
      return file.path;
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  /// Share PDF using share_plus
  /// Uses XFile.fromData on iOS to avoid temp file path issues with the share sheet
  Future<void> sharePDF(Uint8List pdfBytes, String fileName) async {
    try {
      if (Platform.isIOS) {
        // iOS: Use fromData to avoid "source file doesn't exist" and share sheet access issues
        await Share.shareXFiles(
          [
            XFile.fromData(
              pdfBytes,
              mimeType: 'application/pdf',
              name: fileName,
            ),
          ],
          text: 'Family Cookbook - Legacy Table',
          subject: 'Family Cookbook PDF',
        );
      } else {
        // Android/other: Write to temp file and share
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(pdfBytes);

        await Share.shareXFiles(
          [XFile(tempFile.path, mimeType: 'application/pdf')],
          text: 'Family Cookbook - Legacy Table',
          subject: 'Family Cookbook PDF',
        );
      }

      if (kDebugMode) {
        print('PDF shared successfully');
      }
    } catch (e) {
      throw Exception('Failed to share PDF: $e');
    }
  }

  /// Preview/Print PDF using printing package
  Future<void> previewPDF(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }

  // Build cover page
  pw.Widget _buildCoverPage(int recipeCount, DateTime createdDate) {
    return pw.Container(
      width: double.infinity,
      height: double.infinity,
      decoration: pw.BoxDecoration(
        gradient: pw.LinearGradient(
          begin: pw.Alignment.topCenter,
          end: pw.Alignment.bottomCenter,
          colors: [
            PdfColor.fromHex('#F8F5F1'), // Light cream background
            PdfColor.fromHex('#F0ECE5'),
          ],
        ),
      ),
      child: pw.Padding(
        padding: const pw.EdgeInsets.all(72),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            // Title
            pw.Text(
              'Legacy Table',
              style: pw.TextStyle(
                fontSize: 48,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#2B2B2B'),
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 16),
            
            // Subtitle
            pw.Text(
              'Family Cookbook',
              style: pw.TextStyle(
                fontSize: 36,
                fontWeight: pw.FontWeight.bold,
                color: PdfColor.fromHex('#2B2B2B'),
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 24),
            
            // Description
            pw.Text(
              'Recipes passed down with love',
              style: pw.TextStyle(
                fontSize: 18,
                color: PdfColor.fromHex('#6F6F6F'),
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 48),
            
            // Recipe count and date
            pw.Text(
              '$recipeCount ${recipeCount == 1 ? 'cherished recipe' : 'cherished recipes'}',
              style: pw.TextStyle(
                fontSize: 16,
                color: PdfColor.fromHex('#6F6F6F'),
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Created on ${_formatDate(createdDate)}',
              style: pw.TextStyle(
                fontSize: 14,
                color: PdfColor.fromHex('#9B9B9B'),
              ),
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 72),
            
            // Quote
            pw.Container(
              padding: const pw.EdgeInsets.all(24),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: PdfColor.fromHex('#E3DED7'),
                  width: 1,
                ),
              ),
              child: pw.Text(
                '"The fondest memories are made when gathered around the table."',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontStyle: pw.FontStyle.italic,
                  color: PdfColor.fromHex('#6F6F6F'),
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build table of contents
  pw.Widget _buildTableOfContents(List<Recipe> recipes) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Table of Contents',
          style: pw.TextStyle(
            fontSize: 32,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#2B2B2B'),
          ),
        ),
        pw.SizedBox(height: 32),
        ...recipes.asMap().entries.map((entry) {
          final index = entry.key;
          final recipe = entry.value;
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 16),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${index + 1}. ',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#F26B3A'), // Brand primary
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        _removeEmojis(recipe.title),
                        style: pw.TextStyle(
                          fontSize: 16,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#2B2B2B'),
                        ),
                      ),
                      if (recipe.authorName != null)
                        pw.Text(
                          'by ${_removeEmojis(recipe.authorName!)}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            color: PdfColor.fromHex('#6F6F6F'),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // Build recipe pages (supports multiple pages)
  List<pw.Widget> _buildRecipePages(Recipe recipe, [List<pw.ImageProvider?>? recipeImages]) {
    return [
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
        // Recipe Photos
        if (recipeImages != null && recipeImages.isNotEmpty) ...[
          if (recipeImages.length == 1) ...[
            // Single photo - full width
            pw.Container(
              width: double.infinity,
              height: 200,
              margin: const pw.EdgeInsets.only(bottom: 24),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(8),
                image: pw.DecorationImage(
                  image: recipeImages[0]!,
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
          ] else ...[
            // Multiple photos - grid layout
            pw.Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recipeImages.map((image) {
                if (image == null) return pw.SizedBox.shrink();
                return pw.Container(
                  width: 150,
                  height: 150,
                  decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(8),
                    image: pw.DecorationImage(
                      image: image,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
            ),
            pw.SizedBox(height: 24),
          ],
        ],
        
        // Recipe Title
        pw.Text(
          _removeEmojis(recipe.title),
          style: pw.TextStyle(
            fontSize: 36,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#2B2B2B'),
          ),
        ),
        pw.SizedBox(height: 24),
        
        // Category and Difficulty badges
        pw.Row(
          children: [
            if (recipe.category != null)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#6C8B74'), // Brand secondary
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  recipe.category!.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            if (recipe.category != null && recipe.difficulty != null)
              pw.SizedBox(width: 12),
            if (recipe.difficulty != null)
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: pw.BoxDecoration(
                  color: _getDifficultyColor(recipe.difficulty!),
                  borderRadius: pw.BorderRadius.circular(4),
                ),
                child: pw.Text(
                  recipe.difficulty!.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
          ],
        ),
        pw.SizedBox(height: 16),
        
        // Author, time, servings
        pw.Row(
          children: [
            if (recipe.authorName != null) ...[
              pw.Text(
                'By ${_removeEmojis(recipe.authorName!)}',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromHex('#6F6F6F'),
                ),
              ),
              if (recipe.cookingTime != null || recipe.servings != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                  child: pw.Container(
                    width: 4,
                    height: 4,
                    decoration: pw.BoxDecoration(
                      color: PdfColor.fromHex('#F26B3A'), // Brand primary
                      shape: pw.BoxShape.circle,
                    ),
                  ),
                ),
            ],
            if (recipe.cookingTime != null)
              pw.Text(
                '${recipe.cookingTime} min',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromHex('#6F6F6F'),
                ),
              ),
            if (recipe.cookingTime != null && recipe.servings != null)
              pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 8),
                child: pw.Container(
                  width: 4,
                  height: 4,
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F26B3A'), // Brand primary
                    shape: pw.BoxShape.circle,
                  ),
                ),
              ),
            if (recipe.servings != null)
              pw.Text(
                '${recipe.servings} servings',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColor.fromHex('#6F6F6F'),
                ),
              ),
          ],
        ),
        pw.SizedBox(height: 32),
        
        // Ingredients Section
        pw.Text(
          'Ingredients',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#2B2B2B'),
          ),
        ),
        pw.SizedBox(height: 16),
        ...recipe.ingredients.map((ingredient) {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  margin: const pw.EdgeInsets.only(top: 8, right: 12),
                  width: 6,
                  height: 6,
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#F26B3A'), // Brand primary
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(
                    _removeEmojis(ingredient),
                    style: pw.TextStyle(
                      fontSize: 14,
                      color: PdfColor.fromHex('#2B2B2B'),
                      lineSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
        pw.SizedBox(height: 32),
        
        // Instructions Section
        pw.Text(
          'Instructions',
          style: pw.TextStyle(
            fontSize: 24,
            fontWeight: pw.FontWeight.bold,
            color: PdfColor.fromHex('#2B2B2B'),
          ),
        ),
        pw.SizedBox(height: 16),
        pw.Text(
          _removeEmojis(recipe.instructions),
          style: pw.TextStyle(
            fontSize: 14,
            color: PdfColor.fromHex('#2B2B2B'),
            lineSpacing: 1.6,
          ),
        ),
        
        // Story Section
        if (recipe.story != null && recipe.story!.isNotEmpty) ...[
          pw.SizedBox(height: 32),
          pw.Row(
            children: [
              pw.Text(
                '* ',
                style: pw.TextStyle(
                  fontSize: 20,
                  color: PdfColor.fromHex('#EF4444'), // Red for heart symbol
                ),
              ),
              pw.Text(
                'The Story',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#2B2B2B'),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            _removeEmojis(recipe.story!),
            style: pw.TextStyle(
              fontSize: 14,
              fontStyle: pw.FontStyle.italic,
              color: PdfColor.fromHex('#2B2B2B'),
              lineSpacing: 1.6,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Shared by ${_removeEmojis(recipe.authorName ?? 'Unknown')}',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColor.fromHex('#6F6F6F'),
            ),
          ),
        ],
        
        // Creation Date
        pw.SizedBox(height: 24),
        pw.Container(
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            color: PdfColor.fromHex('#F8F5F1'),
            borderRadius: pw.BorderRadius.circular(4),
          ),
          child: pw.Row(
            children: [
              pw.Text(
                'Recipe added on ',
                style: pw.TextStyle(
                  fontSize: 12,
                  color: PdfColor.fromHex('#6F6F6F'),
                ),
              ),
              pw.Text(
                _formatDate(recipe.createdAt),
                style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#2B2B2B'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    ];
  }
  
  String _removeEmojis(String text) {
    if (text.isEmpty) return text;
    
    String cleaned = text;
    
    cleaned = cleaned.replaceAll(RegExp(
      r'[\u{1F300}-\u{1F9FF}]|[\u{1F600}-\u{1F64F}]|[\u{1F680}-\u{1F6FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{FE00}-\u{FE0F}]|[\u{200D}]|[\u{200C}]|[\u{FEFF}]',
      unicode: true,
    ), '');
    
    cleaned = cleaned
        .replaceAll('♥', '*') // Heart symbol
        .replaceAll('❤', '*') // Red heart
        .replaceAll('💕', '*') // Two hearts
        .replaceAll('🔥', 'Hot') // Fire
        .replaceAll('⭐', '*') // Star
        .replaceAll('✨', '*') // Sparkles
        .replaceAll('👍', 'Good') // Thumbs up
        .replaceAll('👎', 'Bad') // Thumbs down
        .replaceAll('❤️', '*') // Red heart with variation selector
        .replaceAll('💖', '*') // Sparkling heart
        .replaceAll('💗', '*') // Growing heart
        .replaceAll('💓', '*') // Beating heart
        .replaceAll('💞', '*') // Revolving hearts
        .replaceAll('💝', '*') // Heart with ribbon
        .replaceAll('💘', '*') // Heart with arrow
        .replaceAll('💟', '*') // Heart decoration
        .replaceAll('❣', '*') // Heart exclamation
        .replaceAll('💌', '*') // Love letter
        .replaceAll('🖤', '*') // Black heart
        .replaceAll('🤍', '*') // White heart
        .replaceAll('💛', '*') // Yellow heart
        .replaceAll('💚', '*') // Green heart
        .replaceAll('💙', '*') // Blue heart
        .replaceAll('💜', '*') // Purple heart
        .replaceAll('🧡', '*') // Orange heart
        .trim();
    
    return cleaned;
  }
  
  // Load image from base64 or network URL
  Future<pw.ImageProvider?> _loadImage(String imageSource) async {
    try {
      Uint8List imageBytes;
      
      if (imageSource.startsWith('data:image')) {
        // Base64 image
        final base64String = imageSource.split(',').last;
        imageBytes = base64Decode(base64String);
      } else {
        // Network image
        final dio = Dio();
        final response = await dio.get<List<int>>(
          imageSource,
          options: Options(responseType: ResponseType.bytes),
        );
        imageBytes = Uint8List.fromList(response.data ?? []);
      }
      
      return pw.MemoryImage(imageBytes);
    } catch (e) {
      return null;
    }
  }

  // Get difficulty color
  PdfColor _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return PdfColor.fromHex('#22C55E'); // Green
      case 'medium':
        return PdfColor.fromHex('#F59E0B'); // Orange/Amber
      case 'hard':
        return PdfColor.fromHex('#EF4444'); // Red
      default:
        return PdfColor.fromHex('#6B7280'); // Gray
    }
  }

  // Format date
  String _formatDate(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
