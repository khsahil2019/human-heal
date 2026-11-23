import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const HumanHealApp());
}

class HumanHealApp extends StatelessWidget {
  const HumanHealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Human Heal",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.SPLASH,
      getPages: AppPages.routes,
    );
  }
}
