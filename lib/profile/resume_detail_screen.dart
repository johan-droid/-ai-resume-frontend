// lib/profile/resume_detail_screen.dart

import 'package:flutter/material.dart';

class ResumeDetailScreen extends StatelessWidget {
  final dynamic resumeData; // accept Map or Candidate object

  const ResumeDetailScreen({
    super.key,
    required this.resumeData,
  });

  Map<String, dynamic> _toMap(dynamic src) {
    if (src is Map<String, dynamic>) return src;
    
    // fall back to dynamic-field access for Candidate object
    // We know 'src' is a 'Candidate' object, so we cast it to dynamic
    final dynamic s = src;
    
    return {
      'title': s.jobProfile ?? '',
      // 'subtitle': s.subtitle ?? '', // This was the original error
      'fullName': s.name ?? '',
      'jobTitle': s.jobProfile ?? '',
      'contact': {
        // --- FIX: Candidate object does not have 'phone'. Provide safe fallback. ---
        'phone': '', // Candidate object does not have a phone field
        'email': s.email ?? '', // This field exists
        'location': s.location ?? '' // This field exists
      },
      'experience': s.experience != null
          // --- FIX: Made text clearer ---
          ? [{'position': '${s.experience} years total experience'}] 
          : [],
      'skills': s.skills ?? [], // This field exists
      
      // --- FIX: 'licenses' and 'languages' do not exist on the Candidate object. ---
      'licenses': [], // Provide an empty list fallback
      'languages': [], // Provide an empty list fallback
      
      'achievements': s.achievements ?? [], // This field exists
      'qualification': s.qualification ?? '', // This field exists
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _toMap(resumeData);
    final bool isFromCandidate = resumeData is! Map;

    return Scaffold(
      appBar: AppBar(
        title: Text(data['fullName']?.toString() ?? 'Resume'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      // --- WRAP body in Column ---
      body: Column(
        children: [
          // --- MAKE SingleChildScrollView EXPANDED ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    data['fullName']?.toString() ?? '',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  if ((data['jobTitle'] ?? '').toString().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
                      child: Text(
                        data['jobTitle']?.toString() ?? '',
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                    ),

                  // Contact card
                  if (data['contact'] is Map)
                    Card(
                      color: Colors.indigo[50],
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            if ((data['contact']['phone'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Row(children: [
                                const Icon(Icons.phone,
                                    size: 18, color: Colors.indigo),
                                const SizedBox(width: 8),
                                Text(data['contact']['phone'].toString()),
                              ]),
                            if ((data['contact']['email'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Row(children: [
                                  const Icon(Icons.email,
                                      size: 18, color: Colors.indigo),
                                  const SizedBox(width: 8),
                                  Text(data['contact']['email'].toString()),
                                ]),
                              ),
                            if ((data['contact']['location'] ?? '')
                                .toString()
                                .isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Row(children: [
                                  const Icon(Icons.location_on,
                                      size: 18, color: Colors.indigo),
                                  const SizedBox(width: 8),
                                  Text(data['contact']['location'].toString()),
                                ]),
                              ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),

                  // Qualification
                  if ((data['qualification'] ?? '').toString().isNotEmpty) ...[
                    const Text('Qualification',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(data['qualification'].toString(),
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),
                  ],

                  // Experience
                  if ((data['experience'] as List).isNotEmpty) ...[
                    const Text('Experience',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...((data['experience'] as List).map((exp) {
                      final Map<String, dynamic> e =
                          exp is Map<String, dynamic> ? exp : {};
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if ((e['company'] ?? '').toString().isNotEmpty)
                                  Text(e['company'].toString(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold)),
                                if ((e['position'] ?? '').toString().isNotEmpty)
                                  Text(
                                      '${e['position'] ?? ''} ${e['duration'] != null ? '(${e['duration']})' : ''}',
                                      style: const TextStyle(
                                          color: Colors.black54)),
                                if ((e['details'] ?? []).isNotEmpty)
                                  const SizedBox(height: 8),
                                if ((e['details'] ?? []).isNotEmpty)
                                  ...((e['details'] as List)
                                      .map((d) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text('• ',
                                                      style: TextStyle(
                                                          fontSize: 16)),
                                                  Expanded(
                                                      child: Text(d.toString())),
                                                ]),
                                          ))),
                              ]),
                        ),
                      );
                    })).toList(),
                  ],

                  // Achievements (Only for Candidate object)
                  if ((data['achievements'] as List).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Achievements',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (data['achievements'] as List)
                            .map((l) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4.0),
                                      child: Icon(Icons.star,
                                          size: 14, color: Colors.amber),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(l.toString())),
                                  ],
                                )))
                            .toList())
                  ],

                  // Skills
                  if ((data['skills'] as List).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Skills',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: (data['skills'] as List)
                            .map((s) => Chip(
                                label: Text(s.toString()),
                                backgroundColor: Colors.indigo[50],
                                labelStyle:
                                    const TextStyle(color: Colors.indigo)))
                            .toList()),
                  ],

                  // Licenses
                  if ((data['licenses'] as List).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Licenses & Certifications',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: (data['licenses'] as List)
                            .map((l) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text('• ${l.toString()}')))
                            .toList())
                  ],

                  // Languages
                  if ((data['languages'] as List).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('Languages',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                        spacing: 8.0,
                        children: (data['languages'] as List)
                            .map((l) => Chip(
                                label: Text(l.toString()),
                                backgroundColor: Colors.indigo[50],
                                labelStyle:
                                    const TextStyle(color: Colors.indigo)))
                            .toList()),
                  ],
                ],
              ),
            ),
          ),

          // --- Accept/Reject Button Bar ---
          if (isFromCandidate)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Candidate Rejected'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Candidate Accepted'),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}