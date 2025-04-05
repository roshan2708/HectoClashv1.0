import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/game_model.dart';
import 'package:hecto_clash_frontend/screens/ResultScreen.dart.dart';
import '../models/puzzle.dart';

class EndlessModeScreen extends StatefulWidget {
  const EndlessModeScreen({super.key});

  @override
  _EndlessModeScreenState createState() => _EndlessModeScreenState();
}

class _EndlessModeScreenState extends State<EndlessModeScreen> {
  late GameController gameController;
  String currentInput = '';

  @override
  void initState() {
    super.initState();
    gameController = Get.find<GameController>();
    gameController.startNewGame(mode: GameMode.endless);
  }

  void nextPuzzle(bool isCorrect) {
    gameController.updateScore(isCorrect);
    gameController.puzzles.add(Puzzle.generate());
    gameController.currentPuzzleIndex.value++;
    setState(() => currentInput = '');
  }

  void checkAnswer() {
    Puzzle currentPuzzle = gameController.puzzles[gameController.currentPuzzleIndex.value];
    bool isCorrect = currentPuzzle.isSolutionValid(currentInput);
    currentPuzzle.userInput = currentInput; // Store user input
    nextPuzzle(isCorrect);
  }

  void endGame() {
    gameController.addGameResult(GameResult(
      score: gameController.score.value,
      date: DateTime.now(),
      puzzles: gameController.puzzles.toList(),
      mode: GameMode.endless,
    ));
    Get.off(() => ResultsScreen());
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
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Endless Mode', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Score: ${gameController.score.value}', style: TextStyle(fontSize: 20)),
                  IconButton(icon: Icon(Icons.cancel, color: Color(0xFFEF4444)), onPressed: endGame),
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    gameController.puzzles[gameController.currentPuzzleIndex.value].question,
                    style: TextStyle(fontSize: 24, color: Color(0xFF1F2937)),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Color(0xFFF8EDEB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(currentInput, style: TextStyle(fontSize: 32, color: Color(0xFF1F2937))),
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
}