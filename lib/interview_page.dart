import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'interview_data.dart';

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  // --- CHANGE 1: The map now uses String keys ---
  final Map<String, String> _answers = {};

  bool get _areAllQuestionsAnswered =>
      _answers.length == interviewQuestions.length;

  void _submitInterview() async {
    if (!_areAllQuestionsAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please answer all questions before submitting.')),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Not logged in. Please log in again.')),
      );
      return;
    }

    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'questionnaire_answers': _answers})
          .eq('id', user.id);

      if (mounted) {
        print('Interview answers saved successfully for user ${user.id}!');
        Navigator.pushReplacementNamed(context, '/loading');
      }
    } catch (error) {
      print('An error occurred while saving answers: $error');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('An error occurred. Please check your connection.')),
        );
      }
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
          style: TextStyle(
              fontFamily: 'Montserrat',
              color: pranaTextColor,
              fontWeight: FontWeight.bold),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
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
                              style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: pranaTextColor,
                                  fontWeight: FontWeight.w900),
                            ),
                            value: option,
                            // --- CHANGE 2: Use the question ID as a string ---
                            groupValue: _answers[question.id.toString()],
                            onChanged: (value) {
                              setState(() {
                                // --- CHANGE 3: Save the answer with the ID as a string ---
                                _answers[question.id.toString()] = value!;
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
                foregroundColor: _areAllQuestionsAnswered
                    ? Colors.white
                    : Colors.grey[300],
              ),
              child: const Text(
                'Predict Dosha',
                style: TextStyle(
                    fontFamily: 'Montserrat', fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}