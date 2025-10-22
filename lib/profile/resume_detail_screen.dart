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
    final dynamic s = src;
    return {
      'title': s['title'] ?? s.title ?? s.jobProfile ?? '',
      'subtitle': s['subtitle'] ?? '',
      'fullName': s['fullName'] ?? s.name ?? '',
      'jobTitle': s['jobTitle'] ?? s.jobProfile ?? '',
      'contact': s['contact'] ??
          {
            'phone': s.phone ?? '',
            'email': s.email ?? '',
            'location': s.location ?? ''
          },
      'experience': s['experience'] ?? [],
      'skills': s['skills'] ?? [],
      'licenses': s['licenses'] ?? [],
      'languages': s['languages'] ?? [],
    };
  }

  @override
  Widget build(BuildContext context) {
    final data = _toMap(resumeData);

    return Scaffold(
      appBar: AppBar(
        title: Text(data['title']?.toString() ?? 'Resume'),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Header
          Text(
            data['fullName']?.toString() ?? '',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          if ((data['jobTitle'] ?? '').toString().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0, bottom: 12.0),
              child: Text(
                data['jobTitle']?.toString() ?? '',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),

          // Contact card (safe access)
          if (data['contact'] is Map)
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    if ((data['contact']['phone'] ?? '').toString().isNotEmpty)
                      Row(children: [
                        const Icon(Icons.phone, size: 18, color: Color(0xFF0056b3)),
                        const SizedBox(width: 8),
                        Text(data['contact']['phone'].toString()),
                      ]),
                    if ((data['contact']['email'] ?? '').toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(children: [
                          const Icon(Icons.email, size: 18, color: Color(0xFF0056b3)),
                          const SizedBox(width: 8),
                          Text(data['contact']['email'].toString()),
                        ]),
                      ),
                    if ((data['contact']['location'] ?? '').toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Row(children: [
                          const Icon(Icons.location_on, size: 18, color: Color(0xFF0056b3)),
                          const SizedBox(width: 8),
                          Text(data['contact']['location'].toString()),
                        ]),
                      ),
                  ],
                ),
              ),
            ),

          const SizedBox(height: 12),

          // Experience
          if ((data['experience'] as List).isNotEmpty) ...[
            const Text('Experience', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...((data['experience'] as List).map((exp) {
              final Map<String, dynamic> e = exp is Map<String, dynamic> ? exp : {};
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if ((e['company'] ?? '').toString().isNotEmpty)
                      Text(e['company'].toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    if ((e['position'] ?? '').toString().isNotEmpty)
                      Text('${e['position'] ?? ''} ${e['duration'] != null ? '(${e['duration']})' : ''}', style: const TextStyle(color: Colors.black54)),
                    if ((e['details'] ?? []).isNotEmpty)
                      const SizedBox(height: 8),
                    if ((e['details'] ?? []).isNotEmpty)
                      ...((e['details'] as List).map((d) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              const Text('• ', style: TextStyle(fontSize: 16)),
                              Expanded(child: Text(d.toString())),
                            ]),
                          ))),
                  ]),
                ),
              );
            })).toList(),
          ],

          // Skills
          if ((data['skills'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Skills', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(spacing: 8.0, runSpacing: 8.0, children: (data['skills'] as List).map((s) => Chip(label: Text(s.toString()), backgroundColor: Colors.blue[50], labelStyle: const TextStyle(color: Color(0xFF0056b3)))).toList()),
          ],

          // Licenses
          if ((data['licenses'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Licenses & Certifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: (data['licenses'] as List).map((l) => Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: Text('• ${l.toString()}'))).toList())
          ],

          // Languages
          if ((data['languages'] as List).isNotEmpty) ...[
            const SizedBox(height: 12),
            const Text('Languages', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(spacing: 8.0, children: (data['languages'] as List).map((l) => Chip(label: Text(l.toString()), backgroundColor: Colors.blue[50], labelStyle: const TextStyle(color: Color(0xFF0056b3)))).toList()),
          ],
        ]),
      ),
    );
  }
}
