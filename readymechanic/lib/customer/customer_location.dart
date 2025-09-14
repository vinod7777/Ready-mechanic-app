import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/customer/customer_choose_mechanic.dart';

class CustomerLocationScreen extends StatefulWidget {
  final String vehicle;
  final String serviceName;
  final int servicePrice;

  const CustomerLocationScreen({
    super.key,
    required this.vehicle,
    required this.serviceName,
    required this.servicePrice,
  });
  @override
  State<CustomerLocationScreen> createState() => _CustomerLocationScreenState();
}

class _CustomerLocationScreenState extends State<CustomerLocationScreen> {
  final _primaryColor = const Color(0xFFea2a33);
  final _backgroundColor = const Color(0xFFf7f8fa);
  final _textPrimary = const Color(0xFF1a1a1a);
  final _textSecondary = const Color(0xFF6b7280);

  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _issueController = TextEditingController();
  bool _isLoadingAddress = true;
  bool _isGettingLocation = false;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    _fetchUserAddress();
  }

  Future<void> _fetchUserAddress() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() => _isLoadingAddress = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('customers')
          .doc(user.uid)
          .get();
      if (doc.exists && mounted) {
        setState(() {
          _addressController.text = doc.data()?['address'] ?? '';
          _cityController.text = doc.data()?['city'] ?? '';
        });
      }
    } catch (e) {
      // Handle error if needed
    } finally {
      if (mounted) {
        setState(() => _isLoadingAddress = false);
      }
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isGettingLocation = true);
    try {
      bool serviceEnabled =
          await geolocator.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw ('Location services are disabled.');

      geolocator.LocationPermission permission =
          await geolocator.Geolocator.checkPermission();
      if (permission == geolocator.LocationPermission.denied) {
        permission = await geolocator.Geolocator.requestPermission();
        if (permission == geolocator.LocationPermission.denied) {
          throw ('Location permissions are denied');
        }
      }
      if (permission == geolocator.LocationPermission.deniedForever) {
        throw ('Location permissions are permanently denied.');
      }

      geolocator.Position position =
          await geolocator.Geolocator.getCurrentPosition();
      List<geocoding.Placemark> placemarks = await geocoding
          .placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty && mounted) {
        final place = placemarks.first;
        _addressController.text = '${place.street}, ${place.subLocality}'
            .replaceAll(', ,', ',');
        _cityController.text = place.locality ?? '';
        _latitude = position.latitude;
        _longitude = position.longitude;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _geocodeAddressAndContinue() async {
    if (_addressController.text.isEmpty || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a valid address and city.'),
        ),
      );
      return;
    }

    try {
      List<geocoding.Location> locations = await geocoding.locationFromAddress(
        '${_addressController.text}, ${_cityController.text}',
      );
      if (locations.isNotEmpty) {
        _navigateToChooseMechanic(
          locations.first.latitude,
          locations.first.longitude,
        );
      }
    } catch (e) {
      _navigateToChooseMechanic(null, null);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _issueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: Colors.white.withAlpha((255 * 0.8).round()),
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Book a Service',
            style: GoogleFonts.splineSans(
              color: _textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProgressIndicator(isActive: false),
                  const SizedBox(width: 10),
                  _buildProgressIndicator(isActive: true),
                  const SizedBox(width: 10),
                  _buildProgressIndicator(isActive: false),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Where should we come?',
              style: GoogleFonts.splineSans(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Let us know the location for your service.',
              style: GoogleFonts.splineSans(
                fontSize: 16,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 32),
            _buildCurrentLocationButton(),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'OR',
                    style: GoogleFonts.splineSans(color: _textSecondary),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 16),
            if (_isLoadingAddress)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 8),
                      Text('Loading saved address...'),
                    ],
                  ),
                ),
              )
            else
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
              ),
            const SizedBox(height: 24),
            _buildTextField(
              controller: _cityController,
              label: 'City',
              icon: Icons.location_city,
            ),
            const SizedBox(height: 24),
            _buildTextArea(
              controller: _issueController,
              label: 'Describe the Issue (optional)',
              placeholder: 'e.g., Engine is making a strange noise.',
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCurrentLocationButton() {
    return OutlinedButton.icon(
      onPressed: _isGettingLocation ? null : _getCurrentLocation,
      icon: _isGettingLocation
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(Icons.my_location, color: _primaryColor),
      label: Text(
        _isGettingLocation ? 'Getting Location...' : 'Use Current Location',
        style: GoogleFonts.splineSans(
          fontWeight: FontWeight.bold,
          color: _primaryColor,
        ),
      ),
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(double.infinity, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: _primaryColor),
      ),
    );
  }

  Widget _buildProgressIndicator({required bool isActive}) {
    return Container(
      height: 6,
      width: 32,
      decoration: BoxDecoration(
        color: isActive ? _primaryColor : Colors.grey[200],
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.splineSans(color: _textPrimary, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.splineSans(color: _textSecondary),
        prefixIcon: Icon(icon, color: _textSecondary),
        filled: true,
        fillColor: _backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
        ),
      ),
    );
  }

  Widget _buildTextArea({
    required String label,
    required String placeholder,
    required TextEditingController controller,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      style: GoogleFonts.splineSans(color: _textPrimary, fontSize: 16),
      decoration: InputDecoration(
        alignLabelWithHint: true,
        labelText: label,
        hintText: placeholder,
        labelStyle: GoogleFonts.splineSans(color: _textSecondary),
        hintStyle: GoogleFonts.splineSans(color: Colors.grey[400]),
        filled: true,
        fillColor: _backgroundColor,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryColor, width: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ElevatedButton(
              onPressed: (_latitude != null && _longitude != null)
                  ? () => _navigateToChooseMechanic(_latitude, _longitude)
                  : _geocodeAddressAndContinue,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
                elevation: 4,
                shadowColor: _primaryColor.withAlpha((255 * 0.3).round()),
              ),
              child: Text(
                'Continue',
                style: GoogleFonts.splineSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToChooseMechanic(double? lat, double? lng) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerChooseMechanicScreen(
          vehicle: widget.vehicle,
          serviceName: widget.serviceName,
          servicePrice: widget.servicePrice,
          address: _addressController.text,
          city: _cityController.text,
          issueDescription: _issueController.text,
          latitude: lat,
          longitude: lng,
        ),
      ),
    );
  }
}
