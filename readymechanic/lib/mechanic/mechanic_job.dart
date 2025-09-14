import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readymechanic/mechanic/mechanic_job_details.dart';

enum JobStatus { accepted, inProgress, completed }

class MechanicJobScreen extends StatefulWidget {
  const MechanicJobScreen({super.key});

  @override
  State<MechanicJobScreen> createState() => _MechanicJobScreenState();
}

class _MechanicJobScreenState extends State<MechanicJobScreen> {
  // Colors from mechanic_dashboard.dart
  final Color _backgroundColor = Colors.grey[50]!;
  final Color _textPrimary = Colors.grey[800]!;
  final Color _textSecondary = Colors.grey[600]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Jobs',
          style: GoogleFonts.spaceGrotesk(
            color: _textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black87),
            onPressed: () {
              // TODO: Handle add job
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where(
              'mechanicId',
              isEqualTo: FirebaseAuth.instance.currentUser?.uid,
            )
            .where('status', whereIn: ['accepted', 'inprogress', 'completed'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No jobs found.'));
          }
          final jobs = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: jobs.length,
            itemBuilder: (context, index) {
              final jobData = jobs[index].data() as Map<String, dynamic>;
              jobData['bookingId'] = jobs[index].id;
              return _buildJobCard(jobData);
            },
          );
        },
      ),
    );
  }

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shadowColor: Colors.black.withAlpha((255 * 0.1).round()),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MechanicJobDetailsScreen(job: job),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    (job['customerImage'] != null &&
                        job['customerImage'].isNotEmpty)
                    ? NetworkImage(job['customerImage'])
                    : null,
                child:
                    (job['customerImage'] == null ||
                        job['customerImage'].isEmpty)
                    ? Icon(Icons.person, color: Colors.grey[400])
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['customerName'] ?? 'N/A',
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['service'] ?? 'N/A',
                      style: GoogleFonts.spaceGrotesk(
                        color: _textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['address'] ?? 'N/A',
                      style: GoogleFonts.spaceGrotesk(
                        color: _textSecondary,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _getStatusBadgeFromString(job['status']),
                  const SizedBox(height: 16),
                  Icon(Icons.chevron_right, color: _textSecondary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getStatusBadgeFromString(String? statusStr) {
    JobStatus status;
    switch (statusStr?.toLowerCase()) {
      case 'accepted':
        status = JobStatus.accepted;
        break;
      case 'inprogress':
        status = JobStatus.inProgress;
        break;
      case 'completed':
        status = JobStatus.completed;
        break;
      default:
        status = JobStatus.accepted;
    }
    Color color;
    String text;
    Color textColor;

    switch (status) {
      case JobStatus.accepted:
        color = Colors.blue[100]!;
        text = 'Accepted';
        textColor = Colors.blue[800]!;
        break;
      case JobStatus.inProgress:
        color = Colors.indigo[100]!;
        text = 'In-Progress';
        textColor = Colors.indigo[800]!;
        break;
      case JobStatus.completed:
        color = Colors.green[100]!;
        text = 'Completed';
        textColor = Colors.green[800]!;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text(
        text,
        style: GoogleFonts.spaceGrotesk(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
