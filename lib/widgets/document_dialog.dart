import 'package:flutter/material.dart';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/models/document/document.dart';
import 'package:file_picker/file_picker.dart';

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
                  documentID: 0,
                  projectID: widget.project.projectID!,
                  documentName: file.name,
                  documentType: file.extension ?? '',
                  documentPath: file.path ?? '',
                  uploadDate: DateTime.now(),
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
