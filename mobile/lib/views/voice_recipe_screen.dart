import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import '../config/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../widgets/styled_snackbar.dart';
import 'add_recipe_screen.dart';

class VoiceRecipeScreen extends StatefulWidget {
  const VoiceRecipeScreen({super.key});

  @override
  State<VoiceRecipeScreen> createState() => _VoiceRecipeScreenState();
}

class _VoiceRecipeScreenState extends State<VoiceRecipeScreen> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isProcessing = false;
  String? _recordingPath;
  Duration _recordingDuration = Duration.zero;
  Timer? _durationTimer;

  @override
  void dispose() {
    _durationTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<bool> _requestMicPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecording() async {
    final granted = await _requestMicPermission();
    if (!granted) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        StyledSnackBar.showWarning(
          context,
          l10n.voiceRecipeMicPermissionRequired,
        );
      }
      return;
    }

    try {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/voice_recipe_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _recorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          sampleRate: 44100,
          bitRate: 128000,
        ),
        path: path,
      );

      setState(() {
        _isRecording = true;
        _recordingPath = path;
        _recordingDuration = Duration.zero;
      });

      _durationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _recordingDuration += const Duration(seconds: 1);
        });
      });
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        StyledSnackBar.showError(context, l10n.voiceRecipeFailedToStart(e.toString()));
      }
    }
  }

  Future<void> _stopRecording() async {
    _durationTimer?.cancel();

    try {
      final path = await _recorder.stop();
      setState(() {
        _isRecording = false;
        if (path != null) {
          _recordingPath = path;
        }
      });
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        StyledSnackBar.showError(context, l10n.voiceRecipeFailedToStop(e.toString()));
      }
    }
  }

  Future<void> _processRecording() async {
    if (_recordingPath == null) return;

    final file = File(_recordingPath!);
    if (!await file.exists()) {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        StyledSnackBar.showError(context, l10n.voiceRecipeFileNotFound);
      }
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      final bytes = await file.readAsBytes();
      final base64Audio = base64Encode(bytes);

      // Determine format from extension
      final ext = _recordingPath!.split('.').last.toLowerCase();
      final format = ext == 'wav' ? 'wav' : ext == 'webm' ? 'webm' : 'mp4';

      final result = await apiService.ai.voiceToRecipe(base64Audio, format);

      if (!mounted) return;

      // Show success with transcription preview
      if (result.creditsRemaining != null) {
        final l10n = AppLocalizations.of(context);
        StyledSnackBar.showSuccess(
          context,
          l10n.voiceRecipeTranscribedCredits(result.creditsRemaining!),
        );
      }

      // Navigate to AddRecipeScreen with the transcribed recipe
      final recipe = result.recipe;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AddRecipeScreen(
            recipe: null,
            initialTitle: recipe.title,
            initialIngredients: recipe.ingredients,
            initialInstructions: recipe.instructions,
            initialCookingTime: recipe.cookingTime,
            initialServings: recipe.servings,
            initialCategory: recipe.category,
            initialDifficulty: recipe.difficulty,
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        StyledSnackBar.showError(
          context,
          e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _resetRecording() {
    setState(() {
      _recordingPath = null;
      _recordingDuration = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasRecording = _recordingPath != null && !_isRecording;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(title: Text(l10n.voiceRecipeTitle)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.voiceRecipeIntro,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 16, color: Color(0xFFD97706)),
                  const SizedBox(width: 8),
                  Text(
                    l10n.voiceRecipeUsesCredits,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFFD97706),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Recording area
            Center(
              child: Column(
                children: [
                  // Mic button
                  GestureDetector(
                    onTap: _isProcessing
                        ? null
                        : (_isRecording ? _stopRecording : (hasRecording ? null : _startRecording)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _isRecording ? 140 : 120,
                      height: _isRecording ? 140 : 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRecording
                            ? Colors.red.withValues(alpha: 0.15)
                            : brandPrimary.withValues(alpha: 0.1),
                        border: Border.all(
                          color: _isRecording ? Colors.red : brandPrimary,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        size: 56,
                        color: _isRecording ? Colors.red : brandPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Duration / Status text
                  if (_isRecording) ...[
                    Text(
                      _formatDuration(_recordingDuration),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.voiceRecipeTapToStop,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                      ),
                    ),
                  ] else if (hasRecording) ...[
                    Text(
                      l10n.voiceRecipeRecordingDuration(_formatDuration(_recordingDuration)),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.voiceRecipeReadyToTranscribe,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brandPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ] else ...[
                    Text(
                      l10n.voiceRecipeTapToStart,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.voiceRecipeSpeakNaturally,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Tips card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? DarkColors.surface : LightColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isDark ? DarkColors.border : LightColors.border,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.voiceRecipeTipsTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.voiceRecipeTipsBody,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? DarkColors.textSecondary : LightColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Action buttons
            if (hasRecording) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _processRecording,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.auto_awesome_outlined),
                  label: Text(
                    _isProcessing ? l10n.voiceRecipeTranscribing : l10n.voiceRecipeTranscribeIntoDraft,
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _isProcessing ? null : _resetRecording,
                  icon: const Icon(Icons.refresh_outlined),
                  label: Text(l10n.voiceRecipeRecordAgain),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
