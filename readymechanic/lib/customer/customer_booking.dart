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

  // Mock data
  final List<Map<String, dynamic>> bookings = [
    {
      'mechanic': 'Alex',
      'service': 'Oil Change',
      'vehicle': 'Honda Civic',
      'date': '2023-10-27',
      'status': BookingStatus.pending,
    },
    {
      'mechanic': 'Ben',
      'service': 'Brake Repair',
      'vehicle': 'Toyota Camry',
      'date': '2023-10-26',
      'status': BookingStatus.accepted,
    },
    {
      'mechanic': 'Chris',
      'service': 'Tire Rotation',
      'vehicle': 'Ford Focus',
      'date': '2023-10-25',
      'status': BookingStatus.inProgress,
    },
    {
      'mechanic': 'David',
      'service': 'Engine Tune-Up',
      'vehicle': 'Chevrolet Malibu',
      'date': '2023-10-24',
      'status': BookingStatus.completed,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _selectedFilter == 'All'
        ? bookings
        : bookings
              .where(
                (b) =>
                    b['status'].toString().split('.').last.toLowerCase() ==
                    _selectedFilter.toLowerCase(),
              )
              .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: filteredBookings.length,
        itemBuilder: (context, index) {
          final booking = filteredBookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
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
                'pending',
                'accepted',
                'inProgress',
                'completed',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
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

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/customer_booking_details');
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
                      'Mechanic: ${booking["mechanic"]}',
                      style: GoogleFonts.splineSans(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['service'],
                      style: GoogleFonts.splineSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Vehicle: ${booking["vehicle"]}',
                      style: GoogleFonts.splineSans(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Date: ${booking["date"]}',
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
                  _getStatusBadge(booking['status']),
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

  Widget _getStatusBadge(BookingStatus status) {
    Color color;
    String text;
    Color textColor;

    switch (status) {
      case BookingStatus.pending:
        color = Colors.yellow[100]!;
        text = 'Pending';
        textColor = Colors.yellow[800]!;
        break;
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
