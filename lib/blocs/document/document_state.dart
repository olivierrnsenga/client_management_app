import 'package:equatable/equatable.dart';
import 'package:client_management_app/models/document/document.dart';

abstract class DocumentState extends Equatable {
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

  DocumentLoaded({
    required this.documents,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [documents, totalCount, currentPage, totalPages];
}

class DocumentAdded extends DocumentState {
  final Document document;

  DocumentAdded({required this.document});

  @override
  List<Object?> get props => [document];
}

class DocumentUpdated extends DocumentState {
  final Document document;

  DocumentUpdated({required this.document});

  @override
  List<Object?> get props => [document];
}

class DocumentDeleted extends DocumentState {
  final int documentID;

  DocumentDeleted({required this.documentID});

  @override
  List<Object?> get props => [documentID];
}

class DocumentError extends DocumentState {
  final String message;

  DocumentError({required this.message});

  @override
  List<Object?> get props => [message];
}
