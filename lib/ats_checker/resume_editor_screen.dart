// lib/ats_checker/resume_editor_screen.dart
import 'package:flutter/material.dart';

class ResumeEditorScreen extends StatefulWidget {
  final List<Map<String, dynamic>> suggestions;

  const ResumeEditorScreen({super.key, required this.suggestions});

  @override
  State<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends State<ResumeEditorScreen> {
  final List<String> _questions = [
    "What's your full name?",
    "What job title would you like to appear on your resume?",
    "List your key skills (comma separated).",
    "Describe your past experience or achievements briefly."
  ];

  int _currentIndex = 0;
  Map<String, String> _answers = {};
  final TextEditingController _answerController = TextEditingController();

  bool _isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI Resume Editor"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isCompleted
            ? _buildSummaryScreen(context)
            : _buildChatInterface(context),
      ),
    );
  }

  // 🧠 Chat-like Q&A screen
  Widget _buildChatInterface(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Show progress
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions.length,
          backgroundColor: Colors.grey[300],
          color: Colors.blueAccent,
        ),
        const SizedBox(height: 20),
        Text(
          "AI: ${_questions[_currentIndex]}",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            hintText: "Type your answer here...",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (_) => _nextQuestion(),
        ),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton.icon(
            onPressed: _nextQuestion,
            icon: const Icon(Icons.arrow_forward),
            label: const Text("Next"),
          ),
        ),
      ],
    );
  }

  // 🧾 Final summary before download
  Widget _buildSummaryScreen(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "🎉 Your Updated Resume Info",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        ..._answers.entries.map(
          (entry) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              "${entry.key}: ${entry.value}",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const Spacer(),
        Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // 🔗 Backend: send updated data to API for resume download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Preparing your resume...")),
              );
            },
            icon: const Icon(Icons.download),
            label: const Text("Download Resume"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _nextQuestion() {
    final currentAnswer = _answerController.text.trim();
    if (currentAnswer.isEmpty) return;

    // Save answer
    _answers[_questions[_currentIndex]] = currentAnswer;
    _answerController.clear();

    if (_currentIndex < _questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _isCompleted = true);
    }
  }
}
