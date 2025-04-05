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
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() => Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(icon: Icon(Icons.arrow_back_ios, color: Color(0xFF3B82F6)), onPressed: () => Get.back()),
                  Text('Leaderboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(width: 48),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(color: Color(0xFFF8EDEB), borderRadius: BorderRadius.circular(12)),
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
            Expanded(
              child: Container(
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                child: _buildLeaderboardContent(),
              ),
            ),
          ],
        )),
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
            color: selectedTab == index ? Color(0xFF3B82F6) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: selectedTab == index ? Colors.white : Color(0xFF6B7280), fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardContent() {
    List<GameResult> filteredResults = selectedTab == 0
        ? gameController.gameResults.toList()
        : gameController.gameResults.where((result) => _getModeFromResult(result) == selectedTab).toList();
    filteredResults.sort((a, b) => b.score.compareTo(a.score));

    if (filteredResults.isEmpty) {
      return Center(child: Text('No games played yet!', style: TextStyle(fontSize: 18, color: Color(0xFF6B7280))));
    }

    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Container(
          height: 250,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(color: Color(0xFFF8EDEB), borderRadius: BorderRadius.circular(16)),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(drawHorizontalLine: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(fontSize: 12)))),
                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 40, getTitlesWidget: (value, meta) => Text(value.toInt().toString(), style: TextStyle(fontSize: 12)))),
              ),
              borderData: FlBorderData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: filteredResults.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.score.toDouble())).toList(),
                  isCurved: true,
                  color: Color(0xFF3B82F6),
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Text('Top Scores', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        SizedBox(height: 10),
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
        leading: CircleAvatar(backgroundColor: Color(0xFF3B82F6), child: Text(result.score.toString()[0], style: TextStyle(color: Colors.white))),
        title: Text('Score: ${result.score}', style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Date: ${result.date.toString().substring(0, 16)}', style: TextStyle(color: Color(0xFF6B7280))),
        trailing: Icon(Icons.star, color: Color(0xFFFBBF24), size: 30),
      ),
    );
  }

  int _getModeFromResult(GameResult result) {
    if (result.puzzles.length == 5) return 1;
    if (result.puzzles.length > 10) return 3;
    return 2;
  }
}