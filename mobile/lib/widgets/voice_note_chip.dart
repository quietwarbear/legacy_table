import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/analytics_service.dart';

/// The voice keepsake player — "her voice stays with the recipe."
/// Streams from the public listen endpoint; the token is the capability.
class VoiceNoteChip extends StatefulWidget {
  final String voiceToken;
  final String? authorName;

  const VoiceNoteChip({super.key, required this.voiceToken, this.authorName});

  @override
  State<VoiceNoteChip> createState() => _VoiceNoteChipState();
}

class _VoiceNoteChipState extends State<VoiceNoteChip> {
  final AudioPlayer _player = AudioPlayer();
  PlayerState _state = PlayerState.stopped;

  String get _url =>
      '${AppConfig.baseUrl}${AppConfig.apiPrefix}/listen/${widget.voiceToken}';

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _state = s);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _toggle() async {
    if (_state == PlayerState.playing) {
      await _player.pause();
    } else {
      await analytics.capture('voice_played');
      await _player.play(UrlSource(_url));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final playing = _state == PlayerState.playing;

    final label = widget.authorName != null && widget.authorName!.isNotEmpty
        ? '${widget.authorName} · ${l10n.recipeDetailVoiceNote}'
        : l10n.recipeDetailVoiceNote;

    return Material(
      color: brandPrimary.withValues(alpha: isDark ? 0.18 : 0.10),
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: _toggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: 20,
                color: brandPrimary,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Manrope',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? DarkColors.textPrimary
                        : LightColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
