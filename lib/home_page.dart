import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
  }

  Future<void> _fetchUserName() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      try {
        final response = await Supabase.instance.client
            .from('profiles')
            .select('full_name')
            .eq('id', user.id)
            .single();

        if (response['full_name'] != null) {
          setState(() {
            _userName = response['full_name'];
          });
        }
      } catch (e) {
        print('Error fetching user name: $e');
      }
    }
  }

  Future<void> _logout() async {
    try {
      await Supabase.instance.client.auth.signOut();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const backgroundColor = Color(0xFFF3F3ED);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- THIS TOP ROW IS UPDATED ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hi, ${_userName.split(' ').first}!',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: pranaTextColor,
                    ),
                  ),
                  // Use PopupMenuButton for the dialog
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'profile') {
                        Navigator.pushNamed(context, '/view_profile');
                      } else if (value == 'logout') {
                        _logout();
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      // "View profile" item
                      const PopupMenuItem<String>( 
                        value: 'profile',
                        child: Center(
                          child: Text(
                            'View profile',
                            style: TextStyle(fontFamily: 'Montserrat', color: pranaTextColor, fontWeight: FontWeight.w900),
                          ),
                        ),
                      ),
                      // "Logout" item with custom styling
                      PopupMenuItem<String>(
                        value: 'logout',
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _logout,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text('Logout', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                    // The icon that triggers the popup
                    child: const Icon(
                      Icons.person_outline,
                      size: 35, // Restored icon size
                      color: pranaTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              _buildFeatureCard(
                context,
                imagePath: 'assets/images/home_1.png',
                title: 'Report',
                description:
                    'Tap here to discover the curated diet chart designed to bring your body and mind into perfect balance and begin your journey to wellness.',
                cardColor: const Color(0xFFF2B176),
                onTap: () {
                  Navigator.pushNamed(context, '/report');
                },
              ),
              const SizedBox(height: 24),
              _buildFeatureCard(
                context,
                imagePath: 'assets/images/home_2.png',
                title: 'Interview',
                description:
                    'Has your lifestyle or health recently changed? Retake our quick interview to recalibrate your Ayurvedic profile, ensuring your diet plan remains perfectly aligned with your current body and mind\'s needs.',
                cardColor: const Color(0xFFE8C16E),
                onTap: () {
                  Navigator.pushNamed(context, '/interview');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String imagePath,
    required String title,
    required String description,
    required Color cardColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 5,
        shadowColor: Colors.black.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      imagePath,
                      height: 80,
                      width: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 3,
                child: Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}