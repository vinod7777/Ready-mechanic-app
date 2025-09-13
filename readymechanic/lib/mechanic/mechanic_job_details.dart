import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicJobDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> job;

  const MechanicJobDetailsScreen({super.key, required this.job});

  // Consistent colors from other mechanic screens
  final Color _primaryColor = const Color(0xFFea2a33);
  final Color _backgroundColor = const Color(0xFFf7f8fa); // bg-gray-50
  final Color _textPrimary = const Color(0xFF1a1a1a); // text-gray-900
  final Color _textSecondary = const Color(0xFF6b7280); // text-gray-500/600

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Service Details',
          style: GoogleFonts.spaceGrotesk(
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
            _buildSectionTitle('Customer Details'),
            _buildCustomerDetailsCard(),
            const SizedBox(height: 24),
            _buildSectionTitle('Payment Status'),
            _buildPaymentStatusCard(),
          ],
        ),
      ),
      bottomNavigationBar: _buildFooterButtons(),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(
        title,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: _textPrimary,
        ),
      ),
    );
  }

  Widget _buildCustomerDetailsCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.05).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(job['image']),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['name'],
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      'Toyota Camry', // Placeholder vehicle
                      style: GoogleFonts.spaceGrotesk(color: _textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(Icons.location_on, 'Location', job['location']),
            _buildDetailRow(
              Icons.schedule,
              'Scheduled Time',
              '9:00 AM - 10:00 AM',
            ),
            _buildDetailRow(Icons.build, 'Service', job['service']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: _primaryColor.withOpacity(0.1),
            child: Icon(icon, color: _primaryColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceGrotesk(color: _textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStatusCard() {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.05).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFFdcfce7), // green-100
                  child: Icon(
                    Icons.paid,
                    color: Color(0xFF16a34a),
                  ), // green-600
                ),
                const SizedBox(width: 12),
                Text(
                  'Payment Received',
                  style: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                ),
              ],
            ),
            Text(
              '\$50.00', // Placeholder price
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            offset: Offset(0, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.navigation),
            label: const Text('Navigate to Customer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Service'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor.withAlpha((255 * 0.1).round()),
              foregroundColor: _primaryColor,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
