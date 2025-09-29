import 'dart:convert';

// A helper class to hold the combined report data
class FullReportData {
  final Map<String, double> probabilities;
  final TextualReport textualReport;

  FullReportData({required this.probabilities, required this.textualReport});
}


// Classes to parse the textual report JSON
class TextualReport {
  final InputParameters inputParameters;
  final String report;

  TextualReport({
    required this.inputParameters,
    required this.report,
  });

  factory TextualReport.fromMap(Map<String, dynamic> json) => TextualReport(
        inputParameters: InputParameters.fromMap(json["input_parameters"]),
        report: json["report"] ?? 'No detailed report available.',
      );
}

class InputParameters {
  final String dosha;
  // Other parameters can be added here if needed in the UI
  
  InputParameters({required this.dosha});

  factory InputParameters.fromMap(Map<String, dynamic> json) => InputParameters(
        dosha: json["dosha"] ?? 'N/A',
      );
}

// Helper extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
