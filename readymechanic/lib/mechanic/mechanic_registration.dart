import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicRegistrationScreen extends StatefulWidget {
  const MechanicRegistrationScreen({super.key});

  @override
  State<MechanicRegistrationScreen> createState() =>
      _MechanicRegistrationScreenState();
}

class _MechanicRegistrationScreenState
    extends State<MechanicRegistrationScreen> {
  String? _selectedVehicleType;
  final _vehicleTypes = ['Sedan', 'SUV', 'Truck', 'Motorcycle'];

  final _primaryColor = const Color(0xFFea2a33);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Mechanic Registration',
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
            _buildSectionTitle('Personal Info'),
            _buildTextField(placeholder: 'Full Name'),
            _buildTextField(
              placeholder: 'Phone Number',
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              placeholder: 'Email Address',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(placeholder: 'Address'),
            const SizedBox(height: 24),
            _buildSectionTitle('Professional Info'),
            _buildTextField(
              placeholder: 'Years of Experience',
              keyboardType: TextInputType.number,
            ),
            _buildDropdown(),
            _buildTextArea(
              placeholder:
                  'Skills/Specializations (e.g., Engine repair, Brakes, ...)',
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Verification'),
            _buildTextField(placeholder: 'Driving License No.'),
            _buildTextField(placeholder: 'Aadhar No.'),
            const SizedBox(height: 24),
            _buildSectionTitle('Bank Details'),
            _buildTextField(placeholder: 'Account Holder Name'),
            _buildTextField(placeholder: 'Account Number'),
            _buildTextField(placeholder: 'IFSC Code'),
            const SizedBox(height: 24),
            _buildTermsAndPolicyText(),
            const SizedBox(height: 80), // Space for the floating button
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
      child: Text(
        title,
        style: GoogleFonts.splineSans(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.grey[900],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String placeholder,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: keyboardType,
        style: GoogleFonts.splineSans(fontSize: 16),
        decoration: _inputDecoration(placeholder),
      ),
    );
  }

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _selectedVehicleType,
        isExpanded: true,
        style: GoogleFonts.splineSans(fontSize: 16, color: Colors.grey[800]),
        decoration: _inputDecoration('Vehicle Types Serviced').copyWith(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
        ),
        hint: Text(
          'Vehicle Types Serviced',
          style: GoogleFonts.splineSans(color: Colors.grey[500], fontSize: 16),
        ),
        onChanged: (String? newValue) {
          setState(() {
            _selectedVehicleType = newValue;
          });
        },
        items: _vehicleTypes.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(value: value, child: Text(value));
        }).toList(),
      ),
    );
  }

  Widget _buildTextArea({required String placeholder}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: 4,
        style: GoogleFonts.splineSans(fontSize: 16),
        decoration: _inputDecoration(placeholder),
      ),
    );
  }

  InputDecoration _inputDecoration(String placeholder) {
    return InputDecoration(
      hintText: placeholder,
      hintStyle: GoogleFonts.splineSans(color: Colors.grey[500]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(color: _primaryColor, width: 2.0),
      ),
    );
  }

  Widget _buildTermsAndPolicyText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.splineSans(color: Colors.grey[600], fontSize: 14),
          children: [
            const TextSpan(text: 'By registering, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()..onTap = () {
                // Handle Terms of Service tap
              },
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(color: _primaryColor, fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()..onTap = () {
                // Handle Privacy Policy tap
              },
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAppBar() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Text(
            'Register as Mechanic',
            style: GoogleFonts.splineSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
