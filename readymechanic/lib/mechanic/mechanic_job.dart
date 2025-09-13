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

  final List<Map<String, dynamic>> _jobs = [
    {
      'name': 'Sophia Carter',
      'service': 'Oil Change',
      'location': '123 Maple St, Anytown, USA',
      'status': JobStatus.accepted,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDR2o_FLQ9OPwVoHI4ryDtAejW8k2q96qzEvY6l7jOkNSWlVjy9rqeUDBBCsWgOYDLdcDKMLx_LZVRZe2AcHVT55SNtCjtSfXDF_pMd1vK7ac_1_U75m6tQt6DPQwGLWR6NOnutAMMHExOjbiMLgvDGOonwQZCZ_3yaaDAyNDb1Z7W2ZB4Wsj24BtDoj29Th0-vWg53mQ88uEnZp7tJ5YL-NtlllY5thLIW4hiMpEJ9uL1eIT_HAlo5pDN05cJfNDUDUWEKOfk0-FE',
    },
    {
      'name': 'Jane Smith',
      'service': 'Tire Rotation',
      'location': '456 Oak Ave, Sometown, USA',
      'status': JobStatus.inProgress,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAQZyTUZj_5aHq5eM_D8Bhr0K_zifZdcgKcJWv4h0ZwhLACgKGRAxkfXcSY3xGBh41Yzz9vSW3Bh8UOAuP6GLiPPcGWurO44B4pLIjz4-VZkA6K-w0lbtrRz4pvXn6-2y3rv2CXD0tTvz02LpVmvQKTJ34xkWtB1sETd9w0ZL_KGcpe99WcMuxijat_6r-hbBwhnTyARuXMVvr3C2CXD0tTvz02LpVmvQKTJ34xkWtB1sETd9w0ZL_KGcpe99WcMuxijat_6r-hbBwhnTyARuXMVvr3C4xBEqmUmnRiitD7kofmD4SXN_h0KOJnPfUx2zoGugkbKQpTY4szauO8Q_gvCaM',
    },
    {
      'name': 'Mike Johnson',
      'service': 'Brake Repair',
      'location': '789 Pine Ln, Othertown, USA',
      'status': JobStatus.completed,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXHm9DDZHrl5jqSN9nPuLy3sqU48BjDHUKl8UQZ8WhBb3ULW7RnCukmlBZuxKM9htqa10-cDTJCOlAtVNs9p_RhnKw8mkdjfOUFhsINf-rQ3EbYOZ-cBOI3kCxByFkIrWRb2n-_V5U7IeTKEvb03mpaFZPqPwR5aQkOSRK6vZxqRarjFpEQFxXhaRQOTCF39yVgBuxPW8hf2hmIktKZ-VIsjBgW0ED8BDU_lPi3OXbPautlZ9M4-Qkhe2CwMdengFsJJoLN3378Go',
    },
  ];

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
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return _buildJobCard(job);
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
                backgroundImage: NetworkImage(job['image']),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['name'],
                      style: GoogleFonts.spaceGrotesk(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: _textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['service'],
                      style: GoogleFonts.spaceGrotesk(
                        color: _textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['location'],
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
                  _getStatusBadge(job['status']),
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

  Widget _getStatusBadge(JobStatus status) {
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
        color = Colors.amber[100]!;
        text = 'In-Progress';
        textColor = Colors.amber[800]!;
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
