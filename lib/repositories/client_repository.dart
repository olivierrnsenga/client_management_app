import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client_management_app/models/client.dart';
import 'package:client_management_app/models/client_response.dart';

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

  Future<Client> getClient(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Clients/$id'));
    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load client');
    }
  }

  Future<Client> addClient(Client client) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Clients'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (response.statusCode == 201) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add client');
    }
  }

  Future<void> updateClient(int id, Client client) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Clients/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(client.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update client');
    }
  }

  Future<void> deleteClient(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Clients/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete client');
    }
  }

  Future<ClientResponse> searchClients(
      String searchTerm, int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/Clients/search?searchTerm=$searchTerm&pageNumber=$pageNumber&pageSize=$pageSize'),
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return ClientResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to search clients');
    }
  }
}
