import 'package:dio/dio.dart' show DioException, DioExceptionType;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:provider/provider.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../config/api_config.dart';
import '../config/app_theme.dart';
import '../main.dart' show facebookAppEvents;
import '../providers/theme_provider.dart';
import '../services/session_manager.dart';
import '../services/storage_service.dart';
import '../widgets/styled_snackbar.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const String _iosGoogleClientId =
      '229052236659-h4op49fi71nktbtrtp0vjdemaaputub7.apps.googleusercontent.com';
  static const String _webGoogleClientId =
      '229052236659-t8h924k1gj6llotoebdarle2v5deet0q.apps.googleusercontent.com';

  final _formKey = GlobalKey<FormState>();
  final StorageService _storageService = StorageService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isGoogleLoading = false;
  bool _isAppleLoading = false;
  bool _isFacebookLoading = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    clientId: defaultTargetPlatform == TargetPlatform.iOS
        ? _iosGoogleClientId
        : null,
    serverClientId: _webGoogleClientId,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Build a single descriptive error message from any thrown error.
  ///
  /// The default Dart try/catch swallows error TYPES; this preserves them.
  /// Critically, this handles DioException (network/HTTP errors thrown by
  /// the api_client when the backend is unreachable, returns 4xx/5xx, or
  /// times out) which previously fell through the generic catch and showed
  /// a meaningless "Google sign-in failed".
  String _describeAuthError(String flow, Object e) {
    // Always log full detail so `flutter logs` shows it for debugging.
    debugPrint('[$flow] ${e.runtimeType}: $e');

    if (e is DioException) {
      final url = e.requestOptions.baseUrl + e.requestOptions.path;
      final status = e.response?.statusCode;
      final body = e.response?.data;
      debugPrint('[$flow] DioException URL=$url status=$status body=$body');
      // Use if/else rather than switch — older Dart toolchains reject
      // enum-value cases as "not a constant expression" in classic switch.
      final type = e.type;
      if (type == DioExceptionType.connectionError ||
          type == DioExceptionType.connectionTimeout) {
        return "$flow failed: can't reach ${ApiConfig.apiBaseUrl}. "
            "Check internet / VPN, or verify the backend is up.";
      }
      if (type == DioExceptionType.sendTimeout ||
          type == DioExceptionType.receiveTimeout) {
        return "$flow failed: backend timed out (${type.name}).";
      }
      if (type == DioExceptionType.badCertificate) {
        return "$flow failed: TLS/cert problem reaching ${ApiConfig.apiBaseUrl}.";
      }
      if (type == DioExceptionType.badResponse) {
        return "$flow failed: backend returned $status. ${body ?? ''}";
      }
      if (type == DioExceptionType.cancel) {
        return "$flow cancelled.";
      }
      // DioExceptionType.unknown or anything else
      return "$flow failed: ${e.message ?? 'unknown network error'}";
    }

    if (e is PlatformException) {
      final detail = e.message ?? e.details?.toString() ?? 'no detail';
      return "$flow failed [${e.code}]: $detail";
    }

    if (e.toString().startsWith('Exception:')) {
      return e.toString().replaceFirst('Exception: ', '');
    }

    return "$flow failed: $e";
  }

  Future<void> _handleLogin() async {
    // Dismiss keyboard safely
    final currentFocus = FocusScope.of(context);
    if (currentFocus.hasPrimaryFocus || currentFocus.focusedChild != null) {
      currentFocus.unfocus();
      // Wait a frame to ensure keyboard is dismissed
      await Future.delayed(const Duration(milliseconds: 100));
    }

    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await sessionManager.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (mounted) {
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e, stackTrace) {
      debugPrint('[EmailLogin] stack: $stackTrace');
      if (mounted) {
        StyledSnackBar.showError(context, _describeAuthError('Login', e));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled
        setState(() {
          _isGoogleLoading = false;
        });
        return;
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        throw Exception('Failed to get Google ID token');
      }

      final isNewGoogleUser = await sessionManager.googleLogin(idToken);

      if (isNewGoogleUser) {
        await _storageService.setPendingSubscriptionAfterRegister(true);
      }

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          isNewGoogleUser ? '/subscription' : '/home',
          (route) => false,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[GoogleSignIn] stack: $stackTrace');
      if (mounted) {
        StyledSnackBar.showError(
          context,
          _describeAuthError('Google sign-in', e),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  Future<void> _handleFacebookSignIn() async {
    setState(() {
      _isFacebookLoading = true;
    });

    try {
      // Triggers the Facebook Login dialog (in-app SDK on iOS).
      final result = await FacebookAuth.instance.login(
        permissions: const ['email', 'public_profile'],
      );

      switch (result.status) {
        case LoginStatus.success:
          final accessToken = result.accessToken;
          if (accessToken == null) {
            throw Exception('Facebook returned no access token');
          }

          // Fire App Event so Meta attributes the sign-up to the right ad.
          await facebookAppEvents.logEvent(
            name: 'fb_mobile_login',
            parameters: {'method': 'facebook'},
          );

          // Hand off to backend /auth/facebook — same pattern as Google/Apple.
          // Backend verifies the access token with Facebook's debug_token
          // endpoint and returns our own session token.
          final isNewFacebookUser = await sessionManager.facebookLogin(
            accessToken.tokenString,
          );

          if (isNewFacebookUser) {
            await _storageService.setPendingSubscriptionAfterRegister(true);
          }

          if (mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              isNewFacebookUser ? '/subscription' : '/home',
              (route) => false,
            );
          }
          break;

        case LoginStatus.cancelled:
          // User dismissed the sheet — silent, matches Google/Apple behavior.
          break;

        case LoginStatus.failed:
          throw Exception(result.message ?? 'Facebook login failed');

        case LoginStatus.operationInProgress:
          // Another FB auth call is already in flight; ignore the duplicate tap.
          break;
      }
    } catch (e, stackTrace) {
      debugPrint('[FacebookSignIn] stack: $stackTrace');
      if (mounted) {
        StyledSnackBar.showError(
          context,
          _describeAuthError('Facebook sign-in', e),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isFacebookLoading = false;
        });
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    setState(() {
      _isAppleLoading = true;
    });

    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final idToken = credential.identityToken;
      if (idToken == null) {
        throw Exception('No identity token');
      }

      final fullName = [
        credential.givenName,
        credential.familyName,
      ].where((s) => s != null).join(' ');

      final isNewAppleUser = await sessionManager.appleLogin(
        idToken,
        fullName: fullName,
        email: credential.email ?? '',
      );

      if (isNewAppleUser) {
        await _storageService.setPendingSubscriptionAfterRegister(true);
      }

      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          isNewAppleUser ? '/subscription' : '/home',
          (route) => false,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('Apple sign-in error: $e');
      debugPrint('Stack trace: $stackTrace');
      if (mounted) {
        String errorMessage = 'Apple sign-in failed';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        // Check if user cancelled the sign-in
        if (!errorMessage.toLowerCase().contains('cancel') &&
            !errorMessage.toLowerCase().contains('user_cancelled')) {
          StyledSnackBar.showError(context, errorMessage);
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAppleLoading = false;
        });
      }
    }
  }

  Widget _buildProviderButton({
    required String label,
    required Widget icon,
    required bool isLoading,
    required VoidCallback? onPressed,
    required Color backgroundColor,
    required Color foregroundColor,
    required Color borderColor,
  }) {
    return Expanded(
      child: SizedBox(
        height: 48,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            disabledBackgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            disabledForegroundColor: foregroundColor.withValues(alpha: 0.55),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 48),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: BorderSide(color: borderColor, width: 1),
          ),
          child: isLoading
              ? SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                  ),
                )
              : FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      icon,
                      const SizedBox(width: 6),
                      Text(
                        label,
                        maxLines: 1,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: foregroundColor,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isAnySocialLoading =
        _isGoogleLoading || _isAppleLoading || _isFacebookLoading;

    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: isDark
            ? DarkColors.background
            : LightColors.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: isDark ? DarkColors.surface : LightColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.3 : 0.05,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo
                      Center(
                        child: Image.asset(
                          isDark
                              ? 'assets/images/app-logo-white.png'
                              : 'assets/images/app-logo.png',
                          width: 92,
                          height: 92,
                          fit: BoxFit.contain,
                        ),
                      ),
                      // const SizedBox(height: 12),

                      // Title
                      Text(
                        'Legacy Table',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Dancing Script',
                          // fontFamily: 'Playfair Display',
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? DarkColors.textPrimary
                              : LightColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Subtitle
                      Text(
                        'Share your culinary heritage',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 15,
                          color: isDark
                              ? DarkColors.textSecondary
                              : LightColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Email Field
                      Text(
                        'EMAIL',
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
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          color: isDark
                              ? DarkColors.textPrimary
                              : LightColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: isDark
                                ? DarkColors.textMuted
                                : LightColors.textMuted,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? DarkColors.surfaceMuted
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? DarkColors.border
                                  : LightColors.border,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? DarkColors.border
                                  : LightColors.border,
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
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      Text(
                        'PASSWORD',
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
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleLogin(),
                        style: TextStyle(
                          fontFamily: 'Manrope',
                          fontSize: 16,
                          color: isDark
                              ? DarkColors.textPrimary
                              : LightColors.textPrimary,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: isDark
                                ? DarkColors.textMuted
                                : LightColors.textMuted,
                          ),
                          filled: true,
                          fillColor: isDark
                              ? DarkColors.surfaceMuted
                              : Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? DarkColors.border
                                  : LightColors.border,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: isDark
                                  ? DarkColors.border
                                  : LightColors.border,
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
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: isDark
                                  ? DarkColors.textMuted
                                  : LightColors.textMuted,
                              size: 20,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Sign In Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontFamily: 'Manrope',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                      const SizedBox(height: 14),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? DarkColors.border
                                  : LightColors.border,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                color: isDark
                                    ? DarkColors.textMuted
                                    : LightColors.textMuted,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: isDark
                                  ? DarkColors.border
                                  : LightColors.border,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Social sign-in buttons
                      Row(
                        children: [
                          _buildProviderButton(
                            label: 'Google',
                            icon: const Text(
                              'G',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF4285F4),
                              ),
                            ),
                            isLoading: _isGoogleLoading,
                            onPressed: (_isLoading || isAnySocialLoading)
                                ? null
                                : _handleGoogleSignIn,
                            backgroundColor: isDark
                                ? DarkColors.surfaceMuted
                                : Colors.white,
                            foregroundColor: isDark
                                ? DarkColors.textPrimary
                                : LightColors.textPrimary,
                            borderColor: isDark
                                ? DarkColors.border
                                : LightColors.border,
                          ),
                          const SizedBox(width: 10),
                          _buildProviderButton(
                            label: 'Apple',
                            icon: const Text(
                              '\u{F8FF}',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                            isLoading: _isAppleLoading,
                            onPressed: (_isLoading || isAnySocialLoading)
                                ? null
                                : _handleAppleSignIn,
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            borderColor: Colors.black,
                          ),
                          const SizedBox(width: 10),
                          _buildProviderButton(
                            label: 'Facebook',
                            icon: const Text(
                              'f',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                fontFamily: 'Helvetica',
                              ),
                            ),
                            isLoading: _isFacebookLoading,
                            onPressed: (_isLoading || isAnySocialLoading)
                                ? null
                                : _handleFacebookSignIn,
                            backgroundColor: const Color(0xFF1877F2),
                            foregroundColor: Colors.white,
                            borderColor: const Color(0xFF1877F2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Create Account Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'New to the family? ',
                            style: TextStyle(
                              fontFamily: 'Manrope',
                              fontSize: 14,
                              color: isDark
                                  ? DarkColors.textSecondary
                                  : LightColors.textSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const RegisterScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'Create account',
                              style: TextStyle(
                                fontFamily: 'Manrope',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: brandPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
