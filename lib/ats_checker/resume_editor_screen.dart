// lib/ats_checker/resume_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
// For font loading
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rezume_app/utils/color_extensions.dart';

// Helper class for chat messages
class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ResumeEditorScreen extends StatefulWidget {
  final List<Map<String, dynamic>> suggestions;

  const ResumeEditorScreen({super.key, required this.suggestions});

  @override
  State<ResumeEditorScreen> createState() => _ResumeEditorScreenState();
}

class _ResumeEditorScreenState extends State<ResumeEditorScreen> {
  // This list will be populated from the suggestions
  final List<Map<String, String>> _suggestionFlow = [];

  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _chatFocusNode = FocusNode();
  int _currentQuestionIndex = 0;
  final Map<String, String> _updatedDetails = {};
  bool _isConversationComplete = false;

  @override
  void initState() {
    super.initState();
    // Build the conversation flow from the suggestions
    _buildSuggestionFlow();
    _askQuestion();
  }

  void _buildSuggestionFlow() {
    // Add a welcome message first
    _suggestionFlow.add({
      'key': 'Welcome',
      'question':
          'Welcome to the AI Resume Editor. Let\'s improve your resume based on the suggestions we found.'
    });

    // Add each suggestion as a question
    for (var suggestion in widget.suggestions) {
      _suggestionFlow.add({
        'key': suggestion['title'] ?? 'Suggestion',
        'question': suggestion['subtitle'] ?? 'Please provide an update.'
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    _chatFocusNode.dispose();
    super.dispose();
  }

  // Scroll helper - scrolls to the bottom when messages change
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _askQuestion() {
    if (_currentQuestionIndex < _suggestionFlow.length) {
      setState(() {
        _messages.add(ChatMessage(
          text: _suggestionFlow[_currentQuestionIndex]['question']!,
          isUser: false,
        ));
      });
      _scrollToBottom();
    } else {
      setState(() {
        _messages.add(ChatMessage(
          text:
              'Great! Your resume updates are complete. You can now generate the updated PDF.',
          isUser: false,
        ));
        _isConversationComplete = true;
      });
      _scrollToBottom();
      if (kDebugMode) {
        debugPrint('Final Updated Details: $_updatedDetails');
      }
    }
  }

  void _sendMessage() {
    if (_isConversationComplete) return;

    String userInput = _textController.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userInput, isUser: true));
    });
    _scrollToBottom();

    // Don't save the answer to the "Welcome" message
    if (_currentQuestionIndex > 0 &&
        _currentQuestionIndex < _suggestionFlow.length) {
      String key = _suggestionFlow[_currentQuestionIndex]['key']!;
      _updatedDetails[key] = userInput;
    }

    _currentQuestionIndex++;
    _textController.clear();
    if (!_isConversationComplete) {
      _chatFocusNode.requestFocus();
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _askQuestion();
    });
  }

  // --- PDF Generation (Modified) ---
  Future<void> _generateUpdatedPdf() async {
    final pdf = pw.Document();
    pw.ThemeData myTheme;
    try {
      final fontData =
          await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
      final hindiFontData =
          await rootBundle.load("assets/fonts/NotoSansDevanagari-Regular.ttf");
      final odiaFontData =
          await rootBundle.load("assets/fonts/NotoSansOriya-Regular.ttf");
      final ttf = pw.Font.ttf(fontData);
      final hindiTtf = pw.Font.ttf(hindiFontData);
      final odiaTtf = pw.Font.ttf(odiaFontData);
      myTheme = pw.ThemeData.withFont(
        base: ttf,
        fontFallback: [hindiTtf, odiaTtf],
      );
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Custom fonts not found. Using default fonts. Error: $e');
      }
      myTheme = pw.ThemeData.base();
    }

    // Build a list of widgets from the updated details
    final List<pw.Widget> contentWidgets = [];
    _updatedDetails.forEach((key, value) {
      contentWidgets.add(
        pw.Text(
          key, // The suggestion title (e.g., "Quantify Driving Experience")
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
      );
      contentWidgets.add(pw.Divider());
      contentWidgets.add(
        pw.Text(value), // The user's new text
      );
      contentWidgets.add(pw.SizedBox(height: 15));
    });

    pdf.addPage(
      pw.Page(
        theme: myTheme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Center(
                child: pw.Text('Updated Resume',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              ...contentWidgets, // Add all the generated widgets
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using the background color from the chat UI
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        title: const Text("AI Resume Editor"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              reverse: false,
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatMessage(
                  isUser: message.isUser,
                  message: message.text,
                );
              },
            ),
          ),
          if (_isConversationComplete) _buildGenerateButton(),
          if (!_isConversationComplete) _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.description_rounded, size: 20),
        label: const Text('Generate Updated PDF'),
        onPressed: _generateUpdatedPdf,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF),
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Chat input UI
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacityCompat(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              focusNode: _chatFocusNode,
              decoration: InputDecoration(
                hintText: "Type your answer...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
              ),
              onSubmitted: (text) => _sendMessage(),
            ),
          ),
          const SizedBox(width: 8.0),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF007BFF)),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  // Chat bubble UI
  Widget _buildChatMessage({required bool isUser, required String message}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? const Color(0xFF007BFF) : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: isUser
              ? []
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacityCompat(0.15),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  )
                ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isUser ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
