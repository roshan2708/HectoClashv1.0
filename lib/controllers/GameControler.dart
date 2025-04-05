// controllers/game_controller.dart
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:hecto_clash_frontend/models/game_model.dart';
import 'package:hecto_clash_frontend/models/puzzle.dart';

enum GameMode { duel, endless, blitz }

class GameController extends GetxController {
  var output = ''.obs;
  var currentPuzzleIndex = 0.obs;
  var score = 0.obs;
  var puzzles = <Puzzle>[].obs;
  var gameResults = <GameResult>[].obs;
  var incorrectAttempts = <int, int>{}.obs;
  var hints = <int, String>{}.obs;
  var gameMode = GameMode.duel.obs;
  var totalTimeLeft = 300.obs; // 5 minutes for Blitz Mode

  @override
  void onInit() {
    super.onInit();
    startNewGame();
  }

  void startNewGame({GameMode mode = GameMode.duel}) {
    gameMode.value = mode;
    puzzles.clear();
    score.value = 0;
    incorrectAttempts.clear();
    hints.clear();
    currentPuzzleIndex.value = 0;

    if (mode == GameMode.blitz) {
      totalTimeLeft.value = 300;
      generatePuzzles(5); // Initial batch
    } else if (mode == GameMode.endless) {
      generatePuzzles(1); // Generate one at a time
    } else {
      generatePuzzles(5); // Duel mode
    }
  }

  void generatePuzzles(int count) {
    for (int i = 0; i < count; i++) {
      puzzles.add(Puzzle.generate());
    }
  }

  void updateScore(bool isCorrect) {
    score.value += isCorrect ? 100 : -50;
  }

  void addGameResult(GameResult result) {
    if (gameResults.length >= 10) {
      gameResults.removeAt(0);
    }
    gameResults.add(GameResult(
      score: result.score,
      date: result.date,
      puzzles: result.puzzles,
      mode: gameMode.value, // Add current mode
    ));
  }
}