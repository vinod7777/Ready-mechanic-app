import 'package:cloud_firestore/cloud_firestore.dart';
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
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    (mechanic['photoURL'] != null &&
                        mechanic['photoURL'].isNotEmpty)
                    ? NetworkImage(mechanic['photoURL'])
                    : null,
                child:
                    (mechanic['photoURL'] == null ||
                        mechanic['photoURL'].isEmpty)
                    ? Icon(Icons.person, color: Colors.grey[400])
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            mechanic['fullName'],
                            style: GoogleFonts.splineSans(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1a1a1a),
                            ),
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
                              mechanic['rating']?.toString() ?? 'N/A',
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  ? null // Button is disabled if no mechanic is selected
                  : () async {
                      // Get the full data of the selected mechanic
                      final mechanics = (snapshot.data?.docs ?? []).map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        data['id'] = doc.id;
                        return data;
                      }).toList();
                      final selectedMechanicData = mechanics.firstWhere(
                        (m) => m['id'] == _selectedMechanicId,
                      );

                      Navigator.push(
                        context, // The context is available here
                        MaterialPageRoute(
                          builder: (context) => CustomerConfirmationScreen(
                            vehicle: widget.vehicle,
                            serviceName: widget.serviceName,
                            servicePrice: widget.servicePrice,
                            address: widget.address,
                            city: widget.city,
                            issueDescription: widget.issueDescription,
                            mechanicId: _selectedMechanicId!,
                            mechanicName:
                                selectedMechanicData['fullName'] ?? 'N/A',
                            mechanicImage:
                                selectedMechanicData['photoURL'] ?? '',
                            mechanicRating:
                                selectedMechanicData['rating']?.toString() ??
                                'N/A',
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFf7f8fa),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          // This IconButton remains here
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
      backgroundColor: const Color(0xFFf7f8fa),
      body: StreamBuilder<QuerySnapshot>(
        stream: (() {
          if (widget.city.isEmpty) {
            return Stream<QuerySnapshot>.empty();
          }
          String capitalizedCity =
              widget.city[0].toUpperCase() +
              (widget.city.length > 1
                  ? widget.city.substring(1).toLowerCase()
                  : '');

          return FirebaseFirestore.instance
              .collection('mechanics')
              .where(
                'serviceArea',
                whereIn: [
                  widget.city,
                  widget.city.toLowerCase(),
                  capitalizedCity,
                ],
              )
              .where('isActive', isEqualTo: true)
              .snapshots();
        })(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: const Color(0xFFf7f8fa),
            body: Builder(
              builder: (context) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No mechanics found in ${widget.city}.',
                      style: GoogleFonts.splineSans(color: _textSecondary),
                    ),
                  );
                }

                final mechanics = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: mechanics.length, // This is correct
                  itemBuilder: (context, index) {
                    final mechanicDoc = mechanics[index];
                    final mechanicData =
                        mechanicDoc.data() as Map<String, dynamic>;
                    // Add the document ID to the map
                    mechanicData['id'] = mechanicDoc.id;
                    return _buildMechanicCard(mechanicData);
                  },
                );
              },
            ),
            bottomNavigationBar: _buildBottomNavigationBar(snapshot),
          );
        },
      ),
    );
  }
}
