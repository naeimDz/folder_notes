import 'package:flutter/material.dart';
import 'package:my_lab/screen/add_word/add_word_screen.dart';
import 'package:my_lab/screen/advanced_features/analytics_screen.dart';
import 'package:my_lab/screen/home/home_screen.dart';
import 'package:my_lab/screen/vocabulary_list/vocabulary_list_screen.dart';
import 'package:my_lab/screen/word_detail/word_detail.dart';

class AppRoutes {
  static final navigatorKey = GlobalKey<NavigatorState>();

  // Route Names
  static const String initial = '/';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case initial:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case "/add-word":
        return MaterialPageRoute(builder: (_) => AddWordScreen());
      case "/word-details":
        return MaterialPageRoute(builder: (_) => WordDetailScreen());
      case "/word-list":
        return MaterialPageRoute(builder: (_) => VocabularyListScreen());
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
