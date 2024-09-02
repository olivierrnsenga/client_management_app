import 'dart:convert';

import 'package:client_management_app/models/user/user.dart';

class UserResponse {
  final List<User> users;
  final int totalCount;
  final int currentPage;
  final int totalPages;

  UserResponse({
    required this.users,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
  });

  factory UserResponse.fromJson(
      Map<String, dynamic> json, String paginationJson) {
    var userList = json['users'] as List;
    List<User> users = userList.map((i) => User.fromJson(i)).toList();

    final pagination = jsonDecode(paginationJson) as Map<String, dynamic>;

    return UserResponse(
      users: users,
      totalCount: pagination['TotalCount'] ?? 0,
      currentPage: pagination['CurrentPage'] ?? 0,
      totalPages: pagination['TotalPages'] ?? 0,
    );
  }
}
