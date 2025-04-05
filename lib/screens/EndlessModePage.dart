// screens/endless_mode_screen.dart
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
    setState(() {
      currentInput = '';
    });
  }

  void checkAnswer() {
    Puzzle currentPuzzle = gameController.puzzles[gameController.currentPuzzleIndex.value];
    bool isCorrect = currentPuzzle.isSolutionValid(currentInput);
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
      ['7', '8', '9', '+'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '*'],
      ['0', '(', ')', '/'],
      ['C', 'Submit', '']
    ];

    return Column(
      children: calculatorKeys.map((row) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: row.map((key) {
          if (key.isEmpty) return const SizedBox(width: 64);
          final isOperator = ['+', '-', '*', '/', 'Submit'].contains(key);
          final isClear = key == 'C';

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (key == 'C') currentInput = '';
                  else if (key == 'Submit') checkAnswer();
                  else currentInput += key;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isClear
                    ? Colors.red[400]
                    : isOperator
                        ? Colors.orange[300]
                        : Colors.teal[200],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(key, style: const TextStyle(fontSize: 20)),
            ),
          );
        }).toList(),
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal[700]!, Colors.cyan[400]!],
          ),
        ),
        child: SafeArea(
          child: Obx(() => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Endless Mode',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Score: ${gameController.score.value}',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    IconButton(
                      icon: Icon(Icons.cancel, color: Colors.white),
                      onPressed: endGame,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(gameController.puzzles[gameController.currentPuzzleIndex.value].question,
                        style: TextStyle(fontSize: 24, color: Colors.white)),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(currentInput, style: TextStyle(fontSize: 32, color: Colors.white)),
                    ),
                    SizedBox(height: 30),
                    _buildNumpad(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: endGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('End Game', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }
}