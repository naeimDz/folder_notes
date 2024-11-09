import 'package:flutter/material.dart';
import 'package:folder_notes/screen/home_screen.dart';

class AppRoutes {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // Route Names
  static const String initial = '/';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(title: 'Splash Screen'));
      case home:
        return MaterialPageRoute(
            builder: (_) => const HomeScreen(title: 'Home Screen'));

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
