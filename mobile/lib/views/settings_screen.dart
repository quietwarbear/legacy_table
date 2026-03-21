import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../services/session_manager.dart';
import '../services/api_service.dart';
import '../models/family.dart';
import '../models/user.dart';
import '../widgets/styled_snackbar.dart';
import 'profile_settings_screen.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Family? _family;
  List<User> _familyMembers = [];
  bool _isLoadingMembers = false;

  Future<void> _openDeleteAccountPage() async {
    final uri = Uri.parse('https://legacytable.app/delete-account');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        StyledSnackBar.showError(context, 'Could not open delete account page');
      }
    } catch (_) {
      if (mounted) {
        StyledSnackBar.showError(context, 'Could not open delete account page');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadFamilyInfo();
  }

  void refreshFamilyInfo() {
    if (kDebugMode) {
      print('Refreshing family info and members list...');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadFamilyInfo();
      }
    });
  }

  Future<void> _loadFamilyMembers() async {
    final user = sessionManager.currentUser;
    if (user?.familyId == null) {
      debugPrint('Cannot load family members: user has no familyId');
      if (mounted) {
        setState(() {
          _familyMembers = [];
          _isLoadingMembers = false;
        });
      }
      return;
    }

    final familyId = user!.familyId!;
    debugPrint('Loading family members for family: $familyId');

    if (mounted) {
      setState(() {
        _isLoadingMembers = true;
      });
    }

    try {
      final members = await apiService.families.getFamilyMembers(familyId);
      debugPrint('Loaded ${members.length} family members');
      if (mounted) {
        setState(() {
          _familyMembers = members;
          _isLoadingMembers = false;
        });
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Error loading family members: $e');
        setState(() {
          _isLoadingMembers = false;
        });
        // Show error to user
        if (mounted) {
          StyledSnackBar.showError(context, 'Failed to load family members');
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = sessionManager.currentUser;
    final userFamilyId = user?.familyId;
    if (userFamilyId != null) {
      final currentFamilyId = _family?.id;
      if (currentFamilyId == null || currentFamilyId != userFamilyId) {
        _loadFamilyInfo();
      } else if (_familyMembers.isEmpty) {
        // Reload members if members list is empty
        _loadFamilyMembers();
      }
    }
  }

  Future<void> _loadFamilyInfo() async {
    if (!sessionManager.isLoggedIn) {
      if (mounted) {
        setState(() {
          _family = null;
          _familyMembers = [];
          _isLoadingMembers = false;
        });
      }
      return;
    }
    
    final user = sessionManager.currentUser;
    if (user?.familyId == null) {
      if (mounted) {
        setState(() {
          _family = null;
          _familyMembers = [];
          _isLoadingMembers = false;
        });
      }
      return;
    }

    final familyId = user!.familyId!;
    
    try {
      if (kDebugMode) {
        print('Loading family info for family ID: $familyId');
      }
      
      final family = await apiService.families.getFamily(familyId);
      
      if (kDebugMode) {
        print('Family loaded successfully: ${family.name}, Invite Code: ${family.inviteCode}');
      }
      
      if (mounted) {
        setState(() {
          _family = family;
        });
        _loadFamilyMembers();
      }
    } catch (e) {
      // Log error for debugging
      if (mounted) {
        debugPrint('Error loading family info: $e');
        if (_family == null) {
          setState(() {
            _family = null;
            _familyMembers = [];
            _isLoadingMembers = false;
          });
        }
      }
    }
  }

  Future<void> _copyInviteCode(String inviteCode) async {
    await Clipboard.setData(ClipboardData(text: inviteCode));
    if (mounted) {
      StyledSnackBar.showSuccess(context, 'Invite code copied!');
    }
  }

  Future<void> _shareInviteCode(Family family) async {
    final descriptionText = family.description != null && family.description!.isNotEmpty
        ? '\n\n${family.description}'
        : '';
    
    final shareText = 'Join my family "${family.name}" on Legacy Table!\n\n'
        'Invite Code: ${family.inviteCode}'
        '$descriptionText';
    
    await Share.share(shareText);
  }

  Future<void> _handleLeaveFamily() async {
    final user = sessionManager.currentUser;
    if (user?.familyId == null || _family == null) return;

    // If user is keeper, check if they can leave
    if (user?.isKeeper == true) {
      // Check if keeper is the only member
      if (_familyMembers.isEmpty || _familyMembers.length == 1) {
        // Only member, can leave directly
        await _leaveFamily();
      } else {
        // Keeper has other members, must transfer role first
        await _showTransferKeeperDialog();
      }
    } else {
      // Regular member can leave directly
      await _leaveFamily();
    }
  }

  Future<void> _leaveFamily() async {
    final user = sessionManager.currentUser;
    if (user?.familyId == null || _family == null) return;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    // Show confirmation dialog
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          'Leave Family',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to leave "${_family!.name}"? You will need an invite code to rejoin.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Leave',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldLeave != true) return;

    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
            ),
          ),
        );
      }

      // Leave the family
      await apiService.families.leaveFamily(user!.familyId!);

      // Refresh user session to update family status
      await sessionManager.refreshUser();

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Update local state
      if (mounted) {
        setState(() {
          _family = null;
          _familyMembers = [];
        });
      }

      // Show success message
      if (mounted) {
        StyledSnackBar.showSuccess(context, 'Successfully left family');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        String errorMessage = 'Failed to leave family';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else if (e.toString().contains('keeper')) {
          errorMessage = 'You must transfer the keeper role before leaving';
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  Future<void> _showTransferKeeperDialog() async {
    final user = sessionManager.currentUser;
    if (user?.familyId == null || _family == null) return;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    // Get list of members who are not the current keeper
    final otherMembers = _familyMembers.where((m) => !m.isKeeper && m.id != user?.id).toList();

    if (otherMembers.isEmpty) {
      // No other members, can leave directly
      await _leaveFamily();
      return;
    }

    // Show dialog to select new keeper
    final selectedMember = await showDialog<User?>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          'Transfer Keeper Role',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'As the keeper, you must transfer your role to another member before leaving. Select a member to become the new keeper:',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ...otherMembers.map((member) {
                final memberName = member.nickname ?? member.name;
                return ListTile(
                  title: Text(
                    memberName,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    member.email,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                  onTap: () => Navigator.pop(context, member),
                );
              }),
            ],
          ),
        ),
        actions: [
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

    if (selectedMember == null) return;

    // Transfer keeper role
    await _transferKeeper(selectedMember);
  }

  Future<void> _transferKeeper(User newKeeper) async {
    final user = sessionManager.currentUser;
    if (user?.familyId == null || _family == null) return;

    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
            ),
          ),
        );
      }

      // Transfer keeper role
      await apiService.families.transferKeeper(
        user!.familyId!,
        TransferKeeperRequest(newKeeperId: newKeeper.id),
      );

      // Refresh user session to update role
      await sessionManager.refreshUser();

      // Reload family members to reflect new keeper
      await _loadFamilyMembers();

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show success message
      if (mounted) {
        final newKeeperName = newKeeper.nickname ?? newKeeper.name;
        StyledSnackBar.showSuccess(context, 'Keeper role transferred to $newKeeperName');
      }

      if (mounted) {
        final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
        final isDark = themeProvider.isDarkMode;

        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
            title: Text(
              'Leave Family?',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
            content: Text(
              'You have successfully transferred the keeper role. Would you like to leave the family now?',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Stay',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Leave',
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        );

        if (shouldLeave == true) {
          await _leaveFamily();
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        String errorMessage = 'Failed to transfer keeper role';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  Future<void> _removeMember(User member) async {
    final user = sessionManager.currentUser;
    if (user?.familyId == null || _family == null) return;

    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    final memberName = member.nickname ?? member.name;

    // Show confirmation dialog
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          'Remove Member',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: Text(
          'Are you sure you want to remove "$memberName" from "${_family!.name}"? They will need an invite code to rejoin.',
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Remove',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldRemove != true) return;

    try {
      // Show loading indicator
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
            ),
          ),
        );
      }

      // Remove member
      await apiService.families.removeMember(user!.familyId!, member.id);

      // Reload family members
      await _loadFamilyMembers();

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      // Show success message
      if (mounted) {
        StyledSnackBar.showSuccess(context, '$memberName has been removed from the family');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        String errorMessage = 'Failed to remove member';
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
    final user = sessionManager.currentUser;
    final hasFamily = user?.hasFamily ?? false;
    final userFamilyId = user?.familyId;

    if (hasFamily && userFamilyId != null) {
      final currentFamilyId = _family?.id;
      if (currentFamilyId == null || currentFamilyId != userFamilyId) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && userFamilyId == sessionManager.currentUser?.familyId) {
            _loadFamilyInfo();
          }
        });
      } else if (_familyMembers.isEmpty && !_isLoadingMembers) {
        // If members list is empty, reload members
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && sessionManager.currentUser?.familyId != null) {
            _loadFamilyMembers();
          }
        });
      }
    } else if (!hasFamily && _family != null) {
      // Clear family if user no longer has a family
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !(sessionManager.currentUser?.hasFamily ?? false)) {
          setState(() {
            _family = null;
            _familyMembers = [];
          });
        }
      });
    }

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      appBar: AppBar(
        title: Text(
          'Settings',
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Family Invite Code Section (if user has a family)
          if (hasFamily && _family != null) ...[
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: brandPrimary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              color: isDark ? DarkColors.surface : LightColors.surface,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          color: brandPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _family!.name,
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                            ),
                          ),
                        ),
                        if (user?.isKeeper == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: brandPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Keeper',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: brandPrimary,
                              ),
                            ),
                          )
                        else if (user?.isMember == true)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (isDark ? DarkColors.textSecondary : LightColors.textSecondary).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Member',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_family!.description != null && _family!.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? DarkColors.surfaceMuted : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _family!.description!,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      'Invite Code',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? DarkColors.surfaceMuted : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: brandPrimary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _family!.inviteCode,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.copy,
                              color: brandPrimary,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: () => _copyInviteCode(_family!.inviteCode),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Show share invite code button for all members
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _shareInviteCode(_family!),
                        icon: const Icon(Icons.share, size: 20),
                        label: const Text(
                          'Share Invite Code',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: _handleLeaveFamily,
                        icon: Icon(Icons.exit_to_app, size: 20, color: Colors.red),
                        label: Text(
                          'Leave Family',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          // Family Members Section (All members can see)
          if (hasFamily && _family != null) ...[
            const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: isDark ? DarkColors.border : LightColors.border,
                    width: 1,
                  ),
                ),
                color: isDark ? DarkColors.surface : LightColors.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.people,
                            color: brandPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Family Members',
                            style: TextStyle(
                              fontFamily: 'Playfair Display',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_isLoadingMembers)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(brandPrimary),
                            ),
                          ),
                        )
                        else if (_familyMembers.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'No members found',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        else
                          ..._familyMembers.map((member) {
                          final memberAvatar = member.avatar;
                          final memberName = member.nickname ?? member.name;
                          final memberEmail = member.email;
                          final isMemberKeeper = member.isKeeper;
                          
                          // Decode base64 avatar if it's a data URI
                          ImageProvider? avatarImage;
                          if (memberAvatar != null && memberAvatar.isNotEmpty) {
                            if (memberAvatar.startsWith('data:image')) {
                              // Base64 data URI
                              try {
                                final base64Data = memberAvatar.contains(',')
                                    ? memberAvatar.split(',').last
                                    : memberAvatar;
                                final imageBytes = base64Decode(base64Data);
                                avatarImage = MemoryImage(imageBytes);
                              } catch (e) {
                                debugPrint('Error decoding avatar: $e');
                                avatarImage = null;
                              }
                            } else {
                              // Regular URL
                              avatarImage = NetworkImage(memberAvatar);
                            }
                          }
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: brandPrimary.withValues(alpha: 0.1),
                                  backgroundImage: avatarImage,
                                  child: avatarImage == null
                                      ? Text(
                                          memberName.isNotEmpty 
                                              ? memberName.substring(0, 1).toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            fontFamily: 'Manrope',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: brandPrimary,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(width: 12),
                                // Name and email
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              memberName,
                                              style: TextStyle(
                                                fontFamily: 'Manrope',
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isMemberKeeper)
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: brandPrimary.withValues(alpha: 0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  'Keeper',
                                                  style: TextStyle(
                                                    fontFamily: 'Manrope',
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                    color: brandPrimary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        memberEmail,
                                        style: TextStyle(
                                          fontFamily: 'Manrope',
                                          fontSize: 12,
                                          color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                if (user?.isKeeper == true && 
                                    !isMemberKeeper && 
                                    member.id != user?.id)
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                      size: 20,
                                    ),
                                    onPressed: () => _removeMember(member),
                                    tooltip: 'Remove member',
                                  ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          // Theme Toggle
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? DarkColors.border : LightColors.border,
                width: 1,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: SvgPicture.asset(
                isDark ? 'assets/icons/Moon.svg' : 'assets/icons/Sun.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'Theme',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                ),
              ),
              subtitle: Text(
                isDark ? 'Dark Mode' : 'Light Mode',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
              trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
                activeThumbColor: brandPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Profile Settings
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? DarkColors.border : LightColors.border,
                width: 1,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: Icon(
                Icons.person_outline,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ProfileSettingsScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Delete Account
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? DarkColors.border : LightColors.border,
                width: 1,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              title: Text(
                'Delete Account',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              trailing: Icon(
                Icons.open_in_new,
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
              ),
              onTap: _openDeleteAccountPage,
            ),
          ),
          const SizedBox(height: 16),

          // Notifications
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? DarkColors.border : LightColors.border,
                width: 1,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: Icon(
                Icons.notifications_outlined,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
              title: Text(
                'Notifications',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // About
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? DarkColors.border : LightColors.border,
                width: 1,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: Icon(
                Icons.info_outline,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
              title: Text(
                'About',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                ),
              ),
              subtitle: Text(
                'Legacy Table Family Recipes',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
              ),
              onTap: () {
                // TODO: Show about dialog
              },
            ),
          ),
          const SizedBox(height: 16),

          // Logout
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: isDark ? DarkColors.border : LightColors.border,
                width: 1,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: SvgPicture.asset(
                'assets/icons/LogOut.svg',
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  Colors.red,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          
                          try {
                            // Perform logout
                            await sessionManager.logout();
                            
                            // Small delay to ensure logout completes
                            await Future.delayed(const Duration(milliseconds: 100));
                            
                            // Navigate to login screen using root navigator
                            // This ensures we clear the entire navigation stack
                            if (mounted) {
                              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            // Even if logout fails, try to navigate to login
                            if (mounted) {
                              Navigator.of(context, rootNavigator: true).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            }
                          }
                        },
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
