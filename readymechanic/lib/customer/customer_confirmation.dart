import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerConfirmationScreen extends StatefulWidget {
  const CustomerConfirmationScreen({super.key});

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
                          borderRadius: BorderRadius.circular(8),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuBVLhO1D92MKcoKpWcG6ODC_BUb74IsUsDR0CEvWtOV2Ep8tcfvwHAfY1OWfaQ68Vct4BbOhf7zOec1zeU50PTVLp3jTfEANv94FA2Zyexz5Si9m-jXRilXYvk6McZl6mh85SdCA94U2Lc3oTAZzT2ituURc-eeEKIcP9Hmj0ycyz5nSO25_TW5Efe5xbeZ0UtJmGdUry93Ticj-snQ0YR0IcTKGdAPHAQ1OFnH87HVE6lR4uhny6_w-3KJ-P5ZS35hTJUPV3PW7J0',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Honda Civic',
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '2018',
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
                            'Oil Change',
                            style: GoogleFonts.splineSans(
                              color: _textPrimary,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            '\$50.00',
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
                            '\$5.00',
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
                            '\$55.00',
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
                          '123 Main St, Anytown, USA',
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
                        backgroundImage: NetworkImage(
                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBjZ4W_ShhWJG7gN3YhHcbLlwnb8X-Fn3DWD15M5Kev5TrbyHZG73odnhhzqyPTYdRLOHicgxO7FByvlzcjHpKnpUdVg43C1hYWS0Jme7jmitcuMwfgsWq78RWQSfbq70E-D070KhE_KWkCt4X6HpVBukyCwazc-SMB0TMa1f1dnjycE-7IoyHlMfYwtfnNkWnUuf6ERz6KjxCUig7-mFE1BOiskskM-vljK5CmO-Bu5UVJKJeIpEAVOMwThMlJC9gao7kN_BF9fow',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ethan Carter',
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
                                '4.8 (120 reviews)',
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
              onPressed: () {
                // TODO: Handle Confirm & Book
              },
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
              child: Text(
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
}
