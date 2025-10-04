import 'package:flutter/material.dart';
import 'package:flutter_cleaner/home.dart';
import 'package:flutter_cleaner/constants.dart';

class APKBuildCleanerApp extends StatelessWidget {
  const APKBuildCleanerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const CleanerHomePage(),
    );
  }
}
