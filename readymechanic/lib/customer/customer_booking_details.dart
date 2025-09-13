import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerBookingDetailsScreen extends StatefulWidget {
  const CustomerBookingDetailsScreen({super.key});

  @override
  State<CustomerBookingDetailsScreen> createState() =>
      _CustomerBookingDetailsScreenState();
}

class _CustomerBookingDetailsScreenState
    extends State<CustomerBookingDetailsScreen> {
  int _selectedIndex = 1; // Set to Bookings
  final _primaryColor = const Color(0xFFea2a33);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // TODO: Handle navigation to other screens
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Booking Details',
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
        child: Column(
          children: [
            _buildMechanicDetailsCard(),
            const SizedBox(height: 16),
            _buildServiceDetailsCard(),
            const SizedBox(height: 16),
            _buildStatusAndCostCard(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_outlined),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car_outlined),
            label: 'Vehicles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: _primaryColor,
        unselectedItemColor: Colors.grey[600],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        showUnselectedLabels: true,
        selectedLabelStyle: GoogleFonts.splineSans(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.splineSans(),
      ),
    );
  }

  Widget _buildMechanicDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mechanic Details',
            style: GoogleFonts.splineSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuC61vSy---n2xIijzlucTB_1drBFR0uiC7xVtOZGdyf_3uq0oPxteY2zeY8DjavQ0Kz-qSbKy2hlwm0SP3nnqrLnb6DqmTKLG2L664ho3OCt5muVWq72VUMFIqhgfcY8JpxoYPx6EOhmZrHu9hwMD2ITwAwboievPg7_r1bwV7FPngiGhwkv0ne6PNy_m0P5Zrxrcs2nqpNH_qkIMO5dHzJIMzzOwVLBXoSuC1iOduSEar0KLkvjtDW0wsD_yuQxwlq8MXp83oX91g',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ethan Carter',
                      style: GoogleFonts.splineSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[900],
                      ),
                    ),
                    Text(
                      'Mechanic',
                      style: GoogleFonts.splineSans(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone, color: Colors.white),
                style: IconButton.styleFrom(
                  backgroundColor: _primaryColor,
                  fixedSize: const Size(40, 40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: GoogleFonts.splineSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.build,
            title: 'Oil Change',
            subtitle: 'Service',
            trailing: '\$80',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            icon: Icons.directions_car,
            title: 'Honda Civic',
            subtitle: '2018',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            icon: Icons.location_on,
            title: '123 Main St, Anytown',
            isLink: true,
            linkText: 'View on Map',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusAndCostCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status & Cost',
            style: GoogleFonts.splineSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            icon: Icons.check_circle,
            title: 'Completed',
            subtitle: 'Status',
            iconColor: Colors.green,
            iconBgColor: Colors.green[100],
          ),
          const Divider(height: 24),
          _buildDetailRow(
            icon: Icons.payments,
            title: '\$80.00',
            subtitle: 'Total Cost',
            iconColor: Colors.grey[600],
            iconBgColor: const Color(0xFFF5F5F5),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download, size: 20),
            label: const Text('Download Invoice'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    String? subtitle,
    String? trailing,
    Color? iconColor,
    Color? iconBgColor,
    bool isLink = false,
    String? linkText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: iconBgColor ?? _primaryColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor ?? _primaryColor, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.splineSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle,
                  style: GoogleFonts.splineSans(color: Colors.grey[500]),
                ),
              if (isLink)
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                  child: Text(
                    linkText ?? 'View',
                    style: TextStyle(
                      color: _primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: GoogleFonts.splineSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[900],
            ),
          ),
      ],
    );
  }
}
