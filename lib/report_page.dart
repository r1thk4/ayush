import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Import Supabase

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<Map<String, double>> _doshaProbabilitiesFuture;

  final Map<String, Color> _doshaColors = {
    'Vata': Colors.lightBlue.shade300,
    'Pitta': Colors.red.shade300,
    'Kapha': Colors.green.shade300,
    'Vata-Pitta': Colors.orange.shade300,
    'Vata-Kapha': Colors.teal.shade300,
    'Pitta-Kapha': Colors.purple.shade300,
  };

  @override
  void initState() {
    super.initState();
    _doshaProbabilitiesFuture = _fetchDoshaProbabilities();
  }

  /// --- UPDATED: This function now fetches live data from Supabase ---
  Future<Map<String, double>> _fetchDoshaProbabilities() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in.');
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('prediction_probs') // Select the correct column
          .eq('id', user.id)
          .single();

      // Check if data exists
      if (response['prediction_probs'] == null) {
        throw Exception('No prediction data found. Please complete the interview.');
      }

      // The data from Supabase will be Map<String, dynamic>
      final rawProbs = response['prediction_probs'] as Map<String, dynamic>;
      
      // Convert the keys and cast values to the format our UI needs
      final formattedProbs = <String, double>{};
      rawProbs.forEach((key, value) {
        // Format key from "vata+pitta" to "Vata-Pitta"
        final formattedKey = key
            .split('+')
            .map((part) => part.capitalize())
            .join('-');
        // Ensure the value is a double
        formattedProbs[formattedKey] = (value as num).toDouble();
      });

      return formattedProbs;

    } catch (e) {
      print('Error fetching prediction probabilities: $e');
      // Re-throw the error to be caught by the FutureBuilder
      throw Exception('Failed to load your dosha report.');
    }
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const backgroundColor = Color(0xFFF3F3ED);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Dosha Profiling Report', style: TextStyle(color: pranaTextColor, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
      ),
      body: FutureBuilder<Map<String, double>>(
        future: _doshaProbabilitiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: pranaTextColor));
          } else if (snapshot.hasError) {
            // Display a user-friendly error message
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final probabilities = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dosha Prediction Probabilities',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: pranaTextColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: _buildChartSections(probabilities),
                        centerSpaceRadius: 60,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider(),
                  const SizedBox(height: 20),
                  _buildLegend(probabilities),
                ],
              ),
            );
          }
          return const Center(child: Text('No data available.'));
        },
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections(Map<String, double> probabilities) {
    return probabilities.entries.map((entry) {
      final percentage = (entry.value * 100).toStringAsFixed(1);
      return PieChartSectionData(
        value: entry.value,
        title: '$percentage%',
        color: _doshaColors[entry.key] ?? Colors.grey,
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: [Shadow(color: Colors.black, blurRadius: 2)],
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> probabilities) {
    // Sort the entries by probability, descending
    final sortedEntries = probabilities.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      children: sortedEntries.map((entry) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 16,
                height: 16,
                color: _doshaColors[entry.key] ?? Colors.grey,
              ),
              const SizedBox(width: 10),
              Text(
                '${entry.key} (${(entry.value * 100).toStringAsFixed(1)}%)',
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// Helper extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}