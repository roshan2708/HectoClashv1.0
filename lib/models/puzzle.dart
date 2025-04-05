import 'dart:math';
import 'package:math_expressions/math_expressions.dart';

class Puzzle {
  final String sequence;
  int timeLeft = 60;
  final List<String> solutions;
  String? _userInput; // Private field to store user input

  Puzzle(this.sequence, this.solutions);

  // Getter for userInput
  String? get userInput => _userInput;

  // Setter for userInput
  set userInput(String? value) => _userInput = value;

  String get question => "Solve the puzzle using the sequence: $sequence";

  static Puzzle generate({int target = 100}) {
    while (true) {
      String digits = List.generate(6, (_) => (Random().nextInt(9) + 1).toString()).join();
      List<String> solutions = _findValidExpressions(digits, target);

      if (solutions.isNotEmpty) {
        return Puzzle(digits, solutions.take(3).toList()); // Take top 3
      }
    }
  }

  static List<String> _findValidExpressions(String digits, int target) {
    List<String> results = [];

    // 1. Generate all possible ways to split digits into numbers
    void splitDigits(int index, List<String> current) {
      if (index == digits.length) {
        _tryOperators(current, results, target);
        return;
      }

      for (int i = index + 1; i <= digits.length; i++) {
        current.add(digits.substring(index, i));
        splitDigits(i, current);
        current.removeLast();
      }
    }

    splitDigits(0, []);
    return results;
  }

  // 2. For each digit split (e.g. ["1","23","4"]), try all operator combinations
  static void _tryOperators(List<String> numbers, List<String> results, int target) {
    int n = numbers.length;

    void dfs(int index, String expr) {
      if (index == n) {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expr);
          ContextModel cm = ContextModel();
          double result = exp.evaluate(EvaluationType.REAL, cm);
          if (result == target) results.add(expr);
        } catch (_) {}
        return;
      }

      dfs(index + 1, "$expr+${numbers[index]}");
      dfs(index + 1, "$expr-${numbers[index]}");
      dfs(index + 1, "$expr*${numbers[index]}");
    }

    dfs(1, numbers[0]);
  }

  bool isSolutionValid(String expression) {
    try {
      // Check if digits match original sequence in order
      String cleaned = expression.replaceAll(RegExp(r'[^0-9]'), '');
      if (cleaned != sequence) return false;

      // Evaluate
      Parser p = Parser();
      Expression exp = p.parse(expression);
      ContextModel cm = ContextModel();
      double result = exp.evaluate(EvaluationType.REAL, cm);
      return result == 100;
    } catch (_) {
      return false;
    }
  }

  String getSampleSolution() {
    return solutions.isNotEmpty ? "${solutions.first} = 100" : "No valid solution found.";
  }
}