import 'package:client_management_app/blocs/user/user_event.dart';
import 'package:client_management_app/blocs/user/user_state.dart';
import 'package:client_management_app/repositories/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<SearchUsers>(_onSearchUsers);
    on<AddUser>(_onAddUser);
    on<UpdateUser>(_onUpdateUser);
    on<DeleteUser>(_onDeleteUser);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response =
          await userRepository.fetchUsers(event.pageNumber, event.pageSize);
      emit(UserLoaded(
        users: response.users,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onSearchUsers(
    SearchUsers event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      if (event.searchTerm.trim().length < 2) {
        emit(UserInitial());
        return;
      }
      final response = await userRepository.searchUsers(
        event.searchTerm,
        event.pageNumber,
        event.pageSize,
      );
      emit(UserLoaded(
        users: response.users,
        totalCount: response.totalCount,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onAddUser(AddUser event, Emitter<UserState> emit) async {
    try {
      final user = await userRepository.addUser(event.user);
      emit(UserAdded(user: user));
      add(const FetchUsers(
          pageNumber: 1, pageSize: 10)); // Refresh list after adding
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onUpdateUser(
    UpdateUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await userRepository.updateUser(event.user.userID, event.user);
      emit(UserUpdated(user: event.user));
      add(const FetchUsers(
          pageNumber: 1, pageSize: 10)); // Refresh list after updating
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }

  Future<void> _onDeleteUser(
    DeleteUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      await userRepository.deleteUser(event.userID);
      emit(UserDeleted(userID: event.userID));
      add(const FetchUsers(
          pageNumber: 1, pageSize: 10)); // Refresh list after deleting
    } catch (e) {
      emit(UserError(message: e.toString()));
    }
  }
}
