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
  bool _isEditing = false;

  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _healthConditionsController = TextEditingController();

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
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _healthConditionsController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }

    try {
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      _fullNameController.text = response['full_name'] ?? '';
      _phoneController.text = response['phone'] ?? '';
      _emailController.text = user.email ?? '';
      _ageController.text = (response['age'] ?? '').toString();
      _heightController.text = (response['height_cm'] ?? '').toString();
      _weightController.text = (response['weight_kg'] ?? '').toString();
      _healthConditionsController.text = response['health_conditions'] ?? '';
      _gender = response['gender'];
      _activityLevel = response['activity_level'];
      _goal = response['goal']?.replaceAll('_', ' ').capitalize();

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
        setState(() { _isEditing = false; });
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
    const subtleTextColor = Color(0xFF8E8E93);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile', style: TextStyle(color: Colors.black, fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: pranaTextColor))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade200,
                          child: const Icon(Icons.person, size: 60, color: Colors.grey),
                        ),
                        if (_isEditing)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: const Icon(Icons.edit, size: 20, color: pranaTextColor),
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Image upload coming soon!')),
                                  );
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    _buildInfoCard(
                      title: 'Personal Info',
                      onEditPressed: () => setState(() => _isEditing = true),
                      child: _isEditing
                          ? _buildEditablePersonalInfo()
                          : _buildReadOnlyPersonalInfo(subtleTextColor),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoCard(
                      title: 'Health & Goal Info',
                      child: _isEditing
                          ? _buildEditableHealthInfo()
                          : _buildReadOnlyHealthInfo(subtleTextColor),
                    ),
                    const SizedBox(height: 20),
                     _buildInfoCard(
                      title: 'Account Info',
                      child: _buildReadOnlyAccountInfo(subtleTextColor),
                    ),
                    const SizedBox(height: 40),
                    if (_isEditing) _buildSaveChangesButtons(),
                    const SizedBox(height: 20), // Added padding at the bottom
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildReadOnlyPersonalInfo(Color subtleTextColor) {
    return Column(
      children: [
        _buildInfoRow(icon: Icons.person_outline, label: 'Name', value: _fullNameController.text, subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.phone_outlined, label: 'Phone Number', value: _phoneController.text, subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.cake_outlined, label: 'Age', value: _ageController.text, subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.wc_outlined, label: 'Gender', value: _gender ?? 'N/A', subtleTextColor: subtleTextColor, isLast: true),
      ],
    );
  }

  Widget _buildEditablePersonalInfo() {
    return Column(
      children: [
        const SizedBox(height: 5),
        _buildTextFormField(controller: _fullNameController, label: 'Full Name'),
        const SizedBox(height: 16),
        _buildTextFormField(controller: _phoneController, label: 'Phone Number', keyboardType: TextInputType.phone),
         const SizedBox(height: 16),
        _buildTextFormField(controller: _ageController, label: 'Age', keyboardType: TextInputType.number),
        const SizedBox(height: 16),
        _buildDropdownFormField(
          value: _gender,
          label: 'Gender',
          items: ['Male', 'Female', 'Other'],
          onChanged: (value) => setState(() => _gender = value),
        ),
      ],
    );
  }

  Widget _buildReadOnlyHealthInfo(Color subtleTextColor) {
     return Column(
      children: [
        _buildInfoRow(icon: Icons.height, label: 'Height', value: '${_heightController.text} cm', subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.monitor_weight_outlined, label: 'Weight', value: '${_weightController.text} kg', subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.directions_run, label: 'Activity Level', value: _activityLevel ?? 'N/A', subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.flag_outlined, label: 'Goal', value: _goal ?? 'N/A', subtleTextColor: subtleTextColor),
        _buildInfoRow(icon: Icons.healing_outlined, label: 'Health Conditions', value: _healthConditionsController.text, subtleTextColor: subtleTextColor, isLast: true),
      ],
    );
  }

   Widget _buildEditableHealthInfo() {
    return Column(
      children: [
        const SizedBox(height: 5),
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
        _buildDropdownFormField(
          value: _goal,
          label: 'Goal',
          items: ['Lose weight', 'Gain weight', 'Maintain weight'],
          onChanged: (value) => setState(() => _goal = value),
        ),
        const SizedBox(height: 16),
        _buildTextFormField(controller: _healthConditionsController, label: 'Health Conditions', isOptional: true),
      ],
    );
  }
  
  Widget _buildReadOnlyAccountInfo(Color subtleTextColor) {
    return Column(
      children: [
        _buildInfoRow(icon: Icons.email_outlined, label: 'E-mail', value: _emailController.text, subtleTextColor: subtleTextColor),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            'Email and password can only be changed via security settings.',
            style: TextStyle(fontSize: 12, color: subtleTextColor),
          ),
        ),
      ],
    );
  }
  
  // --- THIS IS THE CORRECTED BUTTONS WIDGET ---
  Widget _buildSaveChangesButtons() {
    const buttonColor = Color(0xFF3A6A70);
    return Row(
      // Use MainAxisAlignment.end to push buttons to the right
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: () => setState(() {
            _isEditing = false;
            _fetchProfile(); // Re-fetch to discard any changes
          }),
          style: OutlinedButton.styleFrom(
            // Add padding for better sizing
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Cancel'),
        ),
        const SizedBox(width: 16), // Space between buttons
        ElevatedButton(
          onPressed: _updateProfile,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
  
  Widget _buildInfoCard({required String title, required Widget child, VoidCallback? onEditPressed}) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (onEditPressed != null && !_isEditing)
                  TextButton(
                    onPressed: onEditPressed,
                    child: const Text('Edit', style: TextStyle(color: Color(0xFF3A6A70))),
                  ),
              ],
            ),
            const Divider(height: 20),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value, required Color subtleTextColor, bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: subtleTextColor, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: subtleTextColor)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  TextFormField _buildTextFormField({required TextEditingController controller, required String label, TextInputType? keyboardType, bool isOptional = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      validator: isOptional ? null : (value) => (value == null || value.isEmpty) ? 'This field is required' : null,
    );
  }

  DropdownButtonFormField<String> _buildDropdownFormField({required String? value, required String label, required List<String> items, required void Function(String?) onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      items: items.map((String item) => DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Please make a selection' : null,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}