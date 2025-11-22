import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/components/avatar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  static const exampleJson = [
    {"x": 0, "y": 1},
    {"x": 1, "y": 3},
    {"x": 2, "y": 2},
    {"x": 3, "y": 5},
    {"x": 4, "y": 3},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Avatar(text: 'Luks'),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var point in exampleJson)
                        FlSpot(point['x']!.toDouble(), point['y']!.toDouble()),
                    ],
                    isCurved: true,
                    barWidth: 4,
                    dotData: FlDotData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(show: true),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(show: true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
