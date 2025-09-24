import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import dart:convert for JSON encoding

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // This function now sends the login request to a backend
  void _login() async {
    if (_formKey.currentState!.validate()) {
      final String username = _usernameController.text;
      final String password = _passwordController.text;

      // 1. Define your backend API endpoint for login
      final url = Uri.parse('https://your-backend-api.com/login'); // <-- IMPORTANT: Replace with your actual URL

      // 2. Create the request body and encode it to JSON
      final body = json.encode({
        'username': username,
        'password': password,
      });

      try {
        // 3. Send the data as an HTTP POST request
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        // 4. Check the server's response
        if (response.statusCode == 200 && mounted) {
          // HTTP 200 means success
          print('Login successful!');
          Navigator.pushReplacementNamed(context, '/quiz_intro');
        } else {
          // If the server returns an error (e.g., 401 Unauthorized), show an error
          print('Login failed. Status code: ${response.statusCode}');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invalid username or password'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        // Handle potential network errors
        print('An error occurred: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred. Please check your connection.'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
              0.0,
              0.32,
              0.69,
              1.0,
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
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: cardBackgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/images/logo_lotus.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
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

