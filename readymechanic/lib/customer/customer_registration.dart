import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerRegistrationScreen extends StatefulWidget {
  const CustomerRegistrationScreen({super.key});

  @override
  State<CustomerRegistrationScreen> createState() =>
      _CustomerRegistrationScreenState();
}

class _CustomerRegistrationScreenState
    extends State<CustomerRegistrationScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  final _neutral100 = const Color(0xFFfcf8f8);
  final _neutral200 = const Color(0xFFf3e7e8);
  final _neutral400 = const Color(0xFF994d51);
  final _neutral900 = const Color(0xFF1b0e0e);
  final _blue600 = const Color(0xFF2563EB); // From button and links

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Create Account',
          style: GoogleFonts.splineSans(
            color: _neutral900,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
            _buildTextField(
              icon: Icons.person_outline,
              placeholder: 'Full Name',
            ),
            _buildTextField(
              icon: Icons.email_outlined,
              placeholder: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            _buildTextField(
              icon: Icons.phone_outlined,
              placeholder: 'Phone',
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              icon: Icons.lock_outline,
              placeholder: 'Password',
              obscureText: true,
            ),
            _buildTextField(
              icon: Icons.lock_outline,
              placeholder: 'Confirm Password',
              obscureText: true,
            ),
            _buildTextField(icon: Icons.home_outlined, placeholder: 'Address'),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    icon: Icons.location_city_outlined,
                    placeholder: 'City',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    icon: Icons.pin_drop_outlined,
                    placeholder: 'Pincode',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _blue600,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 5,
                shadowColor: _blue600.withOpacity(0.4),
              ),
              child: Text(
                'Register',
                style: GoogleFonts.splineSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildTermsAndPolicyText(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String placeholder,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.splineSans(color: _neutral900),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: GoogleFonts.splineSans(color: _neutral400),
          filled: true,
          fillColor: _neutral100,
          prefixIcon: Icon(icon, color: _neutral400),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: _neutral200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: _neutral200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: _primaryColor, width: 2.0),
          ),
        ),
      ),
    );
  }

  Widget _buildTermsAndPolicyText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.splineSans(color: _neutral400, fontSize: 14),
          children: [
            const TextSpan(text: 'By registering, you agree to our '),
            TextSpan(
              text: 'Terms of Service',
              style: TextStyle(color: _blue600, fontWeight: FontWeight.w600),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  // Handle Terms of Service tap
                },
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(color: _blue600, fontWeight: FontWeight.w600),
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
}
