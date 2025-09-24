import 'package:flutter/material.dart';
import 'interview_data.dart'; // Import our questions

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  // A map to store the selected answer for each question ID
  final Map<int, String> _answers = {};

  // Function to check if all questions have been answered
  bool get _areAllQuestionsAnswered => _answers.length == interviewQuestions.length;

  void _submitInterview() {
    if (_areAllQuestionsAnswered) {
      // Navigate to the loading page after submission
      // In a real app, you would pass the _answers map to the model here
      Navigator.pushReplacementNamed(context, '/loading');
      print('Interview submitted with answers: $_answers');
    } else {
      // Show a message if not all questions are answered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
          backgroundColor: Colors.orange,
        ),
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
                        // Build radio buttons for each option
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
          // Submit Button Area
          Container(
            // Use padding to give space around the button and lift it from the bottom
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
                // Change button style based on whether all questions are answered
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