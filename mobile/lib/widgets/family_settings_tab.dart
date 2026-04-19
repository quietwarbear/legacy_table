import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../config/app_theme.dart';
import '../providers/theme_provider.dart';
import '../services/session_manager.dart';
import '../services/api_service.dart';
import '../models/family.dart';
import '../models/user.dart';
import '../widgets/styled_snackbar.dart';
import '../views/join_family_screen.dart';
import '../views/create_family_screen.dart';
import '../widgets/share_invite_dialog.dart';

/// Family tab that mirrors the website's /family page.
/// Shows family name, invite code, members list, and join/create actions.
class FamilySettingsTab extends StatefulWidget {
  const FamilySettingsTab({super.key});

  @override
  State<FamilySettingsTab> createState() => _FamilySettingsTabState();
}

class _FamilySettingsTabState extends State<FamilySettingsTab> {
  Family? _family;
  List<User> _familyMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFamilyInfo();
  }

  void refreshFamilyInfo() {
    if (kDebugMode) {
      print('FamilySettingsTab: refreshing family info...');
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _loadFamilyInfo();
      }
    });
  }

  Future<void> _loadFamilyInfo() async {
    if (!sessionManager.isLoggedIn) {
      if (mounted) {
        setState(() {
          _family = null;
          _familyMembers = [];
          _isLoading = false;
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
          _isLoading = false;
        });
      }
      return;
    }

    final familyId = user!.familyId!;

    try {
      final family = await apiService.families.getFamily(familyId);
      final members = await apiService.families.getFamilyMembers(familyId);

      if (mounted) {
        setState(() {
          _family = family;
          _familyMembers = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Error loading family info: $e');
        setState(() {
          _isLoading = false;
        });
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
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => ShareInviteDialog(family: family),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _family == null
                ? _buildNoFamilyState(isDark)
                : _buildFamilyView(isDark),
      ),
    );
  }

  Widget _buildNoFamilyState(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Family',
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Join or create a family to start sharing recipes',
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color:
                  isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? DarkColors.surface : LightColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people_outline,
                    size: 64,
                    color:
                        isDark ? DarkColors.textMuted : LightColors.textMuted,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'No family yet',
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Start sharing recipes with your family members',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 16,
                    color: isDark
                        ? DarkColors.textSecondary
                        : LightColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const JoinFamilyScreen(),
                          ),
                        );
                        if (result == true) _loadFamilyInfo();
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: brandPrimary),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Join Family',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
                          color: brandPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CreateFamilyScreen(),
                          ),
                        );
                        if (result != null && result['success'] == true) {
                          _loadFamilyInfo();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create Family',
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontWeight: FontWeight.w600,
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

  Widget _buildFamilyView(bool isDark) {
    final family = _family!;

    return RefreshIndicator(
      onRefresh: _loadFamilyInfo,
      color: brandPrimary,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Family settings',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color:
                    isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Manage your family and invite code.',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            // Family Name Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surface : LightColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      family.name,
                      style: TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? DarkColors.textPrimary
                            : LightColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _shareInviteCode(family),
                    icon: Icon(
                      Icons.share_outlined,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Invite Code Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surface : LightColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invite code',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? DarkColors.surfaceMuted
                              : LightColors.surfaceMuted,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          family.inviteCode ?? '',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                            color: isDark
                                ? DarkColors.textPrimary
                                : LightColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () =>
                            _copyInviteCode(family.inviteCode ?? ''),
                        icon: Icon(Icons.copy, size: 16, color: isDark ? DarkColors.textPrimary : LightColors.textPrimary),
                        label: Text(
                          'Copy',
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: isDark
                                ? DarkColors.textPrimary
                                : LightColors.textPrimary,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color:
                                isDark ? DarkColors.border : LightColors.border,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Share this code so others can join your family.',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      color: isDark
                          ? DarkColors.textMuted
                          : LightColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Members Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surface : LightColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Members',
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_familyMembers.isEmpty)
                    Text(
                      'No members yet',
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 14,
                        color: isDark
                            ? DarkColors.textMuted
                            : LightColors.textMuted,
                      ),
                    )
                  else
                    ..._familyMembers.map((member) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 18,
                                backgroundColor: brandSecondary,
                                child: Text(
                                  (member.name.isNotEmpty ? member.name : member.email)
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Manrope',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  member.name.isNotEmpty ? member.name : member.email,
                                  style: TextStyle(
                                    fontFamily: 'Manrope',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? DarkColors.textPrimary
                                        : LightColors.textPrimary,
                                  ),
                                ),
                              ),
                              if (member.isKeeper == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: brandAccent
                                        .withValues(alpha: isDark ? 0.3 : 0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Keeper',
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: brandAccent,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
