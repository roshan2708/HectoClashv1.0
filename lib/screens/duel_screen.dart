import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/game_model.dart';
import 'package:hecto_clash_frontend/screens/ResultScreen.dart.dart';
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
    gameController.startNewGame(mode: GameMode.duel);
    startTimer();
    _scoreAnimationController = AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    _scoreAnimation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _scoreAnimationController, curve: Curves.easeInOut));
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted && gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft > 0 && !isSubmitted) {
        setState(() => gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft--);
      } else {
        timer.cancel();
        if (!isSubmitted) endDuel(false);
      }
    });
  }

  void endDuel(bool submitted) {
    if (gameController.currentPuzzleIndex.value == 4 || !submitted) {
      gameController.addGameResult(GameResult(
        score: gameController.score.value,
        date: DateTime.now(),
        puzzles: gameController.puzzles.toList(),
        mode: GameMode.duel,
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
    currentPuzzle.userInput = currentInput; // Store user input
    setState(() => isSubmitted = true);
    timer.cancel();
    gameController.updateScore(isCorrect);
    _scoreAnimationController.forward(from: 0);

    if (!isCorrect) {
      int attempts = gameController.incorrectAttempts[gameController.currentPuzzleIndex.value] ?? 0;
      if (attempts < 1) {
        gameController.incorrectAttempts[gameController.currentPuzzleIndex.value] = attempts + 1;
        gameController.hints[gameController.currentPuzzleIndex.value] = currentPuzzle.getSampleSolution().substring(0, 3) + "...";
        setState(() {
          isSubmitted = false;
          timer = Timer(Duration(seconds: 1), startTimer);
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
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFF8EDEB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          ...calculatorKeys.map((row) => Row(
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
          )),
          if (gameController.hints[gameController.currentPuzzleIndex.value] != null)
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(color: Color(0xFFFFF9DB), borderRadius: BorderRadius.circular(8)),
                child: Text('Hint: ${gameController.hints[gameController.currentPuzzleIndex.value]}', style: TextStyle(color: Color(0xFF92400E))),
              ),
            ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => endDuel(false),
            child: Text('End Game', style: TextStyle(fontSize: 18)),
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEF4444)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => gameController.puzzles.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Duel Mode ${gameController.currentPuzzleIndex.value + 1}/5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ScaleTransition(
                          scale: _scoreAnimation,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(color: Color(0xFFF8EDEB), borderRadius: BorderRadius.circular(8)),
                            child: Text('Score: ${gameController.score.value}', style: TextStyle(fontSize: 20)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            gameController.puzzles[gameController.currentPuzzleIndex.value].question,
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          Text('Time Left: ${gameController.puzzles[gameController.currentPuzzleIndex.value].timeLeft}', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(color: Color(0xFFF8EDEB), borderRadius: BorderRadius.circular(12)),
                            child: Text(currentInput, style: TextStyle(fontSize: 32)),
                          ),
                          SizedBox(height: 20),
                          _buildNumpad(),
                        ],
                      ),
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
    _scoreAnimationController.dispose();
    super.dispose();
  }
}