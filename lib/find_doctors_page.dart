import 'package:flutter/material.dart';

// --- 1. Doctor Model (Dummy Data Structure) ---
class Doctor {
  final String name;
  final String qualification;
  final String specialty;
  final String clinicName;
  final String workingHours;
  final double distanceKm;
  final String profileImagePath;
  final bool isAvailableNow; // For "Available Now" vs "Other Days"

  Doctor({
    required this.name,
    required this.qualification,
    required this.specialty,
    required this.clinicName,
    required this.workingHours,
    required this.distanceKm,
    required this.profileImagePath,
    this.isAvailableNow = false,
  });
}

// --- Dummy Data for Doctors ---
final List<Doctor> dummyDoctors = [
  Doctor(
    name: 'Dr. Priya Sharma',
    qualification: 'BAMS, MD (Ayurveda)',
    specialty: 'Panchakarma & Wellness',
    clinicName: 'AyurHeal Clinic',
    workingHours: 'Mon-Fri, 9:00 AM - 5:00 PM',
    distanceKm: 2.5,
    profileImagePath: 'assets/images/doc_priya.png', // Placeholder
    isAvailableNow: true,
  ),
  Doctor(
    name: 'Dr. Rohan Kumar',
    qualification: 'BAMS, PhD (Ayurveda)',
    specialty: 'Herbal Medicine & Chronic Diseases',
    clinicName: 'Rishi Ayurveda Centre',
    workingHours: 'Tue-Sat, 10:00 AM - 6:00 PM',
    distanceKm: 5.1,
    profileImagePath: 'assets/images/doc_rohan.png', // Placeholder
    isAvailableNow: true, // Also available now for demonstration
  ),
  Doctor(
    name: 'Dr. Anjali Gupta',
    qualification: 'BAMS, MS (Ayurveda)',
    specialty: 'Pediatric & Women\'s Health',
    clinicName: 'Eternal Bliss Ayurveda',
    workingHours: 'Not Available Today', // Clearly state unavailability
    distanceKm: 3.8,
    profileImagePath: 'assets/images/doc_anjali.png', // Placeholder
    isAvailableNow: false, // Will be shown in "Available Other Days" and greyed out
  ),
];

class FindDoctorsPage extends StatefulWidget {
  const FindDoctorsPage({super.key});

  @override
  State<FindDoctorsPage> createState() => _FindDoctorsPageState();
}

class _FindDoctorsPageState extends State<FindDoctorsPage> {
  // Separate doctors into available now and other days
  late List<Doctor> _availableNowDoctors;
  late List<Doctor> _otherDaysDoctors;

  @override
  void initState() {
    super.initState();
    _availableNowDoctors = dummyDoctors.where((doc) => doc.isAvailableNow).toList();
    _otherDaysDoctors = dummyDoctors.where((doc) => !doc.isAvailableNow).toList();
  }

  @override
  Widget build(BuildContext context) {
    const pranaTextColor = Color(0xFF6B5B3B);
    const lightGreyBackground = Color(0xFFF2F2F7);

    return Scaffold(
      backgroundColor: lightGreyBackground,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Find Ayurvedic Doctors',
          style: TextStyle(
              color: Colors.black, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Available Now Doctors ---
            const Text(
              'Available Now',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: pranaTextColor,
              ),
            ),
            const SizedBox(height: 15),
            _availableNowDoctors.isEmpty
                ? const Text('No doctors currently available.')
                : Column(
                    children: _availableNowDoctors
                        .map((doctor) => _buildDoctorCard(doctor, true))
                        .toList(),
                  ),
            const SizedBox(height: 30),

            // --- Available Other Days Doctors ---
            const Text(
              'Available Other Days',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: pranaTextColor,
              ),
            ),
            const SizedBox(height: 15),
            _otherDaysDoctors.isEmpty
                ? const Text('No doctors available on other days.')
                : Column(
                    children: _otherDaysDoctors
                        .map((doctor) => _buildDoctorCard(doctor, false))
                        .toList(),
                  ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- Doctor Card Widget ---
  Widget _buildDoctorCard(Doctor doctor, bool isAvailable) {
    // Define colors for available vs unavailable
    final cardBackgroundColor = isAvailable ? Colors.white : Colors.grey.shade300;
    final textColor = isAvailable ? Colors.black87 : Colors.grey.shade600;
    final subtitleColor = isAvailable ? Colors.grey.shade600 : Colors.grey.shade500;
    final avatarBorderColor = isAvailable ? const Color(0xFFB3C691) : Colors.grey.shade400;

    return Card(
      margin: const EdgeInsets.only(bottom: 15.0),
      color: cardBackgroundColor,
      elevation: isAvailable ? 3 : 1, // Less elevation for unavailable
      shadowColor: Colors.black.withOpacity(isAvailable ? 0.1 : 0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Profile Image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: avatarBorderColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: Colors.white, // Fallback if image not found
                backgroundImage: AssetImage(doctor.profileImagePath),
                onBackgroundImageError: (exception, stackTrace) {
                  // Handle image loading errors by showing a default icon
                  print('Error loading image for ${doctor.name}: $exception');
                },
                child: !isAvailable && doctor.profileImagePath.isEmpty // If no image and unavailable, show default icon
                    ? Icon(Icons.person, color: Colors.grey.shade500, size: 40)
                    : null,
              ),
            ),
            const SizedBox(width: 15),
            // Doctor Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${doctor.qualification} (${doctor.specialty})',
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.clinicName,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: subtitleColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    doctor.workingHours,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 14,
                      color: subtitleColor,
                      fontStyle: !isAvailable ? FontStyle.italic : FontStyle.normal, // Italicize unavailable times
                    ),
                  ),
                ],
              ),
            ),
            // Distance
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: Text(
                '${doctor.distanceKm.toStringAsFixed(1)} km',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isAvailable ? const Color(0xFF3A6A70) : Colors.grey.shade500, // Distance color
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}