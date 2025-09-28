import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
            _predictedDosha = response['prakriti'] ?? 'None';
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
    const backgroundColor = Color(0xFFF3F3ED);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Hi, ${_userName.split(' ').first}!',
          style: const TextStyle(
            fontFamily: 'Cinzel',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: pranaTextColor,
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.person_outline, size: 30, color: pranaTextColor),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              tooltip: 'Profile Menu',
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(_userName, style: const TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
              accountEmail: Text(_userEmail ?? '', style: const TextStyle(fontFamily: 'Montserrat')),
              decoration: const BoxDecoration(color: pranaTextColor),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('View Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/view_profile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(24.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  // --- WRAPPED THIS CARD WITH GESTUREDETECTOR ---
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/dosha_result');
                    },
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black.withOpacity(0.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEAB073), Color(0xFFF2B176)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Your Primary Dosha',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              _predictedDosha,
                              style: const TextStyle(
                                fontFamily: 'Cinzel',
                                color: Color.fromARGB(255, 82, 70, 45),
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'This represents your core constitution. All diet recommendations are based on this profile.',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.4,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Your Tools',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: pranaTextColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Action Buttons
                  _buildActionTile(
                    icon: Icons.assignment_outlined,
                    title: 'View Full Report',
                    subtitle: 'See your detailed diet chart and analysis.',
                    onTap: () => Navigator.pushNamed(context, '/report'),
                    iconColor: const Color(0xFF3A6A70),
                  ),
                  _buildActionTile(
                    icon: Icons.replay_outlined,
                    title: 'Retake Interview',
                    subtitle: 'Update your profile if your lifestyle has changed.',
                    onTap: () => Navigator.pushNamed(context, '/interview'),
                    iconColor: const Color(0xFFE5D57B),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper widget for creating the tappable action tiles
  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color iconColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B5B3B),
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            color: Color(0xFF6B5B3B),
            fontWeight: FontWeight.w800,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}