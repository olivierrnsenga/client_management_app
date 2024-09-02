import 'package:equatable/equatable.dart';
import 'package:client_management_app/models/user/user.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final int pageNumber;
  final int pageSize;

  const FetchUsers({required this.pageNumber, required this.pageSize});

  @override
  List<Object?> get props => [pageNumber, pageSize];
}

class SearchUsers extends UserEvent {
  final String searchTerm;
  final int pageNumber;
  final int pageSize;

  const SearchUsers({
    required this.searchTerm,
    required this.pageNumber,
    required this.pageSize,
  });

  @override
  List<Object?> get props => [searchTerm, pageNumber, pageSize];
}

class AddUser extends UserEvent {
  final User user;

  const AddUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateUser extends UserEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class DeleteUser extends UserEvent {
  final int userID;

  const DeleteUser({required this.userID});

  @override
  List<Object?> get props => [userID];
}
