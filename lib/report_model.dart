import 'dart:convert';

class ReportData {
  final InputParameters inputParameters;
  final int calculatedTdee;
  final int calorieTarget;
  final String report;

  ReportData({
    required this.inputParameters,
    required this.calculatedTdee,
    required this.calorieTarget,
    required this.report,
  });

  factory ReportData.fromJson(String str) => ReportData.fromMap(json.decode(str));

  factory ReportData.fromMap(Map<String, dynamic> json) => ReportData(
        inputParameters: InputParameters.fromMap(json["input_parameters"]),
        calculatedTdee: json["calculated_tdee"] ?? 0,
        calorieTarget: json["calorie_target"] ?? 0,
        report: json["report"] ?? 'No report available.',
      );
}

class InputParameters {
  final String dosha;
  final String goal;
  final int weightKg;
  final int heightCm;
  final int age;
  final String gender;
  final String activityLevel;

  InputParameters({
    required this.dosha,
    required this.goal,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    required this.gender,
    required this.activityLevel,
  });

  factory InputParameters.fromMap(Map<String, dynamic> json) => InputParameters(
        // Use ?? to provide a default value if the key is missing or null
        dosha: json["dosha"] ?? 'N/A',
        // Use ?. (null-aware operator) before calling methods on potentially null strings
        goal: (json["goal"] as String?)?.replaceAll('_', ' ').capitalize() ?? 'N/A',
        weightKg: json["weight_kg"] ?? 0,
        heightCm: json["height_cm"] ?? 0,
        age: json["age"] ?? 0,
        gender: (json["gender"] as String?)?.capitalize() ?? 'N/A',
        activityLevel: (json["activity_level"] as String?)?.capitalize() ?? 'N/A',
      );
}

// Helper extension to add the capitalize() function to the String class
extension StringExtensions on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}