import 'dart:convert';

import 'package:client_management_app/models/lawyer/lawyer.dart';
import 'package:client_management_app/models/lawyer/lawyer_response.dart';
import 'package:http/http.dart' as http;

class LawyerRepository {
  final String baseUrl;

  LawyerRepository({required this.baseUrl});

  Future<LawyerResponse> fetchLawyers(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Lawyers?pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return LawyerResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to load lawyers');
    }
  }

  Future<Lawyer> getLawyer(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Lawyers/$id'));
    if (response.statusCode == 200) {
      return Lawyer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load lawyer');
    }
  }

  Future<Lawyer> addLawyer(Lawyer lawyer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Lawyers'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(lawyer.toJson()),
    );
    if (response.statusCode == 201) {
      return Lawyer.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add lawyer');
    }
  }

  Future<void> updateLawyer(int id, Lawyer lawyer) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Lawyers/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(lawyer.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update lawyer');
    }
  }

  Future<void> deleteLawyer(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Lawyers/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete lawyer');
    }
  }

  Future<LawyerResponse> searchLawyers(
      String searchTerm, int pageNumber, int pageSize) async {
    final uri = Uri.parse(
      '$baseUrl/Lawyers/search?searchTerm=$searchTerm&pageNumber=$pageNumber&pageSize=$pageSize',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return LawyerResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to search lawyers');
    }
  }
}
