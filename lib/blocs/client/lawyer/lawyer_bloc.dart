import 'package:client_management_app/repositories/lawyer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'lawyer_event.dart';
import 'lawyer_state.dart';

class LawyerBloc extends Bloc<LawyerEvent, LawyerState> {
  final LawyerRepository lawyerRepository;

  LawyerBloc({required this.lawyerRepository}) : super(LawyerInitial()) {
    on<FetchLawyers>(_onFetchLawyers);
    on<SearchLawyers>(_onSearchLawyers);
    on<AddLawyer>(_onAddLawyer);
    on<UpdateLawyer>(_onUpdateLawyer);
    on<DeleteLawyer>(_onDeleteLawyer);
  }

  Future<void> _onFetchLawyers(
    FetchLawyers event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final response =
          await lawyerRepository.fetchLawyers(event.pageNumber, event.pageSize);
      emit(LawyerLoaded(
        lawyers: response.lawyers,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(LawyerError(message: e.toString()));
    }
  }

  Future<void> _onSearchLawyers(
    SearchLawyers event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      if (event.searchTerm.trim().length < 2) {
        emit(LawyerInitial());
        return;
      }
      final response = await lawyerRepository.searchLawyers(
        event.searchTerm,
        event.pageNumber,
        event.pageSize,
      );
      emit(LawyerLoaded(
        lawyers: response.lawyers,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(LawyerError(message: e.toString()));
    }
  }

  Future<void> _onAddLawyer(
    AddLawyer event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      final lawyer = await lawyerRepository.addLawyer(event.lawyer);
      emit(LawyerAdded(lawyer: lawyer));
      add(FetchLawyers(
          pageNumber: 1, pageSize: 10)); // Refresh list after adding
    } catch (e) {
      emit(LawyerError(message: e.toString()));
    }
  }

  Future<void> _onUpdateLawyer(
    UpdateLawyer event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      await lawyerRepository.updateLawyer(event.lawyer.lawyerID, event.lawyer);
      emit(LawyerUpdated(lawyer: event.lawyer));
      add(FetchLawyers(
          pageNumber: 1, pageSize: 10)); // Refresh list after updating
    } catch (e) {
      emit(LawyerError(message: e.toString()));
    }
  }

  Future<void> _onDeleteLawyer(
    DeleteLawyer event,
    Emitter<LawyerState> emit,
  ) async {
    emit(LawyerLoading());
    try {
      await lawyerRepository.deleteLawyer(event.lawyerID);
      emit(LawyerDeleted(lawyerID: event.lawyerID));
      add(FetchLawyers(
          pageNumber: 1, pageSize: 10)); // Refresh list after deleting
    } catch (e) {
      emit(LawyerError(message: e.toString()));
    }
  }
}
