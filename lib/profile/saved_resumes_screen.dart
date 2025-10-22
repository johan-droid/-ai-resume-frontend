// lib/profile/saved_resumes_screen.dart

import 'package:flutter/material.dart';
import 'package:rezume_app/profile/resume_detail_screen.dart';  // Fixed import path

class SavedResumesScreen extends StatelessWidget {
  const SavedResumesScreen({super.key});

  // --- Updated Dummy Resume Data with full details ---
  final List<Map<String, dynamic>> dummyResumes = const [
    {
      'title': 'Driver Profile (Eng)', // Changed to Driver Profile (Eng)
      'subtitle': 'Last edited: Oct 18, 2025',
      'fullName': 'Rajesh Kumar',
      'jobTitle': 'Professional Driver',
      'contact': {
        'phone': '+91 9876543210',
        'email': 'rajesh.k@email.com',
        'location': 'Bhubaneswar, Odisha'
      },
      'experience': [
        {
          'company': 'ABC Logistics',
          'position': 'Senior Driver',
          'duration': '2020-Present',
          'details': [
            'Managed daily delivery routes covering 200+ km',
            'Maintained perfect safety record for 5 years',
            'Trained 10+ new drivers on safety protocols'
          ]
        },
        {
          'company': 'XYZ Transport',
          'position': 'Commercial Driver',
          'duration': '2015-2020',
          'details': [
            'Operated heavy vehicles for interstate deliveries',
            'Received "Best Driver" award in 2018',
            'Reduced fuel consumption by 15%'
          ]
        }
      ],
      'skills': [
        'Commercial Vehicle Operation',
        'Route Optimization',
        'Vehicle Maintenance',
        'Safety Protocols',
        'GPS Navigation',
        'Loading/Unloading',
      ],
      'licenses': [
        'Commercial Driver\'s License (CDL)',
        'Hazardous Materials Endorsement',
        'Clean Driving Record'
      ],
      // Make English first so display shows (English) / (Eng)
      'languages': ['English', 'Odia', 'Hindi'],
    },
    // New Hindi resume entry
    {
      'title': 'Driver Profile (Hin)',
      'subtitle': 'Last edited: Oct 20, 2025',
      'fullName': 'रामनाथ सिंह',
      'jobTitle': 'पेशेवर ड्राइवर',
      'contact': {
        'phone': '+91 9123456780',
        'email': 'ramnath.s@example.com',
        'location': 'Cuttack, Odisha'
      },
      'experience': [
        {
          'company': 'लोकल ट्रांसपोर्ट सर्विसेज',
          'position': 'सीनियर ड्राइवर',
          'duration': '2019-प्रesent',
          'details': [
            'दैनन्दिन डिलीवरी रूट्स का संचालन और प्रबंधन',
            'वाहन की नियमित देखभाल और सुरक्षा जांच करना',
            'नए ड्राइवरों को प्रशिक्षण दिया और सुरक्षा प्रोटोकॉल लागू किए'
          ]
        },
        {
          'company': 'नगरिक लॉजिस्टिक्स',
          'position': 'कमर्शियल ड्राइवर',
          'duration': '2014-2019',
          'details': [
            'अंतर-राज्यीय परिवहन के लिए भारी वाहन संचालित किए',
            'समय पर डिलीवरी सुनिश्चित करने के लिए रूट योजना में सुधार किया'
          ]
        }
      ],
      'skills': [
        'कमर्शियल वाहन संचालन',
        'रूट ऑप्टिमाइज़ेशन',
        'वाहन रखरखाव',
        'सुरक्षा प्रोटोकॉल',
        'GPS नेविगेशन'
      ],
      'licenses': [
        'वाणिज्यिक ड्राइवर लाइसेंस (CDL)',
        'स्वच्छ ड्राइविंग रिकॉर्ड'
      ],
      'languages': ['Hindi', 'Odia', 'English'],
    },
    {
      'title': 'Electrician Profile (Hin)',  // New electrician profile
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
            '10+ जूनियर इलेक्ट्रीशियन का मार्गदर्शन किया'
          ]
        },
        {
          'company': 'शक्ति इलेक्ट्रिकल्स',
          'position': 'इलेक्ट्रीशियन',
          'duration': '2015-2018',
          'details': [
            'इलेक्ट्रिकल सर्किट और उपकरणों की मरम्मत और रखरखाव',
            'सुरक्षा मानकों का पालन करते हुए समस्या समाधान',
            'ग्राहक सेवा और तकनीकी सहायता प्रदान की'
          ]
        }
      ],
      'skills': [
        'विद्युत स्थापना',
        'सर्किट विश्लेषण',
        'वायरिंग सिस्टम',
        'समस्या निवारण',
        'सुरक्षा प्रोटोकॉल',
        'उपकरण रखरखाव'
      ],
      'licenses': [
        'विद्युत कार्य लाइसेंस',
        'उच्च वोल्टेज प्रमाणन',
        'सुरक्षा प्रमाणपत्र'
      ],
      'languages': ['Hindi', 'Odia', 'English'],
    },
    // ... keep any other existing resumes ...
  ];

  @override
  Widget build(BuildContext context) {
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
          final rawTitle = resume['title']?.toString() ?? '';

          // base title without any parenthetical part
          final baseTitle =
              rawTitle.replaceAll(RegExp(r'\s*\(.*?\)\s*'), '').trim();

          // determine language: prefer resume['languages'] first entry, fallback to parenthetical token
          String language = '';
          if (resume['languages'] is List && (resume['languages'] as List).isNotEmpty) {
            language = (resume['languages'] as List).first.toString();
          } else {
            final m = RegExp(r'\((.*?)\)').firstMatch(rawTitle);
            if (m != null) {
              final token = m.group(1)!.toLowerCase();
              if (token.contains('hin') || token.contains('hindi')) language = 'Hindi';
              else if (token.contains('eng') || token.contains('english')) language = 'English';
              else if (token.contains('odia') || token.contains('oriya')) language = 'Odia';
              else language = token[0].toUpperCase() + token.substring(1);
            }
          }

          final displayTitle = language.isNotEmpty ? '$baseTitle (${language.trim()})' : baseTitle;

          // pass a copy with cleaned title so detail screen shows the cleaned value
          final cleanedResume = Map<String, dynamic>.from(resume)
            ..['title'] = displayTitle;

          return _buildResumeCard(
            title: displayTitle,
            subtitle: resume['subtitle'] ?? '',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumeDetailScreen(
                    resumeData: cleanedResume,
                  ),
                ),
              );
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
          // We use a resume icon for all of them
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
            style: TextStyle(color: color.withOpacity(0.7)),
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
