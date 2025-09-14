import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:url_launcher/url_launcher.dart' as url_launcher;

class MechanicJobDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> job;

  const MechanicJobDetailsScreen({super.key, required this.job});

  @override
  State<MechanicJobDetailsScreen> createState() =>
      _MechanicJobDetailsScreenState();
}

class _MechanicJobDetailsScreenState extends State<MechanicJobDetailsScreen> {
  // Consistent colors
  final Color _primaryColor = const Color(0xFFea2a33);
  final Color _backgroundColor = const Color(0xFFf7f8fa); // bg-gray-50
  final Color _textPrimary = const Color(0xFF1a1a1a); // text-gray-900
  final Color _textSecondary = const Color(0xFF6b7280); // text-gray-500/600

  Future<void> _openMap(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location not available for this job.')),
      );
      return;
    }
    // Universal URL for starting navigation. This will open in a browser or the Maps app.
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    try {
      if (await url_launcher.canLaunchUrl(googleMapsUrl)) {
        await url_launcher.launchUrl(googleMapsUrl);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open navigation.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while opening navigation: $e'),
        ),
      );
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Customer phone number is not available.')),
      );
      return;
    }

    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await url_launcher.canLaunchUrl(phoneUri)) {
        await url_launcher.launchUrl(phoneUri);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the dialer.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }
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
    final vehicle = widget.job['vehicle'] as Map<String, dynamic>? ?? {};
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
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      (widget.job['customerImage'] != null &&
                          widget.job['customerImage'].isNotEmpty)
                      ? NetworkImage(widget.job['customerImage'])
                      : null,
                  child:
                      (widget.job['customerImage'] == null ||
                          widget.job['customerImage'].isEmpty)
                      ? Icon(Icons.person, color: Colors.grey[400], size: 32)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job['customerName'] ?? 'N/A',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _textPrimary,
                      ),
                    ),
                    Text(
                      '${vehicle['make'] ?? ''} ${vehicle['model'] ?? ''}',
                      style: GoogleFonts.spaceGrotesk(color: _textSecondary),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    _makePhoneCall(widget.job['customerPhone'] as String?);
                  },
                  icon: Icon(Icons.phone, color: _primaryColor),
                  tooltip: 'Call Customer',
                ),
              ],
            ),
            const Divider(height: 32),
            _buildDetailRow(
              Icons.location_on,
              'Location',
              widget.job['address'] ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.schedule,
              'Scheduled Time',
              (widget.job['createdAt'] as Timestamp?)
                      ?.toDate()
                      .toString()
                      .substring(0, 16) ??
                  'N/A',
            ),
            _buildDetailRow(
              Icons.build,
              'Service',
              widget.job['service'] ?? 'N/A',
            ),
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
            backgroundColor: _primaryColor.withAlpha((255 * 0.1).round()),
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
              '₹${widget.job['serviceCost'] ?? 0}',
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
    final status = (widget.job['status'] as String?)?.toLowerCase();
    return Container(
      // Wrap with a container
      padding: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24,
      ), // Adjust padding for safe area
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
      child: SafeArea(
        // Use SafeArea to avoid system intrusions
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                final location =
                    widget.job['location'] as Map<String, dynamic>?;
                _openMap(location?['lat'], location?['lng']);
              },
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
              onPressed: status == 'accepted' ? () => _showOtpDialog() : null,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Service'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor.withAlpha((255 * 0.1).round()),
                foregroundColor: _primaryColor,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                disabledBackgroundColor: Colors.grey[200],
                disabledForegroundColor: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOtpDialog() {
    final otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Service OTP'),
        content: TextField(
          controller: otpController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Enter OTP from customer',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (otpController.text == widget.job['serviceStartOTP']) {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(widget.job['bookingId'])
                    .update({'status': 'inprogress'});
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Service Started!')),
                );
              } else {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Invalid OTP.')));
              }
            },
            child: const Text('Verify & Start'),
          ),
        ],
      ),
    );
  }
}
