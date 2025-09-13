import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                child: Form(
                  key: _formKey,
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
                      _buildTextField(
                        controller: _emailController,
                        icon: Icons.mail,
                        hint: 'Email',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        controller: _passwordController,
                        icon: Icons.lock,
                        hint: 'Password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
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
                        onPressed: _isLoading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          minimumSize: const Size(double.infinity, 56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 5,
                          shadowColor: primaryColor.withAlpha(
                            (255 * 0.3).round(),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : Text(
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
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      debugPrint('Attempting to sign in with email and password...');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        final selectedRole = _userType == UserType.customer
            ? 'customer'
            : 'mechanic';
        final collectionName = selectedRole == 'customer'
            ? 'customers'
            : 'mechanics';

        final userDoc = await _firestore
            .collection(collectionName)
            .doc(userCredential.user!.uid)
            .get();

        if (userDoc.exists) {
          // User found in the correct collection. Proceed to dashboard.
          final dashboardRoute = selectedRole == 'customer'
              ? '/customer_dashboard'
              : '/mechanic_dashboard';
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil(dashboardRoute, (route) => false);
        } else {
          // User not found in the selected collection. Check the other one to provide a better error.
          final otherCollection = selectedRole == 'customer'
              ? 'mechanics'
              : 'customers';
          final otherDoc = await _firestore
              .collection(otherCollection)
              .doc(userCredential.user!.uid)
              .get();

          if (otherDoc.exists) {
            // User exists, but with the other role.
            final actualRole = selectedRole == 'customer'
                ? 'mechanic'
                : 'customer';
            throw ('You are registered as a $actualRole. Please log in with the correct role.');
          } else {
            // User not found in either collection.
            throw ('User data not found in database. Please contact support.');
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'User not found. Please contact support.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = e.message ?? 'An unknown error occurred.';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } on FirebaseException catch (e) {
      debugPrint('FirebaseException: ${e.code} - ${e.message}');
      if (e.code == 'permission-denied') {
        throw ('You do not have permission to access user data. Please check Firestore rules.');
      } else {
        rethrow;
      }
    } catch (e) {
      debugPrint('Caught generic exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
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
                    color: Colors.black.withAlpha((255 * 0.1).round()),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.splineSans(color: textColor),
      decoration: InputDecoration(
        errorStyle: const TextStyle(height: 0.8),
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
