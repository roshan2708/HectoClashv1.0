import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/game_model.dart';
import 'package:hecto_clash_frontend/screens/ResultScreen.dart.dart';
import '../models/puzzle.dart';

class BlitzModeScreen extends StatefulWidget {
  const BlitzModeScreen({super.key});

  @override
  _BlitzModeScreenState createState() => _BlitzModeScreenState();
}

class _BlitzModeScreenState extends State<BlitzModeScreen> {
  late GameController gameController;
  late Timer timer;
  String currentInput = '';

  @override
  void initState() {
    super.initState();
    gameController = Get.find<GameController>();
    gameController.startNewGame(mode: GameMode.blitz);
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && gameController.totalTimeLeft > 0) {
        setState(() => gameController.totalTimeLeft--);
      } else {
        timer.cancel();
        endGame();
      }
    });
  }

  void nextPuzzle(bool isCorrect) {
    gameController.updateScore(isCorrect);
    if (gameController.currentPuzzleIndex.value + 1 < gameController.puzzles.length) {
      gameController.currentPuzzleIndex.value++;
    } else {
      gameController.generatePuzzles(5);
      gameController.currentPuzzleIndex.value++;
    }
    setState(() => currentInput = '');
  }

  void endGame() {
    timer.cancel();
    gameController.addGameResult(GameResult(
      score: gameController.score.value,
      date: DateTime.now(),
      puzzles: gameController.puzzles.sublist(0, gameController.currentPuzzleIndex.value + 1),
      mode: GameMode.blitz,
    ));
    Get.off(() => ResultsScreen());
  }

  void checkAnswer() {
    Puzzle currentPuzzle = gameController.puzzles[gameController.currentPuzzleIndex.value];
    bool isCorrect = currentPuzzle.isSolutionValid(currentInput);
    currentPuzzle.userInput = currentInput; // Store user input
    nextPuzzle(isCorrect);
  }

  Widget _buildNumpad() {
    final List<List<String>> calculatorKeys = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
      ['C', '(', ')', 'Submit']
    ];

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8EDEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: calculatorKeys.map((row) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) {
            final isOperator = ['+', '-', '*', '/', '=', '(', ')'].contains(key);
            final isSubmit = key == 'Submit';
            final isClear = key == 'C';

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (isClear) currentInput = '';
                    else if (isSubmit) checkAnswer();
                    else currentInput += key;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClear
                      ? Color(0xFFFECACA)
                      : isSubmit
                          ? Color(0xFF3B82F6)
                          : isOperator
                              ? Color(0xFFE5E7EB)
                              : Color(0xFFFFFFFF),
                  foregroundColor: isSubmit ? Colors.white : Color(0xFF1F2937),
                  minimumSize: Size(70, 70),
                ),
                child: Text(key, style: TextStyle(fontSize: 24)),
              ),
            );
          }).toList(),
        )).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Blitz Mode', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Score: ${gameController.score.value}', style: TextStyle(fontSize: 20)),
                  Text('Time: ${gameController.totalTimeLeft.value}s', style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gameController.puzzles[gameController.currentPuzzleIndex.value].question,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Color(0xFFF8EDEB), borderRadius: BorderRadius.circular(12)),
                    child: Text(currentInput, style: TextStyle(fontSize: 32)),
                  ),
                  SizedBox(height: 30),
                  _buildNumpad(),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: endGame,
                    child: Text('End Game', style: TextStyle(fontSize: 18)),
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
                  ),
                ],
              ),
            ),
          ],
        )),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}