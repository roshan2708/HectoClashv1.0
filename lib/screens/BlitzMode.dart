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
  final Color primaryColor = Color(0xFF6A5ACD); // A nice purple shade
  final Color backgroundColor = Color(0xFFF5F7FA);
  final Color accentColor = Color(0xFF5D5FEF);
  final Color dangerColor = Color(0xFFFF6B6B);
  final Color textColor = Color(0xFF2D3748);

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
      child: Column(
        children: calculatorKeys.map((row) => Padding(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(0, 2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Blitz Mode', 
                    style: TextStyle(
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Container(
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: gameController.totalTimeLeft.value < 10 
                          ? dangerColor.withOpacity(0.1) 
                          : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer, 
                          color: gameController.totalTimeLeft.value < 10 
                              ? dangerColor 
                              : Colors.orange, 
                          size: 18
                        ),
                        SizedBox(width: 4),
                        Text(
                          '${gameController.totalTimeLeft.value}s', 
                          style: TextStyle(
                            fontSize: 18, 
                            fontWeight: FontWeight.bold,
                            color: gameController.totalTimeLeft.value < 10 
                                ? dangerColor 
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
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
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
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
                    Spacer(),
                    ElevatedButton(
                      onPressed: endGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dangerColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text('End Game', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            _buildNumpad(),
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