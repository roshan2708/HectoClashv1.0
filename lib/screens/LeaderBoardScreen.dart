// screens/leaderboard_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hecto_clash_frontend/controllers/GameControler.dart';
import 'package:hecto_clash_frontend/models/game_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final GameController gameController = Get.find();
  int selectedTab = 0; // 0: Combined, 1: Duel, 2: Endless, 3: Blitz

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.purple[800]!, Colors.blue[600]!],
          ),
        ),
        child: SafeArea(
          child: Obx(() => Column(
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      onPressed: () => Get.back(),
                    ),
                    Text(
                      'Leaderboard',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 48), // Balance the layout
                  ],
                ),
              ),
              
              // Tab Bar
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildTabButton('All', 0),
                    _buildTabButton('Duel', 1),
                    _buildTabButton('Endless', 2),
                    _buildTabButton('Blitz', 3),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _buildLeaderboardContent(),
                ),
              ),
            ],
          )),
        ),
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selectedTab == index ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selectedTab == index ? Colors.purple[800] : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    List<GameResult> filteredResults = selectedTab == 0
        ? gameController.gameResults.toList()
        : gameController.gameResults
            .where((result) => _getModeFromResult(result) == selectedTab)
            .toList();

    filteredResults.sort((a, b) => b.score.compareTo(a.score)); // Sort by score descending

    if (filteredResults.isEmpty) {
      return Center(
        child: Text(
          'No games played yet!',
          style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        // Chart
        Container(
          height: 250,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(drawHorizontalLine: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: filteredResults
                      .asMap()
                      .entries
                      .map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble()))
                      .toList(),
                  isCurved: true,
                  color: _getModeColor(selectedTab),
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        
        // Top Scores
        Text(
          'Top Scores',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple[800],
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        
        // Score List
        ...filteredResults.take(5).map((result) => _buildScoreCard(result)).toList(),
      ],
    );
  }

  Widget _buildScoreCard(GameResult result) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getModeColor(_getModeFromResult(result)),
          child: Text(
            result.score.toString()[0],
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          'Score: ${result.score}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Date: ${result.date.toString().substring(0, 16)}',
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: Icon(
          Icons.star,
          color: Colors.yellow[700],
          size: 30,
        ),
      ),
    );
  }

  int _getModeFromResult(GameResult result) {
    // This assumes you modify GameResult to store the mode
    // For now, we'll use a simple heuristic based on puzzle count
    if (result.puzzles.length == 5) return 1; // Duel
    if (result.puzzles.length > 10) return 3; // Blitz (likely more puzzles)
    return 2; // Endless
  }

  Color _getModeColor(int mode) {
    switch (mode) {
      case 1: return Colors.blue; // Duel
      case 2: return Colors.teal; // Endless
      case 3: return Colors.purple; // Blitz
      default: return Colors.green; // Combined
    }
  }
}