// lib/profile/posted_jobs_screen.dart

import 'package:flutter/material.dart';
import 'package:rezume_app/models/job_model.dart'; // Import our new model
import 'package:rezume_app/profile/create_job_screen.dart'; // Import the create screen

class PostedJobsScreen extends StatefulWidget {
  final Color themeColor;

  const PostedJobsScreen({super.key, required this.themeColor});

  @override
  State<PostedJobsScreen> createState() => _PostedJobsScreenState();
}

class _PostedJobsScreenState extends State<PostedJobsScreen> {
  // This list will store the jobs created during this session.
  // In a real app, this would be loaded from a database.
  final List<Job> _postedJobs = [];

  // This function handles navigation to the CreateJobScreen
  // and waits for a result (the new job).
  void _navigateToCreateJobScreen() async {
    // We 'await' the result from the CreateJobScreen
    final newJob = await Navigator.push<Job>(
      context,
      MaterialPageRoute(
        builder: (context) => CreateJobScreen(themeColor: widget.themeColor),
      ),
    );

    // If the user created a job (newJob is not null), add it to our list
    if (newJob != null) {
      setState(() {
        _postedJobs.add(newJob);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Posted Jobs'),
        backgroundColor: widget.themeColor,
      ),
      body: _postedJobs.isEmpty
          ? _buildEmptyState() // Show a message if no jobs are posted
          : _buildJobList(), // Show the list of jobs
      
      // This is the "plus" button you requested
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateJobScreen,
        backgroundColor: widget.themeColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  // Widget to show when the list is empty
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'No jobs posted yet.',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Click the "+" button to create one.',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // Widget to show the list of jobs
  Widget _buildJobList() {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: _postedJobs.length,
      itemBuilder: (context, index) {
        final job = _postedJobs[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: widget.themeColor.withOpacity(0.1),
              child: Icon(Icons.work_outline_rounded, color: widget.themeColor),
            ),
            title: Text(
              job.role,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            subtitle: Text(
              '${job.location} • ${job.salary}\n${job.openings} Openings',
            ),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
            isThreeLine: true,
            onTap: () {
              // You could navigate to a "Job Details" screen here
            },
          ),
        );
      },
    );
  }
}