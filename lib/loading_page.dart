import 'package:flutter/material.dart'; 
import 'dart:async';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  int _currentImageIndex = 0;
  Timer? _imageCycleTimer;
  final int _totalImages = 5;
  final int _imageDurationMs = 900; // Each image will show for 0.9 seconds

  @override
  void initState() {
    super.initState();

    // This timer cycles through the images
    _imageCycleTimer = Timer.periodic(Duration(milliseconds: _imageDurationMs), (timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _totalImages;
        });
      }
    });

    // This timer navigates to the home page after the full animation cycle
    final totalLoadingTimeMs = _totalImages * _imageDurationMs;
    Future.delayed(Duration(milliseconds: totalLoadingTimeMs), () {
      if (mounted) { // Check if the widget is still active before navigating
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  @override
  void dispose() {
    _imageCycleTimer?.cancel(); // Important: cancel the timer to prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color pranaTextColor = Color(0xFF6B5B3B);

    return Scaffold(
      backgroundColor: Colors.white, // Set the background to white
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedSwitcher provides a smooth fade transition between images
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400), // Fade duration
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Image.asset(
                // Dynamically builds the image path, e.g., 'assets/images/loader_1.jpg'
                './assets/images/loader_${_currentImageIndex + 1}.png',
                // The key is crucial for AnimatedSwitcher to detect a change
                key: ValueKey<int>(_currentImageIndex),
                width: 180, // Adjust size as needed
                height: 180,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Generating your personalized report...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Montserrat',
                color: pranaTextColor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}