import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'login_page.dart';
import 'home_page.dart'; // Make sure to import HomePage
import 'quiz_intro_page.dart';
import 'interview_page.dart';
import 'register_page.dart';
import 'report_page.dart'; // Assuming you will create this page
import 'view_profile_page.dart'; // Assuming you will create this page
import 'dosha_result_page.dart';
import 'diet_chart_interview_page.dart';
import 'diet_chart_display_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

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
      home: const LoginPage(),
      routes: {
        '/home': (context) => const HomePage(), // Ensure this route is here
        '/login': (context) => const LoginPage(),
        '/quiz_intro': (context) => const QuizIntroPage(),
        '/interview': (context) => const InterviewPage(),
        '/register': (context) => const RegisterPage(),
        '/report': (context) => const ReportPage(), // New route
        '/view_profile': (context) => const ViewProfilePage(), // New route
        '/dosha_result': (context) => const DoshaResultPage(),
        '/diet_chart_interview': (context) => const DietChartInterviewPage(), // <-- ADD THIS
        '/diet_chart_display': (context) => const DietChartDisplayPage()
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
