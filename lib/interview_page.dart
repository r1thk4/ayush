import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'interview_data.dart';
import 'loading_page.dart';

class InterviewPage extends StatefulWidget {
  const InterviewPage({super.key});

  @override
  State<InterviewPage> createState() => _InterviewPageState();
}

class _InterviewPageState extends State<InterviewPage> {
  final _pageController = PageController();
  final Map<String, String> _answers = {};
  int _currentPageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Navigates to the next question if an answer is selected.
  void _nextPage() {
    final questionId = interviewQuestions[_currentPageIndex].id.toString();
    if (_answers[questionId] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option to continue.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  /// Navigates to the previous question.
  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _submitInterview() async {
    // Final check to ensure all questions are answered before submitting
    if (_answers.length != interviewQuestions.length) {
       ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer all questions before submitting.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client
          .from('profiles')
          .update({'questionnaire_answers': _answers})
          .eq('id', user.id);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoadingPage(
              loadingText: 'Predicting your Dosha...',
              nextRoute: '/dosha_result',
            ),
          ),
        );
      }
    } catch (error) {
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
    const pranaTextColor = Color(0xFF6B5B3B);
    const primaryColor = Color(0xFFB3C691);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Question ${_currentPageIndex + 1} of ${interviewQuestions.length}',
          style: const TextStyle(
            color: pranaTextColor,
            fontFamily: 'Montserrat',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: LinearProgressIndicator(
            value: (_currentPageIndex + 1) / interviewQuestions.length,
            backgroundColor: Colors.grey.shade200,
            color: primaryColor,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: interviewQuestions.length,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final question = interviewQuestions[index];
          return _buildQuestionPage(question);
        },
      ),
    );
  }

  /// Builds the UI for a single question page, including navigation arrows.
  Widget _buildQuestionPage(InterviewQuestion question) {
    final isLastQuestion = _currentPageIndex == interviewQuestions.length - 1;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          // --- NEW: Navigation Arrows ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.grey),
                onPressed: _currentPageIndex == 0 ? null : _previousPage, // Disabled on first page
              ),
              // Forward Button (hidden on the last page)
              if (!isLastQuestion)
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Color(0xFF6B5B3B)),
                  onPressed: _nextPage,
                ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            question.question,
            style: const TextStyle(
              fontFamily: 'Montserrat',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B5B3B),
            ),
          ),
          const SizedBox(height: 40),
          ...question.options.map((option) {
            final isSelected = _answers[question.id.toString()] == option;
            return _buildOptionCard(option, isSelected, () {
              setState(() {
                _answers[question.id.toString()] = option;
              });
            });
          }).toList(),
          
          // --- NEW: Conditional Predict Dosha Button ---
          if (isLastQuestion)
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 40.0),
              child: Center(
                child: ElevatedButton(
                  onPressed: _submitInterview,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6A70),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Predict Dosha',
                    style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Builds the custom tappable option card.
  Widget _buildOptionCard(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: isSelected ? 4 : 1,
        color: isSelected ? const Color(0xFFB3C691).withOpacity(0.3) : Colors.white,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? const Color(0xFFB3C691) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFFB3C691) : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFB3C691),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}