import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'quiz_intro_page.dart';
import 'interview_page.dart';
import 'loading_page.dart';
import 'register_page.dart'; // <-- Import the new page
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 2. Load the .env file
  await dotenv.load(fileName: ".env");

  // 3. Initialize Supabase with the variables
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
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/quiz_intro': (context) => const QuizIntroPage(),
        '/interview': (context) => const InterviewPage(),
        '/loading': (context) => const LoadingPage(),
        '/register': (context) => const RegisterPage(), // <-- Add the new route
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

