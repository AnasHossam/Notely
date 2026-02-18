import 'package:flutter/material.dart';
import 'package:notely/features/profile/managers/user_profile_manager.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_manager.g.dart';

@riverpod
class ThemeManager extends _$ThemeManager {
  @override
  ThemeMode build() {
    final profileAsync = ref.watch(userProfileManagerProvider);

    return profileAsync.when(
      data: (profile) {
        if (profile == null) return ThemeMode.system;
        switch (profile.themeMode) {
          case 'light':
            return ThemeMode.light;
          case 'dark':
            return ThemeMode.dark;
          default:
            return ThemeMode.system;
        }
      },
      loading: () => ThemeMode.system,
      error: (_, __) => ThemeMode.system,
    );
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    final profile = ref.read(userProfileManagerProvider).value;
    if (profile != null) {
      String modeStr = 'system';
      if (mode == ThemeMode.light) modeStr = 'light';
      if (mode == ThemeMode.dark) modeStr = 'dark';

      ref.read(userProfileManagerProvider.notifier).updateProfile(
            profile.copyWith(themeMode: modeStr),
          );
    }
  }
}
