import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/client_repository.dart';
import 'client_event.dart';
import 'client_state.dart';

class ClientBloc extends Bloc<ClientEvent, ClientState> {
  final ClientRepository clientRepository;

  ClientBloc({required this.clientRepository}) : super(ClientInitial()) {
    on<FetchClients>(_onFetchClients);
    on<SearchClients>(_onSearchClients); // Added event handler for search
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
}
