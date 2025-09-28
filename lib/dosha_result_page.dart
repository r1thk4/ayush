import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart'; // For date formatting

class DoshaResultPage extends StatefulWidget {
  const DoshaResultPage({super.key});

  @override
  State<DoshaResultPage> createState() => _DoshaResultPageState();
}

class _DoshaResultPageState extends State<DoshaResultPage> {
  String _predictedDosha = '...'; // Default text while loading
  String _interviewDate = ''; // To store the interview date

  @override
  void initState() {
    super.initState();
    _fetchPrediction();
  }

  Future<void> _fetchPrediction() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('prakriti, updated_at') // Fetch both dosha and last update time
          .eq('id', user.id)
          .single();

      if (mounted) {
        setState(() {
          _predictedDosha = response['prakriti'] ?? 'Not found';
          // Format the date
          _interviewDate = DateFormat('dd/MM/yyyy').format(DateTime.parse(response['updated_at']));
        });
      }
    } catch (e) {
      print('Error fetching dosha prediction: $e');
      if (mounted) {
        setState(() {
          _predictedDosha = 'Error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF92C6D6),
              Color(0xFFB3C691),
              Color(0xFFE8C16E),
              Color(0xFFEAB073)
            ],
            stops: [0.0, 0.32, 0.69, 1.0],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top section with result
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Based on your last interview on $_interviewDate',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Your Predicted\nDosha Type:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    _predictedDosha,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Cinzel',
                      fontSize: 56,
                      color: pranaTextColor,
                    ),
                  ),
                ],
              ),
            ),
            // Bottom navigation buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/interview');
                  },

                  child: const Text(
                    'Retake interview',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      color: pranaTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                  },
                  child: const Text(
                    'Go home',
                    style: TextStyle(
                      fontFamily: 'Cinzel',
                      color: pranaTextColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}