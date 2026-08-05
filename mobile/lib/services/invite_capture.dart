import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Deferred invite capture — recovers an invite code when the install came
/// through an app store and the deep link couldn't survive that boundary.
///
/// The web invite page (legacytable.app/invite/CODE) sets up both paths:
///   - Android: it appends `referrer=invite%3DCODE` to its Play Store link,
///     which Google Play hands back to us via the Install Referrer API.
///   - iOS: it copies the code to the clipboard when the visitor taps the
///     App Store link (Apple has no install-referrer equivalent), so we
///     check the clipboard for something shaped like an invite code.
///
/// Runs at most ONCE per install (SharedPreferences flag) and is only
/// invoked when the app was NOT opened via a real deep link, so the iOS
/// system paste notice appears a single time at most. Codes are 8 chars of
/// uppercase hex/alphanumerics (see backend: `str(uuid4())[:8].upper()`);
/// the JoinFamilyScreen the code is fed into is itself the user's
/// confirmation step — nothing joins automatically.
class InviteCapture {
  static const String _doneKey = 'deferred_invite_capture_done';
  static final RegExp _codePattern = RegExp(r'^[A-Z0-9]{8}$');

  /// Returns a plausible invite code exactly once per install, else null.
  static Future<String?> captureOnce() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getBool(_doneKey) ?? false) return null;
      await prefs.setBool(_doneKey, true);

      String? code;
      if (Platform.isAndroid) {
        code = await _fromInstallReferrer();
      } else if (Platform.isIOS) {
        code = await _fromClipboard();
      }

      if (code != null && _codePattern.hasMatch(code)) {
        debugPrint('[InviteCapture] deferred invite code recovered');
        return code;
      }
      return null;
    } catch (e) {
      debugPrint('[InviteCapture] error: $e');
      return null;
    }
  }

  static Future<String?> _fromInstallReferrer() async {
    try {
      final details = await PlayInstallReferrer.installReferrer;
      final referrer = details.installReferrer;
      if (referrer == null || referrer.isEmpty) return null;
      // Referrer may arrive URL-encoded ("invite%3DAB12CD34") or plain
      // ("invite=AB12CD34&utm_source=..."). Decode once, then parse.
      final decoded = Uri.decodeComponent(referrer);
      final params = Uri.splitQueryString(decoded);
      final code = params['invite']?.trim().toUpperCase();
      return (code == null || code.isEmpty) ? null : code;
    } catch (e) {
      // Sideloaded install, Play services unavailable, or referrer expired
      // (Play keeps it ~90 days) — all normal, all mean "no invite".
      debugPrint('[InviteCapture] install referrer unavailable: $e');
      return null;
    }
  }

  static Future<String?> _fromClipboard() async {
    // Reading the clipboard triggers the iOS system paste notice — this
    // method is reached once per install at most, so the user sees it once.
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim().toUpperCase();
    if (text == null || text.isEmpty) return null;
    return text;
  }
}
