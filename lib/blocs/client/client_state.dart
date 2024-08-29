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

class ClientError extends ClientState {
  final String message;

  ClientError({required this.message});

  @override
  List<Object?> get props => [message];
}
