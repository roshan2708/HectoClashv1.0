// models/game_result.dart
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/puzzle.dart';

class GameResult {
  final int score;
  final DateTime date;
  final List<Puzzle> puzzles;
  final GameMode mode;

  GameResult({required this.score, required this.date, required this.puzzles,
  required this.mode,
  });
}