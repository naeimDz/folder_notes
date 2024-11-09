import 'package:flutter/material.dart';
import 'package:folder_notes/screen/home/home_screen.dart';

class AppRoutes {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // Route Names
  static const String initial = '/';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(
            builder: (_) => HomeScreen(title: 'مرحباً، Ahmad!'));
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen(title: 'مرحباً،'));

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
