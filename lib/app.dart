import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/constants.dart';
import 'package:flutter_cleaner/pages/main_view.dart';
import 'package:flutter_cleaner/theme/app_theme.dart';
import 'package:macos_ui/macos_ui.dart';

class BroomieApp extends StatelessWidget {
  const BroomieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MacosApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: const MainView(),
    );
  }
}
