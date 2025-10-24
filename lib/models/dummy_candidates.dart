// lib/models/dummy_candidates.dart

class Candidate {
  final int id;
  final String name;
  final String jobProfile;
  final String location;
  final int experience;
  final String qualification;
  final String email;
  final List<String> skills;
  final List<String> achievements;
  // --- NEW FIELDS ---
  final String jobType; // 'Full-time' or 'Part-time'
  final int salary; // Annual salary in INR, e.g., 300000
  final bool isWorkFromHome;

  Candidate({
    required this.id,
    required this.name,
    required this.jobProfile,
    required this.location,
    required this.experience,
    required this.qualification,
    required this.email,
    required this.skills,
    required this.achievements,
    // --- ADD TO CONSTRUCTOR ---
    required this.jobType,
    required this.salary,
    required this.isWorkFromHome,
  });
}

// A list of 100 dummy candidates for blue-collar jobs
final List<Candidate> dummyCandidates = List.generate(100, (index) {
  final jobProfiles = [
    'Driver',
    'Electrician',
    'Plumber',
    'Cook',
    'Security Guard',
    'Welder',
    'Carpenter',
    'Mechanic'
  ];
  final names = [
    'Rohan Sharma',
    'Priya Singh',
    'Amit Kumar',
    'Sneha Patel',
    'Vijay Yadav',
    'Anjali Gupta',
    'Suresh Reddy',
    'Meera Desai'
  ];
  final locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Rourkela',
    'Kolkata',
    'Chennai',
    'Hyderabad',
    'Pune'
  ];
  final qualifications = [
    '10th Pass',
    '12th Pass',
    'ITI Certified',
    'Diploma in Engineering'
  ];

  final job = jobProfiles[index % jobProfiles.length];

  List<String> skills = [];
  List<String> achievements = [];

  switch (job) {
    case 'Driver':
      skills = [
        'Commercial Driving (CDL)',
        'Route Navigation',
        'Vehicle Maintenance',
        'Defensive Driving'
      ];
      achievements = [
        'Maintained a 99% on-time delivery record over 3 years.',
        'Awarded "Driver of the Month" twice for safety and efficiency.'
      ];
      break;
    case 'Electrician':
      skills = [
        'Wiring & Installation',
        'Troubleshooting',
        'Circuit Breakers',
        'Safety Compliance'
      ];
      achievements = [
        'Successfully completed wiring for 3 new commercial buildings.',
        'Reduced electrical faults by 25% through proactive maintenance.'
      ];
      break;
    case 'Plumber':
      skills = [
        'Pipe Fitting',
        'Drainage Systems',
        'Fixture Installation',
        'Leak Repair'
      ];
      achievements = [
        'Resolved over 500+ residential plumbing issues.',
        'Praised for quick and effective emergency repair services.'
      ];
      break;
    case 'Cook':
      skills = [
        'Indian Cuisine',
        'Food Safety (FSSAI)',
        'Kitchen Management',
        'Menu Planning'
      ];
      achievements = [
        'Head Cook at a restaurant serving 100+ customers daily.',
        'Improved kitchen efficiency by 20%.'
      ];
      break;
    default:
      skills = ['General Maintenance', 'Safety Procedures', 'Teamwork'];
      achievements = [
        'Consistently met project deadlines.',
        'Received positive feedback from supervisors.'
      ];
      break;
  }

  return Candidate(
    id: index + 1,
    name: names[index % names.length],
    jobProfile: job,
    location: locations[index % locations.length],
    experience: (index % 10) + 1, // 1 to 10 years experience
    qualification: qualifications[index % qualifications.length],
    email: 'candidate${index + 1}@example.com',
    skills: skills,
    achievements: achievements,
    // --- POPULATE NEW FIELDS ---
    jobType: (index % 3 == 0) ? 'Part-time' : 'Full-time',
    salary: (index % 6 + 2) * 100000, // 2,00,000 to 7,00,000
    isWorkFromHome: (index % 5 == 0), // 1 in 5 are work from home
  );
});
