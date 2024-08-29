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
