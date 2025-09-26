import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewProfilePage extends StatefulWidget {
  const ViewProfilePage({super.key});

  @override
  State<ViewProfilePage> createState() => _ViewProfilePageState();
}

class _ViewProfilePageState extends State<ViewProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isEditing = false; // Controls the view/edit state

  // Controllers for all the input fields
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthConditionsController = TextEditingController();

  // State variables for dropdowns
  String? _gender;
  String? _activityLevel;
  String? _goal;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    // Dispose all controllers to prevent memory leaks
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _healthConditionsController.dispose();
    super.dispose();
  }

  /// Fetches the user profile data from Supabase and populates the form fields.
  Future<void> _fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      // Populate the controllers and state variables with the fetched data
      _fullNameController.text = response['full_name'] ?? '';
      _phoneController.text = response['phone'] ?? '';
      _emailController.text = user.email ?? ''; // Email comes from the auth user
      _ageController.text = (response['age'] ?? '').toString();
      _heightController.text = (response['height_cm'] ?? '').toString();
      _weightController.text = (response['weight_kg'] ?? '').toString();
      _healthConditionsController.text = response['health_conditions'] ?? '';
      _gender = response['gender'];
      _activityLevel = response['activity_level'];
      _goal = response['goal']?.replaceAll('_', ' ')?.capitalize();

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching profile data.'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  /// Saves the updated profile data to Supabase.
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() { _isLoading = true; });

    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    try {
      await Supabase.instance.client.from('profiles').update({
        'full_name': _fullNameController.text,
        'phone': _phoneController.text,
        'age': int.tryParse(_ageController.text),
        'gender': _gender,
        'height_cm': double.tryParse(_heightController.text.replaceAll(',', '.')),
        'weight_kg': double.tryParse(_weightController.text.replaceAll(',', '.')),
        'activity_level': _activityLevel,
        'health_conditions': _healthConditionsController.text,
        'goal': _goal?.toLowerCase().replaceAll(' ', '_'),
      }).eq('id', user.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!'), backgroundColor: Colors.green),
        );
        setState(() { _isEditing = false; }); // Switch back to view mode
      }
    } catch (e) {
       if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error updating profile.'), backgroundColor: Colors.red),
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
        title: Text(_isEditing ? 'Edit Profile' : 'View Profile', style: const TextStyle(color: pranaTextColor, fontFamily: 'Montserrat')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: pranaTextColor),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: pranaTextColor))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextFormField(controller: _fullNameController, label: 'Full Name', enabled: _isEditing),
                      const SizedBox(height: 16),
                      _buildTextFormField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone, enabled: _isEditing),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextFormField(controller: _ageController, label: 'Age', keyboardType: TextInputType.number, enabled: _isEditing)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDropdownFormField(
                              value: _gender,
                              label: 'Gender',
                              items: ['Male', 'Female', 'Other'],
                              onChanged: (value) => setState(() => _gender = value),
                              enabled: _isEditing,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildTextFormField(controller: _heightController, label: 'Height (cm)', keyboardType: TextInputType.number, enabled: _isEditing)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextFormField(controller: _weightController, label: 'Weight (kg)', keyboardType: TextInputType.number, enabled: _isEditing)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownFormField(
                        value: _goal,
                        label: 'Goal',
                        items: ['Lose weight', 'Gain weight', 'Maintain weight'],
                        onChanged: (value) => setState(() => _goal = value),
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      _buildDropdownFormField(
                        value: _activityLevel,
                        label: 'Activity Level',
                        items: ['Sedentary', 'Moderate', 'Active'],
                        onChanged: (value) => setState(() => _activityLevel = value),
                        enabled: _isEditing,
                      ),
                      const SizedBox(height: 16),
                      _buildTextFormField(controller: _healthConditionsController, label: 'Health Conditions', isOptional: true, enabled: _isEditing),
                      const SizedBox(height: 30),

                      // --- Secure Fields Section ---
                       _buildSecureFieldsInfo(),
                      const SizedBox(height: 30),

                      // --- Action Buttons ---
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  /// Builds the action buttons based on whether the user is in "edit" or "view" mode.
  Widget _buildActionButtons() {
    const buttonColor = Color(0xFF3A6A70);

    if (_isEditing) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _isEditing = false),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _updateProfile,
              style: ElevatedButton.styleFrom(backgroundColor: buttonColor, padding: const EdgeInsets.symmetric(vertical: 16)),
              child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           ElevatedButton(
            onPressed: () => setState(() => _isEditing = true),
            style: ElevatedButton.styleFrom(backgroundColor: buttonColor, padding: const EdgeInsets.symmetric(vertical: 16)),
            child: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
             onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
            child: const Text('Go to Home'),
          ),
        ],
      );
    }
  }

  /// Builds an informational section for secure fields that require special handling.
  Widget _buildSecureFieldsInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Security Information',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey.shade700),
          ),
          const SizedBox(height: 8),
          _buildTextFormField(controller: _emailController, label: 'Email', enabled: false), // Always disabled
          const SizedBox(height: 10),
          Text(
            'To update your email or password, please use the "Forgot Password" feature on the login screen or contact support.',
             style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // Helper methods for building form fields with an 'enabled' state
  TextFormField _buildTextFormField({required TextEditingController controller, required String label, bool enabled = true, TextInputType? keyboardType, bool isOptional = false}) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: isOptional ? null : (value) => (value == null || value.isEmpty) ? 'This field is required' : null,
    );
  }

  DropdownButtonFormField<String> _buildDropdownFormField({required String? value, required String label, required List<String> items, required void Function(String?) onChanged, bool enabled = true}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: enabled ? Colors.white : Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
      onChanged: enabled ? onChanged : null,
      validator: (value) => value == null ? 'Please make a selection' : null,
    );
  }
}

// Helper extension for string capitalization, if not already defined elsewhere
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}