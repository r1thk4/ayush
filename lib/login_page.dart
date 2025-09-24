import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      if (username == 'testuser' && password == 'password123') {
        // If login is successful, navigate to the new Quiz Intro Page.
        // --- CHANGE THIS LINE ---
          Navigator.pushReplacementNamed(context, '/quiz_intro');
        } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid username or password'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color cardBackgroundColor = Color(0xFFF3F3ED);
    const Color textFieldBorderColor = Color(0xFFD2B48C);
    const Color focusedTextFieldBorderColor = Color.fromARGB(255, 134, 114, 89);
    const Color buttonColor = Color(0xFF3A6A70);
    const Color pranaTextColor = Color(0xFF6B5B3B);
    
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF92C6D6), // Light sky blue
              Color(0xFFB3C691), // Greenish
              Color(0xFFE8C16E), // Soft yellow
              Color(0xFFEAB073) // Warm orange
            ],
            stops: [
              0.0,  // Blue starts at the beginning
              0.32,  // Green starts 20% of the way down
              0.69,  // Orange starts 80% of the way down
              1.0,  // Purple is at the very end
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: screenHeight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Spacer(flex: 2),

                    // --- THIS IS THE UPDATED PART ---
                    Container(
                      padding: const EdgeInsets.all(4), // Optional padding for the background
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(20), // This creates the outer rounded shape
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0), // This clips the image inside
                        child: Image.asset(
                          'assets/images/logo_lotus.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // --- END OF UPDATED PART ---

                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Column(
                              children: [
                                Text(
                                  'Prana',
                                  style: TextStyle(
                                    fontFamily: 'Cinzel',
                                    fontSize: 48,
                                    color: pranaTextColor,
                                    letterSpacing: 1.0,
                                    height: 1.2
                                  ),
                                ),
                                Text(
                                  'Ayurvedic Nutrition',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontSize: 14,
                                    color: pranaTextColor,
                                    letterSpacing: 1.5,
                                    height: 0.1,
                                    fontWeight: FontWeight.w700
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                hintText: 'Username',
                                filled: true,
                                fillColor: Color(0X57F2E6D1),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(color: textFieldBorderColor, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(color: focusedTextFieldBorderColor, width: 2.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your username';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                fillColor: Color(0X57F2E6D1),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(color: textFieldBorderColor, width: 1.5),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(color: focusedTextFieldBorderColor, width: 2.0),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: buttonColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

