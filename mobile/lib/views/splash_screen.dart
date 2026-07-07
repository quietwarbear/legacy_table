import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../services/storage_service.dart';
import '../services/session_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
  }

  Future<void> _checkOnboardingStatus() async {
    // Wait for splash screen display and session validation in parallel
    await Future.wait([
      Future.delayed(const Duration(seconds: 3)),
      sessionManager.initialized,
    ]);

    if (!mounted) return;

    final storageService = StorageService();
    final isOnboardingCompleted = await storageService.isOnboardingCompleted();
    final pendingSubscription =
        await storageService.getPendingSubscriptionAfterRegister();
    final hasFirstRecipe = await storageService.getHasCreatedFirstRecipe();

    if (mounted) {
      if (!isOnboardingCompleted) {
        // First time user, show onboarding
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else if (sessionManager.isLoggedIn &&
          pendingSubscription &&
          hasFirstRecipe) {
        // Pitch the subscription only after the user has experienced value
        // (saved their first recipe), never before.
        Navigator.of(context).pushReplacementNamed('/subscription');
      } else if (sessionManager.isLoggedIn) {
        // Use validated session state, not raw storage flag
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  } 

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(themeProvider.backgroundImagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo Icon
              Image.asset(
                isDark ? 'assets/images/app-logo-white.png' : 'assets/images/app-logo.png',
                width: 180,
                height: 180,
                fit: BoxFit.contain,
              ),
              // const SizedBox(height: 12),
              // App Name
              Text(
                'Legacy Table',
                style: TextStyle(
                  fontFamily: 'Dancing Script',
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: isDark ? DarkColors.textPrimary : LightColors.textPrimary,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
