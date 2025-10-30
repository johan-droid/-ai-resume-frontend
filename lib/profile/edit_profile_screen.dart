// lib/profile/edit_profile_screen.dart

import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Controllers to make the text fields editable
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _jobController;

  @override
  void initState() {
    super.initState();
    // Load the (dummy) data into the controllers
    _nameController = TextEditingController(text: 'John Doe');
    _phoneController = TextEditingController(text: '+91 98765 43210');
    _jobController =
        TextEditingController(text: 'Driver'); // From our chat flow
  }

  @override
  void dispose() {
    // Clean up the controllers
    _nameController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          // A "Save" button in the app bar
          IconButton(
            icon: const Icon(Icons.check_rounded),
            tooltip: 'Save',
            onPressed: () async {
              // Validate and save the data
              if (_nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter your name')),
                );
                return;
              }

              // Show a loading indicator
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              try {
                // TODO: Replace with actual API call to save the profile
                // For now, we'll just simulate a network delay
                await Future.delayed(const Duration(milliseconds: 500));

                // Show success message
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Profile updated successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Navigate back with the updated data
                navigator.pop({
                  'name': _nameController.text.trim(),
                  'phone': _phoneController.text.trim(),
                  'job': _jobController.text.trim(),
                });
              } catch (e) {
                // Show error message
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text('Failed to update profile: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar to match the profile screen
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue[50],
              child: const Text(
                'J', // Placeholder initial
                style: TextStyle(fontSize: 48, color: Color(0xFF007BFF)),
              ),
            ),
            const SizedBox(height: 30),

            // Re-using our helper widget for clean text fields
            _buildEditField(
              controller: _nameController,
              label: 'Full Name',
              icon: Icons.person_outline_rounded,
            ),
            _buildEditField(
              controller: _phoneController,
              label: 'Phone Number',
              icon: Icons.phone_outlined,
            ),
            _buildEditField(
              controller: _jobController,
              label: 'Job Description',
              icon: Icons.work_outline_rounded,
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for the text fields
  Widget _buildEditField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none, // Clean look
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF007BFF), width: 2),
          ),
        ),
      ),
    );
  }
}
