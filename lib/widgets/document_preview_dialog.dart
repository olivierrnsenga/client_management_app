import 'package:flutter/material.dart';
import 'package:client_management_app/models/document/document.dart';

class DocumentPreviewDialog extends StatelessWidget {
  final Document document;

  const DocumentPreviewDialog({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Preview ${document.documentName}'),
      content: _getPreviewContent(document),
      actions: [
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _getPreviewContent(Document document) {
    if (_isImage(document.documentType)) {
      return Image.network(
        document
            .documentPath, // assuming the documentPath is a URL or local path
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Text('Failed to load image');
        },
      );
    } else if (_isPDF(document.documentType)) {
      return const Text('Preview not available for PDFs');
    } else if (_isVideo(document.documentType)) {
      return const Text('Preview not available for videos');
    } else {
      return const Text('Preview not available for this file type');
    }
  }

  bool _isImage(String documentType) {
    return ['jpg', 'jpeg', 'png', 'gif'].contains(documentType.toLowerCase());
  }

  bool _isPDF(String documentType) {
    return documentType.toLowerCase() == 'pdf';
  }

  bool _isVideo(String documentType) {
    return ['mp4', 'avi', 'mov'].contains(documentType.toLowerCase());
  }
}
