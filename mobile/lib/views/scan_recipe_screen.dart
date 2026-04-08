import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../config/app_theme.dart';
import '../widgets/styled_snackbar.dart';

class ScanRecipeScreen extends StatefulWidget {
  const ScanRecipeScreen({super.key});

  @override
  State<ScanRecipeScreen> createState() => _ScanRecipeScreenState();
}

class _ScanRecipeScreenState extends State<ScanRecipeScreen> {
  File? _selectedImage;
  bool _isScanning = false;

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      final granted = await _requestCameraPermission();
      if (!granted) {
        if (mounted) {
          StyledSnackBar.showWarning(
            context,
            'Camera permission is required to scan a recipe',
          );
        }
        return;
      }
    }

    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (image == null) return;

    setState(() {
      _selectedImage = File(image.path);
    });
  }

  Future<String> _encodeImageToDataUrl(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64String = base64Encode(bytes);
    final extension = imageFile.path.split('.').last.toLowerCase();
    final mimeType = extension == 'png' ? 'image/png' : 'image/jpeg';
    return 'data:$mimeType;base64,$base64String';
  }

  Future<void> _scanRecipe() async {
    if (_selectedImage == null) return;

    setState(() {
      _isScanning = true;
    });

    try {
      // TODO: Wire up AI scan API when backend is ready
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      StyledSnackBar.showWarning(
        context,
        'Recipe scanning is coming soon! The AI service is being set up.',
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
          _isScanning = false;
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
      appBar: AppBar(title: const Text('Scan Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Turn a handwritten card or cookbook page into an editable recipe draft.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              height: 320,
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surface : LightColors.surface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: _selectedImage == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.document_scanner_outlined,
                          size: 56,
                          color: brandPrimary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Add a recipe photo to scan',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontFamily: 'Manrope',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Best results come from a clear, well-lit photo with the full recipe visible.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(_selectedImage!, fit: BoxFit.cover),
                    ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Choose Photo'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt_outlined),
                    label: const Text('Take Photo'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isScanning || _selectedImage == null
                    ? null
                    : _scanRecipe,
                icon: _isScanning
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.auto_awesome_outlined),
                label: Text(_isScanning ? 'Scanning...' : 'Scan Into Draft'),
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
