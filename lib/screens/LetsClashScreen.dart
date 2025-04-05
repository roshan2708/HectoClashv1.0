import 'package:flutter/material.dart';
import 'package:hecto_clash_frontend/components/CustomFeatureButton.dart';
import 'package:hecto_clash_frontend/screens/BlitzMode.dart';
import 'package:hecto_clash_frontend/screens/EndlessModePage.dart';
import 'package:hecto_clash_frontend/screens/duel_screen.dart';

class LetsClashScreen extends StatelessWidget {
  const LetsClashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Let's Clash",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Offline section
            const Text(
              "----------- offline -----------",
              style: TextStyle(
                color: Color(0xFF8BC34A),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            // Offline buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              CustomFeatureButton(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const EndlessModeScreen()));
                },
                  title: "Endless Mode",
                  imagePath: "assets/images/endless_mode.png",
                ),
                CustomFeatureButton(
                   onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const BlitzModeScreen()));
                },
                  title: "Time Limit",
                  imagePath: "assets/images/time_limit.png",
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Online section
            const Text(
              "----------- online -----------",
              style: TextStyle(
                color: Color(0xFF8BC34A),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            // Online buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:  [
                CustomFeatureButton(
                   onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DuelScreen()));
                },
                  title: "Random Match",
                  imagePath: "assets/images/random_match.png",
                ),
                CustomFeatureButton(
                   onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const DuelScreen()));
                },
                  title: "Play with Friends",
                  imagePath: "assets/images/friends.png",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

