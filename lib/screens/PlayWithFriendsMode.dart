import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/components/CustomHeader.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart'; // Fix typo if it’s "GameController.dart"
import 'package:hecto_clash_frontend/models/game_model.dart';
import 'package:hecto_clash_frontend/screens/ResulTScreen.dart.dart';


import '../models/puzzle.dart';

class DuelScreen extends StatefulWidget {
  const DuelScreen({super.key});

  @override
  _DuelScreenState createState() => _DuelScreenState();
}

class _DuelScreenState extends State<DuelScreen> with SingleTickerProviderStateMixin {
  late GameController gameController;
  late Timer timer;
  String currentInput = '';
  bool isSubmitted = false;
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  @override
  void initState() {
    super.initState();
    gameController = Get.find<GameController>();
    startTimer();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeInOut),
    );
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft > 0 && !isSubmitted) {
            gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft--;
          } else {
            timer.cancel();
            if (!isSubmitted) endDuel(false);
          }
        });
      }
    });
  }

  void endDuel(bool submitted) {
    if (gameController.currentPuzzleIndex.value == 4) {
      gameController.addGameResult(GameResult(
        score: gameController.score.value,
        date: DateTime.now(),
        puzzles: gameController.puzzles.toList(), mode: GameMode.duel,
      ));
      Get.off(() => ResultsScreen());
    } else {
      gameController.currentPuzzleIndex.value++;
      setState(() {
        currentInput = '';
        isSubmitted = false;
      });
      timer.cancel();
      startTimer();
    }
  }

  void checkAnswer() {
    Puzzle currentPuzzle = gameController.puzzles[gameController.currentPuzzleIndex.value];
    bool isCorrect = currentPuzzle.isSolutionValid(currentInput);

    setState(() {
      isSubmitted = true;
      timer.cancel();
    });

    gameController.updateScore(isCorrect);
    _scoreAnimationController.forward(from: 0);

    if (!isCorrect) {
      int attempts = gameController.incorrectAttempts[gameController.currentPuzzleIndex.value] ?? 0;
      if (attempts < 1) { // Reduced from 2 to 1 attempt
        gameController.incorrectAttempts[gameController.currentPuzzleIndex.value] = attempts + 1;
        gameController.hints[gameController.currentPuzzleIndex.value] =
            currentPuzzle.getSampleSolution().substring(0, 3) + "...";
        setState(() {
          isSubmitted = false;
          timer = Timer(const Duration(seconds: 1), startTimer);
        });
        return;
      }
    }
    endDuel(true);
  }

  // Replace your _buildNumpad() method with this updated one:
Widget _buildNumpad() {
  final List<List<String>> calculatorKeys = [
    ['7', '8', '9', '+'],
    ['4', '5', '6', '-'],
    ['1', '2', '3', '*'],
    ['0', '(', ')', '/'],
    ['C', '=', '']
  ];

  return Column(
    children: [
      const SizedBox(height: 10),
      ...calculatorKeys.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((key) {
            if (key.isEmpty) return const SizedBox(width: 64); // empty space filler

            final isOperator = ['+', '-', '*', '/', '='].contains(key);
            final isClear = key == 'C';

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (key == 'C') {
                      currentInput = '';
                    } else if (key == '=') {
                      checkAnswer();
                    } else {
                      currentInput += key;
                    }
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isClear
                      ? Colors.red[300]
                      : isOperator
                          ? Colors.purple[200]
                          : Colors.blue[200],
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  key,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        );
      }),
      if (gameController.hints[gameController.currentPuzzleIndex.value] != null)
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Hint: ${gameController.hints[gameController.currentPuzzleIndex.value]}',
              style: TextStyle(fontSize: 16, color: Colors.brown[800]),
            ),
          ),
        ),
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black38,
        ),
        child: SafeArea(
          child: Obx(() {
            if (gameController.puzzles.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Header(text: 'Duel Mode ${gameController.currentPuzzleIndex.value + 1}/5'),
                      ),
                      ScaleTransition(
                        scale: _scoreAnimation,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Score: ${gameController.score.value}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          gameController.puzzles[gameController.currentPuzzleIndex.value].question,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Time Left: ${gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft}',
                          style: const TextStyle(fontSize: 18, color: Colors.white70),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            currentInput,
                            style: const TextStyle(fontSize: 32, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _buildNumpad(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _scoreAnimationController.dispose();
    super.dispose();
  }
}