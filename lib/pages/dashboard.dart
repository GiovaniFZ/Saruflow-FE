import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/components/avatar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();

}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> data = [];
  bool loading = false;
  bool _didFetch = false;

  void showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> fetchData(String token) async {
    final url = Uri.parse('http://localhost:3000/graphic');
    setState(() => loading = true);
    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final graphic = parsed['graphic'] as List<dynamic>;
        List<Map<String, dynamic>> points = [];
        for (var item in graphic) {
          points.add(({'x': item['xAxis'], 'y': item['yAxis']}));
        }
        setState(() {
          data = points;
        });
      } else {
        showErrorMessage('Falha ao carregar dados: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      showErrorMessage('Ocorreu um erro. Tente novamente.');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didFetch) {
      final Map<String, dynamic>? args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final String token = args?['token'] ?? '';
      fetchData(token);
      _didFetch = true;
    }
  }

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
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : LineChart(
                    LineChartData(
                      lineBarsData: [
                        LineChartBarData(
                          spots: data.map((point) {
                            return FlSpot(point['x'], point['y']);
                          }).toList(),
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
