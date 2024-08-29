import 'package:equatable/equatable.dart';
import '../../models/client.dart';

abstract class ClientState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ClientInitial extends ClientState {}

class ClientLoading extends ClientState {}

class ClientLoaded extends ClientState {
  final List<Client> clients;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  ClientLoaded({
    required this.clients,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [clients, totalCount, currentPage, totalPages];
}

class ClientAdded extends ClientState {
  final Client client;

  ClientAdded({required this.client});

  @override
  List<Object?> get props => [client];
}

class ClientUpdated extends ClientState {
  final Client client;

  ClientUpdated({required this.client});

  @override
  List<Object?> get props => [client];
}

class ClientDeleted extends ClientState {
  final int clientID;

  ClientDeleted({required this.clientID});

  @override
  List<Object?> get props => [clientID];
}

class ClientError extends ClientState {
  final String message;

  ClientError({required this.message});

  @override
  List<Object?> get props => [message];
}
