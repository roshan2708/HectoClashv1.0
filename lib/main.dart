import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/screens/CongratsScreen.dart';
import 'package:hecto_clash_frontend/screens/HomeScreen.dart';
import 'package:hecto_clash_frontend/screens/SplashScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put<GameController>(GameController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GameController controller = Get.find<GameController>();
    ever(controller.output, (value) {
      if (value == "100") Get.to(() => CongratsScreen());
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFE8F0FE),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF1F2937)),
        ),
      ),
      home: SplashScreen(),
    );
  }
}