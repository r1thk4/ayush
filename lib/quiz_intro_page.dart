import 'package:flutter/material.dart';
import 'home_page.dart'; // We need to import HomePage to show it underneath

class QuizIntroPage extends StatefulWidget {
  const QuizIntroPage({super.key});

  @override
  State<QuizIntroPage> createState() => _QuizIntroPageState();
}

class _QuizIntroPageState extends State<QuizIntroPage> {
  bool _isOverlayVisible = true;

  void _hideOverlay() {
    setState(() {
      _isOverlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const pranaTextColor = Color(0xFF6B5B3B);

    return Scaffold(
      body: Stack(
        children: [
          const HomePage(),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            top: _isOverlayVisible ? 0 : -screenHeight,
            left: 0,
            right: 0,
            height: screenHeight,
            child: GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity! < -10) {
                  _hideOverlay();
                }
              },
              child: Material( // Using Material widget for better text rendering
                color: Colors.white,
                child: Column(
                  children: [
                    // Use Expanded with a SingleChildScrollView for the main content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Use SizedBox for spacing instead of Spacer
                              SizedBox(height: screenHeight * 0.15),
                              const Column(
                                children: [
                                  Text(
                                    'AyurDiet',
                                    style: TextStyle(fontFamily: 'Cinzel', fontSize: 36, color: pranaTextColor, letterSpacing: 2.0, height: 0.8, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Ayurvedic Nutrition',
                                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: pranaTextColor, letterSpacing: 1.5, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 80),
                              const Text(
                                "Your body is unique, and your diet should be too.\nTake our quick interview to unlock your personal Ayurvedic profile, allowing us to craft a specialized diet plan that perfectly harmonizes your body and mind's needs.",
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: 18,
                                  color: pranaTextColor,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 30),
                              InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, '/interview');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Take your Test Now',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 28,
                                        letterSpacing: 1,
                                        color: pranaTextColor.withOpacity(0.9),
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, color: pranaTextColor.withOpacity(0.9)),
                                  ],
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.1), // Bottom spacing
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Bottom swipe-up indicator area
                    SizedBox(
                      height: 120,
                      child: ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          color: const Color.fromARGB(179, 234, 176, 115),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "or go to home page, swipe up",
                                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                                ),
                                Icon(Icons.keyboard_arrow_up, size: 40, color: Colors.white),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, size.height * 0.4);
    path.quadraticBezierTo(size.width / 2, 0, 0, size.height * 0.4);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}