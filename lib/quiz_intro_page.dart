import 'package:flutter/material.dart';
import 'home_page.dart'; // We need to import HomePage to show it underneath

class QuizIntroPage extends StatefulWidget {
  const QuizIntroPage({super.key});

  @override
  State<QuizIntroPage> createState() => _QuizIntroPageState();
}

class _QuizIntroPageState extends State<QuizIntroPage> {
  // State to control the visibility and position of the overlay
  bool _isOverlayVisible = true;

  void _hideOverlay() {
    setState(() {
      _isOverlayVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for the animation
    final screenHeight = MediaQuery.of(context).size.height;
    const pranaTextColor = Color(0xFF6B5B3B);

    return Scaffold(
      // Use a Stack to layer the homepage and the overlay
      body: Stack(
        children: [
          // 1. The Homepage (always in the background)
          const HomePage(),

          // 2. The Animated Overlay
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            // Animate the 'top' property to slide the overlay up
            top: _isOverlayVisible ? 0 : -screenHeight,
            left: 0,
            right: 0,
            height: screenHeight,
            child: GestureDetector(
              // Detect the swipe-up gesture
              onVerticalDragEnd: (details) {
                // Check for a swipe up (negative velocity)
                if (details.primaryVelocity! < -10) {
                  _hideOverlay();
                }
              },
              child: Container(
                color: const Color(0xFFFFFFFF), // Background color of the overlay
                child: Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(flex: 2),
                            // PRANA Logo Text
                            const Column(
                              children: [
                                Text(
                                  'Prana',
                                  style: TextStyle(fontFamily: 'Cinzel', fontSize: 42, color: pranaTextColor, letterSpacing: 2.0, height: 0.8, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Ayurvedic Nutrition',
                                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 14, color: pranaTextColor, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const Spacer(flex: 1),
                            // Introduction Text
                             const Text(
                              "Your body is unique, and your diet should be too.\n Take our quick interview to unlock your personal Ayurvedic profile, allowing us to craft a specialized diet plan that perfectly harmonizes your body and mind's needs.",
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18,
                                color: pranaTextColor,
                                height: 1.5,
                                fontWeight: FontWeight.w900
                              ),
                            ),
                            const SizedBox(height: 30),
                            // "Take your Test Now" Link
                            InkWell(
                              onTap: () {
                                // Navigate to the interview page
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
                                      letterSpacing: 2,
                                      foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 4 // Adjust this value (e.g., 0.5, 1.0, 1.5) for more thickness
                                          ..color = pranaTextColor,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.arrow_forward, color: pranaTextColor.withOpacity(0.9)),
                                ],
                              ),
                            ),
                            const Spacer(flex: 2),
                          ],
                        ),
                      ),
                    ),
                    // Bottom swipe-up indicator area
                    SizedBox(
                      height: 120, // Height for the curved area
                      child: ClipPath(
                        clipper: BottomWaveClipper(),
                        child: Container(
                          color: const Color.fromARGB(179, 234, 176, 115), // Color of the curved shape
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "or go to home page, swipe up",
                                  style: TextStyle(fontFamily: 'Montserrat', color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900),
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

// Custom Clipper to create the curved bottom shape
// Custom Clipper to create the curved bottom shape
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height); // Start at bottom-left
    path.lineTo(size.width, size.height); // Line to bottom-right (flat bottom)
    path.lineTo(size.width, size.height * 0.4); // Line up the right side

    // The control point's y-value is 0, creating a crest (upward curve)
    path.quadraticBezierTo(
        size.width / 2, // Control point X (horizontal center)
        0,              // Control point Y (top edge)
        0,              // End point X (left side)
        size.height * 0.4); // End point Y

    path.close(); // This will connect back to the starting point (bottom-left)
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}