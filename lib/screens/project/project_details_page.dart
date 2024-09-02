import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/repositories/document_repository.dart';
import 'package:client_management_app/models/document/document.dart';

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
            _buildDocumentsTab(context),
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
          _buildDetailCard('Project Name', project.projectName, Icons.business),
          _buildDetailCard(
              'Description', project.description, Icons.description),
          _buildDetailCard(
              'Start Date', project.startDate.toString(), Icons.calendar_today),
          _buildDetailCard(
              'End Date', project.endDate.toString(), Icons.calendar_today),
          _buildDetailCard(
              'Client ID', project.clientID.toString(), Icons.person),
          _buildDetailCard(
              'Lawyer ID', project.lawyerID.toString(), Icons.person_outline),
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

  Widget _buildDocumentsTab(BuildContext context) {
    return BlocProvider(
      create: (_) => DocumentBloc(
          documentRepository:
              DocumentRepository(baseUrl: 'https://localhost:7137/api'))
        ..add(FetchDocuments(
            projectId: project.projectID!, pageNumber: 1, pageSize: 10)),
      child: BlocBuilder<DocumentBloc, DocumentState>(
        builder: (context, state) {
          if (state is DocumentLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DocumentLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.documents.length,
                    itemBuilder: (context, index) {
                      final document = state.documents[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          leading: Icon(
                            _getDocumentIcon(document.documentType),
                            color: Colors.blueAccent,
                          ),
                          title: Text(
                            document.documentName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            document.documentType,
                            style: const TextStyle(color: Colors.black54),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _showDocumentEditDialog(context, document);
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  context.read<DocumentBloc>().add(
                                      DeleteDocument(
                                          documentID: document.documentID!));
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Open the document or show details if necessary
                          },
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    _showDocumentCreateDialog(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Document'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            );
          } else if (state is DocumentError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No documents found.'));
          }
        },
      ),
    );
  }

  IconData _getDocumentIcon(String documentType) {
    switch (documentType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'docx':
        return Icons.description;
      case 'xlsx':
        return Icons.grid_on;
      default:
        return Icons.insert_drive_file;
    }
  }

  void _showDocumentCreateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return _DocumentDialog(
          project: project,
          onSave: (document) {
            context.read<DocumentBloc>().add(AddDocument(document: document));
          },
        );
      },
    );
  }

  void _showDocumentEditDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return _DocumentDialog(
          project: project,
          document: document,
          onSave: (updatedDocument) {
            context
                .read<DocumentBloc>()
                .add(UpdateDocument(document: updatedDocument));
          },
        );
      },
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

class _DocumentDialog extends StatefulWidget {
  final Project project;
  final Document? document;
  final Function(Document) onSave;

  const _DocumentDialog(
      {required this.project, this.document, required this.onSave});

  @override
  State<_DocumentDialog> createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<_DocumentDialog> {
  late TextEditingController _documentNameController;
  late TextEditingController _documentTypeController;
  late TextEditingController _documentPathController;

  @override
  void initState() {
    super.initState();
    _documentNameController =
        TextEditingController(text: widget.document?.documentName ?? '');
    _documentTypeController =
        TextEditingController(text: widget.document?.documentType ?? '');
    _documentPathController =
        TextEditingController(text: widget.document?.documentPath ?? '');
  }

  @override
  void dispose() {
    _documentNameController.dispose();
    _documentTypeController.dispose();
    _documentPathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.document == null ? 'Add Document' : 'Edit Document'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextFormField(
              controller: _documentNameController,
              decoration: const InputDecoration(labelText: 'Document Name'),
            ),
            TextFormField(
              controller: _documentTypeController,
              decoration: const InputDecoration(labelText: 'Document Type'),
            ),
            TextFormField(
              controller: _documentPathController,
              decoration: const InputDecoration(labelText: 'Document Path'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Save'),
          onPressed: () {
            final newDocument = Document(
              projectID: widget.project.projectID!,
              documentName: _documentNameController.text,
              documentType: _documentTypeController.text,
              documentPath: _documentPathController.text,
              uploadDate: DateTime.now(),
              documentID: widget.document?.documentID,
            );
            widget.onSave(newDocument);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
