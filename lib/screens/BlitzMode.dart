// screens/blitz_mode_screen.dart
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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (gameController.totalTimeLeft > 0) {
            gameController.totalTimeLeft--;
          } else {
            timer.cancel();
            endGame();
          }
        });
      }
    });
  }

  void nextPuzzle(bool isCorrect) {
    gameController.updateScore(isCorrect);
    if (gameController.currentPuzzleIndex.value + 1 < gameController.puzzles.length) {
      gameController.currentPuzzleIndex.value++;
    } else {
      gameController.generatePuzzles(5); // Generate more puzzles
      gameController.currentPuzzleIndex.value++;
    }
    setState(() {
      currentInput = '';
    });
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
    nextPuzzle(isCorrect);
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
                        ? Colors.pink[300]
                        : Colors.indigo[200],
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
            colors: [Colors.indigo[700]!, Colors.purple[400]!],
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
                    Text('Blitz Mode',
                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Score: ${gameController.score.value}',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    Text('Time: ${gameController.totalTimeLeft.value}s',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
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

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}