import 'package:flutter/material.dart';
import 'package:client_management_app/models/project/project.dart';

class ProjectDetailsTab extends StatelessWidget {
  final Project project;

  const ProjectDetailsTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildDetailCard('Project Name', project.projectName, Icons.business),
          _buildDetailCard(
              'Description', project.description, Icons.description),
          _buildDetailCard(
              'Start Date', project.startDate.toString(), Icons.calendar_today),
          _buildDetailCard(
              'End Date', project.endDate.toString(), Icons.calendar_today),
          _buildClientsDetailCard(),
          _buildLawyersDetailCard(),
          _buildDetailCard(
              'Status ID', project.statusID.toString(), Icons.info),
        ],
      ),
    );
  }

  Widget _buildDetailCard(String label, String value, IconData icon) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClientsDetailCard() {
    return _buildDetailCard(
      'Clients',
      project.projectClients
          .map((pc) => '${pc.client.firstName} ${pc.client.lastName}')
          .join(', '),
      Icons.person,
    );
  }

  Widget _buildLawyersDetailCard() {
    return _buildDetailCard(
      'Lawyers',
      project.projectLawyers
          .map((pl) => '${pl.lawyer.firstName} ${pl.lawyer.lastName}')
          .join(', '),
      Icons.person_outline,
    );
  }
}
