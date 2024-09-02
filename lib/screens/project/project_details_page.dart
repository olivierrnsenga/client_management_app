import 'package:client_management_app/models/project/project.dart';
import 'package:flutter/material.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Project Details: ${project.projectName}'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Documents'),
              Tab(text: 'Correspondence'),
              Tab(text: 'Stakeholders'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProjectDetailsTab(),
            _buildDocumentsTab(),
            _buildCorrespondenceTab(),
            _buildStakeholdersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsTab() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildDetailItem(
            label: 'Project Name',
            value: project.projectName,
            icon: Icons.work_outline,
          ),
          _buildDetailItem(
            label: 'Description',
            value: project.description,
            icon: Icons.description_outlined,
          ),
          _buildDetailItem(
            label: 'Start Date',
            value: project.startDate.toString(),
            icon: Icons.calendar_today_outlined,
          ),
          _buildDetailItem(
            label: 'End Date',
            value: project.endDate.toString(),
            icon: Icons.calendar_today_outlined,
          ),
          _buildDetailItem(
            label: 'Client ID',
            value: project.clientID.toString(),
            icon: Icons.person_outline,
          ),
          _buildDetailItem(
            label: 'Lawyer ID',
            value: project.lawyerID.toString(),
            icon: Icons.person_outline,
          ),
          _buildDetailItem(
            label: 'Status ID',
            value: project.statusID.toString(),
            icon: Icons.info_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
      {required String label, required String value, required IconData icon}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    return Center(
      child: Text('Documents for project ${project.projectName}'),
    );
  }

  Widget _buildCorrespondenceTab() {
    return Center(
      child: Text('Correspondence related to project ${project.projectName}'),
    );
  }

  Widget _buildStakeholdersTab() {
    return Center(
      child: Text('Stakeholders involved in project ${project.projectName}'),
    );
  }
}
