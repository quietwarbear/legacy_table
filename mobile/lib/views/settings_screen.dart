import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/subscription_provider.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final uri = Uri.parse('https://legacytable.app/delete-account');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        StyledSnackBar.showError(context, l10n.settingsCouldNotOpenDeleteAccount);
      }
    } catch (_) {
      if (mounted) {
        StyledSnackBar.showError(context, l10n.settingsCouldNotOpenDeleteAccount);
      }
    }
  }

  // Bottom sheet to choose the app language. Updates LocaleProvider, which
  // rebuilds MaterialApp with the new locale and persists the choice.
  void _showLanguagePicker(BuildContext context, bool isDark) {
    final localeProvider =
        Provider.of<LocaleProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context);
    final currentCode = Localizations.localeOf(context).languageCode;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        Widget option(String code, String label) {
          final selected = currentCode == code;
          return ListTile(
            title: Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: isDark
                    ? DarkColors.textPrimary
                    : LightColors.textPrimary,
              ),
            ),
            trailing:
                selected ? Icon(Icons.check, color: brandPrimary) : null,
            onTap: () {
              localeProvider.setLocale(Locale(code));
              Navigator.of(sheetContext).pop();
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.selectLanguage,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                ),
              ),
              ...LocaleProvider.supportedLocales.map(
                (loc) => option(
                  loc.languageCode,
                  LocaleProvider.languageNames[loc.languageCode] ??
                      loc.languageCode,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openSubscription(BuildContext context) async {
    await Navigator.of(context).pushNamed('/subscription');
    if (context.mounted) {
      context.read<SubscriptionProvider>().loadSubscriptionStatus();
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
          StyledSnackBar.showError(
            context,
            AppLocalizations.of(context).settingsFailedToLoadMembers,
          );
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
        print(
          'Family loaded successfully: ${family.name}, Invite Code: ${family.inviteCode}',
        );
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
      StyledSnackBar.showSuccess(
        context,
        AppLocalizations.of(context).settingsInviteCodeCopied,
      );
    }
  }

  Future<void> _shareInviteCode(Family family) async {
    final l10n = AppLocalizations.of(context);
    final descriptionText =
        family.description != null && family.description!.isNotEmpty
        ? '\n\n${family.description}'
        : '';

    final shareText =
        '${l10n.settingsShareInviteJoin(family.name)}\n\n'
        '${l10n.settingsShareInviteCode(family.inviteCode)}'
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
    final l10n = AppLocalizations.of(context);

    // Show confirmation dialog
    final shouldLeave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          l10n.settingsLeaveFamily,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: Text(
          l10n.settingsLeaveFamilyConfirm(_family!.name),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark
                ? DarkColors.textSecondary
                : LightColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.settingsCancel,
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.settingsLeave,
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
        StyledSnackBar.showSuccess(context, l10n.settingsLeftFamilySuccess);
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        String errorMessage = l10n.settingsFailedToLeaveFamily;
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else if (e.toString().contains('keeper')) {
          errorMessage = l10n.settingsMustTransferBeforeLeaving;
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
    final l10n = AppLocalizations.of(context);

    // Get list of members who are not the current keeper
    final otherMembers = _familyMembers
        .where((m) => !m.isKeeper && m.id != user?.id)
        .toList();

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
          l10n.settingsTransferKeeperRole,
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
                l10n.settingsTransferKeeperPrompt,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark
                      ? DarkColors.textSecondary
                      : LightColors.textSecondary,
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
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    member.email,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
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
              l10n.settingsCancel,
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
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

    final l10n = AppLocalizations.of(context);

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
        StyledSnackBar.showSuccess(
          context,
          l10n.settingsKeeperTransferredTo(newKeeperName),
        );
      }

      if (mounted) {
        final themeProvider = Provider.of<ThemeProvider>(
          context,
          listen: false,
        );
        final isDark = themeProvider.isDarkMode;

        final shouldLeave = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
            title: Text(
              l10n.settingsLeaveFamilyQuestion,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark
                    ? DarkColors.textPrimary
                    : LightColors.textPrimary,
              ),
            ),
            content: Text(
              l10n.settingsTransferSuccessLeavePrompt,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  l10n.settingsStay,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    color: isDark
                        ? DarkColors.textSecondary
                        : LightColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  l10n.settingsLeave,
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
        String errorMessage = l10n.settingsFailedToTransferKeeper;
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
    final l10n = AppLocalizations.of(context);

    final memberName = member.nickname ?? member.name;

    // Show confirmation dialog
    final shouldRemove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? DarkColors.surface : LightColors.surface,
        title: Text(
          l10n.settingsRemoveMember,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        content: Text(
          l10n.settingsRemoveMemberConfirm(memberName, _family!.name),
          style: TextStyle(
            fontFamily: 'Manrope',
            fontSize: 14,
            color: isDark
                ? DarkColors.textSecondary
                : LightColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              l10n.settingsCancel,
              style: TextStyle(
                fontFamily: 'Manrope',
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              l10n.settingsRemove,
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
        StyledSnackBar.showSuccess(
          context,
          l10n.settingsMemberRemoved(memberName),
        );
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
      }

      // Show error message
      if (mounted) {
        String errorMessage = l10n.settingsFailedToRemoveMember;
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
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
          l10n.settingsTitle,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        backgroundColor: isDark
            ? DarkColors.background
            : LightColors.background,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: subscriptionProvider.hasAnySubscription
                    ? brandSecondary.withValues(alpha: 0.5)
                    : brandPrimary.withValues(alpha: 0.45),
                width: 1.2,
              ),
            ),
            color: isDark ? DarkColors.surface : LightColors.surface,
            child: ListTile(
              leading: Icon(
                subscriptionProvider.hasAnySubscription
                    ? Icons.verified_outlined
                    : Icons.workspace_premium_outlined,
                color: subscriptionProvider.hasAnySubscription
                    ? brandSecondary
                    : brandPrimary,
              ),
              title: Text(
                subscriptionProvider.hasAnySubscription
                    ? l10n.settingsManageSubscription
                    : l10n.settingsUpgradeToPremium,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark
                      ? DarkColors.textPrimary
                      : LightColors.textPrimary,
                ),
              ),
              subtitle: Text(
                switch (subscriptionProvider.tier) {
                  SubscriptionTier.legacy => l10n.settingsLegacyCollectionActive,
                  SubscriptionTier.heritage =>
                    l10n.settingsHeritageKeeperActive,
                  SubscriptionTier.none => l10n.settingsUnlockPremiumFeatures,
                },
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark
                      ? DarkColors.textSecondary
                      : LightColors.textSecondary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: isDark ? DarkColors.textMuted : LightColors.textMuted,
              ),
              onTap: () => _openSubscription(context),
            ),
          ),
          const SizedBox(height: 16),

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
                        Icon(Icons.group, color: brandPrimary, size: 24),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _family!.name,
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
                        if (user?.isKeeper == true)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: brandPrimary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.settingsKeeperBadge,
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (isDark
                                          ? DarkColors.textSecondary
                                          : LightColors.textSecondary)
                                      .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.settingsMemberBadge,
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? DarkColors.textSecondary
                                    : LightColors.textSecondary,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (_family!.description != null &&
                        _family!.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? DarkColors.surfaceMuted
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _family!.description!,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: isDark
                                ? DarkColors.textSecondary
                                : LightColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Text(
                      l10n.settingsInviteCodeLabel,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? DarkColors.surfaceMuted
                            : Colors.grey[100],
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
                                color: isDark
                                    ? DarkColors.textPrimary
                                    : LightColors.textPrimary,
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
                            onPressed: () =>
                                _copyInviteCode(_family!.inviteCode),
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
                        label: Text(
                          l10n.settingsShareInviteCodeButton,
                          style: const TextStyle(
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
                        icon: Icon(
                          Icons.exit_to_app,
                          size: 20,
                          color: Colors.red,
                        ),
                        label: Text(
                          l10n.settingsLeaveFamily,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.red,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.red.withValues(alpha: 0.5),
                          ),
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
                        Icon(Icons.people, color: brandPrimary, size: 24),
                        const SizedBox(width: 12),
                        Text(
                          l10n.settingsFamilyMembers,
                          style: TextStyle(
                            fontFamily: 'Playfair Display',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? DarkColors.textPrimary
                                : LightColors.textPrimary,
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              brandPrimary,
                            ),
                          ),
                        ),
                      )
                    else if (_familyMembers.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          l10n.settingsNoMembersFound,
                          style: TextStyle(
                            fontFamily: 'Manrope',
                            fontSize: 14,
                            color: isDark
                                ? DarkColors.textSecondary
                                : LightColors.textSecondary,
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
                                backgroundColor: brandPrimary.withValues(
                                  alpha: 0.1,
                                ),
                                backgroundImage: avatarImage,
                                child: avatarImage == null
                                    ? Text(
                                        memberName.isNotEmpty
                                            ? memberName
                                                  .substring(0, 1)
                                                  .toUpperCase()
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
                                              color: isDark
                                                  ? DarkColors.textPrimary
                                                  : LightColors.textPrimary,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        if (isMemberKeeper)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 6,
                                                    vertical: 2,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: brandPrimary.withValues(
                                                  alpha: 0.1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                              ),
                                              child: Text(
                                                l10n.settingsKeeperBadge,
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
                                        color: isDark
                                            ? DarkColors.textSecondary
                                            : LightColors.textSecondary,
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
                                  tooltip: l10n.settingsRemoveMemberTooltip,
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
                l10n.settingsTheme,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? DarkColors.textPrimary
                      : LightColors.textPrimary,
                ),
              ),
              subtitle: Text(
                isDark ? l10n.settingsDarkMode : l10n.settingsLightMode,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 14,
                  color: isDark
                      ? DarkColors.textSecondary
                      : LightColors.textSecondary,
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

          // Language
          Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              final currentCode = Localizations.localeOf(context).languageCode;
              final currentName =
                  LocaleProvider.languageNames[currentCode] ?? currentCode;
              return Card(
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
                    Icons.language,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                  title: Text(
                    l10n.settingsLanguage,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    currentName,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color:
                        isDark ? DarkColors.textMuted : LightColors.textMuted,
                  ),
                  onTap: () => _showLanguagePicker(context, isDark),
                ),
              );
            },
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
                color: isDark
                    ? DarkColors.textPrimary
                    : LightColors.textPrimary,
              ),
              title: Text(
                l10n.settingsEditProfile,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? DarkColors.textPrimary
                      : LightColors.textPrimary,
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
              leading: Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                l10n.settingsDeleteAccount,
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
                color: isDark
                    ? DarkColors.textPrimary
                    : LightColors.textPrimary,
              ),
              title: Text(
                l10n.settingsNotifications,
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? DarkColors.textPrimary
                      : LightColors.textPrimary,
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

          // Legal & About
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
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.description_outlined,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                  title: Text(
                    l10n.settingsTermsOfUse,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                  ),
                  onTap: () {
                    launchUrl(
                      Uri.parse('https://api.legacytable.app/terms'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
                ListTile(
                  leading: Icon(
                    Icons.privacy_tip_outlined,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                  title: Text(
                    l10n.settingsPrivacyPolicy,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                  ),
                  onTap: () {
                    launchUrl(
                      Uri.parse('https://api.legacytable.app/privacy-policy'),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                Divider(
                  height: 1,
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
                ListTile(
                  leading: Icon(
                    Icons.info_outline,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                  title: Text(
                    l10n.settingsAbout,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    l10n.settingsAboutVersion,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
                    ),
                  ),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                  ),
                  onTap: () {
                    showAboutDialog(
                      context: context,
                      applicationName: 'Legacy Table',
                      applicationVersion: '2.0.0',
                      applicationLegalese: l10n.settingsLegalese,
                    );
                  },
                ),
              ],
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
                colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
              ),
              title: Text(
                l10n.settingsLogout,
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
                    title: Text(l10n.settingsLogout),
                    content: Text(l10n.settingsLogoutConfirm),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: Text(l10n.settingsCancel),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext);

                          try {
                            // Perform logout
                            await sessionManager.logout();

                            // Small delay to ensure logout completes
                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );

                            // Navigate to login screen using root navigator
                            // This ensures we clear the entire navigation stack
                            if (mounted) {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            // Even if logout fails, try to navigate to login
                            if (mounted) {
                              Navigator.of(
                                context,
                                rootNavigator: true,
                              ).pushNamedAndRemoveUntil(
                                '/login',
                                (route) => false,
                              );
                            }
                          }
                        },
                        child: Text(l10n.settingsLogout),
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
