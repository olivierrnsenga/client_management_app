import 'package:client_management_app/models/user/user.dart';
import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final List<User> users;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  UserLoaded({
    required this.users,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [users, totalCount, currentPage, totalPages];
}

class UserAdded extends UserState {
  final User user;

  UserAdded({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserUpdated extends UserState {
  final User user;

  UserUpdated({required this.user});

  @override
  List<Object?> get props => [user];
}

class UserDeleted extends UserState {
  final int userID;

  UserDeleted({required this.userID});

  @override
  List<Object?> get props => [userID];
}

class UserError extends UserState {
  final String message;

  UserError({required this.message});

  @override
  List<Object?> get props => [message];
}
