import 'package:flutter/widgets.dart';
import 'package:flutter_cleaner/app.dart';
import 'package:flutter_cleaner/services/revenue_cat_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:macos_ui/macos_ui.dart';

Future<void> _configureMacosWindowUtils() async {
  const config = MacosWindowUtilsConfig(
    toolbarStyle: NSWindowToolbarStyle.unified,
  );
  await config.apply();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _configureMacosWindowUtils();
  await dotenv.load(fileName: '.env', isOptional: true);
  await RevenueCatService.initialize();
  runApp(const BroomieApp());
}
