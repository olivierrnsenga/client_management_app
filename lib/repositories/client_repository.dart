import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/client.dart';

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

class ClientResponse {
  final List<Client> clients;
  final int totalCount;
  final int pageSize;
  final int currentPage;
  final int totalPages;

  ClientResponse({
    required this.clients,
    required this.totalCount,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
  });

  factory ClientResponse.fromJson(
      Map<String, dynamic> json, String paginationJson) {
    var clientList = json['clients'] as List;
    List<Client> clients = clientList.map((i) => Client.fromJson(i)).toList();

    // Parse the pagination JSON string
    final pagination = jsonDecode(paginationJson) as Map<String, dynamic>;

    return ClientResponse(
      clients: clients,
      totalCount: pagination['TotalCount'] ?? 0,
      pageSize: pagination['PageSize'] ?? 0,
      currentPage: pagination['CurrentPage'] ?? 0,
      totalPages: pagination['TotalPages'] ?? 0,
    );
  }
}
