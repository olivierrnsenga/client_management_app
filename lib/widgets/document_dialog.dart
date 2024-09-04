import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:client_management_app/models/document/document.dart';
import 'package:client_management_app/models/project/project.dart';

class DocumentDialog extends StatefulWidget {
  final Project project;
  final Function(List<Document>) onSave;

  const DocumentDialog({
    super.key,
    required this.project,
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
      title: const Text('Add Documents'),
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
                    leading: const Icon(Icons.insert_drive_file),
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
                  documentID: 0, // Default to 0 for new documents
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
}
