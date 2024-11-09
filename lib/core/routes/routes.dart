import 'package:flutter/material.dart';
import 'package:folder_notes/screen/add_word/add_word.dart';
import 'package:folder_notes/screen/advanced_features/analytics_screen.dart';
import 'package:folder_notes/screen/home/home_screen.dart';
import 'package:folder_notes/screen/word_detail/word_detail.dart';

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
      case "/add-word":
        return MaterialPageRoute(builder: (_) => AddWordScreen());
      case "/word-details":
        return MaterialPageRoute(builder: (_) => WordDetailScreen());
      case "/progress":
        return MaterialPageRoute(builder: (_) => AnalyticsScreen());
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
