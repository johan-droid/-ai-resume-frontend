import 'package:flutter/material.dart';
import 'dart:math';
import 'package:rezume_app/ats_checker/resume_editor_screen.dart';

class AtsResultsScreen extends StatefulWidget {
  const AtsResultsScreen({super.key});

  @override
  State<AtsResultsScreen> createState() => _AtsResultsScreenState();
}

class _AtsResultsScreenState extends State<AtsResultsScreen> {
  // --- 1. State Variables ---
  // These will hold our random data
  int _atsScore = 0;
  String _scoreMessage = '';
  List<Map<String, dynamic>> _suggestions = [];

  // --- REPLACE THE OLD LIST WITH THIS NEW ONE ---
  final List<Map<String, dynamic>> _allSuggestions = [
    {
      'icon': Icons.trending_up_rounded,
      'title': 'Use Industry Action Verbs',
      'subtitle': "Replace 'responsible for vehicle upkeep' with stronger verbs like 'Maintained vehicle fleet' or 'Performed daily vehicle inspections'.",
      'severity': 'suggestion',
    },
    {
      'icon': Icons.calculate_rounded,
      'title': 'Quantify Driving Experience',
      'subtitle': "Instead of just 'Managed routes', specify the scale: e.g., 'Managed 10+ daily delivery routes covering 150km' or 'Operated commercial vehicles (specify type)'.",
      'severity': 'suggestion',
    },
    {
      'icon': Icons.local_shipping_rounded, // Relevant icon
      'title': 'Highlight Logistics Skills',
      'subtitle': "Add keywords relevant to driving/logistics like 'Route Optimization', 'Load Securement', 'DOT Regulations', or 'Defensive Driving Techniques'.",
      'severity': 'tip',
    },
    {
      'icon': Icons.card_membership_rounded,
      'title': 'Mention Licenses/Certifications',
      'subtitle': "Do you have a Commercial Driver's License (CDL) or specific endorsements? Add a 'Licenses' section to clearly state them.",
      'severity': 'suggestion',
    },
    {
      'icon': Icons.build_circle_rounded, // Relevant icon
      'title': 'Detail Maintenance Skills',
      'subtitle': "Expand on 'vehicle upkeep'. Mention specific tasks like 'Minor repairs', 'Fluid checks', 'Tire pressure monitoring'.",
      'severity': 'tip',
    },
    {
      'icon': Icons.spellcheck_rounded,
      'title': 'Check Technical Terms',
      'subtitle': "Ensure specific vehicle parts, tool names, or safety procedures mentioned are spelled correctly.",
      'severity': 'critical',
    }
  ];

  @override
  void initState() {
    super.initState();
    // This runs the function as soon as the page opens
    _generateFakeAtsData();
  }

  // --- ADD THIS HELPER FUNCTION ---
  Color _getScoreColor(int score) {
    if (score < 50) {
      return Colors.red.shade600; // Poor score
    } else if (score < 75) {
      return Colors.orange.shade600; // Average score
    } else {
      return Colors.green.shade600; // Good score
    }
  }

  // New helper: map severity to color
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

  // --- 3. The "AI" Simulation Function ---
  void _generateFakeAtsData() {
    // Generate a random score between 60 and 95
    final random = Random();
    final score = 60 + random.nextInt(36); // 36 = 95 - 60 + 1

    // Pick 3 random, unique suggestions
    final shuffledList = List.of(_allSuggestions)..shuffle(random);
    final selectedSuggestions = shuffledList.take(3).toList();

    // Set the message based on the score
    String message;
    if (score > 85) {
      message = "This is an excellent score! Just a few minor tweaks.";
    } else if (score > 70) {
      message =
          "This is a good score! Here are some suggestions to make it even better.";
    } else {
      message = "There's room for improvement. Let's fix these key areas.";
    }

    // Update the state to rebuild the UI
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
              // --- 1. The Score Card ---
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.blue[50], // Light blue background
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text('YOUR SCORE',
                            style: TextStyle(color: Colors.blue[800])),
                        const SizedBox(height: 8),
                        // --- DYNAMIC SCORE ---
                        Text(
                          '$_atsScore%',
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            // --- THIS IS THE CHANGE ---
                            color: _getScoreColor(_atsScore), // Use the dynamic color
                            // --- END OF CHANGE ---
                          ),
                        ),
                        const SizedBox(height: 8),
                        // --- DYNAMIC MESSAGE ---
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

              // --- 2. The Suggestions List ---
              const Text(
                'AI Suggestions to Improve',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // --- DYNAMIC LIST ---
              ListView.builder(
                itemCount: _suggestions.length,
                shrinkWrap: true, // Important inside a SingleChildScrollView
                physics:
                    const NeverScrollableScrollPhysics(), // Let the parent scroll
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  // Use your styled card here
                  return _buildSuggestionCard(
                    icon: suggestion['icon'],
                    title: suggestion['title'],
                    subtitle: suggestion['subtitle'],
                    severity: suggestion['severity'] ?? 'suggestion',
                  );
                },
              ),

              const SizedBox(height: 24),
              // --- 3. The Edit Button ---
              ElevatedButton(
                onPressed: () {
                  // --- THIS IS THE CHANGE ---
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ResumeEditorScreen(
                        // Pass the list of suggestions to the new screen
                        suggestions: _suggestions,
                      ),
                    ),
                  );
                  // --- END OF CHANGE ---
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

  // --- 5. Your Suggestion Card Helper ---
  // You probably already have this, just make sure it's here
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
