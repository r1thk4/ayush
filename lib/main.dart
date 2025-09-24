import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'quiz_intro_page.dart';
import 'interview_page.dart';
import 'loading_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prana App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // The app starts on the LoginPage
      home: const LoginPage(),
      // Define all the routes for easy navigation
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/quiz_intro': (context) => const QuizIntroPage(),
        '/interview': (context) => const InterviewPage(),
        '/loading': (context) => const LoadingPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}