import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthConditionsController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _gender;
  String? _activityLevel;
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() { _isLoading = true; });

    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {
          'full_name': _fullNameController.text,
          'phone': _phoneController.text,
          'age': int.tryParse(_ageController.text),
          'gender': _gender,
          'height_cm': double.tryParse(_heightController.text),
          'weight_kg': double.tryParse(_weightController.text),
          'activity_level': _activityLevel,
          'health_conditions': _healthConditionsController.text,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please take our interview to get started.'),
            backgroundColor: Colors.green,
          ),
        );
        // --- CHANGE THIS LINE ---
        // For new users, go to the Quiz Intro page to start the interview
        Navigator.pushReplacementNamed(context, '/quiz_intro');
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3ED),
      appBar: AppBar(
        title: const Text('Create Account', style: TextStyle(color: pranaTextColor, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextFormField(controller: _fullNameController, label: 'Full Name'),
                const SizedBox(height: 16),
                _buildTextFormField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone),
                const SizedBox(height: 16),
                _buildTextFormField(controller: _emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildTextFormField(controller: _ageController, label: 'Age', keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownFormField(
                        value: _gender,
                        label: 'Gender',
                        items: ['Male', 'Female', 'Other'],
                        onChanged: (value) => setState(() => _gender = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                 Row(
                  children: [
                    Expanded(child: _buildTextFormField(controller: _heightController, label: 'Height (cm)', keyboardType: TextInputType.number)),
                    const SizedBox(width: 16),
                     Expanded(child: _buildTextFormField(controller: _weightController, label: 'Weight (kg)', keyboardType: TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDropdownFormField(
                  value: _activityLevel,
                  label: 'Activity Level',
                  items: ['Sedentary', 'Moderate', 'Active'],
                  onChanged: (value) => setState(() => _activityLevel = value),
                ),
                const SizedBox(height: 16),
                _buildTextFormField(controller: _healthConditionsController, label: 'Health Conditions (optional)', isOptional: true),
                const SizedBox(height: 16),
                _buildTextFormField(
                  controller: _passwordController,
                  label: 'Password',
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.length < 8) return 'Password must be at least 8 characters';
                    if (!value.contains(RegExp(r'[A-Z]'))) return 'Must contain an uppercase letter';
                    if (!value.contains(RegExp(r'[0-9]'))) return 'Must contain a number';
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6A70),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Sign Up', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Montserrat')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({required TextEditingController controller, required String label, bool obscureText = false, TextInputType? keyboardType, String? Function(String?)? validator, bool isOptional = false}) {
    return TextFormField(
      controller: controller, obscureText: obscureText, keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label, filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD2B48C))),
      ),
      validator: isOptional ? null : (value) {
        if (value == null || value.isEmpty) return 'Please enter your $label';
        if (validator != null) return validator(value);
        return null;
      },
    );
  }

  DropdownButtonFormField<String> _buildDropdownFormField({required String? value, required String label, required List<String> items, required void Function(String?) onChanged}) {
     return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label, filled: true, fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFD2B48C))),
      ),
      items: items.map((String value) => DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please select your $label' : null,
    );
  }
}

