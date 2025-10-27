import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezume_app/providers/language_provider.dart';
import 'package:rezume_app/screens/auth/login_screen.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  // State variables for dropdown
  String? _selectedOtherLanguage; // Holds the selection from dropdown (null initially)

  // Define the languages for the dropdown
  final List<Map<String, String>> _otherLanguages = [
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'or', 'name': 'ଓଡ଼ିଆ'},
    {'code': 'ta', 'name': 'தமிழ்'},
    {'code': 'te', 'name': 'తెలుగు'},
    {'code': 'ml', 'name': 'മലയാളം'},
    {'code': 'kn', 'name': 'ಕನ್ನಡ'},
    {'code': 'bn', 'name': 'বাংলা'},
    {'code': 'mr', 'name': 'मराठी'},
  ];

  // Helper method for building the new language buttons
  Widget _buildLanguageButton({
    required String text,
    required VoidCallback onTap,
  }) {
    // These are the same colors from your other screens
    const Color color = Color(0xFF0056b3); // Dark blue text

    // --- THIS IS THE CHANGE ---
    final Color bgColor = Colors.blue[50]!; // Was: Color(0xFFf0f8ff)
    // --- END OF CHANGE ---

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: color,
          minimumSize:
              const Size(double.infinity, 54), // Full width, nice height
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2.0, // Subtle shadow
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _selectLanguage(BuildContext context, String languageCode) {
    // Update the locale using the provider
    Provider.of<LanguageProvider>(context, listen: false)
        .changeLanguage(Locale(languageCode));

    // Navigate to login screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center everything
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // Make buttons full-width
            children: [
              // --- 1. New Icon ---
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFf0f8ff), // Light blue
                child: Icon(
                  Icons.translate_rounded, // A more appropriate icon
                  size: 60,
                  color: Color(0xFF007BFF), // Primary blue
                ),
              ),
              const SizedBox(height: 24),

              // --- 2. New Title ---
              const Text(
                'Choose Your Language',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please select a language to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // --- English Button ---
              _buildLanguageButton(
                text: 'English',
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false).changeLanguage(Locale('en'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
              ),
              const SizedBox(height: 16), // Space between button and dropdown

              // --- Dropdown for Other Languages ---
              DropdownButtonFormField<String>(
                value: _selectedOtherLanguage,
                isExpanded: true, // Make dropdown take full width
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[50], // Match button background
                  hintText: 'Choose other Indian languages',
                  prefixIcon: const Icon(Icons.language, color: Color(0xFF0056b3)), // Add an icon
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Clean look
                  ),
                ),
                items: _otherLanguages.map((language) {
                  return DropdownMenuItem<String>(
                    value: language['code'],
                    child: Text(language['name']!),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedOtherLanguage = newValue;
                    });
                    // Update provider and navigate
                    Provider.of<LanguageProvider>(context, listen: false).changeLanguage(Locale(newValue));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
