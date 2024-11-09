import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_starter_template/core/app_theme.dart';
import 'package:flutter_starter_template/core/routes/routes.dart';
import 'package:flutter_starter_template/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();

  // Initialize Shared Preferences
  final prefs = await SharedPreferences.getInstance();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ar')
      ], // Add more locales as needed
      path: 'assets/translations', // Folder for localization files
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          Provider<SharedPreferences>.value(value: prefs),
          ChangeNotifierProvider<ThemeProvider>(
            create: (context) => ThemeProvider(prefs: prefs),
          ),
          // Add your global providers here
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // Theme
      theme: AppTheme.getLightTheme, // Light theme
      darkTheme: AppTheme.getDarkTheme, // Dark theme
      themeMode: themeProvider.getThemeMode(), // Current theme mode
      // Localization
      localizationsDelegates:
          context.localizationDelegates, // Localization delegates
      supportedLocales: context.supportedLocales, // Supported locales
      locale: context.locale, // Current locale
      // Routes
      initialRoute: AppRoutes.initial,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      // Global Navigation Key
      navigatorKey: AppRoutes.navigatorKey,
    );
  }
}
