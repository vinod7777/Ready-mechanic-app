import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum BookingStatus { pending, accepted, inProgress, completed }

class CustomerBookingsListScreen extends StatefulWidget {
  const CustomerBookingsListScreen({super.key});

  @override
  State<CustomerBookingsListScreen> createState() =>
      _CustomerBookingsListScreenState();
}

class _CustomerBookingsListScreenState
    extends State<CustomerBookingsListScreen> {
  String _selectedFilter = 'All';
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          
          title: Text(
            'Bookings',
            style: GoogleFonts.splineSans(
              color: Colors.grey[800],
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: _buildFilterDropdown(),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getBookingsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No bookings found.'));
          }

          final bookings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index].data() as Map<String, dynamic>;
              final bookingId = bookings[index].id;
              return _buildBookingCard(booking, bookingId);
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getBookingsStream() {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    Query query = FirebaseFirestore.instance
        .collection('bookings')
        .where('customerId', isEqualTo: user.uid);

    if (_selectedFilter != 'All') {
      query = query.where('status', isEqualTo: _selectedFilter.toLowerCase());
    }

    return query.snapshots();
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    if (s == 'inProgress') return 'In-Progress';
    return s[0].toUpperCase() + s.substring(1);
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedFilter,
          isExpanded: true,
          icon: const Icon(Icons.expand_more, color: Colors.grey),
          onChanged: (String? newValue) {
            setState(() {
              _selectedFilter = newValue!;
            });
          },
          items:
              <String>[
                'All',
                'Pending',
                'Accepted',
                'InProgress',
                'Completed',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    _capitalize(value),
                    style: GoogleFonts.splineSans(
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking, String bookingId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          // Add bookingId to the map and pass it to the details screen
          final arguments = Map<String, dynamic>.from(booking);
          arguments['bookingId'] = bookingId;
          Navigator.pushNamed(
            context,
            '/customer_booking_details',
            arguments: arguments,
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mechanic: ${booking["mechanicName"] ?? 'N/A'}',
                      style: GoogleFonts.splineSans(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['service'] ??
                          'Unknown Service', // Use 'service' field
                      style: GoogleFonts.splineSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vehicle: ${booking["vehicle"]?['make'] ?? ''} ${booking["vehicle"]?['model'] ?? ''}', // Use vehicle map
                      style: GoogleFonts.splineSans(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${booking["createdAt"]?.toDate().toString().substring(0, 10) ?? 'N/A'}', // Use 'createdAt' field
                      style: GoogleFonts.splineSans(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _getStatusBadgeFromString(booking['status']),
                  const SizedBox(height: 8),
                  if (booking['serviceCost'] != null)
                    Text(
                      '₹${booking['serviceCost']}', // Use 'serviceCost' field
                      style: GoogleFonts.splineSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStatusBadgeFromString(String? statusStr) {
    BookingStatus status;
    switch (statusStr?.toLowerCase()) {
      case 'pending':
        status = BookingStatus.pending;
        break;
      case 'accepted':
        status = BookingStatus.accepted;
        break;
      case 'inprogress':
        status = BookingStatus.inProgress;
        break;
      case 'completed':
        status = BookingStatus.completed;
        break;
      default:
        status = BookingStatus.pending; // Default case
    }

    Color color;
    String text;
    Color textColor;

    switch (status) {
      case BookingStatus.accepted:
        color = Colors.blue[100]!;
        text = 'Accepted';
        textColor = Colors.blue[800]!;
        break;
      case BookingStatus.inProgress:
        color = Colors.indigo[100]!;
        text = 'In-Progress';
        textColor = Colors.indigo[800]!;
        break;
      case BookingStatus.completed:
        color = Colors.green[100]!;
        text = 'Completed';
        textColor = Colors.green[800]!;
        break;
      case BookingStatus.pending:
        color = Colors.yellow[100]!;
        text = 'Pending';
        textColor = Colors.yellow[800]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: GoogleFonts.splineSans(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
