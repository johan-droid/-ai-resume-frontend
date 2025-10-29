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
  // State variable for dropdown selection (using unique 'value')
  String? _selectedOtherLanguageValue;

  // List of 21 languages for the dropdown (using unique 'value')
  final List<Map<String, String>> _otherLanguages = [
    {'name': 'Assamese (অসমীয়া)', 'value': 'Assamese', 'code': 'as'},
    {'name': 'Bengali (বাংলা)', 'value': 'Bengali', 'code': 'bn'},
    {'name': 'Bodo (बर Boro)', 'value': 'Bodo', 'code': 'bn'},
    {'name': 'Dogri (डोगरी)', 'value': 'Dogri', 'code': 'hi'},
    {'name': 'Gujarati (ગુજરાતી)', 'value': 'Gujarati', 'code': 'gu'},
    {'name': 'Hindi (हिन्दी)', 'value': 'Hindi', 'code': 'hi'},
    {'name': 'Kannada (ಕನ್ನಡ)', 'value': 'Kannada', 'code': 'kn'},
    {'name': 'Kashmiri (کٲشُر / कॉ)', 'value': 'Kashmiri', 'code': 'ks'},
    {'name': 'Konkani (कोंकणी)', 'value': 'Konkani', 'code': 'mr'},
    {'name': 'Maithili (मैथिली)', 'value': 'Maithili', 'code': 'hi'},
    {'name': 'Malayalam (മലയാളം)', 'value': 'Malayalam', 'code': 'ml'},
    {'name': 'Manipuri (মৈতৈলোন্)', 'value': 'Manipuri', 'code': 'bn'},
    {'name': 'Marathi (मराठी)', 'value': 'Marathi', 'code': 'mr'},
    {'name': 'Nepali (नेपाली)', 'value': 'Nepali', 'code': 'ne'},
    {'name': 'Odia (ଓଡ଼ିଆ)', 'value': 'Odia', 'code': 'or'},
    {'name': 'Punjabi (ਪੰਜਾਬੀ)', 'value': 'Punjabi', 'code': 'pa'},
    {'name': 'Sanskrit (संस्कृतम्)', 'value': 'Sanskrit', 'code': 'sa'},
    {'name': 'Santali (ᱥᱟᱱᱛᱟᱲᱤ)', 'value': 'Santali', 'code': 'bn'},
    {'name': 'Sindhi (सिन्धी / سنڌي)', 'value': 'Sindhi', 'code': 'sd'},
    {'name': 'Tamil (தமிழ்)', 'value': 'Tamil', 'code': 'ta'},
    {'name': 'Telugu (తెలుగు)', 'value': 'Telugu', 'code': 'te'},
    {'name': 'Urdu (اُردُو)', 'value': 'Urdu', 'code': 'ur'},
  ];

  // Helper method for building the English button
  Widget _buildLanguageButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    final Color color = Color(0xFF0056b3);
    final Color bgColor = Colors.blue[50]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: color,
          minimumSize: const Size(double.infinity, 54),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2.0,
        ),
        child: Text(text,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          // Use Container for padding and Column
          width: double.infinity,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            // Use Column, not SingleChildScrollView here
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Header (Icon, Title, Subtitle) ---
              CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[50],
                  child: Icon(Icons.translate_rounded,
                      size: 60, color: Color(0xFF007BFF))),
              const SizedBox(height: 24),
              const Text('Choose Your Language',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 12),
              Text('Please select a language to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 40),

              // --- English Button ---
              _buildLanguageButton(
                context: context,
                text: 'English',
                onTap: () {
                  Provider.of<LanguageProvider>(context, listen: false)
                      .changeLanguage(const Locale('en'));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
              ),
              const SizedBox(height: 16),

              // --- Dropdown for Other Languages ---
              DropdownButtonFormField<String>(
                initialValue: _selectedOtherLanguageValue,
                isExpanded: true,
                // --- ADDED: Make the popup menu scrollable ---
                menuMaxHeight: MediaQuery.of(context).size.height *
                    0.5, // Limit height to 50% of screen
                // --- END ADDITION ---
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[50], // Match button background
                  hintText: 'Choose other Indian languages',
                  prefixIcon:
                      const Icon(Icons.language, color: Color(0xFF0056b3)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Clean look
                  ),
                ),
                // Build items using the unique 'value'
                items: _otherLanguages.map((language) {
                  return DropdownMenuItem<String>(
                    value: language['value'], // Use unique value
                    child: Text(language['name']!),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  // newValue is the unique 'value'
                  if (newValue != null) {
                    setState(() {
                      _selectedOtherLanguageValue = newValue;
                    });
                    // Find the corresponding language code
                    final selectedLangData = _otherLanguages.firstWhere(
                      (lang) => lang['value'] == newValue,
                      orElse: () => _otherLanguages.first,
                    );
                    final languageCode = selectedLangData['code']!;

                    // Update provider with the code and navigate
                    Provider.of<LanguageProvider>(context, listen: false)
                        .changeLanguage(Locale(languageCode));
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }
                },
              ),
              // --- Add Spacer to push content up if needed ---
              // Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
