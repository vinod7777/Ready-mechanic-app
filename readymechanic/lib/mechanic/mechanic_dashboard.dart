import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MechanicDashboardScreen extends StatefulWidget {
  const MechanicDashboardScreen({super.key});

  @override
  State<MechanicDashboardScreen> createState() =>
      _MechanicDashboardScreenState();
}

class _MechanicDashboardScreenState extends State<MechanicDashboardScreen> {
  // Custom colors based on Tailwind CSS in HTML
  final Color _primaryColor = const Color(0xFFea2a33);
  final Color _backgroundColor = Colors.grey[50]!;
  final Color _textPrimary = Colors.grey[800]!;
  final Color _textSecondary = Colors.grey[600]!;
  final Color _amber400 = const Color(0xFFfbbf24);
  final Color _emerald400 = const Color(0xFF34d399);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {
            // TODO: Handle menu button
          },
        ),
        title: Text(
          'Dashboard',
          style: GoogleFonts.spaceGrotesk(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black87),
            onPressed: () {
              // TODO: Handle notifications button
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, Alex!',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Here\'s what\'s happening today.',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                color: _textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                _buildStatCard(
                  icon: Icons.pending,
                  iconColor: _primaryColor,
                  title: 'Pending Requests',
                  value: '3',
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  icon: Icons.construction,
                  iconColor: _amber400,
                  title: 'Active Jobs',
                  value: '2',
                ),
                const SizedBox(height: 16),
                _buildStatCard(
                  icon: Icons.task_alt,
                  iconColor: _emerald400,
                  title: 'Completed Jobs Today',
                  value: '5',
                  isLarge: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    bool isLarge = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  color: _textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              color: _textPrimary,
              fontSize: isLarge ? 36 : 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
