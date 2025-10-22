import 'package:flutter/material.dart';
import 'package:rezume_app/app/localization/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  final String role; // 'User' or 'Organization'
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, required this.role, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Add language selection and video state
  String? _selectedLanguage;
  final List<Map<String, dynamic>> _languageOptions = [
    {
      'code': 'en',
      'name': 'English',
      'videoAsset': 'assets/videos/tutorial_en.mp4',
    },
    {
      'code': 'hi',
      'name': 'हिंदी (Hindi)',
      'videoAsset': 'assets/videos/tutorial_hi.mp4',
    },
    {
      'code': 'or',
      'name': 'ଓଡ଼ିଆ (Odia)',
      'videoAsset': 'assets/videos/tutorial_or.mp4',
    },
  ];

  // --- Define Color Themes ---
  final Color _userPrimaryColor = Color(0xFF007BFF); // Blue (no change)

  // --- NEW INDIGO COLORS ---
  final Color _orgPrimaryColor = Colors.indigo.shade600; // New Indigo
  final Color _orgBackgroundColor = Colors.indigo.shade50; // New Light Indigo
  // --- END OF NEW COLORS ---

  // --- Helper getters for current theme based on widget.role ---
  Color get _currentPrimaryColor =>
      widget.role == 'User' ? _userPrimaryColor : _orgPrimaryColor;
  Color get _currentBackgroundColor =>
      widget.role == 'User' ? Color(0xFFF0F8FF) : _orgBackgroundColor;

  @override
  Widget build(BuildContext context) {
    // Get localizations
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _currentBackgroundColor,
      appBar: AppBar(
        title: Text(widget.role == 'User' 
            ? (loc?.translate('home') ?? 'Dashboard') 
            : 'Organization Dashboard'),
        backgroundColor: _currentPrimaryColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Header Text ---
              Text(
                widget.role == 'User' 
                    ? (loc?.translate('howToGetStarted') ?? 'How to Get Started') 
                    : 'Find Top Talent',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 20),

              // Language Selection Section
              if (_selectedLanguage == null) ...[
                const Text(
                  'Select Your Language',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _languageOptions.length,
                  itemBuilder: (context, index) {
                    final lang = _languageOptions[index];
                    return _buildLanguageCard(
                      name: lang['name'],
                      code: lang['code'],
                      onTap: () => setState(() => _selectedLanguage = lang['code']),
                    );
                  },
                ),
              ] else ...[
                // Video Player Section with Language Indicator
                Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.play_circle_fill_rounded,
                          color: Colors.white.withOpacity(0.8),
                          size: 60,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _getLanguageName(_selectedLanguage!),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            InkWell(
                              onTap: () => setState(() => _selectedLanguage = null),
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // --- Conditional Features/Suggestions Section ---
                if (widget.role == 'User') ...[
                  // --- User Features ---
                  _buildFeatureCard(
                    icon: Icons.article_rounded,
                    title: loc?.translate('step1Title') ?? 'Step 1: Choose a Template',
                    subtitle: loc?.translate('step1Subtitle') ?? 'Pick a professional template that fits your style.',
                    onTap: () { /* Navigate to Templates */ },
                  ),
                  _buildFeatureCard(
                    icon: Icons.auto_awesome_rounded,
                    title: loc?.translate('step2Title') ?? 'Step 2: Fill in Details with AI',
                    subtitle: loc?.translate('step2Subtitle') ?? 'Use our AI assistant to help you write details.',
                    onTap: () { /* Navigate to chat flow */ },
                  ),
                  _buildFeatureCard(
                    icon: Icons.download_for_offline_rounded,
                    title: loc?.translate('step3Title') ?? 'Step 3: Download your Resume',
                    subtitle: loc?.translate('step3Subtitle') ?? 'Download your completed resume as a PDF.',
                    onTap: () { /* Show download options */ },
                  ),
                ] else ...[
                  // --- Organization Features ---
                  _buildFeatureCard(
                    icon: Icons.search_rounded,
                    title: 'Search Candidate Profiles',
                    subtitle: 'Filter candidates by skills, experience, and location.',
                    onTap: () {
                      // Navigate to Job tab (index 2 for Organization mode)
                      widget.onNavigateToTab?.call(2);
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.playlist_add_check_rounded,
                    title: 'Review AI-Matched Candidates',
                    subtitle: 'See candidates automatically matched to your job postings.',
                    onTap: () { /* Navigate to matched candidates */ },
                  ),
                  _buildFeatureCard(
                    icon: Icons.post_add_rounded,
                    title: 'Post a Job Opening',
                    subtitle: 'Create job listings to attract blue-collar workers.',
                    onTap: () { /* Navigate to job posting form */ },
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Method for Feature Cards (Dynamically Themed) ---
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final Color color = _currentPrimaryColor == _userPrimaryColor
        ? Color(0xFF0056b3) // Dark blue for user
        : Colors.indigo.shade800; // Dark indigo for org

    final Color bgColor = _currentBackgroundColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Card(
        elevation: 1.5,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: bgColor, width: 1),
        ),
        child: ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          leading: Icon(icon, color: color, size: 28),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: color),
          ),
          subtitle: Text(subtitle, style: TextStyle(color: color.withOpacity(0.7))),
          trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
        ),
      ),
    );
  }

  // Helper method for language selection cards
  Widget _buildLanguageCard({
    required String name,
    required String code,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: _currentPrimaryColor.withOpacity(0.2),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _currentPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get language name from code
  String _getLanguageName(String code) {
    return _languageOptions
        .firstWhere((lang) => lang['code'] == code)['name'];
  }
}
