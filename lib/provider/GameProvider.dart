// // providers/game_provider.dart
// import 'package:flutter/foundation.dart';
// import '../models/game_model.dart';
// import '../models/puzzle.dart';

// class GameProvider extends ChangeNotifier {
//   String _output = '';
//   int _currentPuzzleIndex = 0;
//   int _score = 0;
//   List<Puzzle> _puzzles = [];
//   List<GameResult> _gameResults = [];
//   Map<int, int> _incorrectAttempts = {}; // puzzleIndex: attempts
//   Map<int, String> _hints = {}; // puzzleIndex: hint
  
//   // Getters
//   String get output => _output;
//   int get currentPuzzleIndex => _currentPuzzleIndex;
//   int get score => _score;
//   List<Puzzle> get puzzles => _puzzles;
//   List<GameResult> get gameResults => _gameResults;
//   Map<int, int> get incorrectAttempts => _incorrectAttempts;
//   Map<int, String> get hints => _hints;
  
//   // Setters with notifications
//   set output(String value) {
//     _output = value;
//     notifyListeners();
//   }
  
//   set currentPuzzleIndex(int value) {
//     _currentPuzzleIndex = value;
//     notifyListeners();
//   }
  
//   set score(int value) {
//     _score = value;
//     notifyListeners();
//   }

//   GameProvider() {
//     startNewGame();
//   }

//   void startNewGame() {
//     _puzzles = [];
//     for (int i = 0; i < 5; i++) {
//       _puzzles.add(Puzzle.generate());
//     }
//     _currentPuzzleIndex = 0;
//     _score = 0;
//     _incorrectAttempts = {};
//     _hints = {};
//     notifyListeners();
//   }

//   void updateScore(bool isCorrect) {
//     _score += isCorrect ? 100 : -50;
//     notifyListeners();
//   }

//   void addGameResult(GameResult result) {
//     if (_gameResults.length >= 10) {
//       _gameResults.removeAt(0);
//     }
//     _gameResults.add(result);
//     notifyListeners();
//   }
  
//   void addHint(int puzzleIndex, String hint) {
//     _hints[puzzleIndex] = hint;
//     notifyListeners();
//   }
  
//   void incrementIncorrectAttempts(int puzzleIndex) {
//     _incorrectAttempts[puzzleIndex] = (_incorrectAttempts[puzzleIndex] ?? 0) + 1;
//     notifyListeners();
//   }
  
//   // New method to properly update puzzle time
//   void decrementPuzzleTime(int puzzleIndex) {
//     if (_puzzles[puzzleIndex].timeLeft > 0) {
//       _puzzles[puzzleIndex].timeLeft--;
//       notifyListeners();
//     }
//   }
// }