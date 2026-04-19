import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../config/app_theme.dart';
import '../providers/theme_provider.dart';
import '../models/family.dart';
import 'styled_snackbar.dart';

/// Dialog that lets the sender choose between sharing a deep link
/// (for new users) or just the invite code (for users who already have the app).
class ShareInviteDialog extends StatefulWidget {
  final Family family;

  const ShareInviteDialog({super.key, required this.family});

  @override
  State<ShareInviteDialog> createState() => _ShareInviteDialogState();
}

class _ShareInviteDialogState extends State<ShareInviteDialog> {
  bool _useLinkMode = true; // Default to link mode

  String get _inviteLink =>
      'https://api.legacytable.app/invite/${widget.family.inviteCode}';

  String get _shareText {
    final desc = widget.family.description;
    final descText =
        (desc != null && desc.isNotEmpty) ? '\n\n$desc' : '';

    if (_useLinkMode) {
      return 'Join my family "${widget.family.name}" on Legacy Table!'
          '\n\n$_inviteLink'
          '$descText';
    } else {
      return 'Join my family "${widget.family.name}" on Legacy Table!'
          '\n\nInvite Code: ${widget.family.inviteCode}'
          '$descText';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Dialog(
      backgroundColor: isDark ? DarkColors.surface : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Text(
              'Share Invite',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.family.name,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 14,
                color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),

            // Toggle buttons
            Container(
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surfaceMuted : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _useLinkMode = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _useLinkMode
                              ? (isDark ? DarkColors.surface : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: _useLinkMode
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.link,
                              size: 16,
                              color: _useLinkMode
                                  ? brandPrimary
                                  : (isDark
                                      ? DarkColors.textMuted
                                      : LightColors.textMuted),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Link',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: _useLinkMode
                                    ? brandPrimary
                                    : (isDark
                                        ? DarkColors.textMuted
                                        : LightColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _useLinkMode = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_useLinkMode
                              ? (isDark ? DarkColors.surface : Colors.white)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: !_useLinkMode
                              ? [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.05),
                                    blurRadius: 4,
                                  )
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.pin,
                              size: 16,
                              color: !_useLinkMode
                                  ? brandPrimary
                                  : (isDark
                                      ? DarkColors.textMuted
                                      : LightColors.textMuted),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Code',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: !_useLinkMode
                                    ? brandPrimary
                                    : (isDark
                                        ? DarkColors.textMuted
                                        : LightColors.textMuted),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Content display
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surfaceMuted : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: Column(
                children: [
                  if (_useLinkMode) ...[
                    Icon(Icons.link, size: 28, color: brandPrimary),
                    const SizedBox(height: 8),
                    Text(
                      _inviteLink,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 13,
                        color: isDark
                            ? DarkColors.textSecondary
                            : LightColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Opens the app or shows download options',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        color: isDark
                            ? DarkColors.textMuted
                            : LightColors.textMuted,
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    Text(
                      widget.family.inviteCode,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3,
                        color: isDark
                            ? DarkColors.textPrimary
                            : LightColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Recipient enters this code in the app',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Manrope',
                        fontSize: 11,
                        color: isDark
                            ? DarkColors.textMuted
                            : LightColors.textMuted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                // Copy button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final text =
                          _useLinkMode ? _inviteLink : widget.family.inviteCode;
                      await Clipboard.setData(ClipboardData(text: text));
                      if (context.mounted) {
                        StyledSnackBar.showSuccess(context, 'Copied!');
                      }
                    },
                    icon: const Icon(Icons.copy, size: 18),
                    label: const Text('Copy'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor:
                          isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                      side: BorderSide(
                        color: isDark ? DarkColors.border : LightColors.border,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Share button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await Share.share(_shareText);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.share, size: 18),
                    label: const Text('Share'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: brandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
