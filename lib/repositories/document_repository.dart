import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client_management_app/models/document/document.dart';

class DocumentRepository {
  final String baseUrl;

  DocumentRepository({required this.baseUrl});

  Future<List<Document>> fetchDocuments(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Documents?pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List documents =
          jsonResponse['documents'] ?? []; // Access the correct key 'documents'

      return documents.map((doc) => Document.fromJson(doc)).toList();
    } else {
      throw Exception('Failed to load documents');
    }
  }

  Future<List<Document>> fetchDocumentsByProjectId(
      int projectId, int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/Documents/ByProject/$projectId?pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['documents'];
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load documents for project ID: $projectId');
    }
  }

  Future<Document> getDocument(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Documents/$id'));
    if (response.statusCode == 200) {
      return Document.fromJson(
          json.decode(response.body)['document']); // Use lowercase key
    } else {
      throw Exception('Failed to load document');
    }
  }

  Future<List<Document>> addDocuments(List<Document> documents) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Documents'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
          documents.map((doc) => doc.toJson()).toList()), // Send as an array
    );
    if (response.statusCode == 201) {
      final List<dynamic> data = json.decode(response.body)['documents'];
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Failed to add documents');
    }
  }

  Future<void> updateDocuments(List<Document> documents) async {
    for (var document in documents) {
      final response = await http.put(
        Uri.parse('$baseUrl/Documents/${document.documentID}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(document.toJson()),
      );
      if (response.statusCode != 204) {
        throw Exception(
            'Failed to update document with ID ${document.documentID}');
      }
    }
  }

  Future<void> deleteDocument(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Documents/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete document');
    }
  }

  // Add the searchDocuments method
  Future<List<Document>> searchDocuments(
      String searchTerm, int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '$baseUrl/Documents/Search?searchTerm=$searchTerm&pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['documents'];
      return data.map((json) => Document.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search documents');
    }
  }
}
