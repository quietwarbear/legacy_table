import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../config/app_theme.dart';
import '../services/session_manager.dart';
import '../services/api_service.dart';
import '../models/user.dart';
import '../widgets/styled_snackbar.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nicknameController = TextEditingController();
  User? _currentUser;
  bool _isLoading = true;
  bool _isSaving = false;
  Uint8List? _selectedAvatarBytes;
  String? _selectedAvatarBase64;

  Future<bool> _requestGalleryPermission() async {
    if (kIsWeb) return true;
    try {
      if (Platform.isAndroid) {
        // Android 13+ (API 33+) maps to READ_MEDIA_IMAGES
        try {
          final photosStatus = await Permission.photos.status;
          if (photosStatus.isGranted || photosStatus.isLimited) return true;

          final photosRequest = await Permission.photos.request();
          if (photosRequest.isGranted || photosRequest.isLimited) return true;
        } catch (_) {
        }

        // Older Android fallback
        final storageStatus = await Permission.storage.status;
        if (storageStatus.isGranted) return true;

        final storageRequest = await Permission.storage.request();
        return storageRequest.isGranted;
      }

      if (Platform.isIOS) {
        final status = await Permission.photos.status;
        if (status.isGranted || status.isLimited) return true;

        final requestStatus = await Permission.photos.request();
        return requestStatus.isGranted || requestStatus.isLimited;
      }
    } catch (_) {
      // Fall through to false
    }
    return false;
  }

  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true;
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (_) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Ensure we're logged in
      if (!sessionManager.isLoggedIn) {
        if (mounted) {
          Navigator.of(context).pop();
          StyledSnackBar.showWarning(context, 'Please log in to access profile settings');
        }
        return;
      }

      if (sessionManager.currentUser != null) {
        setState(() {
          _currentUser = sessionManager.currentUser;
          _nicknameController.text = sessionManager.currentUser?.nickname ?? '';
          _isLoading = false;
        });
        // Refresh user data in the background
        try {
          final user = await apiService.auth.getCurrentUser();
          setState(() {
            _currentUser = user;
            _nicknameController.text = user.nickname ?? '';
          });
        } catch (e) {
          // If refresh fails, keep using the cached user
          if (kDebugMode) {
            print('Failed to refresh user data: $e');
          }
        }
      } else {
        // If no cached user, fetch from API
        final user = await apiService.auth.getCurrentUser();
        setState(() {
          _currentUser = user;
          _nicknameController.text = user.nickname ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        StyledSnackBar.showError(context, 'Failed to load user data. Please try again.');
      }
    }
  }

  Future<void> _pickImage() async {
    if (!mounted) return;

    final ImagePicker picker = ImagePicker();
    
    // Show options dialog
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Photo Source'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (source == null) return;

    try {
      if (source == ImageSource.camera) {
        final ok = await _requestCameraPermission();
        if (!ok) {
          if (mounted) {
            StyledSnackBar.showWarning(context, 'Camera permission is required to take a photo');
          }
          return;
        }
      } else {
        // final ok = await _requestGalleryPermission();
        // if (!ok) {
        //   if (mounted) {
        //     StyledSnackBar.showWarning(context, 'Photo library permission is required to choose a photo');
        //   }
        //   return;
        // }
      }

      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        // Get file extension, default to jpeg if not found
        final extension = image.path.split('.').last.toLowerCase();
        final mimeType = extension == 'png' 
            ? 'png' 
            : extension == 'jpg' || extension == 'jpeg' 
                ? 'jpeg' 
                : 'jpeg'; // default to jpeg
        final dataUri = 'data:image/$mimeType;base64,$base64String';

        setState(() {
          _selectedAvatarBytes = bytes;
          _selectedAvatarBase64 = dataUri;
        });
      }
    } catch (e) {
      if (mounted) {
        StyledSnackBar.showError(context, 'Failed to pick image. Please try again.');
      }
    }
  }

  Future<void> _saveChanges() async {
    if (_isSaving) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final updatedUser = await apiService.auth.updateProfile(
        UpdateProfileRequest(
          nickname: _nicknameController.text.trim().isEmpty
              ? null
              : _nicknameController.text.trim(),
          avatar: _selectedAvatarBase64,
        ),
      );

      // Update session manager
      await sessionManager.refreshUser();

      setState(() {
        _currentUser = updatedUser;
        _selectedAvatarBase64 = null;
        _selectedAvatarBytes = null;
        _isSaving = false;
      });

      if (mounted) {
        StyledSnackBar.showSuccess(context, 'Profile updated successfully');
      }
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      if (mounted) {
        String errorMessage = 'Failed to update profile';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  void _cancel() {
    // Reset form fields to original values
    _nicknameController.text = _currentUser?.nickname ?? '';
    setState(() {
      _selectedAvatarBytes = null;
      _selectedAvatarBase64 = null;
    });
    
    // Navigate back to previous screen 
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  bool _hasChanges() {
    final currentNickname = _currentUser?.nickname ?? '';
    final newNickname = _nicknameController.text.trim();
    final nicknameChanged = newNickname != currentNickname;
    final avatarChanged = _selectedAvatarBase64 != null;
    return nicknameChanged || avatarChanged;
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _buildAvatar() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_selectedAvatarBytes != null) {
      return Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: MemoryImage(_selectedAvatarBytes!),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: brandPrimary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark ? DarkColors.surface : LightColors.surface,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (_currentUser?.avatar != null) {
      try {
        final base64Data = _currentUser!.avatar!.contains(',')
            ? _currentUser!.avatar!.split(',').last
            : _currentUser!.avatar!;
        final imageBytes = base64Decode(base64Data);
        return Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: MemoryImage(imageBytes),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brandPrimary,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? DarkColors.surface : LightColors.surface,
                      width: 3,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      } catch (e) {
        // Fall through to initials avatar
      }
    }

    return Stack(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: isDark ? DarkColors.surfaceMuted : LightColors.surfaceMuted,
          child: Text(
            _getInitials(_currentUser?.name),
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              fontFamily: 'Manrope',
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: brandPrimary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? DarkColors.surface : LightColors.surface,
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.arrow_upward,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? DarkColors.textPrimary : LightColors.textPrimary;
    final secondaryTextColor = isDark ? DarkColors.textSecondary : LightColors.textSecondary;
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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Profile Settings',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontFamily: 'Playfair Display',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Customize how you appear to the family',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Profile Picture Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                    color: surfaceColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Profile Picture',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              _buildAvatar(),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  'Upload a photo to personalize your profile',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: secondaryTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Display Name Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                    color: surfaceColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Display Name',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Full Name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Full Name',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? DarkColors.surfaceMuted
                                      : LightColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  _currentUser?.name ?? '',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Nickname
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Nickname (optional)',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _nicknameController,
                                onChanged: (_) => setState(() {}), // Trigger rebuild to update save button
                                decoration: InputDecoration(
                                  hintText: 'Enter a nickname...',
                                  hintStyle: TextStyle(
                                    color: secondaryTextColor,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: borderColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: brandPrimary, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: theme.scaffoldBackgroundColor,
                                  contentPadding: const EdgeInsets.all(16),
                                ),
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Your nickname will be shown instead of your full name on recipes and comments.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Account Information Card
                  Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: borderColor, width: 1),
                    ),
                    color: surfaceColor,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Information',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontFamily: 'Playfair Display',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Email
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? DarkColors.surfaceMuted
                                      : LightColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  _currentUser?.email ?? '',
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          // Member Since
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Member Since',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: secondaryTextColor,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? DarkColors.surfaceMuted
                                      : LightColors.surfaceMuted,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: borderColor),
                                ),
                                child: Text(
                                  'January 8, 2026', // TODO: Get from user model if available
                                  style: theme.textTheme.bodyLarge,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Footer with buttons
          Container(
            padding: const EdgeInsets.all(24.0),
            decoration: BoxDecoration(
              color: surfaceColor,
              border: Border(
                top: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _cancel,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: borderColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: (_isSaving || !_hasChanges()) ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: isDark
                            ? DarkColors.surfaceMuted
                            : LightColors.surfaceMuted,
                        disabledForegroundColor: secondaryTextColor,
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(
                              'Save Changes',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
