import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// UserPreferences is a class that holds user-specific settings
@immutable
class UserPreference {
  const UserPreference({this.themeMode = ThemeMode.system});

  final ThemeMode themeMode;

  static UserPreference copyWith({ThemeMode? themeMode}) {
    return UserPreference(themeMode: themeMode ?? ThemeMode.system);
  }
}
