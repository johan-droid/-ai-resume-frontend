// lib/profile/saved_resumes_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:rezume_app/utils/color_extensions.dart';
// PDF Generation Imports
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// --- NEW: Dummy Data from modern-driver-resume.pdf ---
final Map<String, dynamic> driverResumeData = {
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

class SavedResumesScreen extends StatelessWidget {
  const SavedResumesScreen({super.key});

  // --- Updated list to use the new dummy data ---
  List<Map<String, dynamic>> _getDummyResumes() {
    // 1. English Driver Resume (from PDF)
    final englishDriver = {
      ...driverResumeData,
      'title': 'Driver Profile (English)',
      'subtitle': 'Last edited: Oct 18, 2025',
    };

    // 2. Hindi Driver Resume (Simulated)
    final hindiDriver = {
      ...driverResumeData,
      'title': 'Driver Profile (Hindi)',
      'subtitle': 'Last edited: Oct 20, 2025',
      'fullName': 'राजेश कुमार सिंह', // Simulated
      'jobTitle': 'पेशेवर ड्राइवर', // Simulated
      'languages': ['Hindi', 'Marathi', 'English'],
    };

    // 3. Hindi Electrician Resume (Simulated, based on old data)
    final hindiElectrician = {
      'title': 'Electrician Profile (Hindi)',
      'subtitle': 'Last edited: Oct 21, 2025',
      'fullName': 'सुरेश पटेल',
      'jobTitle': 'इलेक्ट्रीशियन',
      'contact': {
        'phone': '+91 9876543210',
        'email': 'suresh.p@example.com',
        'location': 'भुवनेश्वर, ओडिशा'
      },
      'experience': [
        {
          'company': 'मेगा इलेक्ट्रिकल्स',
          'position': 'वरिष्ठ इलेक्ट्रीशियन',
          'duration': '2018-वर्तमान',
          'details': [
            'घरेलू और व्यावसायिक विद्युत स्थापना का निरीक्षण और मरम्मत',
            'नई वायरिंग सिस्टम की स्थापना और परीक्षण',
          ]
        },
      ],
      'skills': [
        'विद्युत स्थापना',
        'सर्किट विश्लेषण',
        'वायरिंग सिस्टम',
        'समस्या निवारण'
      ],
      'licenses': ['विद्युत कार्य लाइसेंस', 'उच्च वोल्टेज प्रमाणन'],
      'languages': ['Hindi', 'Odia', 'English'],
      'education': {
        'degree': 'ITI (Electrician)',
        'institution': 'Govt. ITI, Bhubaneswar',
        'year': '2014',
      },
      'summary': '6+ साल के अनुभव के साथ प्रमाणित इलेक्ट्रीशियन।',
    };

    return [englishDriver, hindiDriver, hindiElectrician];
  }

  // --- PDF Generation Function (Updated to be more robust) ---
  Future<void> _generatePdf(
      BuildContext context, Map<String, dynamic> resumeData) async {
    final pdf = pw.Document();
    pw.ThemeData myTheme;

    // Load fonts for multilingual support
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

    // Extract data safely
    final data = resumeData;
    final contact = data['contact'] as Map<String, dynamic>? ?? {};
    final education = data['education'] as Map<String, dynamic>? ?? {};
    final experience = data['experience'] as List? ?? [];
    final skills = data['skills'] as List? ?? [];
    final certifications = data['certifications'] as List? ?? [];

    pdf.addPage(
      pw.Page(
        theme: myTheme,
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- Header ---
              pw.Text(
                data['fullName']?.toString() ?? '',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              if ((data['jobTitle'] ?? '').toString().isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4.0, bottom: 8.0),
                  child: pw.Text(
                    data['jobTitle']?.toString() ?? '',
                    style:
                        const pw.TextStyle(fontSize: 16, color: PdfColors.grey),
                  ),
                ),

              // --- Contact ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  if ((contact['phone'] ?? '').toString().isNotEmpty)
                    pw.Text(contact['phone'].toString()),
                  if ((contact['email'] ?? '').toString().isNotEmpty)
                    pw.Text(contact['email'].toString()),
                  if ((contact['location'] ?? '').toString().isNotEmpty)
                    pw.Text(contact['location'].toString()),
                ],
              ),
              if ((data['license'] ?? '').toString().isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 4.0),
                  child: pw.Text(
                    'License: ${data['license']}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                ),

              // --- Summary ---
              if ((data['summary'] ?? '').toString().isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _buildPdfSection('Professional Summary', myTheme),
                pw.Text(data['summary'].toString()),
              ],

              // --- Skills ---
              if (skills.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _buildPdfSection('Core Skills', myTheme),
                pw.Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children:
                      skills.map((s) => pw.Text('• ${s.toString()}')).toList(),
                ),
              ],

              // --- Experience ---
              if (experience.isNotEmpty) ...[
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
                            padding:
                                const pw.EdgeInsets.symmetric(vertical: 2.0),
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
              ],

              // --- Education ---
              if (education.isNotEmpty) ...[
                pw.SizedBox(height: 12),
                _buildPdfSection('Education', myTheme),
                pw.Text(
                  education['degree']?.toString() ?? '',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(education['institution']?.toString() ?? ''),
                if ((education['year'] ?? '').toString().isNotEmpty)
                  pw.Text('Year: ${education['year']}'),
              ],

              // --- Certifications ---
              if (certifications.isNotEmpty) ...[
                // --- THIS IS THE FIX ---
                // Replaced the non-existent pw.SVGHidden with a standard pw.Column
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 12),
                    _buildPdfSection('Certifications & Licenses', myTheme),
                    ...certifications.map(
                      (l) => pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(vertical: 2.0),
                        child: pw.Text('• ${l.toString()}'),
                      ),
                    ),
                  ],
                ),
                // --- END OF FIX ---
              ],
            ],
          );
        },
      ),
    );

    // Show the PDF preview screen
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  // --- PDF Helper Widgets ---
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
    final List<Map<String, dynamic>> dummyResumes = _getDummyResumes();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Saved Resumes'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: dummyResumes.length,
        itemBuilder: (context, index) {
          final resume = dummyResumes[index];
          final displayTitle = resume['title']?.toString() ?? 'Resume';

          return _buildResumeCard(
            title: displayTitle,
            subtitle: resume['subtitle']?.toString() ?? '',
            onTap: () {
              // Call the PDF generation function
              _generatePdf(context, resume);
            },
          );
        },
      ),
    );
  }

  Widget _buildResumeCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    const Color color = Color(0xFF0056b3); // Dark blue
    final Color bgColor = Colors.blue[50]!; // Light blue

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 1.5,
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          leading: const Icon(
            Icons.article_rounded,
            color: color,
            size: 28,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: color,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(color: color.withOpacityCompat(0.7)),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_rounded,
            size: 16,
            color: color,
          ),
        ),
      ),
    );
  }
}
