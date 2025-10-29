import 'package:flutter/material.dart';
import 'package:rezume_app/app/localization/app_localizations.dart';
import 'package:rezume_app/utils/color_extensions.dart';

class HomeScreen extends StatefulWidget {
  final String role; // 'User' or 'Organization'
  final Function(int)? onNavigateToTab;

  const HomeScreen({super.key, required this.role, this.onNavigateToTab});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLanguage = 'en'; // Default to English

  final List<Map<String, String>> _languageOptions = [
    {'code': 'en', 'name': 'English'},
    {'code': 'hi', 'name': 'हिंदी'},
    {'code': 'or', 'name': 'ଓଡ଼ିଆ'},
  ];

  // --- Define Color Themes ---
  final Color _userPrimaryColor = Color(0xFF007BFF);
  final Color _orgPrimaryColor = Colors.indigo.shade600;
  final Color _orgBackgroundColor = Colors.indigo.shade50;

  // --- Helper getters for current theme based on widget.role ---
  Color get _currentPrimaryColor =>
      widget.role == 'User' ? _userPrimaryColor : _orgPrimaryColor;
  Color get _currentBackgroundColor =>
      widget.role == 'User' ? Color(0xFFF0F8FF) : _orgBackgroundColor;

  String _getTutorialMessage(String langCode) {
    switch (langCode) {
      case 'hi':
        return 'ट्यूटोरियल हिंदी में दिखाया जा रहा है';
      case 'or':
        return 'ଟ୍ୟୁଟୋରିଆଲ୍ ଓଡିଆରେ ଦେଖାଯାଉଛି';
      case 'en':
      default:
        return 'Tutorial is being shown in English';
    }
  }

