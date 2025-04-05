import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/puzzle.dart';
import 'package:hecto_clash_frontend/screens/LeaderBoardScreen.dart';

class ResultsScreen extends StatelessWidget {
  final GameController gameController = Get.find();

  @override
  Widget build(BuildContext context) {
    String modeTitle = gameController.gameMode.value == GameMode.endless
        ? 'Endless Mode'
        : gameController.gameMode.value == GameMode.blitz
            ? 'Blitz Mode'
            : 'Duel Mode';

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: Color(0xFF3B82F6)),
                    onPressed: () => Get.back(),
                  ),
                  Text(
                    '$modeTitle Results',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
                  ),
                  IconButton(
                    icon: Icon(Icons.leaderboard, color: Color(0xFF3B82F6)),
                    onPressed: () => Get.to(() => LeaderboardScreen()),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                          child: Text('Play Again', style: TextStyle(fontSize: 18)),
                        ),
                      );
                    }
                    Puzzle puzzle = gameController.puzzles[index];
                    bool isCorrect = puzzle.isSolutionValid(puzzle.userInput ?? '');
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Puzzle ${index + 1}: ${puzzle.sequence}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Time: ${60 - puzzle.timeLeft} sec', style: TextStyle(color: Color(0xFF6B7280))),
                            SizedBox(height: 8),
                            Text(
                              'Your Answer: ${puzzle.userInput ?? "Not attempted"}',
                              style: TextStyle(color: isCorrect ? Color(0xFF10B981) : Color(0xFFEF4444)),
                            ),
                            if (!isCorrect)
                              Text(
                                'Correct Answer: ${puzzle.getSampleSolution()}',
                                style: TextStyle(color: Color(0xFF3B82F6)),
                              ),
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
    );
  }
}