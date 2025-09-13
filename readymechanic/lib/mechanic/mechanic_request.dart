import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/mechanic/mechanic_job.dart';
import 'package:readymechanic/mechanic/mechanic_dashboard.dart';
import 'package:readymechanic/mechanic/mechanic_profile.dart';

class MechanicRequestScreen extends StatefulWidget {
  const MechanicRequestScreen({super.key});

  @override
  State<MechanicRequestScreen> createState() => _MechanicRequestScreenState();
}

class _MechanicRequestScreenState extends State<MechanicRequestScreen> {
  int _selectedIndex = 1; // Requests tab

  // Colors from mechanic_dashboard.dart
  final Color _primaryColor = const Color(0xFFea2a33);
  final Color _backgroundColor = Colors.grey[50]!;
  final Color _textPrimary = Colors.grey[800]!;
  final Color _textSecondary = Colors.grey[600]!;

  final List<Map<String, dynamic>> _requests = [
    {
      'name': 'Sophia Carter',
      'vehicle': '2021 Toyota Camry',
      'service': 'Oil Change',
      'location': '123 Maple St, Anytown',
      'distance': '5.2 miles away',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDR2o_FLQ9OPwVoHI4ryDtAejW8k2q96qzEvY6l7jOkNSWlVjy9rqeUDBBCsWgOYDLdcDKMLx_LZVRZe2AcHVT55SNtCjtSfXDF_pMd1vK7ac_1_U75m6tQt6DPQwGLWR6NOnutAMMHExOjbiMLgvDGOonwQZCZ_3yaaDAyNDb1Z7W2ZB4Wsj24BtDoj29Th0-vWg53mQ88uEnZp7tJ5YL-NtlllY5thLIW4hiMpEJ9uL1eIT_HAlo5pDN05cJfNDUDUWEKOfk0-FE',
    },
    {
      'name': 'Ethan Harper',
      'vehicle': '2018 Honda Civic',
      'service': 'Tire Rotation',
      'location': '456 Oak Ave, Anytown',
      'distance': '8.1 miles away',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCEWFy_9Bq5W3L7kOT-B8OqH-fMbKAHG6_zA_4BjqEYAiM1EDsOWh9EZ63WoFyr3s_itT97j98HDQPd-kOg2ToS1DzU7V4Ng9RJkFYYEC355LRatDLROdySNHANco0XzVZGAJj5nqYJ5RS4FYynHPo6QxgRXI8Ewr_j8T8nJprPcDj0yA-lPsNIBwUwcXuu0C7blqzoQCxQuPSYNHrz38m4AHSimQCO8L9mRtvlqzDHB4OgbX6SW1yj8SAyO_oPmsLXs8Z8SzKIdjs',
    },
    {
      'name': 'Olivia Bennett',
      'vehicle': '2020 Ford F-150',
      'service': 'Brake Repair',
      'location': '789 Pine Rd, Anytown',
      'distance': '12.5 miles away',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDzbhe_v04mFFsS6jwxvelcDSVPKnVYXiHhs-JvwSy4n2Jcs3EBI5WqW997-nbiW2WTA3cKaWCNwiuu3WrZJO1928vMsBXubQetRGq7F0xKew7DG8vlFav5XvC_WI3CJvqRJrz3k9iNQ5UJKMqHdeqYIP_F5oWHy9atFdSZHo3s4BhZhjx8Ru-MSk4zDMN5022b3hcCcrOSiyknbD02SHG_hY2sKh7-y1NVlgLN6LwkxYCjqKROszD2Fh5cwFeHmBwJQiB1-lGMPmo',
    },
    {
      'name': 'Noah Foster',
      'vehicle': '2019 Chevrolet Malibu',
      'service': 'Battery Replacement',
      'location': '321 Birch Ln, Anytown',
      'distance': '3.4 miles away',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCrIoT-pErhid05EdRdTlspATjYWSr7HHt8pZfmUfI1QPxpZ-sKPkngUGRUAZs43MZNnbOwFTkaBCWoogMGzhXBMtprREFaettcSaZZVK9ER2HnKhqr38BHH0gmWOMv-iNRoqrWJM8i67deyK5_bTU7DgqBqzR6YuWESMM7Qo_5OvJ7ZaHocdXA6yqQMLoZ4v7FQyF47f2uq5d3XTonGXJYK6KzAKNCNFrroOF5G9dJH8rmPStdq5Hw_w9-JbRfyu1KRYlyTFO6F3s',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Handle navigation to other screens based on index
    if (index == 0) {
      // Tapped on Dashboard
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const MechanicDashboardScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const MechanicJobScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) =>
              const MechanicProfileScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation1, animation2) =>
                  const MechanicDashboardScreen(),
              transitionDuration: Duration.zero,
            ),
          ),
        ),
        title: Text(
          'New Service Requests',
          style: GoogleFonts.spaceGrotesk(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _requests.length,
              itemBuilder: (context, index) {
                final request = _requests[index];
                return _buildRequestCard(request);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request['name'],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.directions_car, request['vehicle']),
                    _buildInfoRow(Icons.build, request['service']),
                    _buildInfoRow(Icons.location_on, request['location']),
                    _buildInfoRow(Icons.social_distance, request['distance']),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(request['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle Reject
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    // TODO: Handle Accept
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Accept',
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: _textSecondary),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              color: _textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Requests',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: _textSecondary,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        unselectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
