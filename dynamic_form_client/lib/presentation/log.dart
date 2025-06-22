import 'dart:math' as math;

import 'package:go_router/go_router.dart';
import 'package:talker/src/talker.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../domain/user_preference.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../infra/providers.dart';

class LogScreen extends HookConsumerWidget {
  const LogScreen({super.key});

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
    Talker talker = ref.watch(Providers.talkerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar Sample'),
        actions: [
          IconButton(
            icon: Icon(_getThemeModeIcon(userPreferences.themeMode)),
            // Use the icon determined by MyApp
            onPressed: () {
              ref
                  .read(Providers.userPrefProvider.notifier)
                  .state = UserPreference.copyWith(
                themeMode: _cycleTheme(userPreferences.themeMode),
              );
            },
            tooltip: 'Switch Theme Mode',
          ),
          IconButton(
            onPressed: () {
              GoRouter.of(context).goNamed("logs");
            },
            icon: const Icon(Icons.error_outline),
            tooltip: 'Errors Monitor',
          ),
        ],
      ),
      body: SafeArea(
        child: TalkerScreen(
          talker: talker,
          theme: TalkerScreenTheme.fromTheme(
            Theme.of(context),
          ),
        ),
      ),
    );
  }
}
