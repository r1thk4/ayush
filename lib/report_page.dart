import 'package:flutter/material.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color pranaTextColor = Color(0xFF6B5B3B);
    const Color buttonColor = Color(0xFF3A6A70);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Diet Report', style: TextStyle(color: pranaTextColor, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back button
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your personalized diet report is ready!',
                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, fontFamily: 'Montserrat', color: pranaTextColor),
                 textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                '(This is where your report details and charts will be displayed)',
                style: TextStyle(fontSize: 16, fontFamily: 'Montserrat', color: pranaTextColor),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // --- CHANGE THIS NAVIGATION ---
                  // Now navigates to the home page instead of login
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Go to Home', // Changed button text
                  style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Montserrat'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}