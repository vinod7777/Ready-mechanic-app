import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomerVehiclesScreen extends StatefulWidget {
  const CustomerVehiclesScreen({super.key});

  @override
  State<CustomerVehiclesScreen> createState() => _CustomerVehiclesScreenState();
}

class _CustomerVehiclesScreenState extends State<CustomerVehiclesScreen> {
  final _primaryColor = const Color(0xFFea2a33);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Vehicles',
          style: GoogleFonts.splineSans(
            color: Colors.grey[900],
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: const [SizedBox(width: 48)], // To balance the leading icon
      ),
      body: user == null
          ? const Center(child: Text('Please log in to see your vehicles.'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('customers')
                  .doc(user.uid)
                  .collection('vehicles')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No vehicles added yet. Add one!'),
                  );
                }

                final vehicles = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: vehicles.length,
                  itemBuilder: (context, index) {
                    return _buildVehicleCard(vehicles[index]);
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/customer_add_vehicles');
        },
        backgroundColor: _primaryColor,
        child: const Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildVehicleCard(DocumentSnapshot vehicleDoc) {
    final vehicleData = vehicleDoc.data() as Map<String, dynamic>;
    final name = '${vehicleData['make'] ?? ''} ${vehicleData['model'] ?? ''}';
    final regNo = vehicleData['registrationNo'] ?? 'N/A';

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.splineSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.grey[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reg No: $regNo',
                  style: GoogleFonts.splineSans(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                vehicleDoc.reference.delete();
              },
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              splashRadius: 24,
            ),
          ],
        ),
      ),
    );
  }
}
