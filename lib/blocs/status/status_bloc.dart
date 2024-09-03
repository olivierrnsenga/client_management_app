import 'package:client_management_app/repositories/status_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:client_management_app/blocs/status/status_event.dart';
import 'package:client_management_app/blocs/status/status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  final StatusRepository statusRepository;

  StatusBloc({required this.statusRepository}) : super(StatusInitial()) {
    on<FetchStatuses>(_onFetchStatuses);
  }

  void _onFetchStatuses(FetchStatuses event, Emitter<StatusState> emit) async {
    emit(StatusLoading());
    try {
      final statuses = await statusRepository.fetchStatuses();
      emit(StatusLoaded(statuses: statuses));
    } catch (e) {
      emit(StatusError(message: e.toString()));
    }
  }
}
