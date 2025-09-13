import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/customer/customer_location.dart';

class CustomerBookServiceScreen extends StatefulWidget {
  const CustomerBookServiceScreen({super.key});

  @override
  State<CustomerBookServiceScreen> createState() =>
      _CustomerBookServiceScreenState();
}

class _CustomerBookServiceScreenState extends State<CustomerBookServiceScreen> {
  final _primaryColor = const Color(0xFFea2a33);

  Map<String, dynamic>? _selectedVehicle;
  String? _selectedService;
  List<Map<String, dynamic>> _vehicles = [];
  bool _isLoadingVehicles = true;

  final List<Map<String, dynamic>> _services = [
    {
      'name': 'General Service & Oil Change',
      'icon': Icons.oil_barrel,
      'price': 1299,
    },
    {
      'name': 'Battery Replacement',
      'icon': Icons.battery_charging_full,
      'price': 499,
    },
    {'name': 'Brake Repair & Service', 'icon': Icons.no_crash, 'price': 899},
    {
      'name': 'Flat Tire & Puncture Repair',
      'icon': Icons.tire_repair,
      'price': 299,
    },
    {'name': 'Engine Diagnostics', 'icon': Icons.build, 'price': 799},
    {'name': 'Starting Problems', 'icon': Icons.car_repair, 'price': 599},
  ];

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _fetchVehicles() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoadingVehicles = false);
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .collection('vehicles')
          .orderBy('createdAt', descending: true)
          .get();

      final vehicles = snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();

      if (mounted) {
        setState(() {
          _vehicles = vehicles;
          _isLoadingVehicles = false;
        });
      }
    } catch (e) {
      // Handle error, maybe show a snackbar
      if (mounted) setState(() => _isLoadingVehicles = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedServiceData = _selectedService == null
        ? null
        : _services.firstWhere(
            (service) => service['name'] == _selectedService,
            orElse: () => <String, dynamic>{}, // This is correct
          );

    final isContinueButtonEnabled =
        _selectedVehicle != null && _selectedService != null;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Book a service',
          style: GoogleFonts.splineSans(
            color: Colors.grey[900],
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
            Text(
              'Select a vehicle',
              style: GoogleFonts.splineSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 8),
            _buildVehicleDropdown(),
            const SizedBox(height: 24),
            Text(
              'Select a service',
              style: GoogleFonts.splineSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[900],
              ),
            ),
            const SizedBox(height: 8),
            _buildServiceGrid(),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isContinueButtonEnabled
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerLocationScreen(
                            // This is the area with the error
                            vehicle:
                                '${_selectedVehicle!['make']} - ${_selectedVehicle!['model']}',
                            serviceName:
                                selectedServiceData?['name'] ??
                                '', // This line is correct
                            servicePrice:
                                selectedServiceData?['price'] ??
                                0, // This line is correct
                          ), // This is the area with the error
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 5,
                shadowColor: _primaryColor.withAlpha((255 * 0.4).round()),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.splineSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((255 * 0.05).round()),
            blurRadius: 5,
          ),
        ],
      ),
      child: _isLoadingVehicles
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
          : DropdownButtonFormField<Map<String, dynamic>>(
              value: _selectedVehicle,
              hint: Text(
                'Select Vehicle',
                style: GoogleFonts.splineSans(color: Colors.grey[500]),
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              icon: const Icon(Icons.unfold_more, color: Colors.grey),
              isExpanded: true,
              style: GoogleFonts.splineSans(
                color: Colors.grey[800],
                fontSize: 16,
              ),
              onChanged: (Map<String, dynamic>? newValue) {
                setState(() {
                  _selectedVehicle = newValue;
                });
              },
              items: _vehicles.map<DropdownMenuItem<Map<String, dynamic>>>((
                Map<String, dynamic> vehicle,
              ) {
                final vehicleName =
                    '${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}';
                return DropdownMenuItem<Map<String, dynamic>>(
                  value: vehicle,
                  child: Text(vehicleName),
                );
              }).toList(),
            ),
    );
  }

  Widget _buildServiceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.85, // Adjust as needed
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(
          service['name']!,
          '₹${service['price']}',
          service['icon']!,
        );
      },
    );
  }

  Widget _buildServiceCard(String name, String price, IconData icon) {
    final isSelected = _selectedService == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedService = isSelected ? null : name;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? _primaryColor.withAlpha((255 * 0.05).round())
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _primaryColor, size: 36),
              const SizedBox(height: 12),
              Text(
                name,
                style: GoogleFonts.splineSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                price,
                style: GoogleFonts.splineSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
