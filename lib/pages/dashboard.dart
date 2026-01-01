import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/components/avatar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_app/common/show_message.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Map<String, dynamic>> data = [];
  bool loading = false;
  bool _didFetch = false;
  String name = '';

  Future<void> fetchData(String token) async {
    final url = Uri.parse('http://localhost:3000/graphic');
    setState(() => loading = true);
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final parsed = jsonDecode(response.body);
        final graphic = parsed['graphic'] as List<dynamic>;
        List<Map<String, dynamic>> points = [];
        for (final item in graphic) {
          final xRaw = item['xAxis'];
          final yRaw = item['yAxis'];
          final itemName = (item['name'] as String?)?.trim();

          if (itemName != null && itemName.isNotEmpty) {
            name = itemName;
          }

          if (xRaw == null || yRaw == null) continue;
          if (xRaw is! num || yRaw is! num) continue;

          points.add({'x': xRaw.toDouble(), 'y': yRaw.toDouble()});
        }
        setState(() {
          data = points;
        });
      } else {
        if (!mounted) return;
        showErrorMessage(
          'Falha ao carregar dados: ${response.statusCode}',
          context,
        );
      }
    } catch (e) {
      if (!mounted) return;
      showErrorMessage('Ocorreu um erro. Tente novamente.', context);
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
      final Map<String, dynamic>? args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
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
          Avatar(text: name),
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
