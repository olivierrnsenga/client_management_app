import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/document/document_event.dart';
import 'package:client_management_app/blocs/document/document_state.dart';
import 'package:client_management_app/repositories/document_repository.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  final DocumentRepository documentRepository;

  DocumentBloc({required this.documentRepository}) : super(DocumentInitial()) {
    on<FetchDocuments>(_onFetchDocuments);
    on<AddDocument>(_onAddDocument);
    on<UpdateDocument>(_onUpdateDocument);
    on<DeleteDocument>(_onDeleteDocument);
  }

  Future<void> _onFetchDocuments(
    FetchDocuments event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final documents = await documentRepository.fetchDocuments(
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

  Future<void> _onAddDocument(
    AddDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      final document = await documentRepository.addDocument(event.document);
      emit(DocumentAdded(document: document));
      add(FetchDocuments(
          projectId: document.projectID, pageNumber: 1, pageSize: 10));
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateDocument(
    UpdateDocument event,
    Emitter<DocumentState> emit,
  ) async {
    emit(DocumentLoading());
    try {
      await documentRepository.updateDocument(
          event.document.documentID!, event.document);
      emit(DocumentUpdated(document: event.document));
      add(FetchDocuments(
          projectId: event.document.projectID, pageNumber: 1, pageSize: 10));
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
      add(FetchDocuments(
          projectId: event.documentID, pageNumber: 1, pageSize: 10));
    } catch (e) {
      emit(DocumentError(message: e.toString()));
    }
  }
}
