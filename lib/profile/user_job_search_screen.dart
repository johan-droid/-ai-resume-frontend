// lib/profile/user_job_search_screen.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting currency
import 'package:rezume_app/models/dummy_jobs.dart'; // Import our new dummy jobs
import 'package:rezume_app/profile/job_application_screen.dart'; // Import the application screen

class UserJobSearchScreen extends StatefulWidget {
  const UserJobSearchScreen({super.key});

  @override
  State<UserJobSearchScreen> createState() => _UserJobSearchScreenState();
}

class _UserJobSearchScreenState extends State<UserJobSearchScreen> {
  List<SearchableJob> _filteredJobs = dummyJobs;
  final _numberFormat = NumberFormat.compact(locale: 'en_IN');

  // --- Filter State Variables (from candidate_list_screen.dart) ---
  String _selectedJobProfile = 'Any';
  bool _isWorkFromHome = false;
  bool _isPartTime = false;
  String _selectedSalary = 'Any';
  String _selectedExperience = 'Any';
  String _selectedLocation = 'Any';

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
  final List<String> _locationOptions = [
    'Any',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Rourkela',
    'Kolkata',
    'Chennai',
    'Hyderabad',
    'Pune'
  ];

  // --- Theme Colors (User) ---
  final Color _primaryColor = Color(0xFF007BFF);
  final Color _backgroundColor = Color(0xFFF0F8FF);

  @override
  void initState() {
    super.initState();
    _filterJobs(); // Initial filter
  }

  // --- Filtering Logic (adapted from candidate_list_screen.dart) ---
  void _filterJobs() {
    List<SearchableJob> tempJobs = dummyJobs;

    // Job Profile
    if (_selectedJobProfile != 'Any') {
      tempJobs =
          tempJobs.where((j) => j.role == _selectedJobProfile).toList();
    }

    // Location
    if (_selectedLocation != 'Any') {
      tempJobs =
          tempJobs.where((j) => j.location == _selectedLocation).toList();
    }

    // Work From Home
    if (_isWorkFromHome) {
      tempJobs = tempJobs.where((j) => j.isWorkFromHome == true).toList();
    }

    // Part-time
    if (_isPartTime) {
      tempJobs = tempJobs.where((j) => j.jobType == 'Part-time').toList();
    }

    // Salary
    if (_selectedSalary != 'Any') {
      int minSalary = 0;
      if (_selectedSalary == 'At least 2 lakhs') minSalary = 200000;
      if (_selectedSalary == 'At least 4 lakhs') minSalary = 400000;
      if (_selectedSalary == 'At least 6 lakhs') minSalary = 600000;
      tempJobs = tempJobs.where((j) => j.salaryMin >= minSalary).toList();
    }

    // Experience
    if (_selectedExperience != 'Any') {
      if (_selectedExperience == '0-2 years') {
        tempJobs =
            tempJobs.where((j) => j.experienceRequired <= 2).toList();
      }
      if (_selectedExperience == '3-5 years') {
        tempJobs = tempJobs
            .where((j) =>
                j.experienceRequired >= 3 && j.experienceRequired <= 5)
            .toList();
      }
      if (_selectedExperience == '6+ years') {
        tempJobs = tempJobs.where((j) => j.experienceRequired >= 6).toList();
      }
    }

    setState(() {
      _filteredJobs = tempJobs;
    });
  }

  // --- Filter Sheet (adapted from candidate_list_screen.dart) ---
  void _showFilterSheet() {
    String tempProfile = _selectedJobProfile;
    String tempLocation = _selectedLocation;
    bool tempWorkFromHome = _isWorkFromHome;
    bool tempPartTime = _isPartTime;
    String tempSalary = _selectedSalary;
    String tempExperience = _selectedExperience;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setSheetState) {
            return Container(
              padding: const EdgeInsets.all(24.0),
              height: MediaQuery.of(context).size.height * 0.8,
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
                        // Job Role
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
                        // Location
                        DropdownButtonFormField<String>(
                          initialValue: tempLocation,
                          decoration:
                              _buildInputDecoration('Location', null),
                          items: _locationOptions.map((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                          onChanged: (String? newValue) {
                            setSheetState(() => tempLocation = newValue!);
                          },
                        ),
                        const SizedBox(height: 16),
                        // Checkboxes
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
                        // Salary
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
                        // Experience
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
                  // Bottom Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setSheetState(() {
                              tempProfile = 'Any';
                              tempLocation = 'Any';
                              tempWorkFromHome = false;
                              tempPartTime = false;
                              tempSalary = 'Any';
                              tempExperience = 'Any';
                            });
                            setState(() {
                              _selectedJobProfile = 'Any';
                              _selectedLocation = 'Any';
                              _isWorkFromHome = false;
                              _isPartTime = false;
                              _selectedSalary = 'Any';
                              _selectedExperience = 'Any';
                            });
                            _filterJobs();
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
                            setState(() {
                              _selectedJobProfile = tempProfile;
                              _selectedLocation = tempLocation;
                              _isWorkFromHome = tempWorkFromHome;
                              _isPartTime = tempPartTime;
                              _selectedSalary = tempSalary;
                              _selectedExperience = tempExperience;
                            });
                            _filterJobs();
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
      fillColor: _backgroundColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Find a Job'),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
            tooltip: 'Filters',
          ),
        ],
      ),
      body: _filteredJobs.isEmpty
          ? const Center(
              child: Text(
                'No jobs match your criteria.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _filteredJobs.length,
              itemBuilder: (context, index) {
                final job = _filteredJobs[index];
                return _buildJobCard(job);
              },
            ),
    );
  }

  // --- New Job Card Widget (styled like image_814ea2.png) ---
  Widget _buildJobCard(SearchableJob job) {
    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // --- NAVIGATE TO THE APPLICATION SCREEN ---
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JobApplicationScreen(job: job),
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
                    child: Icon(job.logo, color: _primaryColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(job.role,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(job.companyName,
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
              _buildInfoChip(
                  Icons.location_on_outlined, job.location, Colors.grey[600]!),
              if (job.isWorkFromHome)
                _buildInfoChip(
                    Icons.home_work_outlined, 'Work from home', Colors.grey[600]!),
              _buildInfoChip(
                  Icons.currency_rupee_rounded,
                  '₹${_numberFormat.format(job.salaryMin)} - ₹${_numberFormat.format(job.salaryMax)} /year',
                  Colors.grey[600]!),
              _buildInfoChip(Icons.business_center_outlined,
                  '${job.experienceRequired} year(s)', Colors.grey[600]!),
              const SizedBox(height: 8),
              Text(
                job.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[800]),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTagChip(job.postedAgo, Colors.green),
                  _buildTagChip(job.jobType, Colors.blue),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(text, style: TextStyle(color: color, fontSize: 14)),
        ],
      ),
    );
  }

  // --- *** THIS IS THE FIX *** ---
  Widget _buildTagChip(String text, MaterialColor color) { // <-- FIX: Changed Color to MaterialColor
  // --- *** END OF FIX *** ---
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style:
            TextStyle(color: color.shade700, fontWeight: FontWeight.w500),
      ),
    );
  }
}