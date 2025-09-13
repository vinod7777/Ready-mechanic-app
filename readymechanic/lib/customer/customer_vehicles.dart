import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerVehiclesScreen extends StatefulWidget {
  const CustomerVehiclesScreen({super.key});

  @override
  State<CustomerVehiclesScreen> createState() => _CustomerVehiclesScreenState();
}

class _CustomerVehiclesScreenState extends State<CustomerVehiclesScreen> {
  int _selectedIndex = 2; // Set to Vehicles
  final _primaryColor = const Color(0xFFea2a33);

  // Mock data for vehicles
  final List<Map<String, String>> _vehicles = [
    {'name': 'Toyota Camry', 'regNo': '123456'},
    {'name': 'Honda Civic', 'regNo': '789012'},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/customer_dashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/customer_booking');
    } else if (index == 2) {
      // Already on vehicles list, no need to navigate
    } else if (index == 3) {
      Navigator.pushReplacementNamed(context, '/customer_profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Vehicles',
          style: GoogleFonts.splineSans(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)], // To balance the leading icon
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = _vehicles[index];
          return _buildVehicleCard(vehicle['name']!, vehicle['regNo']!);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/customer_add_vehicles');
        },
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.splineSans(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.splineSans(),
      ),
    );
  }

  Widget _buildVehicleCard(String name, String regNo) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.splineSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reg No: $regNo',
                  style: GoogleFonts.splineSans(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                // TODO: Handle delete vehicle
              },
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              splashRadius: 24,
            ),
          ],
        ),
      ),
    );
  }
}
