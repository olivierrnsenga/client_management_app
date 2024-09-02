import 'dart:convert';
import 'package:client_management_app/blocs/Login/user_login_dto.dart';
import 'package:client_management_app/models/user/user.dart';
import 'package:client_management_app/models/user/user_response.dart';
import 'package:http/http.dart' as http;

class UserRepository {
  final String baseUrl;

  UserRepository({required this.baseUrl});

  Future<UserResponse> fetchUsers(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user?pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return UserResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> getUser(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/user/$id'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> addUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode == 201) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add user');
    }
  }

  Future<void> updateUser(int id, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/user/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/user/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete user');
    }
  }

  Future<UserResponse> searchUsers(
      String searchTerm, int pageNumber, int pageSize) async {
    final uri = Uri.parse(
      '$baseUrl/user/search?searchTerm=$searchTerm&pageNumber=$pageNumber&pageSize=$pageSize',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return UserResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to search users');
    }
  }

  Future<LoginResponse> loginUser(UserLoginDto userLoginDto) async {
    final url = Uri.parse('$baseUrl/User/login');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(userLoginDto.toJson()),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login');
    }
  }
}
