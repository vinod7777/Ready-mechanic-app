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

  String? _selectedVehicle;
  String? _selectedService;

  final List<String> _vehicles = [
    'Toyota Camry - 2021',
    'Honda Civic - 2022',
    'Ford F-150 - 2020',
  ];

  final List<Map<String, dynamic>> _services = [
    {'name': 'Oil Change', 'price': '\$45.00', 'icon': Icons.oil_barrel},
    {'name': 'Brake Service', 'price': '\$120.00', 'icon': Icons.no_crash},
    {
      'name': 'Battery Replacement',
      'price': '\$150.00',
      'icon': Icons.battery_charging_full,
    },
    {'name': 'Tire Rotation', 'price': '\$30.00', 'icon': Icons.tire_repair},
    {'name': 'Engine Diagnostics', 'price': '\$80.00', 'icon': Icons.build},
    {'name': 'General Inspection', 'price': '\$50.00', 'icon': Icons.search},
  ];

  @override
  Widget build(BuildContext context) {
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomerLocationScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                elevation: 5,
                shadowColor: _primaryColor.withAlpha((255 * 0.4).round()),
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
      child: DropdownButtonFormField<String>(
        value: _selectedVehicle,
        hint: Text(
          'Select Vehicle',
          style: GoogleFonts.splineSans(color: Colors.grey[500]),
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        icon: const Icon(Icons.unfold_more, color: Colors.grey),
        isExpanded: true,
        style: GoogleFonts.splineSans(color: Colors.grey[800], fontSize: 16),
        onChanged: (String? newValue) {
          setState(() {
            _selectedVehicle = newValue;
          });
        },
        items: _vehicles.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
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
        childAspectRatio: 1.0, // Adjust as needed
      ),
      itemCount: _services.length,
      itemBuilder: (context, index) {
        final service = _services[index];
        return _buildServiceCard(
          service['name']!,
          service['price']!,
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
