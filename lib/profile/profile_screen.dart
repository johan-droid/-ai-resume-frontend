// lib/profile/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:rezume_app/utils/color_extensions.dart';
import 'package:rezume_app/screens/auth/login_screen.dart';
import 'package:rezume_app/profile/help_center_screen.dart';
import 'package:rezume_app/profile/edit_profile_screen.dart';
import 'package:rezume_app/profile/saved_resumes_screen.dart';
import 'package:rezume_app/profile/org_edit_profile_screen.dart';
// --- IMPORT THE NEWLY CREATED LIST SCREEN ---
import 'package:rezume_app/profile/posted_jobs_screen.dart';
// --- (The import for CreateJobScreen is no longer needed here) ---
// import 'package:rezume_app/profile/create_job_screen.dart';

// --- *** IMPORT THE NEW JOB SEARCH SCREEN *** ---
import 'package:rezume_app/profile/user_job_search_screen.dart';
import 'package:rezume_app/subscription/subscription_page.dart';

class ProfileScreen extends StatefulWidget {
  final String role; // 'User' or 'Organization'

  const ProfileScreen({super.key, required this.role});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // --- Theme Colors ---
  final Color _userPrimaryColor = Color(0xFF007BFF);
  final Color _orgPrimaryColor = Colors.indigo.shade600;

  // Helper getter for current theme color
  Color get _currentPrimaryColor =>
      widget.role == 'User' ? _userPrimaryColor : _orgPrimaryColor;

  // Dummy Data
  String _profileName = '';
  String _profileContact = '';
  String _profileAvatarText = '';
  String _profileEmail = '';

  @override
  void initState() {
    super.initState();
    _setProfileData();
  }

  void _setProfileData() {
    if (widget.role == 'User') {
      _profileName = 'John Doe';
      _profileContact = '+91 98765 43210';
      _profileAvatarText = 'J';
    } else {
      _profileName = 'Acme Corp';
      _profileContact = 'acmecorp@example.com';
      _profileAvatarText = 'A';
      _profileEmail = 'acmecorp@example.com';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text(
            widget.role == 'User' ? 'Your Profile' : 'Organization Profile'),
        backgroundColor: _currentPrimaryColor,
        elevation: 0,
        automaticallyImplyLeading: false, // Removed back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // --- Profile Header (Avatar, Name, Contact) ---
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor:
                        _currentPrimaryColor.withOpacityCompat(0.1),
                    child: Text(
                      _profileAvatarText,
                      style: TextStyle(
                          fontSize: 48,
                          color: _currentPrimaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(_profileName,
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(_profileContact,
                      style: TextStyle(fontSize: 16, color: Colors.grey[700])),
                ],
              ),
            ),

            // --- Profile Action Buttons (Reordered) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // 1. Edit Profile (Same as before)
                  _buildProfileOption(
                    icon: Icons.person_outline_rounded,
                    title: 'Edit Profile',
                    onTap: () {
                      if (widget.role == 'User') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrgEditProfileScreen(
                              orgName: _profileName,
                              orgEmail: _profileEmail,
                              themeColor: _currentPrimaryColor,
                              onProfileUpdated: (newName, newEmail) {
                                setState(() {
                                  _profileName = newName;
                                  _profileEmail = newEmail;
                                  _profileContact = newEmail;
                                });
                              },
                            ),
                          ),
                        );
                      }
                    },
                    color: _currentPrimaryColor,
                  ),
                  const SizedBox(height: 12),

                  // --- 2. ACTIVE PLAN (Organization Only, using standard button) ---
                  if (widget.role == 'Organization') ...[
                    _buildProfileOption(
                      icon: Icons.subscriptions_outlined,
                      title: 'Active Plan',
                      subtitle: 'Standard Hirer',
                      onTap: () {
                        _showActivePlanDialog(context, 'Standard Hirer');
                      },
                      color: _currentPrimaryColor,
                    ),
                    const SizedBox(height: 12),
                  ],
                  // --- END ACTIVE PLAN ---

                  // 3. Conditional Options based on role (Resume/Jobs)
                  if (widget.role == 'User') ...[
                    _buildProfileOption(
                      icon: Icons.article_outlined,
                      title: 'My Saved Resumes',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedResumesScreen(),
                          ),
                        );
                      },
                      color: _currentPrimaryColor,
                    ),
                    const SizedBox(height: 12),
                    _buildProfileOption(
                      icon: Icons.work_outline_rounded,
                      title: 'Apply for Jobs',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserJobSearchScreen(),
                          ),
                        );
                      },
                      color: _currentPrimaryColor,
                    ),
                    const SizedBox(height: 12),
                  ] else ...[
                    _buildProfileOption(
                      icon: Icons.add_business_rounded,
                      title: 'Create Job',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostedJobsScreen(
                                themeColor: _currentPrimaryColor),
                          ),
                        );
                      },
                      color: _currentPrimaryColor,
                    ),
                    const SizedBox(height: 12),
                  ],

                  // 4. Help Center
                  _buildProfileOption(
                    icon: Icons.help_outline_rounded,
                    title: 'Help Center',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HelpCenterScreen()),
                      );
                    },
                    color: _currentPrimaryColor,
                  ),
                  const SizedBox(height: 12),

                  // 5. Logout
                  _buildProfileOption(
                    icon: Icons.logout_rounded,
                    title: 'Logout',
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      );
                    },
                    color: Colors.red.shade600,
                    isLogout: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required Color color,
    bool isLogout = false,
  }) {
    final Color bgColor =
        isLogout ? Colors.red.shade50 : color.withOpacityCompat(0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        tileColor: bgColor, // Set a subtle background color
        leading: Icon(icon, color: color, size: 24),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                    color: color.withAlpha((0.7 * 255).round()), fontSize: 14),
              )
            : null,
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: color,
        ),
      ),
    );
  }

  // --- ADD THIS DIALOG FUNCTION ---
  void _showActivePlanDialog(BuildContext context, String planName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.subscriptions_outlined, color: _currentPrimaryColor),
              const SizedBox(width: 10),
              const Text('Your Active Plan'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                planName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _currentPrimaryColor),
              ),
              const SizedBox(height: 15),
              const Text('This is your current subscription.'),
              const SizedBox(height: 8),
              Text('Renews on: Nov 30, 2025 (Dummy)',
                  style: TextStyle(color: Colors.grey[600])),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Go to Subscription Page'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SubscriptionPage()));
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
