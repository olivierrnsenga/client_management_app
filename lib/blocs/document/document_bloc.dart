import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/repositories/document_repository.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository documentRepository;

  DocumentBloc({required this.documentRepository}) : super(DocumentInitial()) {
    on<FetchDocumentsByProjectId>(_onFetchDocumentsByProjectId);
    on<AddDocuments>(_onAddDocuments); // Updated to handle multiple documents
    on<UpdateDocuments>(
        _onUpdateDocuments); // Updated to handle multiple documents
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onFetchDocumentsByProjectId(
    FetchDocumentsByProjectId event,
    Emitter<DocumentState> emit,
  ) async {
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
    AddDocuments event, // Accepting multiple documents
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository
          .addDocuments(event.documents); // Handle multiple documents
      emit(DocumentsAdded(
          documents: documents)); // Emitting a state with the added documents
      add(FetchDocumentsByProjectId(
          projectId: documents.first.projectID,
          pageNumber: 1,
          pageSize: 10)); // Fetch documents after adding
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDocuments(
    UpdateDocuments event, // Accepting multiple documents
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      await documentRepository
          .updateDocuments(event.documents); // Handle multiple documents
      emit(DocumentsUpdated(
          documents:
              event.documents)); // Emitting a state with the updated documents
      add(FetchDocumentsByProjectId(
          projectId: event.documents.first.projectID,
          pageNumber: 1,
          pageSize: 10)); // Fetch documents after updating
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onDeleteDocument(
    DeleteDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      await documentRepository.deleteDocument(event.documentID);
      emit(DocumentDeleted(documentID: event.documentID));
      add(FetchDocumentsByProjectId(
          projectId: event.projectId,
          pageNumber: 1,
          pageSize: 10)); // Fetch documents after deleting
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }
}
