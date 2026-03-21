import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../services/api_service.dart';
import '../models/recipe.dart';
import '../widgets/styled_snackbar.dart';

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipe; // Optional - if provided, we're in edit mode

  const AddRecipeScreen({super.key, this.recipe});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _instructionsController = TextEditingController();
  final _storyController = TextEditingController();
  
  final List<TextEditingController> _ingredientControllers = [
    TextEditingController(),
  ];
  
  String? _selectedCategory;
  String? _selectedDifficulty = 'Easy';
  int _cookingTime = 30;
  int _servings = 4;
  final List<File> _selectedImages = [];
  List<String> _remainingExistingPhotos = []; // Track which existing photos to keep
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.recipe != null;
    
    // Initialize form fields if editing
    if (_isEditing && widget.recipe != null) {
      final recipe = widget.recipe!;
      _titleController.text = recipe.title;
      _instructionsController.text = recipe.instructions;
      _storyController.text = recipe.story ?? '';
      _selectedCategory = recipe.category;
      _selectedDifficulty = recipe.difficulty?.isNotEmpty == true
          ? recipe.difficulty![0].toUpperCase() + recipe.difficulty!.substring(1)
          : 'Easy';
      _cookingTime = recipe.cookingTime ?? 30;
      _servings = recipe.servings ?? 4;
      _remainingExistingPhotos = List<String>.from(recipe.photos ?? []);
      
      // Initialize ingredient controllers
      _ingredientControllers.clear();
      for (var ingredient in recipe.ingredients) {
        _ingredientControllers.add(TextEditingController(text: ingredient));
      }
      // Always have at least one empty ingredient field
      if (_ingredientControllers.isEmpty) {
        _ingredientControllers.add(TextEditingController());
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _instructionsController.dispose();
    _storyController.dispose();
    for (var controller in _ingredientControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addIngredient() {
    setState(() {
      _ingredientControllers.add(TextEditingController());
    });
  }

  void _removeIngredient(int index) {
    if (_ingredientControllers.length > 1) {
      setState(() {
        _ingredientControllers[index].dispose();
        _ingredientControllers.removeAt(index);
      });
    }
  }

  Future<bool> _requestGalleryPermission() async {
    try {
      if (Platform.isAndroid) {
        // Try Permission.photos first (Android 13+)
        try {
          if (await Permission.photos.status.isGranted) {
            return true;
          }
          
          final photosRequest = await Permission.photos.request();
          if (photosRequest.isGranted) {
            return true;
          }
          
          if (photosRequest.isPermanentlyDenied) {
            if (mounted) {
              _showPermissionDeniedDialog(
                'Photo Library Permission',
                'Photo library permission is required to select images.\n\nTo enable:\n1. Tap "Open Settings"\n2. Go to "Permissions"\n3. Enable "Photos and videos"',
              );
            }
            return false; 
          }
        } catch (e) {
        } 
        
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) {
          return true;
        }
        
        final storageRequest = await Permission.storage.request();
        if (storageRequest.isGranted) {
          return true;
        }
        
        if (storageRequest.isPermanentlyDenied) {
          if (mounted) {
            _showPermissionDeniedDialog(
              'Storage Permission',
              'Storage permission is required to select images.\n\nTo enable:\n1. Tap "Open Settings"\n2. Go to "Permissions"\n3. Enable "Storage" or "Files and media"',
            );
          } 
        }
        return false;
      } else if (Platform.isIOS) {
        // iOS uses Permission.photos
        final status = await Permission.photos.status;
        if (status.isGranted) {
          return true;
        }
        
        final requestStatus = await Permission.photos.request();
        if (requestStatus.isGranted) {
          return true;
        }
        
        if (requestStatus.isPermanentlyDenied) {
          if (mounted) {
            _showPermissionDeniedDialog(
              'Photo Library Permission',
              'Photo library permission is required to select images.\n\nTo enable:\n1. Tap "Open Settings"\n2. Find "Legacy Table"\n3. Tap "Photos"\n4. Select "All Photos" or "Selected Photos"',
            );
          }
        }
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Permission request error: $e');
      }
    }
    return false;
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return true;
    }
    
    if (status.isPermanentlyDenied) {
      if (mounted) {
        _showPermissionDeniedDialog(
          'Camera Permission',
          'Camera permission is permanently denied. Please enable it from app settings.',
        );
      }
    } else if (status.isDenied) {
      if (mounted) {
        StyledSnackBar.showWarning(context, 'Camera permission is required to take photos');
      }
    }
    return false;
  }

  void _showPermissionDeniedDialog(String title, String message) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              Navigator.pop(context);
              await openAppSettings();
              if (!mounted) return;

              // Show additional help as a reminder
              messenger.showSnackBar(
                SnackBar(
                  content: Text(
                    Platform.isAndroid
                        ? 'Look for "Photos and videos" or "Media" permission in App Settings'
                        : 'Look for "Photos" permission in App Settings',
                    style: const TextStyle(fontFamily: 'Manrope'),
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            },
            child: Text(
              'Open Settings',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: brandPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _uploadFromGallery() async {
    try {
      // final hasPermission = await _requestGalleryPermission();
      // if (!hasPermission) {
      //   return;
      // }

      final ImagePicker picker = ImagePicker();
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images.map((xFile) => File(xFile.path)).toList());
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Couldn\'t select images. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _takePhoto() async {
    try {
      // Request permission
      final hasPermission = await _requestCameraPermission();
      if (!hasPermission) {
        return;
      }

      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image != null) {
        setState(() {
          _selectedImages.add(File(image.path));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Couldn\'t take photo. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _removeExistingPhoto(int index) {
    setState(() {
      _remainingExistingPhotos.removeAt(index);
    });
  }

  Uint8List _decodeBase64(String base64String) {
    try {
      if (base64String.isEmpty) {
        return Uint8List(0);
      }
      final base64Data = base64String.contains(',')
          ? base64String.split(',').last
          : base64String;
      if (base64Data.isEmpty) {
        return Uint8List(0);
      }
      return base64Decode(base64Data);
    } catch (e) {
      if (kDebugMode) {
        print('Error decoding base64: $e');
      }
      return Uint8List(0);
    }
  }

  Future<String> _encodeImageToBase64(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64String = base64Encode(bytes);
    // Determine image type from file extension
    final extension = imageFile.path.split('.').last.toLowerCase();
    final mimeType = extension == 'png' 
        ? 'image/png' 
        : extension == 'jpg' || extension == 'jpeg'
            ? 'image/jpeg'
            : 'image/jpeg';
    return 'data:$mimeType;base64,$base64String';
  }

  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection and try again.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return 'Invalid data. Please check all fields and try again.';
            case 401:
              return 'Please sign in and try again.';
            case 403:
              return 'You don\'t have permission to do that.';
            case 404:
              return 'Something wasn\'t found. Please try again.';
            case 422:
              return 'Please check your entries and try again.';
            case 500:
            case 502:
            case 503:
              return 'Something went wrong on our end. Please try again later.';
            default:
              return 'Something went wrong. Please try again.';
          }
        case DioExceptionType.cancel:
          return 'Request was cancelled. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network and try again.';
        case DioExceptionType.badCertificate:
          return 'Security error. Please try again.';
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') == true ||
              error.message?.contains('Network') == true) {
            return 'Network error. Please check your internet connection.';
          }
          return 'An unexpected error occurred. Please try again.';
      }
    }
    
    // Never expose raw errors; always show a safe user message
    return 'Something went wrong. Please try again.';
  }

  Future<void> _onShareRecipe() async {
    // Validate form first
    if (!_formKey.currentState!.validate()) {
      // Scroll to first error field
      FocusScope.of(context).unfocus();
      return;
    }

    if (_selectedCategory == null || _selectedCategory!.isEmpty) {
      StyledSnackBar.showWarning(context, 'Please select a category');
      return;
    }

    // Collect ingredients
    final ingredients = _ingredientControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (ingredients.isEmpty) {
      StyledSnackBar.showWarning(context, 'Please add at least one ingredient');
      return;
    }

    // Show loading dialog
    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false, // Prevent dismissing by back button
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    _isEditing ? 'Updating recipe...' : 'Sharing recipe...',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    try {
      // Convert images to base64
      List<String> photoBase64List = [];
      if (_selectedImages.isNotEmpty) {
        for (var imageFile in _selectedImages) {
          try {
            // Check file size (limit to 5MB per image)
            final fileSize = await imageFile.length();
            const maxSize = 5 * 1024 * 1024; // 5MB
            
            if (fileSize > maxSize) {
              if (mounted) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Image "${imageFile.path.split('/').last}" is too large. Maximum size is 5MB.',
                    ),
                    backgroundColor: Colors.orange,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
              return;
            }

            final base64String = await _encodeImageToBase64(imageFile);
            photoBase64List.add(base64String);
          } catch (e) {
            // Log encoding error but continue with other images
            if (kDebugMode) {
              print('Error encoding image: $e');
            }
          }
        }
        
        if (_selectedImages.isNotEmpty && photoBase64List.isEmpty) {
          if (!mounted) return;
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to process images. Please try selecting different images.'),
              backgroundColor: Colors.orange,
            ),
          );
          return;
        }
      }

      Recipe updatedRecipe;

      if (_isEditing && widget.recipe != null) {
        // Combine remaining existing photos with new photos
        List<String> finalPhotos = [];
        // Add remaining existing photos
        finalPhotos.addAll(_remainingExistingPhotos);
        // Add new photos
        finalPhotos.addAll(photoBase64List);
        
        // Update existing recipe
        final request = UpdateRecipeRequest(
          title: _titleController.text.trim(),
          ingredients: ingredients,
          instructions: _instructionsController.text.trim(),
          story: _storyController.text.trim().isEmpty
              ? null
              : _storyController.text.trim(),
          category: _selectedCategory,
          difficulty: _selectedDifficulty?.toLowerCase(),
          cookingTime: _cookingTime,
          servings: _servings,
          photos: finalPhotos.isNotEmpty ? finalPhotos : null,
        );

        updatedRecipe = await apiService.recipes.updateRecipe(
          widget.recipe!.id,
          request,
        );

        if (!mounted) return;
        Navigator.pop(context); // Close loading dialog
        Navigator.pop(context, updatedRecipe); // Return updated recipe

        if (mounted) {
          StyledSnackBar.showSuccess(context, 'Recipe updated successfully!');
        }
      } else {
        // Create new recipe
        final request = CreateRecipeRequest(
          title: _titleController.text.trim(),
          ingredients: ingredients,
          instructions: _instructionsController.text.trim(),
          story: _storyController.text.trim().isEmpty
              ? null
              : _storyController.text.trim(),
          category: _selectedCategory,
          difficulty: _selectedDifficulty?.toLowerCase(),
          cookingTime: _cookingTime,
          servings: _servings,
          photos: photoBase64List.isNotEmpty ? photoBase64List : null,
        );

        updatedRecipe = await apiService.recipes.createRecipe(request);

        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pop(context, true);

        if (mounted) {
          StyledSnackBar.showSuccess(context, 'Recipe shared successfully!');
        }
      }
    } catch (e) {
      // Handle errors
      if (!mounted) return;
      
      // Close loading dialog
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      
      // Show error message
      final errorMessage = _getErrorMessage(e);
      StyledSnackBar.showError(context, errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      final themeProvider = Provider.of<ThemeProvider>(context);
      final isDark = themeProvider.isDarkMode;

      return Scaffold(
        backgroundColor: isDark ? DarkColors.background : LightColors.background,
        appBar: AppBar(
          title: Text(
            _isEditing ? 'Edit Recipe' : 'Share a Recipe',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            ),
          ),
          backgroundColor: isDark ? DarkColors.background : LightColors.background,
          elevation: 0,
        ),
        body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subtitle
              Text(
                _isEditing
                    ? 'Update your recipe details'
                    : 'Add a new dish to the family collection',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // PHOTOS Section
              _buildSectionLabel('PHOTOS', isDark),
              const SizedBox(height: 12),
              // Show all images together (existing + new)
              if ((_isEditing && _remainingExistingPhotos.isNotEmpty) || _selectedImages.isNotEmpty)
                _buildAllImagesGrid(isDark),
              if ((_isEditing && _remainingExistingPhotos.isNotEmpty) || _selectedImages.isNotEmpty)
                const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildPhotoUploadArea(isDark),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _buildTakePhotoButton(isDark),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // RECIPE TITLE
              _buildSectionLabel('RECIPE TITLE *', isDark),
              const SizedBox(height: 12),
              _buildTextField(
                controller: _titleController,
                placeholder: "e.g., Grandma's Special Jollof Rice",
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Recipe title is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // CATEGORY & DIFFICULTY
              Wrap(
                spacing: 4,
                runSpacing: 4,  
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('CATEGORY *', isDark),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          value: _selectedCategory,
                          placeholder: 'Select category',
                          items: ['Appetizer', 'Main Course', 'Dessert', 'Beverage', 'Side Dish'],
                          onChanged: (value) {
                            setState(() {
                              _selectedCategory = value;
                            });
                          },
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Category is required';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('DIFFICULTY', isDark),
                        const SizedBox(height: 12),
                        _buildDropdown(
                          value: _selectedDifficulty,
                          placeholder: 'Select difficulty',
                          items: ['Easy', 'Medium', 'Hard'],
                          onChanged: (value) {
                            setState(() {
                              _selectedDifficulty = value;
                            });
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // COOKING TIME & SERVINGS
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('COOKING TIME\n(MINUTES)', isDark),
                        const SizedBox(height: 12),
                        _buildNumberField(
                          value: _cookingTime,
                          onChanged: (value) {
                            setState(() {
                              _cookingTime = value;
                            });
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('\nSERVINGS', isDark),
                        const SizedBox(height: 12),
                        _buildNumberField(
                          value: _servings,
                          onChanged: (value) {
                            setState(() {
                              _servings = value;
                            });
                          },
                          isDark: isDark,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // INGREDIENTS
              _buildSectionLabel('INGREDIENTS *', isDark),
              const SizedBox(height: 12),
              ...List.generate(_ingredientControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _ingredientControllers[index],
                          placeholder: 'Ingredient ${index + 1}',
                          isDark: isDark,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingredient is required';
                            }
                            return null;
                          },
                        ),
                      ),
                      if (_ingredientControllers.length > 1)
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                          ),
                          onPressed: () => _removeIngredient(index),
                        ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 8),
              _buildAddButton(
                icon: Icons.add,
                label: 'Add ingredient',
                onPressed: _addIngredient,
                isDark: isDark,
              ),
              const SizedBox(height: 24),

              // INSTRUCTIONS
              _buildSectionLabel('INSTRUCTIONS *', isDark),
              const SizedBox(height: 12),
              _buildTextArea(
                controller: _instructionsController,
                placeholder: 'Write the step-by-step cooking instructions...',
                isDark: isDark,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Instructions are required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // THE STORY BEHIND THIS RECIPE
              _buildSectionLabel('THE STORY BEHIND THIS RECIPE (optional)', isDark),
              const SizedBox(height: 8),
              Text(
                'Share the story of this recipe... Where did it come from? Who passed it down? What memories does it hold for your family?',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 12,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              _buildTextArea(
                controller: _storyController,
                placeholder: 'Tell us about the history, traditions, or special memories connected to this dish.',
                isDark: isDark,
                minLines: 4,
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                          color: isDark ? DarkColors.border : LightColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _onShareRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isEditing ? 'Update Recipe' : 'Share Recipe',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error building AddRecipeScreen: $e');
        print('Stack trace: $stackTrace');
      }
      // Return a safe fallback UI
      return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Share a Recipe'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please try again or restart the app.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget _buildSectionLabel(String label, bool isDark) {
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1,
        color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
      ),
    );
  }

  Widget _buildAllImagesGrid(bool isDark) {
    final int existingCount = _isEditing ? _remainingExistingPhotos.length : 0;
    final int newCount = _selectedImages.length;
    final int totalCount = existingCount + newCount;

    if (totalCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surface : LightColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? DarkColors.border : LightColors.border,
        ),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 1,
        ),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (index < existingCount) {
            // Existing photo
            final photo = _remainingExistingPhotos[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: photo.startsWith('data:image')
                      ? Builder(
                          builder: (context) {
                            final decodedImage = _decodeBase64(photo);
                            if (decodedImage.isEmpty) {
                              return Container(
                                color: isDark
                                    ? DarkColors.surfaceMuted
                                    : LightColors.surfaceMuted,
                                child: Icon(
                                  Icons.error_outline,
                                  color: isDark
                                      ? DarkColors.textMuted
                                      : LightColors.textMuted,
                                ),
                              );
                            }
                            return Image.memory(
                              decodedImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: isDark
                                      ? DarkColors.surfaceMuted
                                      : LightColors.surfaceMuted,
                                  child: Icon(
                                    Icons.error_outline,
                                    color: isDark
                                        ? DarkColors.textMuted
                                        : LightColors.textMuted,
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Image.network(
                          photo,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: isDark
                                  ? DarkColors.surfaceMuted
                                  : LightColors.surfaceMuted,
                              child: Icon(
                                Icons.error_outline,
                                color: isDark
                                    ? DarkColors.textMuted
                                    : LightColors.textMuted,
                              ),
                            );
                          },
                        ),
                ),
                // Remove button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeExistingPhoto(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else {
            // New image
            final imageIndex = index - existingCount;
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImages[imageIndex],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                // Remove button
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () => _removeImage(imageIndex),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPhotoUploadArea(bool isDark) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surface : LightColors.surface,
        border: Border.all(
          color: isDark ? DarkColors.border : LightColors.border,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: _uploadFromGallery,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload,
              size: 32,
              color: isDark ? DarkColors.textMuted : LightColors.textMuted,
            ),
            const SizedBox(height: 8),
            Text(
              'Upload from gallery',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTakePhotoButton(bool isDark) {
    return SizedBox(
      height: 150,
      child: OutlinedButton(
        onPressed: _takePhoto,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Builder(
              builder: (context) {
                try {
                  return SvgPicture.asset(
                    'assets/icons/Camera.svg',
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(
                      isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (context) => Icon(
                      Icons.camera_alt,
                      size: 24,
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  );
                } catch (e) {
                  return Icon(
                    Icons.camera_alt,
                    size: 24,
                    color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                  );
                }
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Take Photo',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String placeholder,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
        ),
        filled: true,
        fillColor: isDark ? DarkColors.surface : LightColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: brandPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildTextArea({
    required TextEditingController controller,
    required String placeholder,
    required bool isDark,
    int minLines = 6,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: null,
      minLines: minLines,
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
        ),
        filled: true,
        fillColor: isDark ? DarkColors.surface : LightColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: brandPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String placeholder,
    required List<String> items,
    required Function(String?) onChanged,
    required bool isDark,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: isDark ? DarkColors.textMuted : LightColors.textMuted,
        ),
        filled: true,
        fillColor: isDark ? DarkColors.surface : LightColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? DarkColors.border : LightColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: brandPrimary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: TextStyle(
        fontFamily: 'Manrope',
        fontSize: 16,
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      ),
      dropdownColor: isDark ? DarkColors.surface : LightColors.surface,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _buildNumberField({
    required int value,
    required Function(int) onChanged,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surface : LightColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? DarkColors.border : LightColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.remove,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (value > 1) {
                onChanged(value - 1);
              }
            },
          ),
          Expanded(
            child: Text(
              value.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => onChanged(value + 1),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 18,
        color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: 'Manrope',
          fontSize: 14,
          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        ),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: isDark ? DarkColors.border : LightColors.border,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
