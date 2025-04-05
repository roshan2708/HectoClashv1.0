// screens/results_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/puzzle.dart';
import 'package:hecto_clash_frontend/screens/LeaderBoardScreen.dart';

class ResultsScreen extends StatelessWidget {
  final GameController gameController = Get.find();

  @override
  Widget build(BuildContext context) {
    String modeTitle = gameController.gameMode.value == GameMode.endless ? 'Endless Mode' :
                     gameController.gameMode.value == GameMode.blitz ? 'Blitz Mode' : 'Duel Mode';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[700]!, Colors.purple[400]!],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    Text('$modeTitle Results',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: Icon(Icons.leaderboard, color: Colors.white),
                      onPressed: () => Get.to(() => LeaderboardScreen()),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: gameController.puzzles.length + 1,
                    itemBuilder: (context, index) {
                      if (index == gameController.puzzles.length) {
                        return Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              gameController.startNewGame(mode: gameController.gameMode.value);
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[600],
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: Text('PLAY AGAIN', style: TextStyle(fontSize: 18, color: Colors.white)),
                          ),
                        );
                      }
                      Puzzle puzzle = gameController.puzzles[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Puzzle ${index + 1}: ${puzzle.sequence}',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text('Time: ${60 - puzzle.timeLeft} sec'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}