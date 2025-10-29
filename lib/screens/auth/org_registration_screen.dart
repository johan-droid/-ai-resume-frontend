// lib/screens/auth/org_registration_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
// Import the new verification screen
import 'package:rezume_app/screens/auth/email_verification_screen.dart';
import 'package:rezume_app/utils/color_extensions.dart';

class OrgRegistrationScreen extends StatefulWidget {
  const OrgRegistrationScreen({super.key});

  @override
  State<OrgRegistrationScreen> createState() => _OrgRegistrationScreenState();
}

class _OrgRegistrationScreenState extends State<OrgRegistrationScreen> {
  // --- Form controllers and state variables ---
  final _formKey = GlobalKey<FormState>();
  final _orgNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // --- Theme Colors (Indigo for Org) ---
  final Color _primaryColor = Colors.indigo.shade600; // New Indigo
  final Color _backgroundColor = Colors.indigo.shade50; // New Light Indigo

  @override
  void dispose() {
    _orgNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // --- Registration Logic ---
  void _registerOrg() {
    if (_formKey.currentState!.validate()) {
      if (kDebugMode) {
        debugPrint('Organization Registration Submitted!');
      }
      // Navigate to Email Verification Screen, passing the email
      Navigator.pushReplacement(
        // Use pushReplacement to remove this screen
        context,
        MaterialPageRoute(
          builder: (context) => EmailVerificationScreen(
            email: _emailController.text,
            themeColor: _primaryColor, // Pass the indigo theme color
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all mandatory fields')),
      );
    }
  }

  // --- Label helper with red star ---
  Widget _buildMandatoryLabel(String title) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: _backgroundColor, // Use light indigo background
      body: Stack(
        children: [
          // --- Background ---
          Column(
            children: [
              Container(
                height: screenHeight * 0.30,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: _primaryColor, // Use indigo
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 80.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.business_rounded,
                          color: Colors.white.withOpacityCompat(0.9), size: 50),
                      SizedBox(height: 10),
                      Text('Organization Details',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container(color: _backgroundColor)),
            ],
          ),
          // --- Form Card ---
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.22, left: 24, right: 24, bottom: 24),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildMandatoryLabel('Organization Name'),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _orgNameController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.business_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          validator: (v) =>
                              v!.isEmpty ? 'Name cannot be empty' : null,
                        ),
                        SizedBox(height: 16),
                        _buildMandatoryLabel('Organization\'s Email'),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.email_outlined),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter email address';
                            }
                            if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        _buildMandatoryLabel('Set Password'),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          validator: (v) =>
                              v!.length < 6 ? 'Password is too short' : null,
                        ),
                        SizedBox(height: 16),
                        _buildMandatoryLabel('Confirm Password'),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          validator: (v) => v != _passwordController.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: _registerOrg,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor, // Use indigo
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            textStyle: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          child: Text('REGISTER'),
                        ),
                        SizedBox(height: 16),
                        Center(
                            child: Text('* Mandatory',
                                style: TextStyle(color: Colors.red))),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
