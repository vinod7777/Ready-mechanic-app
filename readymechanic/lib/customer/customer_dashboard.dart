import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({super.key});

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  final _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        title: Text(
          'Dashboard',
          style: GoogleFonts.splineSans(
            color: Colors.grey[800],
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 56)], // To balance the leading icon
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, ${_currentUser?.displayName?.split(' ').first ?? 'User'}!',
              style: GoogleFonts.splineSans(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 24),
            _buildStatsList(),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/customer_book_service');
              },
              icon: const Icon(Icons.add, size: 28),
              label: Text(
                'Book New Service',
                style: GoogleFonts.splineSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 5,
                shadowColor: _primaryColor.withAlpha((255 * 0.4).round()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsList() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return _buildStatCards(0, 0, 0); // Show 0 if not logged in
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('customerId', isEqualTo: user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildStatCards(null, null, null); // Loading state
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return _buildStatCards(0, 0, 0); // Error or no data state
        }

        final bookings = snapshot.data!.docs;
        final totalBookings = bookings.length;
        final completedServices = bookings
            .where((doc) => doc['status'] == 'completed')
            .length;
        final ongoingBookings = bookings
            .where(
              (doc) =>
                  doc['status'] == 'accepted' || doc['status'] == 'inprogress',
            )
            .length;

        return _buildStatCards(
          totalBookings,
          completedServices,
          ongoingBookings,
        );
      },
    );
  }

  Widget _buildStatCards(int? total, int? completed, int? ongoing) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/customer_booking'),
          child: _buildStatCard('Total Bookings', total?.toString() ?? '...'),
        ),
        const SizedBox(height: 16),
        _buildStatCard('Completed Services', completed?.toString() ?? '...'),
        const SizedBox(height: 16),
        _buildStatCard('Ongoing Bookings', ongoing?.toString() ?? '...'),
      ],
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.1).round()),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.splineSans(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.splineSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
