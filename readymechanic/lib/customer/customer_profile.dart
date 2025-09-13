import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  final _secondaryColor = const Color(0xFFf7f7f7);
  final _textPrimary = const Color(0xFF1a1a1a);
  final _textSecondary = const Color(0xFF6b7280);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.splineSans(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)], // To balance the leading icon
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfilePictureSection(),
            const SizedBox(height: 16),
            Text(
              'Sophia Carter',
              style: GoogleFonts.splineSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            Text(
              'Member since 2021',
              style: GoogleFonts.splineSans(
                fontSize: 14,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            _buildProfileForm(),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                // TODO: Handle logout
              },
              child: Text(
                'Logout',
                style: GoogleFonts.splineSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.red[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePictureSection() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 64,
          backgroundImage: NetworkImage(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB5r52uxl3F3tX1KTmTy2KCeDctb0tUKg3RSz2xvHYlsg0YZEOmuX1-Hh7MrNcHWz6AUtlDf-pa0vJjllUK7IFVDKk5H7F9uNcxoX8xemQptVQ8ipQCYL7wRxVSGHbLKbLVSfVC1Ond5GmwhJpdsRBf8ZoiB38VNwDJmsc8N3aBL6Tq2MFvHt0Jl5kHeI6cY9WvuUH1IGC0R1eCOXaFF3JeGH1_sDwUdRhknpBtw9WQvYOTSefnkOh0cljFTE8RIQSjdQmb-WDjqyU',
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 16),
              onPressed: () {
                // TODO: Handle edit profile picture
              },
              padding: EdgeInsets.zero,
              splashRadius: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileForm() {
    return Form(
      child: Column(
        children: [
          _buildTextField(label: 'Full Name', initialValue: 'Sophia Carter'),
          _buildTextField(
            label: 'Phone',
            initialValue: '(555) 123-4567',
            keyboardType: TextInputType.phone,
          ),
          _buildTextField(label: 'City', initialValue: 'San Francisco'),
          _buildTextField(label: 'Address', initialValue: '123 Main Street'),
          _buildTextField(
            label: 'Email',
            initialValue: 'sophia.carter@example.com',
            readOnly: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // TODO: Handle save changes
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 5,
              shadowColor: _primaryColor.withAlpha((255 * 0.4).round()),
            ),
            child: Text(
              'Save Changes',
              style: GoogleFonts.splineSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    TextInputType? keyboardType,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.splineSans(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: _textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            initialValue: initialValue,
            keyboardType: keyboardType,
            readOnly: readOnly,
            style: GoogleFonts.splineSans(color: _textPrimary),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? Colors.grey[100] : _secondaryColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: Colors.grey[200]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24),
                borderSide: BorderSide(color: _primaryColor, width: 2.0),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
