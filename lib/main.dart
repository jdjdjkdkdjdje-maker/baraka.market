import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme/app_theme.dart';
import 'shared/router/app_router.dart';

// ============================================================
// BARAKA MARKET — Main Entry Point
// Production-ready Flutter app with Riverpod + GoRouter
// ============================================================

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // System UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Portrait + landscape support
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // TODO: Initialize Firebase
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // TODO: Initialize Hive
  // await Hive.initFlutter();

  runApp(
    const ProviderScope(
      child: BarakaMarketApp(),
    ),
  );
}

class BarakaMarketApp extends ConsumerWidget {
  const BarakaMarketApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    // TODO: watch theme provider
    // final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Baraka Market',
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system, // TODO: replace with provider

      // Router
      routerConfig: router,

      // Localization
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('uz', 'UZ'),
        Locale('ru', 'RU'),
        Locale('en', 'US'),
      ],
      locale: const Locale('uz', 'UZ'), // TODO: from provider

      // Global config
      builder: (context, child) {
        // Apply max text scale to prevent overflow on large font settings
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaleFactor.clamp(0.85, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
