import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'User';
  String? _userEmail;
  String _predictedDosha = '...';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      _userEmail = user.email;
      try {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('full_name, prakriti')
            .eq('id', user.id)
            .single();

        if (mounted) {
          setState(() {
            _userName = response['full_name'] ?? 'User';
            _predictedDosha = response['prakriti'] ?? 'Take Interview';
          });
        }
      } catch (e) {
        print('Error fetching user profile: $e');
        if (mounted) {
          setState(() {
            _predictedDosha = 'Take Interview';
          });
        }
      }
    }
  }

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const headerColor = Color(0xFFB3C691);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildHeader(context, headerColor, pranaTextColor),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How can we help?',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: pranaTextColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // --- UPDATED ACTION TILES WITH IMAGES ---
                    _buildActionTile(
                      imagePath: 'assets/images/home_1.png', // Using your image
                      title: 'Generate Diet Chart',
                      subtitle: 'Get a diet plan based on your preferences.',
                      onTap: () { Navigator.pushNamed(context, '/diet_chart_display'); },
                    ),
                    _buildActionTile(
                      imagePath: 'assets/images/home_2.png', // Using your image
                      title: 'Take Interview',
                      subtitle: 'Answer a few questions to determine your Dosha.',
                      onTap: () { Navigator.pushNamed(context, '/interview'); },
                    ),
                    _buildActionTile(
                      imagePath: 'assets/images/home_3.png', // Using a placeholder
                      title: 'My Ayurvedic Report',
                      subtitle: 'Tap to view your report.',
                      onTap: () { /* Navigator.pushNamed(context, '/doctor_report'); */ },
                    ),
                    _buildActionTile(
                    imagePath: 'assets/images/home_4.png',
                    title: 'Consult a Doctor', // <-- Updated
                    subtitle: 'Find and book appointments with Ayurvedic experts.', // <-- Updated
                    onTap: () { /* Navigator.pushNamed(context, '/find_doctors'); */ },
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

  Widget _buildHeader(BuildContext context, Color headerColor, Color pranaTextColor) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/dosha_result');
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: double.infinity,
        decoration: BoxDecoration(color: headerColor),
        child: Stack(
          children: [
            const _DoshaCardBackground(),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 30),
                      const Text(
                        'Hello,',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _userName.split(' ').first,
                        style: const TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Your Dosha: $_predictedDosha',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'profile') {
                        Navigator.pushNamed(context, '/view_profile');
                      } else if (value == 'logout') {
                        _logout();
                      }
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'profile',
                        child: Center(
                          child: Text(
                            'View profile',
                            style: TextStyle(fontFamily: 'Montserrat', color: pranaTextColor),
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Logout', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                      ),
                      child: const Icon(Icons.person_outline, size: 30, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- UPDATED HELPER WIDGET TO USE IMAGES ---
  Widget _buildActionTile({
    required String imagePath, // Changed from IconData
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    const pranaTextColor = Color(0xFF6B5B3B);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        leading: CircleAvatar(
          radius: 24,
          backgroundImage: AssetImage(imagePath), // Use the image path here
          backgroundColor: Colors.transparent, // Avoid default color if image is transparent
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            color: pranaTextColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontFamily: 'Montserrat',
            color: pranaTextColor.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w500
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}

// Animated Bubble Background Widget
class _DoshaCardBackground extends StatefulWidget {
  const _DoshaCardBackground();
  @override
  State<_DoshaCardBackground> createState() => _DoshaCardBackgroundState();
}

class _DoshaCardBackgroundState extends State<_DoshaCardBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Bubble> _bubbles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25),
    )..repeat();

    _bubbles = List.generate(15, (index) {
      return Bubble(
        startPosition: Offset(_random.nextDouble(), _random.nextDouble() + 1.0),
        radius: _random.nextDouble() * 15 + 10,
        speed: _random.nextDouble() * 0.2 + 0.1,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(_bubbles, _controller),
      child: Container(),
    );
  }
}

class Bubble {
  final Offset startPosition;
  final double radius;
  final double speed;
  Bubble({required this.startPosition, required this.radius, required this.speed});
}

class BubblePainter extends CustomPainter {
  final List<Bubble> bubbles;
  final Animation<double> animation;
  BubblePainter(this.bubbles, this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.15);

    for (var bubble in bubbles) {
      final currentY = (bubble.startPosition.dy - (animation.value * bubble.speed)) % 1.5;
      final position = Offset(bubble.startPosition.dx * size.width, currentY * size.height - (size.height * 0.5));
      canvas.drawCircle(position, bubble.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}