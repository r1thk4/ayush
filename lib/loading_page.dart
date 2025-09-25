import 'dart:async';
import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  int _currentImageIndex = 0;
  Timer? _imageCycleTimer;
  final int _totalImages = 5;
  final int _imageDurationMs = 900;

  @override
  void initState() {
    super.initState();

    _imageCycleTimer = Timer.periodic(Duration(milliseconds: _imageDurationMs), (timer) {
      if (mounted) {
        setState(() {
          _currentImageIndex = (_currentImageIndex + 1) % _totalImages;
        });
      }
    });

    final totalLoadingTimeMs = _totalImages * _imageDurationMs;
    Future.delayed(Duration(milliseconds: totalLoadingTimeMs), () {
      if (mounted) {
        // --- CHANGE THIS LINE ---
        // After loading, go to the Report page
        Navigator.pushReplacementNamed(context, '/report');
      }
    });
  }

  @override
  void dispose() {
    _imageCycleTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color pranaTextColor = Color(0xFF6B5B3B);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: Image.asset(
                'assets/images/loader_${_currentImageIndex + 1}.png',
                key: ValueKey<int>(_currentImageIndex),
                width: 180,
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

