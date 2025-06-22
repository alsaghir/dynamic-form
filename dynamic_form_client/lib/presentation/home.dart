import 'dart:math' as math;

import 'package:go_router/go_router.dart';

import '../domain/user_preference.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infra/providers.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  ThemeMode _cycleTheme(ThemeMode themeMode) {
    if (themeMode == ThemeMode.light) {
      return ThemeMode.dark;
    } else if (themeMode == ThemeMode.dark) {
      return ThemeMode.system;
    } else {
      // Currently ThemeMode.system
      return ThemeMode.light;
    }
  }

  // Helper to get the icon for the current theme mode
  IconData _getThemeModeIcon(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.computer;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserPreference userPreferences = ref.watch(Providers.userPrefProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Sample'),
        actions: [
          IconButton(
            icon: Icon(_getThemeModeIcon(userPreferences.themeMode)),
            // Use the icon determined by MyApp
            onPressed: () {
              ref.read(Providers.userPrefProvider.notifier).state =  UserPreference.copyWith(
              themeMode:_cycleTheme(userPreferences.themeMode),
              );
            },
            tooltip: 'Switch Theme Mode',
          ),
          IconButton(onPressed: () {
            GoRouter.of(context).goNamed("logs");
          }, icon: const Icon(Icons.error_outline), tooltip: 'Errors Monitor'),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  minWidth: 300, // Prevents shrinking below 300px
                  maxWidth: math.max(constraints.maxWidth * 0.5, 300),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: constraints.maxHeight * 0.1,
                  ),
                  child: Center(
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 32),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.input,
                              size: 64,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Welcome to Your App',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'A beautiful landing page for your application. Please login or sign up to continue.',
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 32),
                            Wrap(
                              spacing: 16,
                              // horizontal space between buttons
                              runSpacing: 16,
                              // vertical space between lines
                              alignment: WrapAlignment.center,

                              // mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    // TODO: Navigate to login
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 2,
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  child: const Text('Login'),
                                ),
                                OutlinedButton(
                                  onPressed: () {
                                    // TODO: Navigate to sign up
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      width: 2,
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),

                                  child: const Text('Sign Up'),
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
          ),
        ),
      ),
    );
  }
}
