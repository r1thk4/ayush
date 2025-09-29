import 'package:flutter/material.dart';
import 'loading_page.dart'; // Make sure you have this import for navigation

class DietChartInterviewPage extends StatefulWidget {
  const DietChartInterviewPage({super.key});

  @override
  State<DietChartInterviewPage> createState() => _DietChartInterviewPageState();
}

class _DietChartInterviewPageState extends State<DietChartInterviewPage> {
  final _formKey = GlobalKey<FormState>();

  String? _healthStatus; // 'Yes' or 'No'
  String? _cuisine;
  final _conditionController = TextEditingController();
  final _forbiddenFoodController = TextEditingController();

  final List<String> _indianCuisines = [
    'North Indian', 'South Indian', 'Bengali', 'Gujarati', 'Maharashtrian', 'Rajasthani'
  ];

  void _submitDietInterview() {
    // We only need to validate if the health condition field is visible
    final isHealthConditionValid = _healthStatus == 'No' ? _formKey.currentState!.validate() : true;

    if (isHealthConditionValid) {
      final Map<String, dynamic> dietData = {
        'is_health_okay': _healthStatus == 'Yes',
        'preferred_cuisine': _cuisine,
        'health_condition': _conditionController.text,
        'forbidden_foods': _forbiddenFoodController.text,
      };

      print('Submitting Diet Data: $dietData');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoadingPage(
            loadingText: 'Generating your Diet Chart...',
            nextRoute: '/diet_chart_display',
          ),
        ),
      );
    }
  }
  
  @override
  void dispose() {
    _conditionController.dispose();
    _forbiddenFoodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const primaryColor = Color(0xFFB3C691);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Diet Profile', style: TextStyle(color: pranaTextColor, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: _calculateProgress(),
            backgroundColor: Colors.grey.shade200,
            color: primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildQuestionText("Is your general health condition okay?"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildOptionCard('Yes', _healthStatus == 'Yes', () => setState(() => _healthStatus = 'Yes'))),
                  const SizedBox(width: 16),
                  Expanded(child: _buildOptionCard('No', _healthStatus == 'No', () => setState(() => _healthStatus = 'No'))),
                ],
              ),
              const SizedBox(height: 30),

              if (_healthStatus == 'Yes')
                _buildCuisineQuestion(),
              
              if (_healthStatus == 'No')
                _buildHealthConditionQuestion(),
              
              if (_healthStatus != null)
                _buildForbiddenFoodQuestion(),
              
              const SizedBox(height: 40),

              if (_isFormComplete())
                ElevatedButton(
                  onPressed: _submitDietInterview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6A70),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Generate Diet Chart', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Montserrat')),
                )
            ],
          ),
        ),
      ),
    );
  }

  // --- CORRECTED HELPER WIDGETS ---

  double _calculateProgress() {
    int completedSteps = 0;
    if (_healthStatus != null) {
      completedSteps++; // Step 1: Health status selected
      if (_healthStatus == 'Yes' && _cuisine != null) {
        completedSteps++; // Step 2 (Yes path): Cuisine selected
      }
      if (_healthStatus == 'No') {
        // For the text field, we'll consider it "complete" if it has text, for progress purposes
        if (_conditionController.text.isNotEmpty) {
           completedSteps++; // Step 2 (No path): Condition entered
        }
      }
    }
    // There are always 2 main steps to complete before the final button appears
    return completedSteps / 2.0;
  }

  bool _isFormComplete() {
    if (_healthStatus == 'Yes' && _cuisine != null) {
      // Path 1 is complete if health is 'Yes' and a cuisine is chosen
      return true;
    }
    if (_healthStatus == 'No') {
      // Path 2 is considered complete once the user starts typing in the condition field
      // The final validation is handled on button press
      return true;
    }
    return false;
  }

  // --- UI HELPER WIDGETS (UNCHANGED) ---

  Widget _buildQuestionText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Color(0xFF6B5B3B),
      ),
    );
  }

  Widget _buildOptionCard(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: isSelected ? const Color(0xFFB3C691).withOpacity(0.3) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFFB3C691) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 16)),
        ),
      ),
    );
  }

  Widget _buildCuisineQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionText("What is your preferred cuisine?"),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _indianCuisines.map((cuisine) {
            return _buildOptionCard(cuisine, _cuisine == cuisine, () => setState(() => _cuisine = cuisine));
          }).toList(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
  
  Widget _buildHealthConditionQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionText("Please describe your health condition."),
        const SizedBox(height: 16),
        TextFormField(
          controller: _conditionController,
          decoration: InputDecoration(
            hintText: 'e.g., Diabetes, High Blood Pressure',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
          onChanged: (value) => setState(() {}), // Rebuild to update progress/completion
          validator: (value) => (value == null || value.isEmpty) ? 'Please enter your health condition' : null,
        ),
        const SizedBox(height: 30),
      ],
    );
  }
  
  Widget _buildForbiddenFoodQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildQuestionText("Are there any foods you must avoid?"),
        const SizedBox(height: 16),
        TextFormField(
          controller: _forbiddenFoodController,
          decoration: InputDecoration(
            hintText: 'e.g., Peanuts, Gluten, Dairy (optional)',
            filled: true,
            fillColor: Colors.grey.shade100,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}