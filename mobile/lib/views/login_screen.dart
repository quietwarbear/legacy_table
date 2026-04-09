import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../config/app_theme.dart';
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
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Login failed';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
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
    } catch (e) {
      if (mounted) {
        String errorMessage = 'Google sign-in failed';
        if (e.toString().contains('Exception:')) {
          errorMessage = e.toString().replaceFirst('Exception: ', '');
        }
        StyledSnackBar.showError(context, errorMessage);
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
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

      final fullName = [credential.givenName, credential.familyName]
          .where((s) => s != null)
          .join(' ');

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
    } catch (e) {
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

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

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
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
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
                          width: 120,
                          height: 120,
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
                          fontSize: 32,
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
                          fontSize: 16,
                          color: isDark
                              ? DarkColors.textSecondary
                              : LightColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 40),

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
                      const SizedBox(height: 24),

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
                      const SizedBox(height: 32),

                      // Sign In Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
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
                      const SizedBox(height: 16),

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

                      // Google Sign-In Button
                      OutlinedButton(
                        onPressed: (_isLoading || _isGoogleLoading)
                            ? null
                            : _handleGoogleSignIn,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                            color: isDark
                                ? DarkColors.border
                                : LightColors.border,
                            width: 1,
                          ),
                        ),
                        child: _isGoogleLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isDark
                                        ? DarkColors.textPrimary
                                        : LightColors.textPrimary,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google "G" logo
                                  Container(
                                    width: 20,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      'G',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF4285F4),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Continue with Google',
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? DarkColors.textPrimary
                                          : LightColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 12),

                      // Apple Sign-In Button
                      OutlinedButton(
                        onPressed: (_isLoading || _isAppleLoading)
                            ? null
                            : _handleAppleSignIn,
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: _isAppleLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Apple logo
                                  const Text(
                                    '\u{F8FF}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Continue with Apple',
                                    style: TextStyle(
                                      fontFamily: 'Manrope',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                      const SizedBox(height: 24),

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
