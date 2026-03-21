import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../config/app_theme.dart';
import 'recipe_feed_screen.dart';
import 'cookbook_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'add_recipe_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final GlobalKey _recipeFeedKey = GlobalKey();
  final GlobalKey _cookbookKey = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();

  late final List<Widget> _screens;
  
  @override
  void initState() {
    super.initState();
    _screens = [
      RecipeFeedScreen(key: _recipeFeedKey),
      CookbookScreen(key: _cookbookKey),
      ProfileScreen(key: _profileKey),
      SettingsScreen(key: _settingsKey),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
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
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: 'assets/icons/Home.svg',
                  label: 'Home',
                  index: 0,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/BookOpen.svg',
                  label: 'Cookbook',
                  index: 1,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/User.svg',
                  label: 'My Recipes',
                  index: 2,
                  isDark: isDark,
                ),
                _buildNavItem(
                  icon: 'assets/icons/Settings.svg',
                  label: 'Settings',
                  index: 3,
                  isDark: isDark,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const AddRecipeScreen(),
                  ),
                );
                if (result == true) {
                  // Wait a bit to ensure navigation is complete
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
              },
              backgroundColor: brandPrimary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text(
                'Share a Recipe',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
          });
          
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
              print('Navigating to Settings - refreshing family info and members...');
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
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                color,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
