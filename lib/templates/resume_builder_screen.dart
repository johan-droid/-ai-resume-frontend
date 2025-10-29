// lib/templates/resume_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:rezume_app/models/resume_template_model.dart';
// For font loading
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:async'; // Make sure Timer is imported

// Dummy Data (Keep your existing _fullDriverResumeData map here)
final Map<String, dynamic> _fullDriverResumeData = {
  // --- PASTE YOUR _fullDriverResumeData map here ---
  'fullName': 'Rajesh Kumar Singh',
  'jobTitle': 'Professional Driver',
  'contact': { /*...*/ },
  'license': 'Valid Driving License (LMV & HMV)',
  'summary': 'Reliable and safety-focused...',
  'skills': [ /*...*/ ],
  'experience': [ /*...*/ ],
  'education': { /*...*/ },
  'certifications': [ /*...*/ ],
  'languages': ['English', 'Hindi', 'Marathi'],
};
// --- END: Dummy Data ---


// ChatMessage Class (Keep as is)
class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}

class ResumeBuilderScreen extends StatefulWidget {
  final ResumeTemplate template;
  final String templateName;

  const ResumeBuilderScreen({
    super.key,
    required this.template,
    required this.templateName,
  });

  @override
  State<ResumeBuilderScreen> createState() => _ResumeBuilderScreenState();
}

class _ResumeBuilderScreenState extends State<ResumeBuilderScreen> {
  // --- Question Flow ---
  final List<Map<String, String>> _questionFlow = [
    {'key': 'fullName', 'question': 'Welcome! Let\'s build your job profile. What is your full name?'},
    {'key': 'phone', 'question': 'Got it. What is your 10-digit mobile number?'},
    {'key': 'city', 'question': 'Which city do you live in? (Example: Mumbai, Rourkela, Delhi)'},
    {'key': 'jobType', 'question': 'What kind of job are you looking for? (Example: Driver, Electrician, Plumber, Cook, Security Guard)'},
    {'key': 'experience', 'question': 'How many years of experience do you have in this job? (Type "0" if you are a fresher)'},
    {'key': 'qualification', 'question': 'What is your highest qualification? (Example: 8th Pass, 10th Pass, 12th Pass, ITI, Diploma)'},
    {'key': 'skills', 'question': 'What are your main work skills? (Example: Driving, Welding, Tally, Spoken English, Cooking)'},
    {'key': 'availability', 'question': 'How soon can you join a new job? (Example: Immediately, in 1 week, in 1 month)'},
  ];

  // --- State Variables ---
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _chatFocusNode = FocusNode();
  // --- SCROLL CONTROLLER ---
  final ScrollController _scrollController = ScrollController(); // Make sure this is here
  int _currentQuestionIndex = 0;
  final Map<String, String> _resumeDetails = {};
  bool _isConversationComplete = false;

  @override
  void initState() {
    super.initState();
    _askQuestion();
  }

  @override
  void dispose() {
    _textController.dispose();
    _chatFocusNode.dispose();
    _scrollController.dispose(); // Dispose the scroll controller
    super.dispose();
  }

