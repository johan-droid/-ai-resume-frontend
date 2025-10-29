// lib/templates/resume_builder_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:rezume_app/models/resume_template_model.dart';
// For font loading
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:rezume_app/utils/color_extensions.dart';

// --- NEW: Dummy Data from modern-driver-resume.pdf ---
// This map will serve as the base for the generated PDF
final Map<String, dynamic> _fullDriverResumeData = {
  'fullName': 'Rajesh Kumar Singh',
  'jobTitle': 'Professional Driver',
  'contact': {
    'phone': '+91 98765 43210',
    'email': 'rajesh.kumar@email.com',
    'location': 'Mumbai, Maharashtra'
  },
  'license': 'Valid Driving License (LMV & HMV)',
  'summary':
      'Reliable and safety-focused professional driver with 8+ years of experience in passenger and goods transportation. Proven track record of maintaining a 100% accident-free driving record while delivering exceptional customer service. Skilled in route optimization, vehicle maintenance, and compliance with traffic regulations. Committed to punctuality and ensuring safe, comfortable journeys for all passengers.',
  'skills': [
    'Defensive Driving',
    'Route Planning & GPS Navigation',
    'Vehicle Maintenance & Inspection',
    'Time Management',
    'Customer Service Excellence',
    'Traffic Law Compliance',
    'Load Securing & Cargo Management',
    'DOT Regulations Knowledge',
    'Clean Driving Record',
    'Fuel Efficiency Optimization',
    'Emergency Response',
    'Multi-vehicle Operation',
  ],
  'experience': [
    {
      'position': 'Senior Company Driver',
      'company': 'Tata Corporate Services | Mumbai, MH',
      'duration': 'June 2020 - Present',
      'details': [
        'Safely transport executives and VIP clients across Mumbai metropolitan area, maintaining 99% on-time performance record',
        'Reduced fuel costs by 18% through strategic route optimization and efficient driving practices, saving 85,000 annually',
        'Maintained pristine vehicle condition with zero breakdown incidents over 4 years through proactive maintenance',
        'Awarded \'Driver of the Year 2023\' for outstanding service and zero traffic violations',
        'Successfully managed scheduling for 5+ executives simultaneously, coordinating 30+ trips weekly',
      ]
    },
    {
      'position': 'Delivery Driver',
      'company': 'Amazon Logistics India | Mumbai, MH',
      'duration': 'March 2018 - May 2020',
      'details': [
        'Delivered 150+ packages daily across urban and suburban routes with 98.5% on-time delivery rate',
        'Achieved customer satisfaction rating of 4.9/5 through professional conduct and careful package handling',
        'Completed over 12,000 deliveries with zero damage claims or lost packages',
        'Implemented efficient route planning that increased delivery capacity by 25% without compromising safety',
      ]
    },
    {
      'position': 'Private Chauffeur',
      'company': 'Elite Car Rentals | Pune, MΗ',
      'duration': 'January 2016 - February 2018',
      'details': [
        'Provided luxury transportation services to high-profile clients including business executives and tourists',
        'Maintained 100% punctuality record for airport transfers and corporate events',
        'Received 95% positive feedback from clients, resulting in 40% repeat customer rate',
        'Performed daily vehicle inspections and coordinated maintenance schedules for fleet of 8 premium vehicles',
      ]
    },
  ],
  'education': {
    'degree': 'Higher Secondary Certificate (12th)',
    'institution': 'Maharashtra State Board | Pune, Maharashtra',
    'year': '2015',
  },
  'certifications': [
    'Valid LMV & HMV Driving License (Exp: 2028)',
    'Defensive Driving Certification - National Safety Council (2022)',
    'First Aid & CPR Certified - Red Cross India (2023)',
    'Vehicle Maintenance Training - Auto Service Training Institute (2021)',
    'GPS Navigation & Route Optimization Workshop (2020)',
  ],
  'languages': ['English', 'Hindi', 'Marathi'],
};
// --- END: Dummy Data ---

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
  // This is the chat flow, unchanged
  final List<Map<String, String>> _questionFlow = [
    {
      'key': 'fullName',
      'question':
          'Welcome! Let\'s build your job profile. What is your full name?'
    },
    {
      'key': 'phone',
      'question': 'Got it. What is your 10-digit mobile number?'
    },
    {
      'key': 'city',
      'question':
          'Which city do you live in? (Example: Mumbai, Rourkela, Delhi)'
    },
    {
      'key': 'jobType',
      'question':
          'What kind of job are you looking for? (Example: Driver, Electrician, Plumber, Cook, Security Guard)'
    },
    {
      'key': 'experience',
      'question':
          'How many years of experience do you have in this job? (Type "0" if you are a fresher)'
    },
    {
      'key': 'qualification',
      'question':
          'What is your highest qualification? (Example: 8th Pass, 10th Pass, 12th Pass, ITI, Diploma)'
    },
    {
      'key': 'skills',
      'question':
          'What are your main work skills? (Example: Driving, Welding, Tally, Spoken English, Cooking)'
    },
    {
      'key': 'availability',
      'question':
          'How soon can you join a new job? (Example: Immediately, in 1 week, in 1 month)'
    },
  ];

  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final FocusNode _chatFocusNode = FocusNode();
  int _currentQuestionIndex = 0;
  // This map stores the user's answers from the chat
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
    super.dispose();
  }

  void _askQuestion() {
    if (_currentQuestionIndex < _questionFlow.length) {
      setState(() {
        _messages.add(ChatMessage(
          text: _questionFlow[_currentQuestionIndex]['question']!,
          isUser: false,
        ));
      });
    } else {
      setState(() {
        _messages.add(ChatMessage(
          text:
              'Great! Your profile is complete. You can now generate your PDF resume.',
          isUser: false,
        ));
        _isConversationComplete = true;
      });
      if (kDebugMode) {
        debugPrint('Final Job Profile Details: $_resumeDetails');
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

    if (_currentQuestionIndex < _questionFlow.length) {
      String key = _questionFlow[_currentQuestionIndex]['key']!;
      _resumeDetails[key] = userInput;
      _currentQuestionIndex++;
    }

    _textController.clear();
    if (!_isConversationComplete) {
      _chatFocusNode.requestFocus();
    }

    Future.delayed(const Duration(milliseconds: 500), () {
      _askQuestion();
    });
  }

  // --- NEW: Full PDF Generation ---
  Future<void> _generateFullPdf() async {
    final pdf = pw.Document();
    pw.ThemeData myTheme;

    // Load fonts
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

    // --- Combine User Data with Dummy Data ---
    // User data from chat takes priority
    final String fullName =
        _resumeDetails['fullName'] ?? _fullDriverResumeData['fullName'];
    final String jobTitle =
        _resumeDetails['jobType'] ?? _fullDriverResumeData['jobTitle'];
    final String phone =
        _resumeDetails['phone'] ?? _fullDriverResumeData['contact']['phone'];
    final String location =
        _resumeDetails['city'] ?? _fullDriverResumeData['contact']['location'];
    final String email =
        _fullDriverResumeData['contact']['email']; // From dummy
    final String license = _fullDriverResumeData['license']; // From dummy
    final String summary = _fullDriverResumeData['summary']; // From dummy
    final List skills = _fullDriverResumeData['skills']; // From dummy
    final List experience = _fullDriverResumeData['experience']; // From dummy
    final Map education = _fullDriverResumeData['education']; // From dummy
    final List certifications =
        _fullDriverResumeData['certifications']; // From dummy

    pdf.addPage(
      pw.Page(
        theme: myTheme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- Header (Uses User Data) ---
              pw.Text(
                fullName,
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: pw.Text(
                  jobTitle,
                  style:
                      const pw.TextStyle(fontSize: 16, color: PdfColors.grey),
                ),
              ),

              // --- Contact (Uses User Data) ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(phone),
                  pw.Text(email),
                  pw.Text(location),
                ],
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 4.0),
                child: pw.Text(
                  'License: $license',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),

              // --- Summary (Uses Dummy Data) ---
              pw.SizedBox(height: 12),
              _buildPdfSection('Professional Summary', myTheme),
              pw.Text(summary),

              // --- Skills (Uses Dummy Data) ---
              pw.SizedBox(height: 12),
              _buildPdfSection('Core Skills', myTheme),
              pw.Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children:
                    skills.map((s) => pw.Text('• ${s.toString()}')).toList(),
              ),

              // --- Experience (Uses Dummy Data) ---
              pw.SizedBox(height: 12),
              _buildPdfSection('Work Experience', myTheme),
              ...experience.map((exp) {
                final Map<String, dynamic> e =
                    exp is Map<String, dynamic> ? exp : {};
                final expDetails = e['details'] as List? ?? [];
                return pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 6.0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        e['position']?.toString() ?? '',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        '${e['company']?.toString() ?? ''} | ${e['duration']?.toString() ?? ''}',
                        style: const pw.TextStyle(color: PdfColors.grey700),
                      ),
                      if (expDetails.isNotEmpty) pw.SizedBox(height: 4),
                      ...expDetails.map(
                        (d) => pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('• ',
                                  style: const pw.TextStyle(fontSize: 14)),
                              pw.Expanded(child: pw.Text(d.toString())),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // --- Education & Certs (Split to new page if needed) ---
              pw.Wrap(children: [
                pw.Container(
                    width: 240, // Half page width
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 12),
                          _buildPdfSection('Education', myTheme),
                          pw.Text(
                            education['degree']?.toString() ?? '',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(education['institution']?.toString() ?? ''),
                          if ((education['year'] ?? '').toString().isNotEmpty)
                            pw.Text('Year: ${education['year']}'),
                        ])),
                pw.Container(
                    width: 240, // Half page width
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.SizedBox(height: 12),
                          _buildPdfSection(
                              'Certifications & Licenses', myTheme),
                          ...certifications.map(
                            (l) => pw.Padding(
                              padding:
                                  const pw.EdgeInsets.symmetric(vertical: 2.0),
                              child: pw.Text('• ${l.toString()}'),
                            ),
                          ),
                        ])),
              ])
            ],
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // --- PDF Helper Widget ---
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
      backgroundColor: const Color(0xFFF0F8FF),
      appBar: AppBar(
        title: Text("Building with '${widget.templateName}'"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
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
        label: const Text('Generate PDF Resume'),
        // --- THIS IS THE CHANGE ---
        onPressed: _generateFullPdf, // Call the new function
        // --- END OF CHANGE ---
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

  // Chat input UI (Unchanged)
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

  // Chat bubble UI (Unchanged)
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
