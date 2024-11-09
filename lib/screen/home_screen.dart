import 'package:flutter/material.dart';
import 'package:flutter_starter_template/providers/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final String title;
  const HomeScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          Switch(
            value: themeProvider.getThemeMode() == ThemeMode.dark,
            onChanged: (value) {
              // Toggle theme on switch change
              themeProvider
                  .setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
            },
          ),
        ],
      ),
      body: Center(
          child:
              Column(children: [Text('Welcome to Flutter Starter Template!')])),
    );
  }
}
