import 'package:client_management_app/blocs/client/lawyer/lawyer.dart';
import 'package:equatable/equatable.dart';

abstract class LawyerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchLawyers extends LawyerEvent {
  final int pageNumber;
  final int pageSize;

  FetchLawyers({required this.pageNumber, required this.pageSize});

  @override
  List<Object> get props => [pageNumber, pageSize];
}

class SearchLawyers extends LawyerEvent {
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  SearchLawyers(
      {required this.searchTerm,
      required this.pageNumber,
      required this.pageSize});

  @override
  List<Object> get props => [searchTerm, pageNumber, pageSize];
}

class AddLawyer extends LawyerEvent {
  final Lawyer lawyer;

  AddLawyer({required this.lawyer});

  @override
  List<Object> get props => [lawyer];
}

class UpdateLawyer extends LawyerEvent {
  final Lawyer lawyer;

  UpdateLawyer({required this.lawyer});

  @override
  List<Object> get props => [lawyer];
}

class DeleteLawyer extends LawyerEvent {
  final int lawyerID;

  DeleteLawyer({required this.lawyerID});

  @override
  List<Object> get props => [lawyerID];
}
