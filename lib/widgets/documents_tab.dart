import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/models/document/document.dart';
import 'package:client_management_app/widgets/pagination_controls.dart';
import 'package:file_picker/file_picker.dart';

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
              PaginationControls(
                currentPage: state.currentPage,
                totalPages: state.totalPages,
                totalCount: state.totalCount,
                onPageChanged: (pageNumber) {
                  context.read<DocumentBloc>().add(FetchDocumentsByProjectId(
                      projectId: project.projectID!,
                      pageNumber: pageNumber,
                      pageSize: 10));
                },
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
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.movie;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack;
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
          onSave: (documents) {
            for (var document in documents) {
              context.read<DocumentBloc>().add(AddDocument(document: document));
            }
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
          onSave: (updatedDocuments) {
            for (var document in updatedDocuments) {
              context
                  .read<DocumentBloc>()
                  .add(UpdateDocument(document: document));
            }
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
  final Function(List<Document>) onSave;

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
  final List<PlatformFile> _selectedFiles = [];

  Future<void> _pickFiles() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      setState(() {
        _selectedFiles.addAll(result.files);
      });
    }
  }

  void _removeFile(int index) {
    setState(() {
      _selectedFiles.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.document == null ? 'Add Documents' : 'Edit Documents'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickFiles,
              icon: const Icon(Icons.attach_file),
              label: const Text('Select Documents'),
            ),
            const SizedBox(height: 16.0),
            if (_selectedFiles.isNotEmpty)
              Column(
                children: _selectedFiles.asMap().entries.map((entry) {
                  int index = entry.key;
                  PlatformFile file = entry.value;

                  return ListTile(
                    leading: Icon(_getDocumentIcon(file.extension ?? '')),
                    title: Text(file.name),
                    subtitle: Text(file.extension ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeFile(index),
                    ),
                  );
                }).toList(),
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
            if (_selectedFiles.isNotEmpty) {
              List<Document> documents = _selectedFiles.map((file) {
                return Document(
                  projectID: widget.project.projectID!,
                  documentName: file.name,
                  documentType: file.extension ?? '',
                  documentPath: file.path ?? '',
                  uploadDate: DateTime.now(),
                  documentID: widget.document?.documentID,
                );
              }).toList();

              widget.onSave(documents);
              Navigator.of(context).pop();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select at least one document.')),
              );
            }
          },
        ),
      ],
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
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.movie;
      case 'mp3':
      case 'wav':
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }
}
