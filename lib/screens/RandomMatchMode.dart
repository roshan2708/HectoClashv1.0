import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart'; // Fix typo if it’s "GameController.dart"
import 'package:hecto_clash_frontend/models/game_model.dart';
import 'package:hecto_clash_frontend/screens/ResulTScreen.dart.dart';
import '../models/puzzle.dart';

class RandomMatchScreen extends StatefulWidget {
  const RandomMatchScreen({super.key});

  @override
  _RandomMatchScreenState createState() => _RandomMatchScreenState();
}

class _RandomMatchScreenState extends State<RandomMatchScreen> with SingleTickerProviderStateMixin {
  late GameController gameController;
  late Timer timer;
  String currentInput = '';
  bool isSubmitted = false;
  late AnimationController _scoreAnimationController;
  late Animation<double> _scoreAnimation;

  final Color primaryColor = Color(0xFF6A5ACD); // A nice purple shade
  final Color backgroundColor = Color(0xFFF5F7FA);
  final Color accentColor = Color(0xFF5D5FEF);
  final Color dangerColor = Color(0xFFFF6B6B);
  final Color textColor = Color(0xFF2D3748);

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
        mode: GameMode.duel,
        score: gameController.score.value,
        date: DateTime.now(),
        puzzles: gameController.puzzles.toList(),
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
      if (attempts < 1) {
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

  Widget _buildNumpad() {
    final List<List<String>> calculatorKeys = [
      ['7', '8', '9', '/'],
      ['4', '5', '6', '*'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
      ['C', '(', ')', 'Submit']
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4, // Limit height to 40% of screen
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ...calculatorKeys.map((row) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: row.map((key) {
                    final isOperator = ['+', '-', '*', '/', '=', '(', ')'].contains(key);
                    final isSubmit = key == 'Submit';
                    final isClear = key == 'C';

                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (isClear) currentInput = '';
                              else if (isSubmit) checkAnswer();
                              else if (key != '=') currentInput += key;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isClear
                                ? dangerColor.withOpacity(0.9)
                                : isSubmit
                                    ? accentColor
                                    : isOperator
                                        ? primaryColor.withOpacity(0.1)
                                        : Colors.white,
                            foregroundColor: isSubmit
                                ? Colors.white
                                : isOperator
                                    ? primaryColor
                                    : textColor,
                            elevation: 4,
                            shadowColor: Colors.black26,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            key,
                            style: TextStyle(
                              fontSize: isSubmit ? 16 : 22,
                              fontWeight: isSubmit ? FontWeight.bold : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )).toList(),
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
                      style: TextStyle(fontSize: 16, color: textColor),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() {
          if (gameController.puzzles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Duel Mode ${gameController.currentPuzzleIndex.value + 1}/5',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    ScaleTransition(
                      scale: _scoreAnimation,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: accentColor, size: 18),
                            SizedBox(width: 4),
                            Text(
                              '${gameController.score.value}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close_rounded, color: dangerColor, size: 28),
                      onPressed: () => endDuel(false),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(
                              "QUESTION",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: accentColor,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              gameController.puzzles[gameController.currentPuzzleIndex.value].question,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Time Left: ${gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft}',
                              style: TextStyle(fontSize: 18, color: textColor),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 14),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              offset: Offset(0, 2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Text(
                          currentInput.isEmpty ? "Enter your answer" : currentInput,
                          style: TextStyle(
                            fontSize: 28,
                            color: currentInput.isEmpty ? Colors.black38 : primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildNumpad(),
            ],
          );
        }),
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