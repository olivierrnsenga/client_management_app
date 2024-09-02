import 'package:equatable/equatable.dart';
import 'package:client_management_app/models/document/document.dart';

abstract class DocumentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDocumentsByProjectId extends DocumentEvent {
  final int projectId;
  final int pageNumber;
  final int pageSize;

  FetchDocumentsByProjectId({
    required this.projectId,
    required this.pageNumber,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [projectId, pageNumber, pageSize];
}

class AddDocument extends DocumentEvent {
  final Document document;

  AddDocument({required this.document});

  @override
  List<Object?> get props => [document];
}

class UpdateDocument extends DocumentEvent {
  final Document document;

  UpdateDocument({required this.document});

  @override
  List<Object?> get props => [document];
}

class DeleteDocument extends DocumentEvent {
  final int documentID;
  final int projectId;

  DeleteDocument({required this.documentID, required this.projectId});

  @override
  List<Object?> get props => [documentID, projectId];
}