  // --- NEW: Helper function for step translations ---
  Map<String, String> _getStepDetails(String langCode, int step) {
    switch (langCode) {
      case 'hi': // Hindi Translations
        switch (step) {
          case 1:
            return {
              'title': 'चरण 1: एक टेम्पलेट चुनें',
              'subtitle': 'एक पेशेवर टेम्पलेट चुनें जो आपकी शैली के अनुरूप हो।',
            };
          case 2:
            return {
              'title': 'चरण 2: AI से विवरण भरें',
              'subtitle':
                  'विवरण लिखने में सहायता के लिए हमारे AI सहायक का उपयोग करें।',
            };
          case 3:
            return {
              'title': 'चरण 3: अपना रिज्यूमे डाउनलोड करें',
              'subtitle':
                  'अपना पूरा किया गया रिज्यूमे एक PDF के रूप में डाउनलोड करें।',
            };
          default:
            return {'title': '', 'subtitle': ''};
        }
      case 'or': // Odia Translations
        switch (step) {
          case 1:
            return {
              'title': 'ପଦକ୍ଷେପ 1: ଏକ ଟେମ୍ପଲେଟ୍ ବାଛନ୍ତୁ',
              'subtitle':
                  'ଏକ ପେସାଦାର ଟେମ୍ପଲେଟ୍ ବାଛନ୍ତୁ ଯାହା ଆପଣଙ୍କ ଶୈଳୀ ସହିତ ମେଳ ଖାଏ।',
            };
          case 2:
            return {
              'title': 'ପଦକ୍ଷେପ 2: AI ସହିତ ବିବରଣୀ ଭରନ୍ତୁ',
              'subtitle':
                  'ବିବରଣୀ ଲେଖିବାରେ ସାହାଯ୍ୟ ପାଇଁ ଆମର AI ସହାୟକ ବ୍ୟବହାର କରନ୍ତୁ।',
            };
          case 3:
            return {
              'title': 'ପଦକ୍ଷେପ 3: ଆପଣଙ୍କର ରିଜ୍ୟୁମ୍ ଡାଉନଲୋଡ୍ କରନ୍ତୁ',
              'subtitle':
                  'ଆପଣଙ୍କର ସମ୍ପୂର୍ଣ୍ଣ ରିଜ୍ୟୁମ୍ PDF ଭାବରେ ଡାଉନଲୋଡ୍ କରନ୍ତୁ।',
            };
          default:
            return {'title': '', 'subtitle': ''};
        }
      case 'en': // English (Default)
      default:
        switch (step) {
          case 1:
            return {
              'title': 'Step 1: Choose a Template',
              'subtitle': 'Pick a professional template that fits your style.',
            };
          case 2:
            return {
              'title': 'Step 2: Fill in Details with AI',
              'subtitle': 'Use our AI assistant to help you write details.',
            };
          case 3:
            return {
              'title': 'Step 3: Download your Resume',
              'subtitle': 'Download your completed resume as a PDF.',
            };
          default:
            return {'title': '', 'subtitle': ''};
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get localizations
    final loc = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: _currentBackgroundColor,

      // --- MODIFICATION: The AppBar has been removed ---
      // appBar: AppBar(
      //   title: Text(widget.role == 'User'
      //       ? (loc?.translate('home') ?? 'Dashboard')
      //       : 'Organization Dashboard'),
      //   backgroundColor: _currentPrimaryColor,
      //   elevation: 0,
      //   automaticallyImplyLeading: false, // Add this to remove back button
      // ),
      // --- END OF MODIFICATION ---

      // --- We need to wrap the body in a SafeArea ---
      // --- to avoid the status bar at the top ---
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Header Text ---
                Text(
                  widget.role == 'User'
                      ? (loc?.translate('How to Get Started') ??
                          'How to Get Started')
                      : 'Find Top Talent',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),

                // 1. Language Toggle Buttons
                _buildLanguageToggleButtons(),
                const SizedBox(height: 16),

                // 2. Video Player Section
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
                          color: Colors.white.withOpacityCompat(0.8),
                          size: 60,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 3. Dynamic Tutorial Text
                Center(
                  child: Text(
                    _getTutorialMessage(_selectedLanguage),
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey[700],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 4. Conditional Features/Suggestions Section
                if (widget.role == 'User') ...[
                  // --- User Features ---
                  // --- MODIFIED: Now uses step number ---
                  _buildFeatureCard(
                    icon: Icons.article_rounded,
                    step: 1, // Pass step 1
                    onTap: () {
                      widget.onNavigateToTab?.call(1); // Navigate to Templates
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.auto_awesome_rounded,
                    step: 2, // Pass step 2
                    onTap: () {
                      widget.onNavigateToTab?.call(1); // Navigate to Templates
                    },
                  ),
                  _buildFeatureCard(
                    icon: Icons.download_for_offline_rounded,
                    step: 3, // Pass step 3
                    onTap: () {
                      /* Show download options */
                    },
                  ),
                ] else ...[
                  // --- Organization Features (unchanged) ---
                  _buildFeatureCard(
                    icon: Icons.search_rounded,
                    title: 'Search Candidate Profiles',
                    subtitle:
                        'Filter candidates by skills, experience, and location.',
                    onTap: () {
                      widget.onNavigateToTab?.call(2);
                    },
                  ),
                  // ... other org cards
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget: Language Toggle Buttons (Unchanged) ---
  Widget _buildLanguageToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _languageOptions.map((lang) {
        final isSelected = _selectedLanguage == lang['code'];
        final String displayName = lang['name']!;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: isSelected
              ? ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.check, size: 18),
                  label: Text(displayName),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _currentPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                )
              : OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedLanguage = lang['code']!;
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _currentPrimaryColor,
                    side: BorderSide(
                        color: _currentPrimaryColor.withOpacityCompat(0.5)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(displayName),
                ),
        );
      }).toList(),
    );
  }

  // --- MODIFIED: Helper Method for Feature Cards ---
  Widget _buildFeatureCard({
    required IconData icon,
    required VoidCallback onTap,
    int? step, // Make step nullable
    String? title, // Add optional title/subtitle
    String? subtitle,
  }) {
    // --- Determine text ---
    String cardTitle;
    String cardSubtitle;

    if (step != null && widget.role == 'User') {
      // If it's a user card with steps, get translated text
      final details = _getStepDetails(_selectedLanguage, step);
      cardTitle = details['title']!;
      cardSubtitle = details['subtitle']!;
    } else {
      // Otherwise, use the provided title/subtitle (for Org cards)
      cardTitle = title ?? '';
      cardSubtitle = subtitle ?? '';
    }
    // --- End of text logic ---

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
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          leading: Icon(icon, color: color, size: 28),
          title: Text(
            cardTitle, // Use the determined title
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 17, color: color),
          ),
          subtitle: Text(cardSubtitle,
              style: TextStyle(color: color.withOpacityCompat(0.7))),
          trailing:
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
        ),
      ),
    );
  }
}
