import 'package:flutter/material.dart';
import 'interview_data.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import dart:convert for JSON encoding

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  final Map<int, String> _answers = {};

  bool get _areAllQuestionsAnswered => _answers.length == interviewQuestions.length;

  // This function now sends data to a backend
  void _submitInterview() async {
    if (_areAllQuestionsAnswered) {
      // 1. Define your backend API endpoint URL
      final url = Uri.parse('https://your-backend-api.com/generate-report'); // <-- IMPORTANT: Replace with your actual URL

      // 2. Convert your answers map to a JSON string
      final body = json.encode(_answers);

      try {
        // 3. Send the data as an HTTP POST request
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        // 4. Check if the request was successful (HTTP status code 200)
        if (response.statusCode == 200 && mounted) {
          print('Interview submitted successfully!');
          Navigator.pushReplacementNamed(context, '/loading');
        } else {
          // If the server returned an error, show a message
          print('Failed to submit. Status code: ${response.statusCode}');
          if(mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to submit report. Please try again.')),
            );
          }
        }
      } catch (e) {
        // Handle potential network errors (e.g., no internet connection)
        print('An error occurred: $e');
        if(mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('An error occurred. Please check your connection.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions before submitting.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color pranaTextColor = Color(0xFF6B5B3B);
    const Color backgroundColor = Color.fromARGB(255, 237, 196, 151);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Your Ayurvedic Profile',
          style: TextStyle(fontFamily: 'Montserrat', color: pranaTextColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: interviewQuestions.length,
              itemBuilder: (context, index) {
                final question = interviewQuestions[index];
                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.2),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Q${question.id}. ${question.question}",
                          style: const TextStyle(
                            fontFamily: 'Montserrat',
                            color: pranaTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...question.options.map((option) {
                          return RadioListTile<String>(
                            title: Text(
                              option,
                              style: const TextStyle(fontFamily: 'Montserrat', color: pranaTextColor, fontWeight: FontWeight.w900),
                            ),
                            value: option,
                            groupValue: _answers[question.id],
                            onChanged: (value) {
                              setState(() {
                                _answers[question.id] = value!;
                              });
                            },
                            activeColor: pranaTextColor,
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
            color: backgroundColor,
            child: ElevatedButton(
              onPressed: _submitInterview,
              style: ElevatedButton.styleFrom(
                backgroundColor: pranaTextColor,
                minimumSize: const Size(250, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                foregroundColor: _areAllQuestionsAnswered ? Colors.white : Colors.grey[300],
              ),
              child: const Text(
                'Generate Report',
                style: TextStyle(fontFamily: 'Montserrat', fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}