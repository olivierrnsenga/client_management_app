import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/models/document/document.dart';

class DocumentsTab extends StatelessWidget {
  final Project project;

  const DocumentsTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentBloc, DocumentState>(
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
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showDocumentEditDialog(context, document);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, document);
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
        return DocumentDialog(
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
        return DocumentDialog(
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

  void _showDeleteConfirmationDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text(
              'Are you sure you want to delete the document "${document.documentName}"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                context.read<DocumentBloc>().add(DeleteDocument(
                    documentID: document.documentID!,
                    projectId: document.projectID));
              },
            ),
          ],
        );
      },
    );
  }
}

class DocumentDialog extends StatefulWidget {
  final Project project;
  final Document? document;
  final Function(Document) onSave;

  const DocumentDialog({
    super.key,
    required this.project,
    this.document,
    required this.onSave,
  });

  @override
  // ignore: library_private_types_in_public_api
  _DocumentDialogState createState() => _DocumentDialogState();
}

class _DocumentDialogState extends State<DocumentDialog> {
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
