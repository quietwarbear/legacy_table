import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../providers/theme_provider.dart';
import '../services/api_service.dart';
import '../services/session_manager.dart';
import '../models/family.dart';
import '../widgets/styled_snackbar.dart';
import '../l10n/app_localizations.dart';

class JoinFamilyScreen extends StatefulWidget {
  final String? prefilledCode;

  const JoinFamilyScreen({super.key, this.prefilledCode});

  @override
  State<JoinFamilyScreen> createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _inviteCodeController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefilledCode != null && widget.prefilledCode!.isNotEmpty) {
      _inviteCodeController.text = widget.prefilledCode!;
    }
  }

  @override
  void dispose() {
    _inviteCodeController.dispose();
    super.dispose();
  }

  Future<void> _handleJoinFamily() async {
    final l10n = AppLocalizations.of(context);
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Format invite code (uppercase, remove spaces)
      final inviteCode = _inviteCodeController.text
          .trim()
          .toUpperCase()
          .replaceAll(RegExp(r'[^A-Z0-9]'), '');

      if (inviteCode.length != 8) {
        throw Exception(l10n.joinFamilyCodeLengthError);
      }

      final response = await apiService.families.joinFamily(
        JoinFamilyRequest(inviteCode: inviteCode),
      );

      // Update session manager with new user data
      await sessionManager.refreshUser();

      if (mounted) {
        StyledSnackBar.showSuccess(context, l10n.joinFamilySuccess(response.family.name));
        Navigator.of(context).pop(true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = l10n.joinFamilyGenericError;
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        } else if (e.toString().contains('404')) {
          errorMessage = l10n.joinFamilyInvalidCodeError;
        } else if (e.toString().contains('409')) {
          errorMessage = l10n.joinFamilyAlreadyMemberError;
        } else {
          errorMessage = e.toString();
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? DarkColors.background : LightColors.background,
      appBar: AppBar(
        title: Text(
          l10n.joinFamilyAppBarTitle,
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
          ),
        ),
        backgroundColor: isDark ? DarkColors.background : LightColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
          color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Icon
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: brandPrimary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.group_add,
                        size: 40,
                        color: brandPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    l10n.joinFamilyHeading,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Subtitle
                  Text(
                    l10n.joinFamilySubtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 16,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Invite Code Field
                  Text(
                    l10n.joinFamilyInviteCodeLabel,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _inviteCodeController,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 8,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: 'ABC12345',
                      hintStyle: TextStyle(
                        color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                        letterSpacing: 2,
                      ),
                      filled: true,
                      fillColor: isDark ? DarkColors.surfaceMuted : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? DarkColors.border : LightColors.border,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDark ? DarkColors.border : LightColors.border,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: brandPrimary,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      counterText: '',
                    ),
                    onFieldSubmitted: (_) => _handleJoinFamily(),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.joinFamilyEmptyCodeError;
                      }
                      final cleaned = value.trim().toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
                      if (cleaned.length != 8) {
                        return l10n.joinFamilyCodeLengthError;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 32),

                  // Join Family Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleJoinFamily,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            l10n.joinFamilyButton,
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),

                  // Info Text
                  Text(
                    l10n.joinFamilyInfoText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 14,
                      color: isDark ? DarkColors.textMuted : LightColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
