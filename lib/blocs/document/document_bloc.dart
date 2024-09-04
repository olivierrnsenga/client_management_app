import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/repositories/document_repository.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository documentRepository;

  DocumentBloc({required this.documentRepository}) : super(DocumentInitial()) {
    on<FetchDocumentsByProjectId>(_onFetchDocumentsByProjectId);
    on<AddDocuments>(_onAddDocuments);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onFetchDocumentsByProjectId(
      FetchDocumentsByProjectId event, Emitter<DocumentState> emit) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.fetchDocumentsByProjectId(
          event.projectId, event.pageNumber, event.pageSize);
      emit(DocumentLoaded(
        documents: documents,
        totalCount: documents.length,
        currentPage: event.pageNumber,
        totalPages: (documents.length / event.pageSize).ceil(),
      ));
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onAddDocuments(
      AddDocuments event, Emitter<DocumentState> emit) async {
    emit(DocumentLoading());
    try {
      await documentRepository.addDocuments(event.documents);
      // Refetch documents after adding
      add(FetchDocumentsByProjectId(
        projectId: event.documents.first.projectID,
        pageNumber: 1,
        pageSize: 10,
      ));
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onDeleteDocument(
      DeleteDocument event, Emitter<DocumentState> emit) async {
    try {
      await documentRepository.deleteDocument(event.documentID);
      if (state is DocumentLoaded) {
        final updatedDocuments = (state as DocumentLoaded)
            .documents
            .where((doc) => doc.documentID != event.documentID)
            .toList();

        emit(DocumentLoaded(
          documents: updatedDocuments,
          totalCount: updatedDocuments.length,
          currentPage: (state as DocumentLoaded).currentPage,
          totalPages: (updatedDocuments.length / 10).ceil(),
        ));
      }
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }
}
