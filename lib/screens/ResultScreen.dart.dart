import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/puzzle.dart';
import 'package:hecto_clash_frontend/screens/LeaderBoardScreen.dart';

class ResultsScreen extends StatelessWidget {
  final GameController gameController = Get.find();

  // Premium color palette
  final Color primaryColor = Color(0xFF6A5ACD); // Purple
  final Color secondaryColor = Color(0xFF5D5FEF); // Indigo
  final Color backgroundColor = Color(0xFFF5F7FA); // Light gray
  final Color successColor = Color(0xFF4CAF50); // Green
  final Color errorColor = Color(0xFFFF5252); // Red
  final Color textColor = Color(0xFF2D3748); // Dark gray
  final Color lightTextColor = Color(0xFF6B7280); // Medium gray

  void _resetAndGoBack() {
    gameController.resetGame(); // Reset game state
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    String modeTitle = gameController.gameMode.value == GameMode.endless
        ? 'Endless Mode'
        : gameController.gameMode.value == GameMode.blitz
            ? 'Blitz Mode'
            : 'Duel Mode';

    final totalScore = gameController.score.value;
    final totalPuzzles = gameController.puzzles.length;
    final correctAnswers = gameController.puzzles
        .where((p) => p.isSolutionValid(p.userInput ?? ''))
        .length;

    // Use MediaQuery for responsive sizing
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final scaleFactor = screenWidth / 400; // Base width for scaling

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Premium header with shadow
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 12 * scaleFactor, vertical: 8 * scaleFactor),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios,
                        color: secondaryColor, size: 20 * scaleFactor),
                    onPressed: _resetAndGoBack, // Reset and go back
                  ),
                  Text(
                    '$modeTitle Results',
                    style: TextStyle(
                      fontSize: 20 * scaleFactor,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.leaderboard,
                        color: secondaryColor, size: 20 * scaleFactor),
                    onPressed: () => Get.to(() => LeaderboardScreen()),
                  ),
                ],
              ),
            ),

            // Score summary card
            Container(
              margin: EdgeInsets.all(12 * scaleFactor),
              padding: EdgeInsets.all(16 * scaleFactor),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryColor.withOpacity(0.8),
                    secondaryColor.withOpacity(0.9)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16 * scaleFactor),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 8 * scaleFactor,
                    offset: Offset(0, 3 * scaleFactor),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.emoji_events,
                          color: Colors.white, size: 24 * scaleFactor),
                      SizedBox(width: 8 * scaleFactor),
                      Text(
                        'Final Score',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16 * scaleFactor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scaleFactor),
                  Text(
                    totalScore.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40 * scaleFactor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12 * scaleFactor),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn(
                        title: 'Puzzles',
                        value: totalPuzzles.toString(),
                        icon: Icons.extension,
                        scaleFactor: scaleFactor,
                      ),
                      Container(
                        height: 32 * scaleFactor,
                        width: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildStatColumn(
                        title: 'Correct',
                        value: '$correctAnswers/$totalPuzzles',
                        icon: Icons.check_circle_outline,
                        scaleFactor: scaleFactor,
                      ),
                      Container(
                        height: 32 * scaleFactor,
                        width: 1,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      _buildStatColumn(
                        title: 'Accuracy',
                        value: totalPuzzles > 0
                            ? '${(correctAnswers / totalPuzzles * 100).toStringAsFixed(0)}%'
                            : '0%',
                        icon: Icons.analytics_outlined,
                        scaleFactor: scaleFactor,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Puzzles list header
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16 * scaleFactor, vertical: 8 * scaleFactor),
              child: Row(
                children: [
                  Icon(Icons.format_list_bulleted,
                      color: secondaryColor, size: 18 * scaleFactor),
                  SizedBox(width: 6 * scaleFactor),
                  Text(
                    'Puzzle Details',
                    style: TextStyle(
                      fontSize: 16 * scaleFactor,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),

            // Puzzle list
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(
                    12 * scaleFactor, 0, 12 * scaleFactor, 12 * scaleFactor),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16 * scaleFactor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8 * scaleFactor,
                      offset: Offset(0, 2 * scaleFactor),
                    ),
                  ],
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(12 * scaleFactor),
                  itemCount: gameController.puzzles.length + 1,
                  itemBuilder: (context, index) {
                    if (index == gameController.puzzles.length) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 20 * scaleFactor, bottom: 6 * scaleFactor),
                        child: ElevatedButton(
                          onPressed: () {
                            gameController
                                .startNewGame(mode: gameController.gameMode.value);
                            Get.back();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: secondaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12 * scaleFactor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12 * scaleFactor),
                            ),
                            elevation: 3 * scaleFactor,
                            shadowColor: secondaryColor.withOpacity(0.4),
                          ),
                          child: Text(
                            'Play Again',
                            style: TextStyle(
                              fontSize: 16 * scaleFactor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }

                    Puzzle puzzle = gameController.puzzles[index];
                    bool isCorrect =
                        puzzle.isSolutionValid(puzzle.userInput ?? '');

                    return Card(
                      elevation: 0,
                      margin: EdgeInsets.only(bottom: 8 * scaleFactor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12 * scaleFactor),
                        side: BorderSide(
                          color: isCorrect
                              ? successColor.withOpacity(0.3)
                              : errorColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12 * scaleFactor),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Puzzle ${index + 1}',
                                    style: TextStyle(
                                      fontSize: 14 * scaleFactor,
                                      fontWeight: FontWeight.bold,
                                      color: textColor,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8 * scaleFactor,
                                      vertical: 3 * scaleFactor),
                                  decoration: BoxDecoration(
                                    color: isCorrect
                                        ? successColor.withOpacity(0.1)
                                        : errorColor.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(10 * scaleFactor),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        isCorrect
                                            ? Icons.check_circle
                                            : Icons.cancel_outlined,
                                        size: 14 * scaleFactor,
                                        color:
                                            isCorrect ? successColor : errorColor,
                                      ),
                                      SizedBox(width: 3 * scaleFactor),
                                      Text(
                                        isCorrect ? 'Correct' : 'Incorrect',
                                        style: TextStyle(
                                          fontSize: 11 * scaleFactor,
                                          fontWeight: FontWeight.w500,
                                          color: isCorrect
                                              ? successColor
                                              : errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10 * scaleFactor),
                            Container(
                              padding: EdgeInsets.all(10 * scaleFactor),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius:
                                    BorderRadius.circular(10 * scaleFactor),
                              ),
                              child: Text(
                                puzzle.sequence,
                                style: TextStyle(
                                  fontSize: 14 * scaleFactor,
                                  fontWeight: FontWeight.w500,
                                  color: textColor,
                                ),
                              ),
                            ),
                            SizedBox(height: 10 * scaleFactor),
                            Row(
                              children: [
                                Icon(
                                  Icons.timer_outlined,
                                  size: 14 * scaleFactor,
                                  color: lightTextColor,
                                ),
                                SizedBox(width: 5 * scaleFactor),
                                Text(
                                  'Time: ${60 - puzzle.timeLeft} sec',
                                  style: TextStyle(
                                    color: lightTextColor,
                                    fontSize: 12 * scaleFactor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10 * scaleFactor),
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 14 * scaleFactor,
                                  color: isCorrect ? successColor : errorColor,
                                ),
                                SizedBox(width: 5 * scaleFactor),
                                Expanded(
                                  child: Text(
                                    'Your Answer: ${puzzle.userInput ?? "Not attempted"}',
                                    style: TextStyle(
                                      color:
                                          isCorrect ? successColor : errorColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12 * scaleFactor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (!isCorrect) ...[
                              SizedBox(height: 10 * scaleFactor),
                              Row(
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 14 * scaleFactor,
                                    color: secondaryColor,
                                  ),
                                  SizedBox(width: 5 * scaleFactor),
                                  Expanded(
                                    child: Text(
                                      'Correct Answer: ${puzzle.getSampleSolution()}',
                                      style: TextStyle(
                                        color: secondaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12 * scaleFactor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn({
    required String title,
    required String value,
    required IconData icon,
    required double scaleFactor,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 18 * scaleFactor),
        SizedBox(height: 5 * scaleFactor),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2 * scaleFactor),
        Text(
          title,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 11 * scaleFactor,
          ),
        ),
      ],
    );
  }
}