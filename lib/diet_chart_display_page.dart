import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DietChartDisplayPage extends StatefulWidget {
  const DietChartDisplayPage({super.key});

  @override
  State<DietChartDisplayPage> createState() => _DietChartDisplayPageState();
}

class _DietChartDisplayPageState extends State<DietChartDisplayPage> {
  // Use a Future to handle the asynchronous data fetching
  late final Future<bool> _hasDietChartDataFuture;

  @override
  void initState() {
    super.initState();
    _hasDietChartDataFuture = _checkForDietChartData();
  }

  /// Checks if the current user has existing diet chart data in their profile.
  Future<bool> _checkForDietChartData() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select('diet_chart_data')
          .eq('id', user.id)
          .single();

      // Return true if the diet_chart_data is not null and not empty
      return response['diet_chart_data'] != null;
    } catch (e) {
      print('Error checking for diet chart data: $e');
      return false; // Assume no data if there's an error
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF92C6D6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Diet Chart Display', style: TextStyle(color: Colors.white, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<bool>(
        future: _hasDietChartDataFuture,
        builder: (context, snapshot) {
          // Show a loading indicator while checking for data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          // Check the result of the future
          final hasData = snapshot.data ?? false;

          if (hasData) {
            // If data exists, show the placeholder for the diet chart
            return _buildDietChartExistsView(context);
          } else {
            // If no data exists, show the prompt to take the quiz
            return _buildNoDataView(context);
          }
        },
      ),
    );
  }

  /// The UI to show when the user has NOT generated a diet chart yet.
  Widget _buildNoDataView(BuildContext context) {
    const textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 60),
            const Text(
              "Looks like you haven't taken our quiz yet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Take this short quiz to get a personalized diet chart for you',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: textColor,
                fontSize: 28,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/diet_chart_interview');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3A6A70),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Take your Quiz', style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go home', style: TextStyle(color: textColor)),
            ),
          ],
        ),
      ),
    );
  }

  /// The UI to show when the user HAS generated a diet chart.
  Widget _buildDietChartExistsView(BuildContext context) {
     const textColor = Colors.white;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Text(
                  'Your personalized diet chart will be displayed here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 20, fontFamily: 'Montserrat'),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/diet_chart_interview');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3A6A70),
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Generate a New Diet Chart', style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}