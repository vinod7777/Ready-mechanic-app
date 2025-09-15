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

  bool _isUpdatingStatus = false;
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
        const SnackBar(
          content: Text('Customer phone number is not available.'),
        ),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('An error occurred: $e')));
    }
  }

  Future<void> _updateBookingStatus(String status) async {
    if (_isUpdatingStatus) return;
    setState(() {
      _isUpdatingStatus = true;
    });
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.job['bookingId'])
          .update({'status': status});
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Job marked as $status!')));
    } catch (e) {
      // Handle error
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingStatus = false;
        });
      }
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .doc(widget.job['bookingId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Job details not found.'));
          }

          final jobData = snapshot.data!.data() as Map<String, dynamic>;
          // Keep original bookingId
          jobData['bookingId'] = widget.job['bookingId'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Customer Details'),
                _buildCustomerDetailsCard(jobData),
                const SizedBox(height: 24),
                _buildSectionTitle('Payment Status'),
                _buildPaymentStatusCard(jobData),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildFooterButtons(widget.job),
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

  Widget _buildCustomerDetailsCard(Map<String, dynamic> jobData) {
    final vehicle = jobData['vehicle'] as Map<String, dynamic>? ?? {};
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
                      (jobData['customerImage'] != null &&
                          jobData['customerImage'].isNotEmpty)
                      ? NetworkImage(jobData['customerImage'])
                      : null,
                  child:
                      (jobData['customerImage'] == null ||
                          jobData['customerImage'].isEmpty)
                      ? Icon(Icons.person, color: Colors.grey[400], size: 32)
                      : null,
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      jobData['customerName'] ?? 'N/A',
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
                    _makePhoneCall(jobData['customerPhone'] as String?);
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
              jobData['address'] ?? 'N/A',
            ),
            _buildDetailRow(
              Icons.schedule,
              'Scheduled Time',
              (jobData['createdAt'] as Timestamp?)
                      ?.toDate()
                      .toString()
                      .substring(0, 16) ??
                  'N/A',
            ),
            _buildDetailRow(
              Icons.build,
              'Service',
              jobData['service'] ?? 'N/A',
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

  Widget _buildPaymentStatusCard(Map<String, dynamic> jobData) {
    final isPaid = jobData['paymentStatus'] == 'paid';

    return Card(
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.05).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Opacity(
          opacity: isPaid ? 1.0 : 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isPaid
                        ? const Color(0xFFdcfce7)
                        : const Color(0xFFffedd5),
                    child: Icon(
                      isPaid ? Icons.paid : Icons.hourglass_bottom,
                      color: isPaid
                          ? const Color(0xFF16a34a)
                          : const Color(0xFFc2410c),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isPaid ? 'Payment Received' : 'Payment Pending',
                    style: GoogleFonts.spaceGrotesk(
                      fontWeight: FontWeight.w500,
                      color: _textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '₹${jobData['serviceCost'] ?? 0}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterButtons(Map<String, dynamic> jobData) {
    final status = (jobData['status'] as String?)?.toLowerCase();
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
                final location = jobData['location'] as Map<String, dynamic>?;
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
            if (status == 'accepted')
              ElevatedButton.icon(
                onPressed: () => _showOtpDialog(jobData),
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
              )
            else if (status == 'inprogress')
              ElevatedButton.icon(
                onPressed: _isUpdatingStatus
                    ? null
                    : () => _updateBookingStatus('completed'),
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark as Completed'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16a34a), // green-600
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: Colors.grey[300],
                ),
              )
            else if (status == 'completed')
              const Text(
                'This job has been completed.',
                style: TextStyle(color: Colors.green),
              ),
          ],
        ),
      ),
    );
  }

  void _showOtpDialog(Map<String, dynamic> jobData) {
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
              if (otpController.text == jobData['serviceStartOTP']) {
                FirebaseFirestore.instance
                    .collection('bookings')
                    .doc(jobData['bookingId'])
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
