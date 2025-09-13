import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicProfileScreen extends StatefulWidget {
  const MechanicProfileScreen({super.key});

  @override
  State<MechanicProfileScreen> createState() => _MechanicProfileScreenState();
}

class _MechanicProfileScreenState extends State<MechanicProfileScreen> {
  // Colors from other mechanic screens
  final Color _primaryColor = const Color(0xFFea2a33);
  final Color _backgroundColor = Colors.grey[50]!;
  final Color _textPrimary = Colors.grey[800]!;
  final Color _textSecondary = Colors.grey[600]!;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: GoogleFonts.spaceGrotesk(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _auth.currentUser != null
            ? _firestore
                  .collection('mechanics')
                  .doc(_auth.currentUser!.uid)
                  .snapshots()
            : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Mechanic data not found.'));
          }

          final mechanicData = snapshot.data!.data() as Map<String, dynamic>;
          final photoURL = mechanicData['photoURL'] as String?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: (photoURL != null && photoURL.isNotEmpty)
                      ? NetworkImage(photoURL)
                      : null,
                  child: (photoURL == null || photoURL.isEmpty)
                      ? Icon(Icons.person, size: 60, color: Colors.grey[400])
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  mechanicData['fullName'] ?? 'N/A',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  'Mechanic',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 16,
                    color: _textSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Professional Details'),
                _buildTextField(
                  label: 'Name',
                  value: mechanicData['fullName'] ?? '',
                ),
                _buildTextField(
                  label: 'Email',
                  value: mechanicData['email'] ?? '',
                ),
                _buildTextField(
                  label: 'Phone',
                  value: mechanicData['phone'] ?? '',
                ),
                _buildTextField(
                  label: 'Address',
                  value: mechanicData['address'] ?? '',
                ),
                _buildTextField(
                  label: 'License Number',
                  value: mechanicData['licenseNumber'] ?? '',
                ),
                const SizedBox(height: 24),
                _buildSectionTitle('Bank Details'),
                _buildTextField(
                  label: 'Account Number',
                  value:
                      '**** **** **** ${mechanicData['bankAccount']?.substring(mechanicData['bankAccount'].length - 4)}',
                ),
                _buildTextField(
                  label: 'IFSC Code',
                  value: mechanicData['ifscCode'] ?? '',
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextButton(
                    onPressed: () async {
                      await _auth.signOut();
                      if (mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (Route<dynamic> route) => false,
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: _primaryColor.withAlpha(
                        (255 * 0.1).round(),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      'Logout',
                      style: GoogleFonts.spaceGrotesk(
                        color: _primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Text(
          title,
          style: GoogleFonts.spaceGrotesk(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: value,
        readOnly: true, // Making fields read-only for a profile view
        style: GoogleFonts.spaceGrotesk(fontSize: 16, color: _textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.spaceGrotesk(color: _textSecondary),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }
}
