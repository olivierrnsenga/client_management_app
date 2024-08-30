import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/client_repository.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository clientRepository;

  ClientBloc({required this.clientRepository}) : super(ClientInitial()) {
    on<FetchClients>(_onFetchClients);
    on<SearchClients>(_onSearchClients);
    on<AddClient>(_onAddClient);
    on<UpdateClient>(_onUpdateClient);
    on<DeleteClient>(_onDeleteClient);
  }

  Future<void> _onFetchClients(
    FetchClients event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final response =
          await clientRepository.fetchClients(event.pageNumber, event.pageSize);
      emit(ClientLoaded(
        clients: response.clients,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }

  Future<void> _onSearchClients(
    SearchClients event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      if (event.searchTerm.trim().length < 2) {
        emit(ClientInitial());
        return;
      }
      final response = await clientRepository.searchClients(
        event.searchTerm,
        event.pageNumber,
        event.pageSize,
      );
      emit(ClientLoaded(
        clients: response.clients,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }

  Future<void> _onAddClient(
    AddClient event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      final client = await clientRepository.addClient(event.client);
      emit(ClientAdded(client: client));
      add(FetchClients(
          pageNumber: 1, pageSize: 10)); // Refresh list after adding
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }

  Future<void> _onUpdateClient(
    UpdateClient event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      await clientRepository.updateClient(event.client.clientID, event.client);
      emit(ClientUpdated(client: event.client));
      add(FetchClients(
          pageNumber: 1, pageSize: 10)); // Refresh list after updating
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }

  Future<void> _onDeleteClient(
    DeleteClient event,
    Emitter<ClientState> emit,
  ) async {
    emit(ClientLoading());
    try {
      await clientRepository.deleteClient(event.clientID);
      emit(ClientDeleted(clientID: event.clientID));
      add(FetchClients(
          pageNumber: 1, pageSize: 10)); // Refresh list after deleting
    } catch (e) {
      emit(ClientError(message: e.toString()));
    }
  }
}
