import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../views/join_family_screen.dart';
import '../views/create_family_screen.dart';
import 'styled_snackbar.dart';

class FamilyPromptWidget extends StatelessWidget {
  final VoidCallback? onFamilyJoined;

  const FamilyPromptWidget({
    super.key,
    this.onFamilyJoined,
  });

  Future<void> _handleJoinFamily(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const JoinFamilyScreen(),
      ),
    );

    if (result == true && context.mounted) {
      onFamilyJoined?.call();
    }
  }

  Future<void> _handleCreateFamily(BuildContext context) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const CreateFamilyScreen(),
      ),
    );

    if (result != null && result['success'] == true && context.mounted) {
      onFamilyJoined?.call();
    }
  }

  Future<void> _handleTrySample(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      final result = await apiService.families.seedSampleFamily();
      if (context.mounted) {
        StyledSnackBar.showSuccess(
          context,
          (result['message'] as String?) ?? l10n.familyPromptSampleSuccess,
        );
        onFamilyJoined?.call();
      }
    } catch (_) {
      if (context.mounted) {
        StyledSnackBar.showError(context, l10n.familyPromptSampleFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? DarkColors.surface : LightColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: brandPrimary.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: brandPrimary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.group,
              size: 32,
              color: brandPrimary,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            l10n.familyPromptTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Playfair Display',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            l10n.familyPromptSubtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontSize: 14,
              color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _handleJoinFamily(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: brandPrimary,
                    side: BorderSide(color: brandPrimary, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.familyPromptJoinButton,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleCreateFamily(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    l10n.familyPromptCreateButton,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Quick Start: seed a sample cookbook so first-run users see value
          // before committing to creating or joining a real family.
          TextButton(
            onPressed: () => _handleTrySample(context),
            child: Text(
              l10n.familyPromptSampleButton,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
