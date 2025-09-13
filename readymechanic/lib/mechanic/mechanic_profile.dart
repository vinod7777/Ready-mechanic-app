import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/mechanic/mechanic_dashboard.dart';
import 'package:readymechanic/mechanic/mechanic_job.dart';
import 'package:readymechanic/mechanic/mechanic_request.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  int _selectedIndex = 3; // Profile tab

  // Colors from other mechanic screens
  final Color _primaryColor = const Color(0xFFea2a33);
  final Color _backgroundColor = Colors.grey[50]!;
  final Color _textPrimary = Colors.grey[800]!;
  final Color _textSecondary = Colors.grey[600]!;

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;

    setState(() {
      _selectedIndex = index;
    });

    Widget page;
    switch (index) {
      case 0:
        page = const MechanicDashboardScreen();
        break;
      case 1:
        page = const MechanicRequestScreen();
        break;
      case 2:
        page = const MechanicJobScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.spaceGrotesk(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCsg4zDkeUElHy-SojE5jk3Rdk_q29Qb7EtDNi0aMTZUVsSbOlU25XEH1pwO0RKpCRxpOt_QUe4RFF-C7OGddrImww6LIVTx1UYXQ3p378XI3N1QmUvC84VLINaQGfW7Ahptl8aMWoNFd64zbAw8zfCH48_7jFWvc3HifPOe_Py2g7N0LcgRsEqkJDGfAr_NX4iCctGEt9qwU0QurC3IJ4TrSbXTmtF7Eb1l3at4SAK7nFkk_WAZ82TMkP235eDCy3s9eBelAHxfjg',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Ethan Carter',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            Text(
              'Mechanic',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildSectionTitle('Professional Details'),
            _buildTextField(label: 'Name', value: 'Ethan Carter'),
            _buildTextField(label: 'Email', value: 'ethan.carter@example.com'),
            _buildTextField(label: 'Phone', value: '+1 123 456 7890'),
            _buildTextField(
              label: 'Address',
              value: '123 Main St, Anytown, USA',
            ),
            _buildTextField(label: 'License Number', value: 'MC12345678'),
            const SizedBox(height: 24),
            _buildSectionTitle('Bank Details'),
            _buildTextField(
              label: 'Account Number',
              value: '**** **** **** 1234',
            ),
            _buildTextField(label: 'Routing Number', value: '*********'),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  // TODO: Handle Logout
                },
                style: TextButton.styleFrom(
                  backgroundColor: _primaryColor.withOpacity(0.1),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Logout',
                  style: GoogleFonts.spaceGrotesk(
                    color: _primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true, // Making fields read-only for a profile view
        style: GoogleFonts.spaceGrotesk(fontSize: 16, color: _textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.spaceGrotesk(color: _textSecondary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
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
        items: const <BottomNavigationBarItem>[
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
