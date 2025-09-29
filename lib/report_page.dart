import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'report_model.dart'; // Make sure this model file exists

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Future<FullReportData> _fullReportFuture;

  final Map<String, Color> _doshaColors = {
    'Vata': const Color(0xFF82C2E6),
    'Pitta': const Color(0xFFE89E50),
    'Kapha': const Color(0xFFB6CEB0),
    'Vata-Pitta': const Color(0xFF9B866D),
    'Vata-Kapha': const Color(0xFF5B9C89),
    'Pitta-Kapha': const Color(0xFFA68040),
  };

  @override
  void initState() {
    super.initState();
    _fullReportFuture = _fetchFullReport();
  }

  // --- UPDATED FUNCTION TO USE DUMMY DATA ---
  Future<FullReportData> _fetchFullReport() async {
    // Simulate a network delay
    await Future.delayed(const Duration(seconds: 1));

    // --- Dummy Data for Pie Chart ---
    final Map<String, dynamic> rawProbs = {
      "Vata": 0.2616,
      "Kapha": 0.0147,
      "Pitta": 0.1272,
      "vata+kapha": 0.0865,
      "vata+pitta": 0.4829,
      "pitta+kapha": 0.0269,
    };

    // --- Dummy Data for Textual Report ---
    final Map<String, dynamic> textualReportData = {
      "input_parameters": {
        "dosha": "Pitta",
        "goal": "lose_weight",
        "weight_kg": 70,
        "height_cm": 165,
        "age": 35,
        "gender": "male",
        "activity_level": "sedentary"
      },
      "report": "**Personalized Meal Plan Report**\n\nAs an expert Ayurvedic nutritionist, I've created a personalized meal plan tailored to your dominant dosha (Pitta), health goal (Lose Weight), and daily calorie target of approximately 1373 Kcal.\n\n**Breakfast:**\n* Oatmeal with Ghee and Almonds (approx. 340 calories)\n\t+ Oatmeal (warm): Excellent for Pitta, grounding, nourishing, and soothing.\n\t+ Ghee (Clarified Butter): Cooling, aids digestion, and nourishes tissues.\n\n**Lunch:**\n* Basmati Rice with Mung Beans and Cucumber (approx. 435 calories)\n\t+ Mung Beans (cooked): Tridoshic, especially good for Pitta, easy to digest, cleansing, and nourishing.\n\n**Dinner:**\n* Leafy Greens with Ghee (approx. 420 calories)\n\t+ Leafy Greens (cooked): Good for Pitta, cleansing, light, and rich in minerals."
    };

    // --- Parsing Logic (same as before) ---
    final formattedProbs = <String, double>{};
    rawProbs.forEach((key, value) {
      final formattedKey = key.split('+').map((p) => p.capitalize()).join('-');
      formattedProbs[formattedKey] = (value as num).toDouble();
    });

    final textualReport = TextualReport.fromMap(textualReportData);

    return FullReportData(probabilities: formattedProbs, textualReport: textualReport);
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const backgroundColor = Color(0xFFF3F3ED);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Your Ayurvedic Report', style: TextStyle(color: pranaTextColor, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
      ),
      body: FutureBuilder<FullReportData>(
        future: _fullReportFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: pranaTextColor));
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  '${snapshot.error}',
                  textAlign: TextAlign.justify,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              ),
            );
          } else if (snapshot.hasData) {
            final fullReport = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dosha Prediction Probabilities',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 24, fontWeight: FontWeight.bold, color: pranaTextColor),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 300,
                    child: PieChart(
                      PieChartData(
                        sections: _buildChartSections(fullReport.probabilities),
                        centerSpaceRadius: 60,
                        sectionsSpace: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildLegend(fullReport.probabilities),
                  const SizedBox(height: 30),
                  const Divider(thickness: 1.5),
                  const SizedBox(height: 30),
                  _buildFormattedReport(fullReport.textualReport.report, pranaTextColor),
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
        titleStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, shadows: [Shadow(color: Colors.black, blurRadius: 2)]),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> probabilities) {
    final sortedEntries = probabilities.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Legend', style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        ...sortedEntries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                Container(width: 16, height: 16, color: _doshaColors[entry.key] ?? Colors.grey),
                const SizedBox(width: 10),
                Text(
                  '${entry.key} (${(entry.value * 100).toStringAsFixed(1)}%)',
                  style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildFormattedReport(String reportText, Color textColor) {
    List<TextSpan> spans = [];
    final lines = reportText.split('\n');

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      TextStyle style = TextStyle(fontFamily: 'Montserrat', color: textColor, fontSize: 15, height: 1.5);
      String text = '$line\n';

      if (line.startsWith('**') && line.endsWith('**')) {
        text = '${line.replaceAll('**', '')}\n';
        style = style.copyWith(fontWeight: FontWeight.bold, fontSize: 22);
      } else if (line.startsWith('* ')) {
        text = '• ${line.substring(2)}\n';
        style = style.copyWith(fontWeight: FontWeight.w600, fontSize: 16);
      } else if (line.startsWith('+ ')) {
        text = '    - ${line.substring(2)}\n';
        style = style.copyWith(color: textColor.withOpacity(0.85));
      }

      spans.add(TextSpan(text: text, style: style));
    }
    
    return RichText(
      textAlign: TextAlign.justify, // Justify the text
      text: TextSpan(children: spans),
    );
  }
}