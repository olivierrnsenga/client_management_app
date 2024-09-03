import 'package:client_management_app/models/status/status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusRepository {
  final String baseUrl;

  StatusRepository({required this.baseUrl});

  Future<List<Status>> fetchStatuses() async {
    final response = await http.get(Uri.parse('$baseUrl/statuses'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Status.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load statuses');
    }
  }
}
