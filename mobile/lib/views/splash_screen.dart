import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import '../services/storage_service.dart';

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
    // Wait for splash screen display
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    final storageService = StorageService();
    final isOnboardingCompleted = await storageService.isOnboardingCompleted();
    final isLoggedIn = await storageService.isLoggedIn();

    if (mounted) {
      if (!isOnboardingCompleted) {
        // First time user, show onboarding
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else if (isLoggedIn) {
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
