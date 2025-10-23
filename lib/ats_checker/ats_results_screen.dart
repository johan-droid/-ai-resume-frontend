// lib/ats_checker/ats_results_screen.dart

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:rezume_app/ats_checker/resume_editor_screen.dart';

class AtsResultsScreen extends StatefulWidget {
  const AtsResultsScreen({super.key});

  @override
  State<AtsResultsScreen> createState() => _AtsResultsScreenState();
}

class _AtsResultsScreenState extends State<AtsResultsScreen> {
  int _atsScore = 0;
  String _scoreMessage = '';
  List<Map<String, dynamic>> _suggestions = [];

  // --- NEW: Suggestions based on modern-driver-resume.pdf ---
  final List<Map<String, dynamic>> _allSuggestions = [
    {
      'icon': Icons.star_border_rounded,
      'title': "Highlight 'Driver of the Year 2023' Award",
      'subtitle':
          // --- FIX: Brackets moved inside the string ---
          "Your 'Driver of the Year 2023' award is a major achievement. Move it to a separate 'Awards' section or bold it for high visibility.",
      'severity': 'suggestion',
    },
    {
      'icon': Icons.directions_car_rounded,
      'title': 'Specify Vehicle Types',
      'subtitle':
          // --- FIX: Brackets moved inside the string ---
          "You mention 'LMV & HMV' and 'Multi-vehicle Operation'. Specify the exact types, e.g., 'Tata Ace, 10-wheel trucks, luxury sedans' to be more concrete.",
      'severity': 'suggestion',
    },
    {
      'icon': Icons.description_outlined,
      'title': 'Combine License Information',
      'subtitle':
          // --- FIX: Brackets moved inside the string ---
          "You list 'Valid LMV & HMV' in the header and in 'Certifications'. Remove it from the header and keep it in the 'Certifications' section to avoid redundancy.",
      'severity': 'tip',
    },
    {
      'icon': Icons.auto_awesome_rounded,
      'title': "Quantify 'Fuel Efficiency' Skill",
      'subtitle':
          // --- FIX: All brackets moved inside a single string ---
          "You list 'Fuel Efficiency Optimization' as a skill and show an 18% cost reduction. Link these, e.g., 'Optimized fuel efficiency, saving 85,000 annually'.",
      'severity': 'suggestion',
    },
    {
      'icon': Icons.thumb_up_alt_outlined,
      'title': 'Consolidate Customer Service Scores',
      'subtitle':
          // --- FIX: All brackets moved inside a single string ---
          "You have 'Customer Service Excellence', a 4.9/5 rating, and 95% positive feedback. Combine these into one powerful point under 'Senior Company Driver'.",
      'severity': 'tip',
    },
    {
      'icon': Icons.text_snippet_outlined,
      'title': 'Strengthen Professional Summary',
      'subtitle':
          // --- FIX: Brackets moved inside the string ---
          "Your summary starts with 'Reliable and safety-focused'. Make it more impactful by starting with your award: 'Award-winning driver with 8+ years...'",
      'severity': 'critical',
    }
  ];
  // --- END: Fixed Suggestions ---

  @override
  void initState() {
    super.initState();
    _generateFakeAtsData();
  }

  Color _getScoreColor(int score) {
    if (score < 50) {
      return Colors.red.shade600;
    } else if (score < 75) {
      return Colors.orange.shade600;
    } else {
      return Colors.green.shade600;
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical':
        return Colors.red;
      case 'suggestion':
        return Colors.blue;
      case 'tip':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  void _generateFakeAtsData() {
    final random = Random();
    // Generate a score between 65 and 80, as the resume is good but has points to improve
    final score = 65 + random.nextInt(16); // 65 to 80

    // Pick 3 random, unique suggestions from our new list
    final shuffledList = List.of(_allSuggestions)..shuffle(random);
    final selectedSuggestions = shuffledList.take(3).toList();

    String message;
    if (score > 75) {
      message =
          "This is a strong resume! Let's fix these key areas to make it perfect.";
    } else {
      message =
          "This is a good score! Here are some suggestions to make it even better.";
    }

    setState(() {
      _atsScore = score;
      _scoreMessage = message;
      _suggestions = selectedSuggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text('Your ATS Score'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text('YOUR SCORE',
                            style: TextStyle(color: Colors.blue[800])),
                        const SizedBox(height: 8),
                        Text(
                          '$_atsScore%',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(_atsScore),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _scoreMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black54),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'AI Suggestions to Improve',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                itemCount: _suggestions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return _buildSuggestionCard(
                    icon: suggestion['icon'],
                    title: suggestion['title'],
                    subtitle: suggestion['subtitle'],
                    severity: suggestion['severity'] ?? 'suggestion',
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumeEditorScreen(
                        // Pass the new list of suggestions
                        suggestions: _suggestions,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Edit My Resume',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String severity,
  }) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        leading: Icon(icon, color: _getSeverityColor(severity), size: 28),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}