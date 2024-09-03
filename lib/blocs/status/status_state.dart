import 'package:equatable/equatable.dart';
import 'package:client_management_app/models/status/status.dart';

abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object> get props => [];
}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}

class StatusLoaded extends StatusState {
  final List<Status> statuses;

  const StatusLoaded({required this.statuses});

  @override
  List<Object> get props => [statuses];
}

class StatusError extends StatusState {
  final String message;

  const StatusError({required this.message});

  @override
  List<Object> get props => [message];
}
