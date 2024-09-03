import 'package:client_management_app/models/document/document.dart';
import 'package:equatable/equatable.dart';

abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

class DocumentInitial extends DocumentState {}

class DocumentLoading extends DocumentState {}

class DocumentLoaded extends DocumentState {
  final List<Document> documents;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  const DocumentLoaded({
    required this.documents,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [documents, totalCount, currentPage, totalPages];
}

class DocumentsAdded extends DocumentState {
  final List<Document> documents; // Handling multiple documents

  const DocumentsAdded({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class DocumentsUpdated extends DocumentState {
  final List<Document> documents; // Handling multiple documents

  const DocumentsUpdated({required this.documents});

  @override
  List<Object?> get props => [documents];
}

class DocumentDeleted extends DocumentState {
  final int documentID;

  const DocumentDeleted({required this.documentID});

  @override
  List<Object?> get props => [documentID];
}

class DocumentError extends DocumentState {
  final String message;

  const DocumentError({required this.message});

  @override
  List<Object?> get props => [message];
}
