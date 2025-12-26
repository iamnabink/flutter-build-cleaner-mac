import 'package:flutter/material.dart';
import 'package:flutter_cleaner/app.dart';
import 'package:flutter_cleaner/services/revenue_cat_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RevenueCatService.initialize();
  runApp(const APKBuildCleanerApp());
}

