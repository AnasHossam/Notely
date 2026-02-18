import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:notely/core/theme/app_theme.dart';
import 'package:notely/features/note/models/note_model.dart';
import 'package:notely/features/profile/managers/theme_manager.dart';
import 'package:notely/features/profile/models/user_profile_model.dart';
import 'package:notely/features/splash/views/splash_view.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(NoteHiveModelAdapter());
  Hive.registerAdapter(UserProfileAdapter());
  runApp(const ProviderScope(child: Notely()));
}

class Notely extends ConsumerWidget {
  const Notely({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeManagerProvider);

    return MaterialApp(
      title: 'Notely',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ar', 'EG'),
      ],
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashView(),
    );
  }
}
