import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/mechanic/mechanic_job.dart';
import 'package:readymechanic/mechanic/mechanic_dashboard.dart';
import 'package:readymechanic/mechanic/mechanic_profile.dart';
import 'package:readymechanic/mechanic/mechanic_request.dart';

class MechanicHomeScreen extends StatefulWidget {
  const MechanicHomeScreen({super.key});

  @override
  State<MechanicHomeScreen> createState() => _MechanicHomeScreenState();
}

class _MechanicHomeScreenState extends State<MechanicHomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MechanicDashboardScreen(),
    MechanicRequestScreen(),
    MechanicJobScreen(),
    MechanicProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      bottomNavigationBar: BottomNavigationBar(
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
        selectedItemColor: const Color(0xFFea2a33),
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: GoogleFonts.spaceGrotesk(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
