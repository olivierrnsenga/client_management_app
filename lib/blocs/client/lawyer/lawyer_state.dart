import 'package:client_management_app/blocs/client/lawyer/lawyer.dart';
import 'package:equatable/equatable.dart';

abstract class LawyerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LawyerInitial extends LawyerState {}

class LawyerLoading extends LawyerState {}

class LawyerLoaded extends LawyerState {
  final List<Lawyer> lawyers;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  LawyerLoaded({
    required this.lawyers,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [lawyers, totalCount, currentPage, totalPages];
}

class LawyerAdded extends LawyerState {
  final Lawyer lawyer;

  LawyerAdded({required this.lawyer});

  @override
  List<Object?> get props => [lawyer];
}

class LawyerUpdated extends LawyerState {
  final Lawyer lawyer;

  LawyerUpdated({required this.lawyer});

  @override
  List<Object?> get props => [lawyer];
}

class LawyerDeleted extends LawyerState {
  final int lawyerID;

  LawyerDeleted({required this.lawyerID});

  @override
  List<Object?> get props => [lawyerID];
}

class LawyerError extends LawyerState {
  final String message;

  LawyerError({required this.message});

  @override
  List<Object?> get props => [message];
}
