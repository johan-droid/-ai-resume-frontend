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

  // --- Filter State Variables ---
  String _selectedJobProfile = 'Any';
  bool _isWorkFromHome = false;
  bool _isPartTime = false;
  String _selectedSalary = 'Any';
  String _selectedExperience = 'Any';

  // --- Filter Options ---
  final List<String> _jobProfileOptions = [
    'Any',
    'Driver',
    'Electrician',
    'Plumber',
    'Cook',
    'Security Guard',
    'Welder',
    'Carpenter',
    'Mechanic'
  ];
  final List<String> _salaryOptions = [
    'Any',
    'At least 2 lakhs',
    'At least 4 lakhs',
    'At least 6 lakhs'
  ];
  final List<String> _experienceOptions = [
    'Any',
    '0-2 years',
    '3-5 years',
    '6+ years'
  ];

  // --- Theme Colors (Indigo for Org) ---
  final Color _primaryColor = Colors.indigo.shade600;
  final Color _backgroundColor = Colors.indigo.shade50;

  @override
  void initState() {
    super.initState();
    _filterCandidates(); // Initial filter
  }

  void _filterCandidates() {
    List<Candidate> tempCandidates = dummyCandidates;

    // Job Profile
    if (_selectedJobProfile != 'Any') {
      tempCandidates = tempCandidates
          .where((c) => c.jobProfile == _selectedJobProfile)
          .toList();
    }

    // Work From Home
    if (_isWorkFromHome) {
      tempCandidates =
          tempCandidates.where((c) => c.isWorkFromHome == true).toList();
    }

    // Part-time
    if (_isPartTime) {
      tempCandidates =
          tempCandidates.where((c) => c.jobType == 'Part-time').toList();
    }

    // Salary
    if (_selectedSalary != 'Any') {
      int minSalary = 0;
      if (_selectedSalary == 'At least 2 lakhs') minSalary = 200000;
      if (_selectedSalary == 'At least 4 lakhs') minSalary = 400000;
      if (_selectedSalary == 'At least 6 lakhs') minSalary = 600000;
      tempCandidates =
          tempCandidates.where((c) => c.salary >= minSalary).toList();
    }

    // Experience
    if (_selectedExperience != 'Any') {
      if (_selectedExperience == '0-2 years') {
        tempCandidates =
            tempCandidates.where((c) => c.experience <= 2).toList();
      }
      if (_selectedExperience == '3-5 years') {
        tempCandidates = tempCandidates
            .where((c) => c.experience >= 3 && c.experience <= 5)
            .toList();
      }
      if (_selectedExperience == '6+ years') {
        tempCandidates =
            tempCandidates.where((c) => c.experience >= 6).toList();
      }
    }

    setState(() {
      _filteredCandidates = tempCandidates;
    });
  }

  void _showFilterSheet() {
    // Temporary states for the bottom sheet
    String tempProfile = _selectedJobProfile;
    bool tempWorkFromHome = _isWorkFromHome;
    bool tempPartTime = _isPartTime;
    String tempSalary = _selectedSalary;
    String tempExperience = _selectedExperience;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        // Use StatefulBuilder to manage the sheet's state independently
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24.0),
              height: MediaQuery.of(context).size.height * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filters',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      children: [
                        DropdownButtonFormField<String>(
                          initialValue: tempProfile,
                          decoration:
                              _buildInputDecoration('Job Role', null),
                          items: _jobProfileOptions.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setSheetState(() => tempProfile = newValue!);
                          },
                        ),
                        const SizedBox(height: 16),
                        CheckboxListTile(
                          title: const Text('Work from home'),
                          value: tempWorkFromHome,
                          onChanged: (bool? value) {
                            setSheetState(() => tempWorkFromHome = value!);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: const Text('Part-time'),
                          value: tempPartTime,
                          onChanged: (bool? value) {
                            setSheetState(() => tempPartTime = value!);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: tempSalary,
                          decoration: _buildInputDecoration(
                              'Annual salary (in lakhs)', null),
                          items: _salaryOptions.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setSheetState(() => tempSalary = newValue!);
                          },
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: tempExperience,
                          decoration: _buildInputDecoration(
                              'Years of experience', null),
                          items: _experienceOptions.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setSheetState(() => tempExperience = newValue!);
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            // Clear sheet state
                            setSheetState(() {
                              tempProfile = 'Any';
                              tempWorkFromHome = false;
                              tempPartTime = false;
                              tempSalary = 'Any';
                              tempExperience = 'Any';
                            });
                            // Clear main state and apply
                            setState(() {
                              _selectedJobProfile = 'Any';
                              _isWorkFromHome = false;
                              _isPartTime = false;
                              _selectedSalary = 'Any';
                              _selectedExperience = 'Any';
                            });
                            _filterCandidates();
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(0, 50),
                          ),
                          child: const Text('Clear All'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton(
                          onPressed: () {
                            // Apply filters to main state
                            setState(() {
                              _selectedJobProfile = tempProfile;
                              _isWorkFromHome = tempWorkFromHome;
                              _isPartTime = tempPartTime;
                              _selectedSalary = tempSalary;
                              _selectedExperience = tempExperience;
                            });
                            _filterCandidates(); // Re-run filter
                            Navigator.pop(context);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: _primaryColor,
                            minimumSize: const Size(0, 50),
                          ),
                          child: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Helper for filter input decoration
  InputDecoration _buildInputDecoration(String label, IconData? icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      filled: true,
      fillColor: _backgroundColor, // Light indigo fill
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none, // No border
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor, // Light indigo background
      appBar: AppBar(
        title: const Text('Find Candidates'),
        backgroundColor: _primaryColor, // Indigo AppBar
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          // --- THIS IS THE MODIFIED BUTTON ---
          IconButton(
            icon: const Icon(Icons.filter_list,
                color: Colors.white), // <-- ADDED COLOR
            onPressed: _showFilterSheet,
            tooltip: 'Filters',
          ),
          // --- END OF MODIFICATION ---
        ],
      ),
      body: Column(
        children: [
          // --- Candidate List ---
          Expanded(
            child: _filteredCandidates.isEmpty
                ? const Center(
                    child: Text(
                      'No candidates match your criteria.',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredCandidates.length,
                    itemBuilder: (context, index) {
                      final candidate = _filteredCandidates[index];
                      return _buildCandidateCard(candidate);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // --- This card matches your 'image_8d2f46.png' screenshot ---
  Widget _buildCandidateCard(Candidate candidate) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResumeDetailScreen(
                resumeData: candidate,
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
                      style: TextStyle(
                          color: _primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(candidate.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(candidate.jobProfile,
                            style: TextStyle(
                                fontSize: 15, color: Colors.grey[700])),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 16, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(candidate.location,
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(width: 12),
                  Icon(Icons.business_center_outlined,
                      size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text('${candidate.experience} yrs exp.',
                      style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              if (candidate.skills.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6.0,
                  runSpacing: 4.0,
                  children: candidate.skills
                      .take(3)
                      .map((skill) => Chip(
                            label: Text(skill),
                            backgroundColor: _backgroundColor,
                            labelStyle: TextStyle(
                                fontSize: 12, color: _primaryColor),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 0),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ))
                      .toList(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}