  // --- AUTO SCROLL FUNCTION ---
  void _scrollToBottom() {
    // Use addPostFrameCallback to ensure the list has updated its layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) { // Check if controller is attached
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // Scroll to the very bottom
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  // --- END AUTO SCROLL ---

  void _askQuestion() {
    if (_currentQuestionIndex < _questionFlow.length) {
      setState(() {
        _messages.add(ChatMessage(
          text: _questionFlow[_currentQuestionIndex]['question']!,
          isUser: false,
        ));
      });
       _scrollToBottom(); // <-- Scroll after adding bot message
    } else {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Great! Your profile is complete. You can now generate your PDF resume.',
          isUser: false,
        ));
        _isConversationComplete = true;
      });
      _scrollToBottom(); // <-- Scroll after adding final bot message
      print('Final Job Profile Details: $_resumeDetails');
      // _saveResumeLocally(); // Call save if needed
    }
  }

  void _sendMessage() {
    if (_isConversationComplete) return;

    String userInput = _textController.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: userInput, isUser: true));
    });
    _scrollToBottom(); // <-- Scroll after adding user message

    if (_currentQuestionIndex < _questionFlow.length) {
      String key = _questionFlow[_currentQuestionIndex]['key']!;
      _resumeDetails[key] = userInput;
      _currentQuestionIndex++;
    }

    _textController.clear();
    if (!_isConversationComplete) {
      _chatFocusNode.requestFocus();
    }

    // Delay before bot reply slightly longer can help scroll smoothness
    Future.delayed(const Duration(milliseconds: 400), () {
      _askQuestion();
    });
  }

  // --- PDF Generation Logic (Keep your existing _generateFullPdf here) ---
  Future<void> _generateFullPdf() async {
     final pdf = pw.Document();
     pw.ThemeData myTheme;

     // Load fonts (Keep this part)
     try {
       final fontData = await rootBundle.load("assets/fonts/NotoSans-Regular.ttf");
       final hindiFontData = await rootBundle.load("assets/fonts/NotoSansDevanagari-Regular.ttf");
       final odiaFontData = await rootBundle.load("assets/fonts/NotoSansOriya-Regular.ttf");
       final ttf = pw.Font.ttf(fontData);
       final hindiTtf = pw.Font.ttf(hindiFontData);
       final odiaTtf = pw.Font.ttf(odiaFontData);
       myTheme = pw.ThemeData.withFont(
         base: ttf,
         fontFallback: [hindiTtf, odiaTtf],
       );
     } catch (e) {
       print('Custom fonts not found. Using default fonts. Error: $e');
       myTheme = pw.ThemeData.base();
     }

     // --- Combine User Data from Chat (_resumeDetails) with Fallback Dummy Data ---
     // User data takes priority if it exists
     final String fullName = _resumeDetails['fullName'] ?? _fullDriverResumeData['fullName'] ?? 'N/A';
     final String jobTitle = _resumeDetails['jobType'] ?? _fullDriverResumeData['jobTitle'] ?? 'N/A'; // Use 'jobType' from chat
     final String phone = _resumeDetails['phone'] ?? _fullDriverResumeData['contact']?['phone'] ?? 'N/A';
     final String location = _resumeDetails['city'] ?? _fullDriverResumeData['contact']?['location'] ?? 'N/A';
     final String email = _fullDriverResumeData['contact']?['email'] ?? 'N/A'; // From dummy
     final String license = _fullDriverResumeData['license'] ?? ''; // From dummy
     final String summary = _fullDriverResumeData['summary'] ?? ''; // From dummy

     // Skills: Use chat input if available, otherwise dummy, split by comma
     final List<String> skills = (_resumeDetails['skills'] != null && _resumeDetails['skills']!.isNotEmpty)
         ? _resumeDetails['skills']!.split(',').map((s) => s.trim()).toList()
         : (_fullDriverResumeData['skills'] as List? ?? []).map((s) => s.toString()).toList();

     // Experience: Use chat years, but dummy details
     final String experienceYears = _resumeDetails['experience'] ?? '0';
     final List experienceDetails = _fullDriverResumeData['experience'] as List? ?? [];

     // Qualification: Use chat input if available, otherwise dummy
     final String qualification = _resumeDetails['qualification'] ?? _fullDriverResumeData['education']?['degree'] ?? 'N/A';
     final String qualificationInstitution = _fullDriverResumeData['education']?['institution'] ?? '';
     final String qualificationYear = _fullDriverResumeData['education']?['year'] ?? '';


     final List certifications = _fullDriverResumeData['certifications'] as List? ?? []; // From dummy
     final List languages = _fullDriverResumeData['languages'] as List? ?? []; // From dummy


     // --- Build the PDF Page ---
     pdf.addPage(
       pw.Page(
         theme: myTheme, // Apply the theme with fallback fonts
         pageFormat: PdfPageFormat.a4,
         margin: const pw.EdgeInsets.all(30), // Add some margin
         build: (pw.Context context) {
           return pw.Column(
             crossAxisAlignment: pw.CrossAxisAlignment.start,
             children: [
               // --- Header ---
               pw.Text(fullName, style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold)),
               pw.SizedBox(height: 2),
               pw.Text(jobTitle, style: pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
               pw.SizedBox(height: 8),
               pw.Row(
                 mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                 children: [
                   if (phone != 'N/A') pw.Text(phone),
                   if (email != 'N/A') pw.Text(email),
                   if (location != 'N/A') pw.Text(location),
                 ],
               ),
                if (license.isNotEmpty) pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4.0),
                  child: pw.Text('License: $license', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ),
               pw.SizedBox(height: 15),

               // --- Summary ---
               if (summary.isNotEmpty) ...[
                 _buildPdfSection('Professional Summary', myTheme),
                 pw.Text(summary, style: const pw.TextStyle(lineSpacing: 2)),
                 pw.SizedBox(height: 15),
               ],

               // --- Skills ---
               if (skills.isNotEmpty) ...[
                 _buildPdfSection('Core Skills', myTheme),
                 pw.Wrap(
                   spacing: 8.0,
                   runSpacing: 4.0,
                   children: skills.map((s) => pw.Text('• $s')).toList(),
                 ),
                 pw.SizedBox(height: 15),
               ],

               // --- Experience ---
               _buildPdfSection('Work Experience', myTheme),
               pw.Text('$experienceYears years total', style: pw.TextStyle(fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
               pw.SizedBox(height: 6),
               // Add dummy experience details
               ...experienceDetails.map((exp) {
                  final Map<String, dynamic> e = exp is Map<String, dynamic> ? exp : {};
                  final expDetailsList = e['details'] as List? ?? [];
                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 6.0),
                    child: pw.Column(
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         pw.Text(e['position']?.toString() ?? '', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
                         pw.Text('${e['company']?.toString() ?? ''} | ${e['duration']?.toString() ?? ''}', style: const pw.TextStyle(color: PdfColors.grey700, fontStyle: pw.FontStyle.italic)),
                         if (expDetailsList.isNotEmpty) pw.SizedBox(height: 4),
                         ...expDetailsList.map((d) => pw.Padding(
                           padding: const pw.EdgeInsets.only(left: 8.0, top: 2.0),
                           child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                             pw.Text('• '),
                             pw.Expanded(child: pw.Text(d.toString())),
                           ]),
                         )),
                       ],
                     ),
                  );
               }),
               pw.SizedBox(height: 15),

               // --- Education & Certifications Side-by-Side ---
               pw.Row(
                 crossAxisAlignment: pw.CrossAxisAlignment.start,
                 children: [
                   // Education Column
                   pw.Expanded(
                     child: pw.Column(
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         _buildPdfSection('Education', myTheme),
                         pw.Text(qualification, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                         if(qualificationInstitution.isNotEmpty) pw.Text(qualificationInstitution),
                         if(qualificationYear.isNotEmpty) pw.Text('Year: $qualificationYear'),
                       ]
                     ),
                   ),
                   pw.SizedBox(width: 20),
                   // Certifications Column
                   pw.Expanded(
                     child: pw.Column(
                       crossAxisAlignment: pw.CrossAxisAlignment.start,
                       children: [
                         if (certifications.isNotEmpty)...[
                           _buildPdfSection('Certifications', myTheme),
                           ...certifications.map((c) => pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
                              child: pw.Text('• ${c.toString()}'),
                           )),
                         ]
                       ]
                     ),
                   ),
                 ]
               ),

               // --- Languages ---
               if (languages.isNotEmpty) ...[
                  pw.SizedBox(height: 15),
                  _buildPdfSection('Languages', myTheme),
                  pw.Text(languages.map((l) => l.toString()).join(', ')),
               ],

             ],
           );
         },
       ),
     );

     // --- Show Preview/Save Screen ---
     await Printing.layoutPdf(
       onLayout: (PdfPageFormat format) async => pdf.save(),
     );
  }

  // PDF Helper Widget (Keep _buildPdfSection)
   pw.Widget _buildPdfSection(String title, pw.ThemeData theme) {
     return pw.Column(
       crossAxisAlignment: pw.CrossAxisAlignment.start,
       children: [
         pw.Text(
           title,
           style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
         ),
         pw.Divider(thickness: 1, color: PdfColors.black),
         pw.SizedBox(height: 6),
       ],
     );
   }
  // --- END: PDF Generation ---


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8FF), // Light background
      appBar: AppBar(
        title: Text("Building with '${widget.templateName}'"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController, // *** ATTACH CONTROLLER HERE ***
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildChatMessage( // Use your existing chat bubble widget
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

  // Generate Button (Keep as is)
  Widget _buildGenerateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.description_rounded, size: 20),
        label: const Text('Generate PDF Resume'),
        onPressed: _generateFullPdf,
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

  // Chat Input UI (Keep as is)
  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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

  // Chat Bubble UI (Keep as is)
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
                    color: Colors.grey.withOpacity(0.15),
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

} // End of _ResumeBuilderScreenState
