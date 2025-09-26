import 'package:flutter/material.dart';
import 'report_model.dart'; // Import the model we just created

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  Future<ReportData>? _reportDataFuture;

  // This is your JSON data from the backend
  final String _jsonResponse = '''
  {
    "input_parameters": {
      "dosha": "Pitta",
      "goal": "lose_weight",
      "weight_kg": 70,
      "height_cm": 165,
      "age": 35,
      "gender": "male",
      "activity_level": "sedentary"
    },
    "calculated_tdee": 1873,
    "calorie_target": 1373,
    "report": "**Personalized Meal Plan Report**\\n\\nAs an expert Ayurvedic nutritionist, I've created a personalized meal plan tailored to your dominant dosha (Pitta), health goal (Lose Weight), and daily calorie target of approximately 1373 Kcal.\\n\\n**Breakfast:**\\n* Oatmeal with Ghee and Almonds (approx. 340 calories)\\n\\t+ Oatmeal (warm): Excellent for Pitta, grounding, nourishing, and soothing.\\n\\t+ Ghee (Clarified Butter): Cooling, aids digestion, and nourishes tissues. Benefits Pitta and can help with weight loss.\\n\\t+ Almonds (soaked and peeled): Nourishing, building, and grounding. Supports Vata, which is good for Pitta's digestive fire.\\n\\n**Lunch:**\\n* Basmati Rice with Mung Beans and Cucumber (approx. 435 calories)\\n\\t+ Basmati Rice: Balances Vata and Pitta, providing stable energy.\\n\\t+ Mung Beans (cooked): Tridoshic, especially good for Pitta, easy to digest, cleansing, and nourishing.\\n\\t+ Cucumber: Cooling, hydrating, and detoxifying. Excellent for Pitta.\\n\\n**Dinner:**\\n* Leafy Greens with Ghee (approx. 420 calories)\\n\\t+ Leafy Greens (cooked): Good for Pitta, cleansing, light, and rich in minerals.\\n\\t+ Ghee (Clarified Butter): Cooling, aids digestion, and nourishes tissues. Benefits Pitta and can help with weight loss.\\n\\n**Total Daily Calories:** 1195\\n\\nTo achieve your daily calorie target of approximately 1373 Kcal, I recommend adding an additional snack or adjusting portion sizes slightly. This meal plan is designed to provide a balanced mix of nutrients while respecting your dosha and health goal.\\n\\nRemember to stay hydrated by drinking plenty of water throughout the day, and adjust the meal plan as needed based on your individual needs and preferences."
  }
  ''';

  @override
  void initState() {
    super.initState();
    _reportDataFuture = _fetchAndParseReport();
  }

  // Simulates fetching and parsing the report data
  Future<ReportData> _fetchAndParseReport() async {
    // In a real app, this would be an API call.
    // Here, we simulate it with a short delay.
    await Future.delayed(const Duration(seconds: 1));
    return ReportData.fromJson(_jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const pageBackgroundColor = Color.fromARGB(255, 69, 136, 153);
    const cardBackgroundColor = Color(0xFFF3F3ED);

    return Scaffold(
      backgroundColor: pageBackgroundColor,
      appBar: AppBar(
        title: const Text('Report', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.w900)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<ReportData>(
        future: _reportDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Personalized report is here!',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // "Your profile" card
                  Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(color: const Color(0xFF87CEEB).withOpacity(0.5), width: 2),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Your profile',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: pranaTextColor,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildProfileColumn(data.inputParameters, true),
                            _buildProfileColumn(data.inputParameters, false),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  // "Your report" section
                  Container(
                     padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      color: cardBackgroundColor,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: _buildFormattedReport(data.report, pranaTextColor),
                  )
                ],
              ),
            );
          }
          return const Center(child: Text('No report data found.', style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  // Helper widget to build the two columns in the profile card
  Widget _buildProfileColumn(InputParameters params, bool isLeft) {
    const labelStyle = TextStyle(fontFamily: 'Montserrat', color: Color.fromARGB(255, 75, 75, 75), fontSize: 14, fontWeight: FontWeight.w700);
    const valueStyle = TextStyle(fontFamily: 'Montserrat', color: Color(0xFF6B5B3B), fontSize: 16, fontWeight: FontWeight.w900);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: isLeft
          ? [
              const Text('Dosha:', style: labelStyle),
              Text(params.dosha, style: valueStyle),
              const SizedBox(height: 10),
              const Text('Goal:', style: labelStyle),
              Text(params.goal, style: valueStyle),
              const SizedBox(height: 10),
              const Text('Weight(kg):', style: labelStyle),
              Text(params.weightKg.toString(), style: valueStyle),
              const SizedBox(height: 10),
              const Text('Height(cm):', style: labelStyle),
              Text(params.heightCm.toString(), style: valueStyle),
            ]
          : [
              const Text('Age:', style: labelStyle),
              Text(params.age.toString(), style: valueStyle),
              const SizedBox(height: 10),
              const Text('Gender:', style: labelStyle),
              Text(params.gender, style: valueStyle),
              const SizedBox(height: 10),
              const Text('Activity Level:', style: labelStyle),
              Text(params.activityLevel, style: valueStyle),
            ],
    );
  }

  // Helper widget to parse and format the LLM report string
  Widget _buildFormattedReport(String reportText, Color textColor) {
    List<TextSpan> spans = [];
    final lines = reportText.split('\n');

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty) {
        spans.add(const TextSpan(text: '\n'));
        continue;
      }

      TextStyle style = TextStyle(fontFamily: 'Montserrat', color: textColor, fontSize: 15, height: 1.5, fontWeight: FontWeight.w900);
      String text = '$line\n';

      if (line.startsWith('**') && line.endsWith('**')) {
        text = '${line.replaceAll('**', '')}\n';
        style = style.copyWith(fontWeight: FontWeight.w900, fontSize: 18);
      } else if (line.startsWith('* ')) {
        text = '• ${line.substring(2)}\n';
        style = style.copyWith(fontWeight: FontWeight.w600);
      } else if (line.startsWith('+ ')) {
        text = '    - ${line.substring(2)}\n';
         style = style.copyWith(color: textColor.withOpacity(0.85));
      }

      spans.add(TextSpan(text: text, style: style));
    }
    
    return RichText(text: TextSpan(children: spans));
  }
}