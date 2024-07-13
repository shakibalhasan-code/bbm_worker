import 'package:bbm_worker/stylish/app_colors.dart';
import 'package:bbm_worker/views/screens/login_screen.dart';
import 'package:bbm_worker/views/screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.appThemeColor
      ),
      home: const SplashScreen(),
    );
  }
}
