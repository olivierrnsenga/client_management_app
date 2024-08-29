import 'dart:convert';
import 'package:client_management_app/models/client.dart';

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
