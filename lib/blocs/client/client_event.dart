import 'package:equatable/equatable.dart';
import '../../models/client.dart';

abstract class ClientEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchClients extends ClientEvent {
  final int pageNumber;
  final int pageSize;

  FetchClients({required this.pageNumber, required this.pageSize});

  @override
  List<Object> get props => [pageNumber, pageSize];
}

class SearchClients extends ClientEvent {
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  SearchClients(
      {required this.searchTerm,
      required this.pageNumber,
      required this.pageSize});

  @override
  List<Object> get props => [searchTerm, pageNumber, pageSize];
}

class AddClient extends ClientEvent {
  final Client client;

  AddClient({required this.client});

  @override
  List<Object> get props => [client];
}

class UpdateClient extends ClientEvent {
  final Client client;

  UpdateClient({required this.client});

  @override
  List<Object> get props => [client];
}

class DeleteClient extends ClientEvent {
  final int clientID;

  DeleteClient({required this.clientID});

  @override
  List<Object> get props => [clientID];
}
