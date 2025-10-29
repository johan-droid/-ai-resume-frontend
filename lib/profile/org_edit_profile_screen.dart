// lib/profile/org_edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:rezume_app/utils/color_extensions.dart';

class OrgEditProfileScreen extends StatefulWidget {
  final String orgName;
  final String orgEmail;
  final Color themeColor;
  final Function(String, String)? onProfileUpdated;

  const OrgEditProfileScreen({
    super.key,
    required this.orgName,
    required this.orgEmail,
    required this.themeColor,
    this.onProfileUpdated,
  });

  @override
  State<OrgEditProfileScreen> createState() => _OrgEditProfileScreenState();
}

class _OrgEditProfileScreenState extends State<OrgEditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  bool _hasNewImage = false; // Dummy for image picking

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.orgName);
    _emailController = TextEditingController(text: widget.orgEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Call the callback to update profile
      widget.onProfileUpdated
          ?.call(_nameController.text, _emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Organization Profile'),
        backgroundColor: widget.themeColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // --- Photo Upload ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: widget.themeColor.withOpacityCompat(0.1),
                    child: _hasNewImage
                        ? Icon(Icons.business_center_outlined,
                            size: 50, color: widget.themeColor)
                        : Text(
                            _nameController.text.isNotEmpty
                                ? _nameController.text
                                    .substring(0, 1)
                                    .toUpperCase()
                                : '?',
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: widget.themeColor),
                          ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _hasNewImage = !_hasNewImage;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(_hasNewImage
                                  ? 'Image Selected (Dummy)'
                                  : 'Image Removed (Dummy)')),
                        );
                      },
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: widget.themeColor,
                        child: Icon(Icons.camera_alt,
                            color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Organization Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Organization Name',
                  prefixIcon:
                      Icon(Icons.business_rounded, color: widget.themeColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.themeColor, width: 2),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Organization name cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Organization Email',
                  prefixIcon:
                      Icon(Icons.email_outlined, color: widget.themeColor),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: widget.themeColor, width: 2),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email cannot be empty';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.themeColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  textStyle: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
