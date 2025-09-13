import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

class CustomerConfirmationScreen extends StatefulWidget {
  final String vehicle;
  final String serviceName;
  final int servicePrice;
  final String address;
  final String city;
  final String issueDescription;
  final String mechanicId;
  final String mechanicName;
  final String mechanicImage;
  final String mechanicRating;

  const CustomerConfirmationScreen({
    super.key,
    required this.vehicle,
    required this.serviceName,
    required this.servicePrice,
    required this.address,
    required this.city,
    required this.issueDescription,
    required this.mechanicId,
    required this.mechanicName,
    required this.mechanicImage,
    required this.mechanicRating,
  });

  @override
  State<CustomerConfirmationScreen> createState() =>
      _CustomerConfirmationScreenState();
}

class _CustomerConfirmationScreenState
    extends State<CustomerConfirmationScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  final _backgroundColor = const Color(0xFFf7f8fa); // Corresponds to bg-gray-50
  final _textPrimary = const Color(0xFF1a1a1a); // Corresponds to text-gray-900
  final _textSecondary = const Color(
    0xFF6b7280,
  ); // Corresponds to text-gray-500

  bool _isBooking = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: _backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Confirm Booking',
          style: GoogleFonts.splineSans(
            color: _textPrimary,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'VEHICLE',
                    style: GoogleFonts.splineSans(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.05).round()),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.directions_car,
                          color: Colors.grey[400],
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.vehicle.split(' - ')[0],
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.vehicle.split(' - ').length > 1
                                ? widget.vehicle.split(' - ')[1]
                                : '',
                            style: GoogleFonts.splineSans(
                              color: _textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'SERVICE DETAILS',
                    style: GoogleFonts.splineSans(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.05).round()),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.serviceName,
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₹${widget.servicePrice}',
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 24,
                        thickness: 1,
                        color: Color(0xFFf3f4f6),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Service Fee',
                            style: GoogleFonts.splineSans(
                              color: _textSecondary,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '₹0', // Assuming no service fee for now
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 24,
                        thickness: 1,
                        color: Color(0xFFf3f4f6),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '₹${widget.servicePrice}',
                            style: GoogleFonts.splineSans(
                              color: _primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'LOCATION',
                    style: GoogleFonts.splineSans(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.05).round()),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _primaryColor.withAlpha((255 * 0.1).round()),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.location_on, color: _primaryColor),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          '${widget.address}, ${widget.city}',
                          style: GoogleFonts.splineSans(
                            color: _textPrimary,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8.0,
                  ),
                  child: Text(
                    'MECHANIC',
                    style: GoogleFonts.splineSans(
                      color: _textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.05).round()),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(widget.mechanicImage),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.mechanicName,
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.amber[700],
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${widget.mechanicRating} / 5.0',
                                style: GoogleFonts.splineSans(
                                  color: _textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!, width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              onPressed: _isBooking ? null : _confirmAndBook,
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
              child: _isBooking
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : Text(
                      'Confirm & Book',
                      style: GoogleFonts.splineSans(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateOTP() {
    var rng = Random();
    return (100000 + rng.nextInt(900000)).toString();
  }

  Future<void> _confirmAndBook() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to book.')),
      );
      return;
    }

    setState(() {
      _isBooking = true;
    });

    String? customerImage;
    try {
      final customerDoc =
          await FirebaseFirestore.instance.collection('customers').doc(user.uid).get();
      if (customerDoc.exists) {
        customerImage = customerDoc.data()?['photoURL'];
      }
    } catch (_) {}

    try {
      final serviceStartOTP = _generateOTP();

      await FirebaseFirestore.instance.collection('bookings').add({
        'customerId': user.uid,
        'customerName': user.displayName ?? 'N/A',
        'customerImage': customerImage,
        'mechanicId': widget.mechanicId,
        'mechanicName': widget.mechanicName,
        'mechanicImage': widget.mechanicImage, // Added mechanic image
        'service': widget.serviceName, // Corrected field name
        'serviceCost': widget.servicePrice, // Corrected field name
        'vehicle': {
          // Saving as a map to match your structure
          'make': widget.vehicle.split(' - ')[0],
          'model': widget.vehicle.split(' - ').length > 1
              ? widget.vehicle.split(' - ')[1]
              : '',
          'type': 'Car', // Assuming 'Car' for now, can be made dynamic later
        },
        'address': '${widget.address}, ${widget.city}',
        'description': widget.issueDescription, // Corrected field name
        'createdAt': FieldValue.serverTimestamp(), // Corrected field name
        'status': 'pending',
        'serviceStartOTP': serviceStartOTP,
      });

      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/customer_dashboard',
        (Route<dynamic> route) => false,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking confirmed successfully!')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to create booking: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isBooking = false;
        });
      }
    }
  }
}
