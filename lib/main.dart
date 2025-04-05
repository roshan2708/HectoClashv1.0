import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';

import 'package:hecto_clash_frontend/screens/CongratsScreen.dart';
import 'package:hecto_clash_frontend/screens/HomeScreen.dart';
import 'package:hecto_clash_frontend/screens/SplashScreen.dart';

void main() {
  // Initialize GetX bindings and controllers
  WidgetsFlutterBinding.ensureInitialized();
  
  // Put the controller in the dependency injection system
  Get.put<GameController>(GameController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the controller instance
    final GameController controller = Get.find<GameController>();

    // Move the ever worker inside the widget tree or controller
    ever(controller.output, (value) {
      if (value == "100") {
        Get.to(() => CongratsScreen());
      }
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}