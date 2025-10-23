import 'package:flutter/material.dart';
import 'package:rezume_app/models/resume_template_model.dart';
import 'package:rezume_app/templates/resume_builder_screen.dart';

class TemplatesScreen extends StatefulWidget {
  const TemplatesScreen({super.key});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  // Dummy data for our templates
  final List<ResumeTemplate> _templates = [
    ResumeTemplate(
        id: '1',
        name: 'Modern',
        imageUrl:
            // Using a real image placeholder
            'https://d.resume.io/api/files/1831405/resume-template-modern-1.png'),
    ResumeTemplate(
        id: '2',
        name: 'Classic',
        imageUrl:
            'https://d.resume.io/api/files/1831405/resume-template-professional-1.png'),
    ResumeTemplate(
        id: '3',
        name: 'Creative',
        imageUrl:
            'https://d.resume.io/api/files/1831405/resume-template-creative-1.png'),
    ResumeTemplate(
        id: '4',
        name: 'Professional',
        imageUrl:
            'https://d.resume.io/api/files/1831405/resume-template-simple-1.png'),
    ResumeTemplate(
        id: '5',
        name: 'Simple',
        imageUrl:
            'https://d.resume.io/api/files/1831405/resume-template-basic-1.png'),
    ResumeTemplate(
        id: '6',
        name: 'Technical',
        imageUrl:
            'https://d.resume.io/api/files/1831405/resume-template-minimalist-1.png'),
  ];

  // --- ADD THIS MAP ---
  final Map<String, IconData> _templateIcons = {
    'Modern': Icons.vignette_outlined,
    'Classic': Icons.class_outlined,
    'Creative': Icons.brush_outlined,
    'Professional': Icons.business_center_outlined,
    'Simple': Icons.text_snippet_outlined,
    'Technical': Icons.code_outlined,
  };
  // --- END OF ADDITION ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Text("Choose a Template"),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      // --- MODIFIED: Switched to GridView.builder ---
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two columns
          mainAxisSpacing: 16.0, // Spacing between rows
          crossAxisSpacing: 16.0, // Spacing between columns
          childAspectRatio: 0.7, // Adjust aspect ratio for images
        ),
        padding: const EdgeInsets.all(16.0),
        itemCount: _templates.length,
        itemBuilder: (context, index) {
          final template = _templates[index];
          return _buildTemplateCard(
            template: template,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ResumeBuilderScreen(
                    template: template,
                    templateName: template.name,
                  ),
                ),
              );
            },
          );
        },
      ),
      // --- END OF MODIFICATION ---
    );
  }

  // --- MODIFIED: Helper method for building the new template cards ---
  Widget _buildTemplateCard({
    required ResumeTemplate template,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias, // Clips the image to the card's shape
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // --- THIS IS THE MODIFICATION ---
            // 1. The Icon (replacing Image.network)
            Container(
              color: Colors.grey[200], // Light placeholder background
              child: Center(
                child: Icon(
                  _templateIcons[template.name] ?? Icons.article_outlined, // Use mapped icon
                  size: 80,
                  color: Colors.grey[400],
                ),
              ),
            ),
            // --- END OF MODIFICATION ---

            // 2. The Gradient Overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
            ),
            // 3. The Text
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Text(
                template.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black54,
                      offset: Offset(1.0, 1.0),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}