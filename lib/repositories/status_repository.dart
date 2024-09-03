import 'package:client_management_app/models/status/status.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatusRepository {
  final String baseUrl;

  StatusRepository({required this.baseUrl});

  Future<List<Status>> fetchStatuses() async {
    final response = await http.get(Uri.parse('$baseUrl/statuses'));

    if (response.statusCode == 200) {
      // Decode the JSON response
      Map<String, dynamic> data = json.decode(response.body);

      // Ensure that the 'statuses' key exists and is a list
      if (data.containsKey('statuses') && data['statuses'] is List) {
        List<dynamic> statusesJson = data['statuses'];
        return statusesJson.map((json) => Status.fromJson(json)).toList();
      } else {
        throw Exception(
            "Unexpected response format: 'statuses' key not found or is not a list");
      }
    } else {
      throw Exception('Failed to load statuses');
    }
  }
}
