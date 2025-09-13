import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/customer/customer_confirmation.dart';

class CustomerChooseMechanicScreen extends StatefulWidget {
  final String vehicle;
  final String serviceName;
  final int servicePrice;
  final String address;
  final String city;
  final String issueDescription;

  const CustomerChooseMechanicScreen({
    super.key,
    required this.vehicle,
    required this.serviceName,
    required this.servicePrice,
    required this.address,
    required this.city,
    required this.issueDescription,
  });

  @override
  State<CustomerChooseMechanicScreen> createState() =>
      _CustomerChooseMechanicScreenState();
}

class _CustomerChooseMechanicScreenState
    extends State<CustomerChooseMechanicScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  final _textSecondary = const Color(
    0xFF6b7280,
  ); // Corresponds to text-gray-500

  String? _selectedMechanicId;

  final List<Map<String, dynamic>> _mechanics = [
    {
      'name': 'Ethan Carter',
      'experience': '10+ years of experience',
      'rating': '4.9',
      'specializations': 'Engine repair, brake service, electrical systems',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC-1C7d1XXJLAMHksF2blT4QUdw585HQDzxMO1iYX5SOi2H0ljU2e4xh3DtBvTwKZQtXXS7rjoD-UgTG1DhXKzuycpzWwK-Mfs0vbtvFUiH4g9_yBuFBFXFQIYF1vnJV6VFfFreqxYxOzPTc_izk9-RvrkQUUH3bb5qo-0C2iwXl-UiIyuw7bxy0XfHA3nYzIFT9wW1pTEt9LzyT65OFIO86ZaSoTUYcoERyQK3Sqz1V8_hHhfQ3qzajam9muuJwTAO68wtAnkWhkM',
      'id': 'mechanic_1',
    },
    {
      'name': 'Olivia Bennett',
      'experience': '5+ years of experience',
      'rating': '4.7',
      'specializations': 'Tire changes, oil changes, routine maintenance',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQZyTUZj_5aHq5eM_D8Bhr0K_zifZdcgKcJWv4h0ZwhLACgKGRAxkfXcSY3xGBh41Yzz9vSW3Bh8UOAuP6GLiPPcGWurO44B4pLIjz4-VZkA6K-w0lbtrRz4pvXn6-2y3rv2CXD0tTvz02LpVmvQKTJ34xkWtB1sETd9w0ZL_KGcpe99WcMuxijat_6r-hbBwhnTyARuXMVvr3C2CXD0tTvz02LpVmvQKTJ34xkWtB1sETd9w0ZL_KGcpe99WcMuxijat_6r-hbBwhnTyARuXMVvr3C4xBEqmUmnRiitD7kofmD4SXN_h0KOJnPfUx2zoGugkbKQpTY4szauO8Q_gvCaM',
      'id': 'mechanic_2',
    },
    {
      'name': 'Noah Thompson',
      'experience': '8+ years of experience',
      'rating': '4.8',
      'specializations': 'Transmission repair, diagnostics, suspension',
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXHm9DDZHrl5jqSN9nPuLy3sqU48BjDHUKl8UQZ8WhBb3ULW7RnCukmlBZuxKM9htqa10-cDTJCOlAtVNs9p_RhnKw8mkdjfOUFhsINf-rQ3EbYOZ-cBOI3kCxByFkIrWRb2n-_V5U7IeTKEvb03mpaFZPqPwR5aQkOSRK6vZxqRarjFpEQFxXhaRQOTCF39yVgBuxPW8hf2hmIktKZ-VIsjBgW0ED8BDU_lPi3OXbPautlZ9M4-Qkhe2CwMdengFsJJoLN3378Go',
      'id': 'mechanic_3',
    },
  ];

  Widget _buildMechanicCard(Map<String, dynamic> mechanic) {
    final isSelected = _selectedMechanicId == mechanic['id'];
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMechanicId = isSelected ? null : mechanic['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? _primaryColor.withAlpha((255 * 0.05).round())
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? _primaryColor : Colors.grey[200]!,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((255 * 0.05).round()),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(mechanic['image']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          mechanic['name'],
                          style: GoogleFonts.splineSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1a1a1a),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              mechanic['rating'],
                              style: GoogleFonts.splineSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1a1a1a),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      mechanic['experience'],
                      style: GoogleFonts.splineSans(
                        fontSize: 14,
                        color: _textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Specializations: ${mechanic['specializations']}',
                      style: GoogleFonts.splineSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
              onPressed: _selectedMechanicId == null
                  ? null
                  : () {
                      final selectedMechanicData = _mechanics.firstWhere(
                        (m) => m['id'] == _selectedMechanicId,
                      );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerConfirmationScreen(
                            vehicle: widget.vehicle,
                            serviceName: widget.serviceName,
                            servicePrice: widget.servicePrice,
                            address: widget.address,
                            city: widget.city,
                            issueDescription: widget.issueDescription,
                            mechanicId: selectedMechanicData['id'],
                            mechanicName: selectedMechanicData['name'],
                            mechanicImage: selectedMechanicData['image'],
                            mechanicRating: selectedMechanicData['rating'],
                          ),
                        ),
                      );
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
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: Text(
                'Continue',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf7f8fa),
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7f8fa),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Select a mechanic',
          style: GoogleFonts.splineSans(
            color: const Color(0xFF1a1a1a),
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
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mechanics.length,
              itemBuilder: (context, index) {
                final mechanic = _mechanics[index];
                return _buildMechanicCard(mechanic);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }
}
