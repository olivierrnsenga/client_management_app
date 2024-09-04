import 'package:client_management_app/models/document/document.dart';
import 'package:equatable/equatable.dart';

abstract class DocumentEvent extends Equatable {
  const DocumentEvent();

  @override
  List<Object?> get props => [];
}

class FetchDocumentsByProjectId extends DocumentEvent {
  final int projectId;
  final int pageNumber;
  final int pageSize;

  const FetchDocumentsByProjectId({
    required this.projectId,
    required this.pageNumber,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [projectId, pageNumber, pageSize];
}

class AddDocuments extends DocumentEvent {
  final List<Document> documents; // Handle multiple documents

  const AddDocuments({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class UpdateDocuments extends DocumentEvent {
  final List<Document> documents; // Handle multiple documents

  const UpdateDocuments({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class DeleteDocument extends DocumentEvent {
  final int documentID;
  final int projectId;

  const DeleteDocument({
    required this.documentID,
    required this.projectId,
  });

  @override
  List<Object?> get props => [documentID, projectId];
}

class FetchAllDocuments extends DocumentEvent {
  final int pageNumber;
  final int pageSize;

  const FetchAllDocuments({
    required this.pageNumber,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [pageNumber, pageSize];
}

class SearchDocuments extends DocumentEvent {
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  const SearchDocuments({
    required this.searchTerm,
    required this.pageNumber,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [searchTerm, pageNumber, pageSize];
}
