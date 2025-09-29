import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for all the input fields
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
  String? _goal;
  bool _isLoading = false;

  Future<void> _signUp() async {
    // Validate all form fields before proceeding
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill out all required fields.'), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() { _isLoading = true; });

    String? goalForSupabase;
    if (_goal != null) {
      goalForSupabase = _goal!.toLowerCase().replaceAll(' ', '_');
    }
    
    try {
      await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
        data: {
          'full_name': _fullNameController.text,
          'phone': _phoneController.text,
          'age': int.tryParse(_ageController.text),
          'gender': _gender,
          'height_cm': double.tryParse(_heightController.text.replaceAll(',', '.')),
          'weight_kg': double.tryParse(_weightController.text.replaceAll(',', '.')),
          'activity_level': _activityLevel,
          'health_conditions': _healthConditionsController.text,
          'goal': goalForSupabase,
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please take our interview to get started.'),
            backgroundColor: Colors.green,
          ),
        );
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
    const backgroundColor = Color.fromARGB(255, 249, 240, 219);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Let us know a bit more...',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 79, 67, 43),
                  ),
                ),
                const SizedBox(height: 30),
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
                    Expanded(child: _buildTextFormField(controller: _heightController, label: 'Height (cm)', keyboardType: TextInputType.number)),
                  ],
                ),
                 const SizedBox(height: 16),
                _buildTextFormField(controller: _weightController, label: 'Weight (kg)', keyboardType: TextInputType.number),
                const SizedBox(height: 30),

                // --- New Toggle Chip Sections ---
                _buildToggleChipGroup(
                  title: "What's your gender?",
                  items: ['Male', 'Female', 'Other'],
                  selectedValue: _gender,
                  onSelected: (value) => setState(() => _gender = value),
                ),
                _buildToggleChipGroup(
                  title: 'What is your primary goal?',
                  items: ['Lose weight', 'Gain weight', 'Maintain weight'],
                  selectedValue: _goal,
                  onSelected: (value) => setState(() => _goal = value),
                ),
                _buildToggleChipGroup(
                  title: 'What is your activity level?',
                  items: ['Sedentary', 'Moderate', 'Active'],
                  selectedValue: _activityLevel,
                  onSelected: (value) => setState(() => _activityLevel = value),
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
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3A6A70),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continue', style: TextStyle(fontSize: 18, color: Colors.white, fontFamily: 'Montserrat')),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                        ],
                      ),
                ),
                const SizedBox(height: 40), // Padding at the bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({required TextEditingController controller, required String label, bool obscureText = false, TextInputType? keyboardType, String? Function(String?)? validator, bool isOptional = false}) {
    return TextFormField(
      controller: controller, obscureText: obscureText, keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: const Color(0xFF6B5B3B).withOpacity(0.7)),
        filled: true,
        fillColor: Color.fromARGB(255, 234, 225, 198),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF6B5B3B), width: 2),
        ),
      ),
      validator: isOptional ? null : (value) {
        if (value == null || value.isEmpty) return 'Please enter your $label';
        if (validator != null) return validator(value);
        return null;
      },
    );
  }
  
  // Helper for the new toggle chip sections
  Widget _buildToggleChipGroup({required String title, required List<String> items, required String? selectedValue, required Function(String) onSelected}) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const selectedColor = Color(0xFF3A6A70);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontFamily: 'Montserrat', color: pranaTextColor, fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: items.map((item) {
            final isSelected = selectedValue == item;
            return ChoiceChip(
              label: Text(item),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  onSelected(item);
                }
              },
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : pranaTextColor,
                fontWeight: FontWeight.bold
              ),
              backgroundColor: Color.fromARGB(255, 237, 215, 170),
              selectedColor: selectedColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            );
          }).toList(),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}