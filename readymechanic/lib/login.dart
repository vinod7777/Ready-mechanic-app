import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum UserType { customer, mechanic }

class _LoginScreenState extends State<LoginScreen> {
  UserType _userType = UserType.customer;

  Color get primaryColor => _userType == UserType.customer
      ? const Color(0xFFea2a33)
      : const Color(0xFF1e40af);
  Color get bgColor => _userType == UserType.customer
      ? const Color(0xFFfcf8f8)
      : const Color(0xFFf0f5ff);
  Color get textColor => _userType == UserType.customer
      ? const Color(0xFF1b0e0e)
      : const Color(0xFF1e293b);
  Color get subtleTextColor => _userType == UserType.customer
      ? const Color(0xFF994d51)
      : const Color(0xFF64748b);
  Color get inputBgColor => _userType == UserType.customer
      ? const Color(0xFFf3e7e8)
      : const Color(0xFFe0e7ff);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    const Icon(
                      Icons.directions_car,
                      size: 60,
                      color: Color(
                        0xFFea2a33,
                      ), // This seems to be constant in the HTML
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Welcome to ReadyMechanic ',
                      style: GoogleFonts.splineSans(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Login to continue',
                      style: GoogleFonts.splineSans(
                        fontSize: 16,
                        color: subtleTextColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    _buildUserTypeToggle(),
                    const SizedBox(height: 32),
                    _buildTextField(Icons.mail, 'Email'),
                    const SizedBox(height: 16),
                    _buildTextField(Icons.lock, 'Password', obscureText: true),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.splineSans(
                            color: subtleTextColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_userType == UserType.customer) {
                          Navigator.of(context).pushNamedAndRemoveUntil('/customer_dashboard', (route) => false);
                        } else {
                          Navigator.of(context).pushNamedAndRemoveUntil('/mechanic_dashboard', (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                        elevation: 5,
                        shadowColor: primaryColor.withOpacity(0.3),
                      ),
                      child: Text(
                        'Login',
                        style: GoogleFonts.splineSans(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't have an account? ",
                            style: GoogleFonts.splineSans(
                              color: subtleTextColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              if (_userType == UserType.mechanic) {
                                Navigator.pushNamed(
                                  context,
                                  '/mechanic_registration',
                                );
                              } else {
                                Navigator.pushNamed(
                                  context,
                                  '/customer_registration',
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.splineSans(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeToggle() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: inputBgColor,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        children: [
          Expanded(child: _buildToggleOption(UserType.customer, 'Customer')),
          Expanded(child: _buildToggleOption(UserType.mechanic, 'Mechanic')),
        ],
      ),
    );
  }

  Widget _buildToggleOption(UserType userType, String text) {
    final isSelected = _userType == userType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _userType = userType;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.splineSans(
              fontWeight: FontWeight.w500,
              color: isSelected ? textColor : subtleTextColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    IconData icon,
    String hint, {
    bool obscureText = false,
  }) {
    return TextField(
      obscureText: obscureText,
      style: GoogleFonts.splineSans(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.splineSans(color: subtleTextColor),
        filled: true,
        fillColor: inputBgColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        prefixIcon: Icon(icon, color: subtleTextColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
      ),
    );
  }
}
