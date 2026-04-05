import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/view/onboarding_view.dart';
import 'features/dashboard/view/dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  final prefs = await SharedPreferences.getInstance();
  final userPhone = prefs.getString('user_phone');

  runApp(MyApp(isLoggedIn: userPhone != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vantage Gateway',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: isLoggedIn ? '/dashboard' : '/onboarding',
      getPages: [
        GetPage(name: '/onboarding', page: () => const OnboardingView()),
        GetPage(name: '/dashboard', page: () => const DashboardView()),
      ],
    );
  }
}
