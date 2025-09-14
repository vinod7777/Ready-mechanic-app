import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:readymechanic/customer/customer_booking.dart';

class CustomerBookingDetailsScreen extends StatefulWidget {
  const CustomerBookingDetailsScreen({super.key});

  @override
  State<CustomerBookingDetailsScreen> createState() =>
      _CustomerBookingDetailsScreenState();
}

class _CustomerBookingDetailsScreenState
    extends State<CustomerBookingDetailsScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  bool _isPaying = false;

  Future<void> _openMap(double? lat, double? lng) async {
    if (lat == null || lng == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location not available for this booking.'),
        ),
      );
      return;
    }
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );

    try {
      if (await url_launcher.canLaunchUrl(googleMapsUrl)) {
        await url_launcher.launchUrl(googleMapsUrl);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the map.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while opening the map: $e')),
      );
    }
  }

  Future<void> _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone number is not available.')),
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

  Future<void> _handlePayment(String bookingId) async {
    setState(() {
      _isPaying = true;
    });

    // Simulate a network call for payment processing
    await Future.delayed(const Duration(seconds: 2));

    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'paymentStatus': 'paid'});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Payment failed: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPaying = false;
        });
      }
    }
  }

  void _downloadInvoice() {
    // TODO: Implement actual invoice generation and download logic
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Downloading invoice...')));
  }

  @override
  Widget build(BuildContext context) {
    final booking =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>? ??
        {};
    final String bookingId = booking['bookingId'] ?? '';
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .doc(bookingId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final updatedBooking = snapshot.data!.data() as Map<String, dynamic>;
          updatedBooking['bookingId'] = snapshot.data!.id; // Keep the id

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildMechanicDetailsCard(updatedBooking),
                const SizedBox(height: 16),
                _buildServiceDetailsCard(updatedBooking),
                const SizedBox(height: 16),
                _buildStatusAndCostCard(updatedBooking),
                const SizedBox(height: 16),
                _buildOtpCard(updatedBooking),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMechanicDetailsCard(Map<String, dynamic> booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
          ),
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
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    (booking['mechanicImage'] != null &&
                        booking['mechanicImage'].isNotEmpty)
                    ? NetworkImage(booking['mechanicImage'])
                    : null,
                child:
                    (booking['mechanicImage'] == null ||
                        booking['mechanicImage'].isEmpty)
                    ? Icon(Icons.person, color: Colors.grey[400])
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking['mechanicName'] ?? 'N/A',
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
                onPressed: () {
                  _makePhoneCall(booking['mechanicPhone'] as String?);
                },
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

  Widget _buildServiceDetailsCard(Map<String, dynamic> booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
          ),
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
            title: booking['service'] ?? 'N/A',
            subtitle: 'Service',
            trailing: '₹${booking['serviceCost'] ?? 0}',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            icon: Icons.directions_car,
            title:
                '${booking["vehicle"]?['make'] ?? ''} ${booking["vehicle"]?['model'] ?? ''}',
            subtitle: booking["vehicle"]?['type'] ?? '',
          ),
          const Divider(height: 24),
          _buildDetailRow(
            icon: Icons.location_on,
            title: booking['address'] ?? 'N/A',
            isLink: true,
            onLinkTap: () {
              final location = booking['location'] as Map<String, dynamic>?;
              _openMap(location?['lat'], location?['lng']);
            },
            linkText: 'View on Map',
          ),
        ],
      ),
    );
  }

  Widget _buildStatusAndCostCard(Map<String, dynamic> booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
          ),
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
          _getStatusRow(booking['status']),
          const Divider(height: 24),
          _buildDetailRow(
            icon: Icons.payments,
            title: '₹${booking['serviceCost'] ?? 0}',
            subtitle: 'Total Cost',
            iconColor: Colors.grey[600],
            iconBgColor: const Color(0xFFF5F5F5),
          ),
          const SizedBox(height: 16),
          if (booking['status'] == 'completed') _buildPaymentButton(booking),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(Map<String, dynamic> booking) {
    final isPaid = booking['paymentStatus'] == 'paid';

    if (isPaid) {
      return ElevatedButton.icon(
        onPressed: _downloadInvoice,
        icon: const Icon(Icons.download, size: 20),
        label: const Text('Download Invoice'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      );
    }

    return ElevatedButton.icon(
      onPressed: _isPaying ? null : () => _handlePayment(booking['bookingId']),
      icon: _isPaying
          ? const SizedBox.shrink()
          : const Icon(Icons.payment, size: 20),
      label: _isPaying
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text('Pay Now (₹${booking['serviceCost'] ?? 0})'),
      style: ElevatedButton.styleFrom(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
    );
  }

  Widget _buildOtpCard(Map<String, dynamic> booking) {
    final otp = booking['serviceStartOTP'] as String?;
    final status = (booking['status'] as String?)?.toLowerCase();

    if (otp == null || (status != 'accepted' && status != 'inprogress')) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((255 * 0.1).round()),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Service Start OTP',
            style: GoogleFonts.splineSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Share this OTP with your mechanic to start the service.',
            textAlign: TextAlign.center,
            style: GoogleFonts.splineSans(color: Colors.grey[600]),
          ),
          const SizedBox(height: 16),
          Text(
            otp,
            style: GoogleFonts.splineSans(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: _primaryColor,
              letterSpacing: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStatusRow(String? statusStr) {
    BookingStatus status;
    switch (statusStr?.toLowerCase()) {
      case 'pending':
        status = BookingStatus.pending;
        break;
      case 'accepted':
        status = BookingStatus.accepted;
        break;
      case 'inprogress': // Handles 'inProgress' and 'inprogress'
        status = BookingStatus.inProgress;
        break;
      case 'completed':
        status = BookingStatus.completed;
        break;
      default:
        status = BookingStatus.pending;
    }

    Color iconColor;
    Color bgColor;
    String title;
    IconData icon;

    switch (status) {
      case BookingStatus.accepted:
        icon = Icons.thumb_up;
        title = 'Accepted';
        iconColor = Colors.blue[800]!;
        bgColor = Colors.blue[100]!;
        break;
      case BookingStatus.inProgress:
        icon = Icons.construction;
        title = 'In-Progress';
        iconColor = Colors.indigo[800]!;
        bgColor = Colors.indigo[100]!;
        break;
      case BookingStatus.completed:
        icon = Icons.check_circle;
        title = 'Completed';
        iconColor = Colors.green[800]!;
        bgColor = Colors.green[100]!;
        break;

      default:
        icon = Icons.pending_actions;
        title = 'Pending';
        iconColor = Colors.orange[800]!;
        bgColor = Colors.orange[100]!;
        break;
    }

    return _buildDetailRow(
      icon: icon,
      title: title,
      subtitle: 'Status',
      iconColor: iconColor,
      iconBgColor: bgColor,
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
    VoidCallback? onLinkTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor:
              iconBgColor ?? _primaryColor.withAlpha((255 * 0.1).round()),
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
                  onPressed: onLinkTap,
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
