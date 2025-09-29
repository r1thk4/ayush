import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

// Helper class to hold the assets for each Dosha type
class DoshaAssets {
  final String imagePath;
  final Color backgroundColor;

  DoshaAssets({required this.imagePath, required this.backgroundColor});
}

class DoshaResultPage extends StatefulWidget {
  const DoshaResultPage({super.key});

  @override
  State<DoshaResultPage> createState() => _DoshaResultPageState();
}

class _DoshaResultPageState extends State<DoshaResultPage> {
  late final Future<Map<String, dynamic>> _predictionFuture;

  // The keys here MUST match the formatted string (e.g., "Vata-Pitta")
  final Map<String, DoshaAssets> _doshaAssetMap = {
    'Vata': DoshaAssets(imagePath: 'assets/images/vata.png', backgroundColor: const Color(0xFF82C3E7)),
    'Pitta': DoshaAssets(imagePath: 'assets/images/pitta.png', backgroundColor: const Color(0xFFE99D51)),
    'Kapha': DoshaAssets(imagePath: 'assets/images/kapha.png', backgroundColor: const Color(0xFFB6CDB0)),
    'Vata-Pitta': DoshaAssets(imagePath: 'assets/images/vata_pitta.png', backgroundColor: const Color(0xFF9B876E)),
    'Pitta-Kapha': DoshaAssets(imagePath: 'assets/images/pitta_kapha.png', backgroundColor: const Color(0xFF99BCBB)),
    'Vata-Kapha': DoshaAssets(imagePath: 'assets/images/vata_kapha.png', backgroundColor: const Color(0xFFA1947A)),
    'Default': DoshaAssets(imagePath: 'assets/images/logo_lotus.png', backgroundColor: Colors.grey.shade400),
  };

  @override
  void initState() {
    super.initState();
    _predictionFuture = _fetchPrediction();
  }

  /// Fetches the prediction and formats the dosha string correctly.
  Future<Map<String, dynamic>> _fetchPrediction() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw Exception('Not logged in');

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('prakriti, updated_at')
          .eq('id', user.id)
          .single();

      final rawDosha = response['prakriti'] as String? ?? 'Not Found';
      
      // --- THIS IS THE FIX ---
      // Format the string from "vata+pitta" to "Vata-Pitta"
      final formattedDosha = rawDosha
          .split('+')
          .map((part) => part.capitalize())
          .join('-');
      // --- END OF FIX ---

      final date = DateFormat('dd/MM/yyyy').format(DateTime.parse(response['updated_at']));
      
      return {'dosha': formattedDosha, 'date': date};
    } catch (e) {
      print('Error fetching dosha prediction: $e');
      throw Exception('Could not load your prediction.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _predictionFuture,
      builder: (context, snapshot) {
        DoshaAssets currentAssets;
        String predictedDosha = 'Loading...';
        String interviewDate = '';

        if (snapshot.connectionState == ConnectionState.done && !snapshot.hasError) {
          predictedDosha = snapshot.data!['dosha'];
          interviewDate = snapshot.data!['date'];
          currentAssets = _doshaAssetMap[predictedDosha] ?? _doshaAssetMap['Default']!;
        } else {
          currentAssets = _doshaAssetMap['Default']!;
        }

        return Scaffold(
          backgroundColor: currentAssets.backgroundColor,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  snapshot.connectionState == ConnectionState.waiting
                      ? const SizedBox()
                      : Column(
                          children: [
                            const SizedBox(height: 40),
                            Text(
                              'Based on your last interview on $interviewDate',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 24,
                                color: Colors.white,
                                decorationColor: Colors.white,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            const SizedBox(height: 30),
                            const Text(
                              'Your Predicted\nDosha Type:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                  
                  snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator(color: Colors.white))
                      : Column(
                          children: [
                            Image.asset(
                              currentAssets.imagePath,
                              height: 180,
                              width: 180,
                            ),
                            Text(
                              predictedDosha,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pushReplacementNamed(context, '/interview'),
                        child: const Text(
                          'Retake interview',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                             decorationColor: Colors.white,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                        child: const Text(
                          'Go home',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                             decorationColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper extension to capitalize strings
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}