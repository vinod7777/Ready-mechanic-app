import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Text Editing Controllers
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _addressController = TextEditingController();
  final _experienceController = TextEditingController();
  final _skillsController = TextEditingController();
  final _licenseController = TextEditingController();
  final _aadharController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscController = TextEditingController();

  String? _selectedVehicleType;
  final _vehicleTypes = ['Sedan', 'SUV', 'Truck', 'Motorcycle'];

  final _primaryColor = const Color(0xFFea2a33);
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _addressController.dispose();
    _experienceController.dispose();
    _skillsController.dispose();
    _licenseController.dispose();
    _aadharController.dispose();
    _accountNumberController.dispose();
    _ifscController.dispose();
    super.dispose();
  }

  String? _validateNonEmpty(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your $fieldName';
    }
    return null;
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Personal Info'),
              TextFormField(
                controller: _nameController,
                decoration: _inputDecoration('Full Name'),
                validator: (v) => _validateNonEmpty(v, 'full name'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: _inputDecoration('Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) => _validateNonEmpty(v, 'phone number'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration('Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || !v.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: _inputDecoration('Password'),
                obscureText: true,
                validator: (v) {
                  if (v == null || v.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: _inputDecoration('Address'),
                validator: (v) => _validateNonEmpty(v, 'address'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Professional Info'),
              TextFormField(
                controller: _experienceController,
                decoration: _inputDecoration('Years of Experience'),
                keyboardType: TextInputType.number,
                validator: (v) => _validateNonEmpty(v, 'experience'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              _buildDropdown(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _skillsController,
                decoration: _inputDecoration(
                  'Skills/Specializations (e.g., Engine repair, Brakes, ...)',
                ),
                maxLines: 4,
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Verification'),
              TextFormField(
                controller: _licenseController,
                decoration: _inputDecoration('Driving License No.'),
                validator: (v) => _validateNonEmpty(v, 'license number'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _aadharController,
                decoration: _inputDecoration('Aadhar No.'),
                validator: (v) => _validateNonEmpty(v, 'Aadhar number'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildSectionTitle('Bank Details'),
              TextFormField(
                controller: _accountNumberController,
                decoration: _inputDecoration('Account Number'),
                validator: (v) => _validateNonEmpty(v, 'account number'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ifscController,
                decoration: _inputDecoration('IFSC Code'),
                validator: (v) => _validateNonEmpty(v, 'IFSC code'),
                style: GoogleFonts.splineSans(fontSize: 16),
              ),
              const SizedBox(height: 24),
              _buildTermsAndPolicyText(),
              const SizedBox(height: 80), // Space for the floating button
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  // ... (keep _buildSectionTitle)

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
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Handle Terms of Service tap
                },
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                color: _primaryColor,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
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
          onPressed: _isLoading ? null : _registerMechanic,
          style: ElevatedButton.styleFrom(
            backgroundColor: _primaryColor,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Text(
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

  Future<void> _registerMechanic() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Save mechanic details to Firestore
      if (userCredential.user != null) {
        await _firestore
            .collection('mechanics')
            .doc(userCredential.user!.uid)
            .set({
              'uid': userCredential.user!.uid,
              'fullName': _nameController.text.trim(),
              'email': _emailController.text.trim(),
              'phone': _phoneController.text.trim(),
              'address': _addressController.text.trim(),
              'experience': _experienceController.text.trim(),
              'skills': _skillsController.text.trim(),
              'vehicleTypes': _selectedVehicleType != null
                  ? [_selectedVehicleType]
                  : [],
              'licenseNumber': _licenseController.text.trim(),
              'aadharNumber': _aadharController.text.trim(),
              'bankAccount': _accountNumberController.text.trim(),
              'ifscCode': _ifscController.text.trim(),
              'userType': 'mechanic',
              'status': 'pending_verification',
              'isActive': false,
              'totalEarnings': 0,
              'totalJobs': 0,
              'photoURL': null,
              'createdAt': FieldValue.serverTimestamp(),
            });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please log in.'),
            ),
          );
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'An error occurred.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
