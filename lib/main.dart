import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rezume_app/app/localization/app_localizations.dart';
import 'package:rezume_app/providers/language_provider.dart';
import 'package:rezume_app/screens/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rezume_app/home/home_screen.dart';
import 'package:rezume_app/templates/templates_screen.dart';
import 'package:rezume_app/subscription/subscription_page.dart';
import 'package:rezume_app/ats_checker/upload_resume_screen.dart';
import 'package:rezume_app/profile/profile_screen.dart';
import 'package:rezume_app/profile/candidate_list_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the provider
    final languageProvider = Provider.of<LanguageProvider>(context);

    return MaterialApp(
      title: 'Rezume App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      
      // --- LOCALIZATION SETTINGS ---
      locale: languageProvider.appLocale,
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('hi', ''), // Hindi
        Locale('or', ''), // Odia
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      // --- END LOCALIZATION SETTINGS ---

      home: const SplashScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String userRole;
  
  const MainScreen({super.key, this.userRole = 'User'});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Default to Job Seeker mode (false)
  bool _isOrganizationMode = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set initial mode based on userRole
    _isOrganizationMode = widget.userRole == 'Organization';
  }

  // Method to navigate to a specific tab
  void _navigateToTab(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- JOB SEEKER UI (Templates & ATS Score, NO Job tab) ---
  List<Widget> get _userPages => [
    HomeScreen(role: 'User', onNavigateToTab: _navigateToTab),
    TemplatesScreen(),
    UploadResumeScreen(),
    ProfileScreen(role: 'User'),
  ];

  final List<BottomNavigationBarItem> _userNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined),
      activeIcon: Icon(Icons.article),
      label: 'Templates',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.score_outlined),
      activeIcon: Icon(Icons.score),
      label: 'ATS Score',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  // --- ORGANIZATION UI (Subscription) ---
  List<Widget> get _organizationPages => [
    HomeScreen(role: 'Organization', onNavigateToTab: _navigateToTab),
    SubscriptionPage(),
    CandidateListScreen(),
    ProfileScreen(role: 'Organization'),
  ];

  final List<BottomNavigationBarItem> _organizationNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.subscriptions_outlined),
      activeIcon: Icon(Icons.subscriptions),
      label: 'Subscription',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.work_outline_rounded),
      activeIcon: Icon(Icons.work_rounded),
      label: 'Job',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bool isOrg = _isOrganizationMode;
    final List<Widget> currentPages = isOrg ? _organizationPages : _userPages;
    final List<BottomNavigationBarItem> currentNavItems = isOrg ? _organizationNavItems : _userNavItems;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildModeButton(
              title: 'User',
              isSelected: !_isOrganizationMode,
              onTap: () => setState(() => _isOrganizationMode = false),
            ),
            const SizedBox(width: 16),
            _buildModeButton(
              title: 'Organization',
              isSelected: _isOrganizationMode,
              onTap: () => setState(() => _isOrganizationMode = true),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: currentPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: currentNavItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? Colors.indigo : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: Colors.indigo.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ] : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}