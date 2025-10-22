// lib/profile/candidate_list_screen.dart

import 'package:flutter/material.dart';
import 'package:rezume_app/models/dummy_candidates.dart';
import 'package:rezume_app/profile/resume_detail_screen.dart';

class CandidateListScreen extends StatefulWidget {
  const CandidateListScreen({super.key});

  @override
  State<CandidateListScreen> createState() => _CandidateListScreenState();
}

class _CandidateListScreenState extends State<CandidateListScreen> {
  List<Candidate> _filteredCandidates = dummyCandidates;
  String? _selectedJobProfile;

  final List<String> _jobProfiles = ['All', 'Driver', 'Electrician', 'Plumber', 'Cook', 'Security Guard', 'Welder', 'Carpenter', 'Mechanic'];

  // --- Theme Colors (Indigo for Org) ---
  final Color _primaryColor = Colors.indigo.shade600;
  final Color _backgroundColor = Colors.indigo.shade50;

  @override
  void initState() {
    super.initState();
    _selectedJobProfile = _jobProfiles.first;
  }

  void _filterCandidates(String? profile) {
    setState(() {
      _selectedJobProfile = profile;
      if (profile == null || profile == 'All') {
        _filteredCandidates = dummyCandidates;
      } else {
        _filteredCandidates = dummyCandidates.where((c) => c.jobProfile == profile).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Light indigo background
      appBar: AppBar(
        title: const Text('Find Candidates'),
        backgroundColor: _primaryColor, // Indigo AppBar
        elevation: 0, // Flat design
        automaticallyImplyLeading: false, // Remove back button if it's a main tab
      ),
      body: Column(
        children: [
          // --- Enhanced Filter Section ---
          Container(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 12.0),
            color: Colors.white, // White background for filter area
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedJobProfile,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: _backgroundColor, // Light indigo fill
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      labelText: 'Filter by Job Profile',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none, // No border
                      ),
                    ),
                    items: _jobProfiles.map((String profile) {
                      return DropdownMenuItem<String>(value: profile, child: Text(profile));
                    }).toList(),
                    onChanged: (String? newValue) {
                      _filterCandidates(newValue);
                    },
                  ),
                ),
                // Optional: Add more filter buttons here (e.g., location)
                // IconButton(onPressed: (){}, icon: Icon(Icons.filter_list))
              ],
            ),
          ),

          // --- Candidate List ---
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredCandidates.length,
              itemBuilder: (context, index) {
                final candidate = _filteredCandidates[index];
                return _buildCandidateCard(candidate); // Use the redesigned card
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- REDESIGNED Candidate Card Widget ---
  Widget _buildCandidateCard(Candidate candidate) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell( // Make the whole card tappable
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResumeDetailScreen(
                resumeData: candidate, // Changed from candidate: candidate
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: _primaryColor.withOpacity(0.1),
                    child: Text(
                      candidate.name.substring(0, 1),
                      style: TextStyle(color: _primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(candidate.name, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(candidate.jobProfile, style: TextStyle(fontSize: 15, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                ],
              ),
              SizedBox(height: 12),
              // Add more details like location, experience, skills highlights
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(candidate.location, style: TextStyle(color: Colors.grey[600])),
                  SizedBox(width: 12),
                  Icon(Icons.business_center_outlined, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text('${candidate.experience} yrs exp.', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              if (candidate.skills.isNotEmpty) ...[
                SizedBox(height: 8),
                Wrap( // Display skills neatly
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: candidate.skills.take(3).map((skill) => Chip( // Show max 3 skills
                    label: Text(skill),
                    backgroundColor: _backgroundColor,
                    labelStyle: TextStyle(fontSize: 12, color: _primaryColor),
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  )).toList(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
