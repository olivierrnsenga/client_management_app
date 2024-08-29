import 'package:equatable/equatable.dart';

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
