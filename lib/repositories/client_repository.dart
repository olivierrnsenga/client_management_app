import 'dart:convert';
import 'package:client_management_app/models/client_response.dart';
import 'package:http/http.dart' as http;

class ClientRepository {
  final String baseUrl;

  ClientRepository({required this.baseUrl});

  Future<ClientResponse> fetchClients(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Clients?pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return ClientResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to load clients');
    }
  }
}
