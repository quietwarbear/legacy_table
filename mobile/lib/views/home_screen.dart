import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/subscription_provider.dart';
import '../config/app_theme.dart';
import 'recipe_feed_screen.dart';
import 'cookbook_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'add_recipe_screen.dart';
import '../widgets/family_settings_tab.dart';
import '../l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showFabs = true;
  Timer? _fabHideTimer;
  DateTime? _fabVisibleUntil;

  final GlobalKey _recipeFeedKey = GlobalKey();
  final GlobalKey _cookbookKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _familyKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      RecipeFeedScreen(key: _recipeFeedKey),
      CookbookScreen(key: _cookbookKey),
      ProfileScreen(key: _profileKey),
      FamilySettingsTab(key: _familyKey),
      SettingsScreen(key: _settingsKey),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SubscriptionProvider>().loadSubscriptionStatus();
      }
    });

    _startFabHideTimer();
  }

  @override
  void dispose() {
    _fabHideTimer?.cancel();
    super.dispose();
  }

  void _startFabHideTimer() {
    _fabHideTimer?.cancel();
    _fabVisibleUntil = DateTime.now().add(const Duration(seconds: 30));
    _fabHideTimer = Timer(const Duration(seconds: 30), () {
      if (!mounted) return;
      setState(() {
        _showFabs = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final hasSubscription = subscriptionProvider.hasAnySubscription;
    final shouldShowFabs =
        _currentIndex == 0 &&
        _showFabs &&
        (_fabVisibleUntil == null ||
            DateTime.now().isBefore(_fabVisibleUntil!));

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _screens),
          if (_currentIndex == 0)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12,
              right: 16,
              child: _buildSubscriptionBanner(
                context: context,
                isDark: isDark,
                subscriptionProvider: subscriptionProvider,
              ),
            ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? DarkColors.surface : LightColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: 'assets/icons/Home.svg',
                  label: l10n.homeNavHome,
                  index: 0,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/BookOpen.svg',
                  label: l10n.homeNavCookbook,
                  index: 1,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/User.svg',
                  label: l10n.homeNavMyRecipes,
                  index: 2,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/Users.svg',
                  label: l10n.homeNavFamily,
                  index: 3,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/Settings.svg',
                  label: l10n.homeNavSettings,
                  index: 4,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: shouldShowFabs
          ? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!hasSubscription) ...[
                  FloatingActionButton.extended(
                    heroTag: 'upgrade_fab',
                    onPressed: () => _openSubscription(context),
                    backgroundColor: brandAccent,
                    foregroundColor: isDark
                        ? DarkColors.background
                        : LightColors.textPrimary,
                    icon: const Icon(Icons.workspace_premium_outlined),
                    label: Text(
                      l10n.homeUpgradeFab,
                      style: const TextStyle(
                        fontFamily: 'Manrope',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                FloatingActionButton.extended(
                  heroTag: 'share_recipe_fab',
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const AddRecipeScreen(),
                      ),
                    );
                    if (result == true) {
                      await Future.delayed(const Duration(milliseconds: 100));

                      final recipeFeedState = _recipeFeedKey.currentState;
                      final cookbookState = _cookbookKey.currentState;

                      if (recipeFeedState != null) {
                        try {
                          (recipeFeedState as dynamic).refreshRecipes();
                        } catch (e) {
                          if (kDebugMode) {
                            print('Error refreshing recipe feed: $e');
                          }
                        }
                      }
                      if (cookbookState != null) {
                        try {
                          (cookbookState as dynamic).refreshRecipes();
                        } catch (e) {
                          if (kDebugMode) {
                            print('Error refreshing cookbook: $e');
                          }
                        }
                      }
                    }
                    if (mounted) {
                      setState(() {
                        _showFabs = false;
                        _fabVisibleUntil = null;
                      });
                    }
                  },
                  backgroundColor: brandPrimary,
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.add),
                  label: Text(
                    l10n.homeShareRecipeFab,
                    style: const TextStyle(
                      fontFamily: 'Manrope',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _openSubscription(BuildContext context) async {
    await Navigator.of(context).pushNamed('/subscription');
    if (context.mounted) {
      context.read<SubscriptionProvider>().loadSubscriptionStatus();
    }
  }

  Widget _buildSubscriptionBanner({
    required BuildContext context,
    required bool isDark,
    required SubscriptionProvider subscriptionProvider,
  }) {
    final l10n = AppLocalizations.of(context);
    final isSubscribed = subscriptionProvider.hasAnySubscription;
    final title = switch (subscriptionProvider.tier) {
      SubscriptionTier.legacy => l10n.homeTierLegacyCollection,
      SubscriptionTier.heritage => l10n.homeTierHeritageKeeper,
      SubscriptionTier.none => l10n.homeUpgradeFab,
    };
    final subtitle = isSubscribed
        ? l10n.homeSubscriptionActive
        : l10n.homeSubscriptionUnlock;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openSubscription(context),
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: isSubscribed
                ? brandSecondary.withValues(alpha: isDark ? 0.24 : 0.16)
                : brandPrimary.withValues(alpha: isDark ? 0.22 : 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSubscribed ? brandSecondary : brandPrimary,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.08),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSubscribed
                    ? Icons.verified_outlined
                    : Icons.workspace_premium_outlined,
                color: isSubscribed ? brandSecondary : brandPrimary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isDark
                          ? DarkColors.textPrimary
                          : LightColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Manrope',
                      fontSize: 11,
                      color: isDark
                          ? DarkColors.textSecondary
                          : LightColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right,
                color: isDark
                    ? DarkColors.textSecondary
                    : LightColors.textSecondary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String icon,
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;
    final color = isSelected
        ? brandPrimary
        : (isDark ? DarkColors.textMuted : LightColors.textMuted);

    return Expanded(
      child: InkWell(
        onTap: () {
          final previousIndex = _currentIndex;
          setState(() {
            _currentIndex = index;
            if (index == 0) {
              _showFabs = true;
              _fabVisibleUntil = DateTime.now().add(
                const Duration(seconds: 30),
              );
            }
          });

          if (index == 0) {
            _startFabHideTimer();
          } else {
            _fabHideTimer?.cancel();
          }

          if (index == 1 && previousIndex != 1) {
            if (kDebugMode) {
              print('Navigating to Cookbook - refreshing recipes...');
            }
            final cookbookState = _cookbookKey.currentState;
            if (cookbookState != null) {
              try {
                (cookbookState as dynamic).refreshRecipes();
              } catch (e) {
                if (kDebugMode) {
                  print('Error refreshing cookbook: $e');
                }
              }
            }
          }

          if (index == 2 && previousIndex != 2) {
            if (kDebugMode) {
              print('Navigating to My Recipes - refreshing recipes...');
            }
            final profileState = _profileKey.currentState;
            if (profileState != null) {
              try {
                (profileState as dynamic).refreshMyRecipes();
              } catch (e) {
                if (kDebugMode) {
                  print('Error refreshing my recipes: $e');
                }
              }
            }
          }

          if (index == 3 && previousIndex != 3) {
            if (kDebugMode) {
              print('Navigating to Family - refreshing family info...');
            }
            final familyState = _familyKey.currentState;
            if (familyState != null) {
              try {
                (familyState as dynamic).refreshFamilyInfo();
              } catch (e) {
                if (kDebugMode) {
                  print('Error refreshing family info: $e');
                }
              }
            }
          }

          if (index == 4 && previousIndex != 4) {
            if (kDebugMode) {
              print(
                'Navigating to Settings - refreshing family info and members...',
              );
            }
            final settingsState = _settingsKey.currentState;
            if (settingsState != null) {
              try {
                (settingsState as dynamic).refreshFamilyInfo();
              } catch (e) {
                if (kDebugMode) {
                  print('Error refreshing family info: $e');
                }
              }
            }
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
