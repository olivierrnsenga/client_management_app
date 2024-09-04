import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/models/document/document.dart';
import 'package:client_management_app/widgets/pagination_controls.dart';
import 'package:client_management_app/widgets/document_preview_dialog.dart';

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
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, document);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _showDocumentPreviewDialog(context, document);
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

  void _showDocumentPreviewDialog(BuildContext context, Document document) {
    showDialog(
      context: context,
      builder: (context) {
        return DocumentPreviewDialog(document: document);
      },
    );
  }

  void _showDocumentCreateDialog(BuildContext context) {
    // Your existing implementation for adding documents
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
