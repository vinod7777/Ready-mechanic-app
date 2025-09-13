import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerAddVehiclesScreen extends StatefulWidget {
  const CustomerAddVehiclesScreen({super.key});

  @override
  State<CustomerAddVehiclesScreen> createState() =>
      _CustomerAddVehiclesScreenState();
}

class _CustomerAddVehiclesScreenState extends State<CustomerAddVehiclesScreen> {
  int _selectedIndex = 2; // Vehicles tab
  final _primaryColor = const Color(0xFFea2a33);

  String? _selectedVehicleType;
  String? _selectedMake;
  String? _selectedModel;

  final List<String> _vehicleTypes = ['Car', 'Bike'];
  final List<String> _carMakes = ['Toyota', 'Honda', 'Ford'];
  final List<String> _bikeMakes = ['Yamaha', 'Suzuki', 'Harley-Davidson'];
  final List<String> _toyotaModels = ['Camry', 'Corolla', 'RAV4'];
  final List<String> _hondaModels = ['Civic', 'Accord', 'CR-V'];
  final List<String> _fordModels = ['Focus', 'Mustang', 'F-150'];
  final List<String> _yamahaModels = ['YZF-R1', 'MT-07', 'Tenere 700'];
  final List<String> _suzukiModels = ['GSX-R1000', 'SV650', 'V-Strom 650'];
  final List<String> _harleyModels = ['Street Glide', 'Iron 883', 'Fat Boy'];

  List<String> _currentMakes = [];
  List<String> _currentModels = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // TODO: Handle navigation to other screens based on index
    if (index == 0) {
      Navigator.pushReplacementNamed(context, '/customer_dashboard');
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, '/customer_booking');
    } else if (index == 3) {
      // Navigator.pushReplacementNamed(context, '/customer_profile');
    }
  }

  void _onVehicleTypeChanged(String? newValue) {
    setState(() {
      _selectedVehicleType = newValue;
      _selectedMake = null;
      _selectedModel = null;
      _currentMakes = [];
      _currentModels = [];

      if (newValue == 'Car') {
        _currentMakes = _carMakes;
      } else if (newValue == 'Bike') {
        _currentMakes = _bikeMakes;
      }
    });
  }

  void _onMakeChanged(String? newValue) {
    setState(() {
      _selectedMake = newValue;
      _selectedModel = null;
      _currentModels = [];

      if (_selectedVehicleType == 'Car') {
        if (newValue == 'Toyota') {
          _currentModels = _toyotaModels;
        } else if (newValue == 'Honda') {
          _currentModels = _hondaModels;
        } else if (newValue == 'Ford') {
          _currentModels = _fordModels;
        }
      } else if (_selectedVehicleType == 'Bike') {
        if (newValue == 'Yamaha') {
          _currentModels = _yamahaModels;
        } else if (newValue == 'Suzuki') {
          _currentModels = _suzukiModels;
        } else if (newValue == 'Harley-Davidson') {
          _currentModels = _harleyModels;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Vehicle',
          style: GoogleFonts.splineSans(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdownField(
              label: 'Vehicle Type',
              value: _selectedVehicleType,
              items: _vehicleTypes,
              hint: 'Select Vehicle Type',
              onChanged: _onVehicleTypeChanged,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Make',
              value: _selectedMake,
              items: _currentMakes,
              hint: 'Select Make',
              onChanged: _onMakeChanged,
              enabled: _selectedVehicleType != null,
            ),
            const SizedBox(height: 16),
            _buildDropdownField(
              label: 'Model',
              value: _selectedModel,
              items: _currentModels,
              hint: 'Select Model',
              onChanged: (newValue) {
                setState(() {
                  _selectedModel = newValue;
                });
              },
              enabled: _selectedMake != null,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              label: 'Registration No.',
              hint: 'Enter Registration No.',
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Go back to vehicles list
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
                'Add Vehicle',
                style: GoogleFonts.splineSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.splineSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha((255 * 0.05).round()), blurRadius: 5),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            items: items.map((String item) {
              return DropdownMenuItem<String>(value: item, child: Text(item));
            }).toList(),
            onChanged: enabled ? onChanged : null,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.splineSans(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            icon: const Icon(Icons.expand_more, color: Colors.grey),
            isExpanded: true,
            style: GoogleFonts.splineSans(
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.splineSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha((255 * 0.05).round()), blurRadius: 5),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.splineSans(color: Colors.grey[500]),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: GoogleFonts.splineSans(
              color: Colors.grey[800],
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}