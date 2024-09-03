import 'package:client_management_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/repositories/document_repository.dart';
import 'package:client_management_app/widgets/documents_tab.dart';

class ProjectDetailsPage extends StatelessWidget {
  final Project project;

  const ProjectDetailsPage({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) {
        final config = RepositoryProvider.of<AppConfig>(context);
        return DocumentRepository(baseUrl: config.baseUrl);
      },
      child: BlocProvider(
        create: (context) {
          final documentRepository =
              RepositoryProvider.of<DocumentRepository>(context);
          return DocumentBloc(documentRepository: documentRepository)
            ..add(FetchDocumentsByProjectId(
                projectId: project.projectID!, pageNumber: 1, pageSize: 10));
        },
        child: DefaultTabController(
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
                DocumentsTab(project: project),
                _buildCorrespondenceTab(),
                _buildStakeholdersTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectDetailsTab() {
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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person, color: Colors.blueAccent),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Clients',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: project.projectClients
                    .map((projectClient) => Text(
                          '${projectClient.client.firstName} ${projectClient.client.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLawyersDetailCard() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person_outline, color: Colors.blueAccent),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Lawyers',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: project.projectLawyers
                    .map((projectLawyer) => Text(
                          '${projectLawyer.lawyer.firstName} ${projectLawyer.lawyer.lastName}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
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
