import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/screens/LeaderBoardScreen.dart';
import 'package:hecto_clash_frontend/screens/LetsClashScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMusicOn = true;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.1),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Color(0xFFF8EDEB),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.calculate_rounded, size: 70, color: Color(0xFF3B82F6)),
              ),
              SizedBox(height: 24),
              Text(
                'Hecto Clash',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              SizedBox(height: 12),
              Text(
                'Challenge Your Mathematical Skills',
                style: TextStyle(fontSize: 18, color: Color(0xFF6B7280)),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => LetsClashScreen()),
                  child: Text('Let\'s Clash', style: TextStyle(fontSize: 24)),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 20),
                child: ElevatedButton(
                  onPressed: () => Get.to(() => LeaderboardScreen()),
                  child: Text('Leaderboard', style: TextStyle(fontSize: 24)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFF8EDEB),
                    foregroundColor: Color(0xFF3B82F6),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color(0xFFE8F0FE),
        color: Color(0xFFF8EDEB),
        buttonBackgroundColor: Color(0xFF3B82F6),
        height: 60,
        items: [
          Icon(isMusicOn ? Icons.music_note : Icons.music_off, size: 30, color: isMusicOn ? Colors.white : Color(0xFF6B7280)),
          Icon(Icons.exit_to_app, size: 30, color: Colors.white),
        ],
        onTap: (index) {
          setState(() {
            if (index == 0) isMusicOn = !isMusicOn; // Toggle music (implement in controller)
            else SystemNavigator.pop();
          });
        },
      ),
    );
  }
}