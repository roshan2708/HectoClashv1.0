import 'package:flutter/material.dart';
import 'package:hecto_clash_frontend/components/CustomFeatureButton.dart';
import 'package:hecto_clash_frontend/screens/BlitzMode.dart';
import 'package:hecto_clash_frontend/screens/EndlessModePage.dart';
import 'package:hecto_clash_frontend/screens/RandomMatchMode.dart';
import 'package:hecto_clash_frontend/screens/duel_screen.dart';

class LetsClashScreen extends StatelessWidget {
  const LetsClashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Clash", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("----------- offline -----------", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 16)),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomFeatureButton(title: "Endless Mode", imagePath: 'assets/images/endless.jpg', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EndlessModeScreen()))),
                CustomFeatureButton(title: "Blitz Mode", imagePath: 'assets/images/blitz.jpg', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BlitzModeScreen()))),
              ],
            ),
            SizedBox(height: 40),
            Text("----------- online -----------", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w600, fontSize: 16)),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CustomFeatureButton(title: "Random Match", imagePath: 'assets/images/random.jpg', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RandomMatchScreen()))),
                CustomFeatureButton(title: "Play With Friends", imagePath: 'assets/images/friends.jpg', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => DuelScreen()))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(BuildContext context, String title, String imagePath, Widget destination) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => destination)),
      child: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height:  MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(color: Color(0xFFF8EDEB), borderRadius: BorderRadius.circular(12)),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        ],
      ),
    );
  }
}