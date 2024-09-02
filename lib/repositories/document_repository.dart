import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client_management_app/models/document/document.dart';

class DocumentRepository {
  final String baseUrl;

  DocumentRepository({required this.baseUrl});

  Future<List<Document>> fetchDocuments(
      int projectId, int pageNumber, int pageSize) async {
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

  Future<Document> getDocument(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Documents/$id'));
    if (response.statusCode == 200) {
      return Document.fromJson(json.decode(response.body)['Document']);
    } else {
      throw Exception('Failed to load document');
    }
  }

  Future<Document> addDocument(Document document) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Documents'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(document.toJson()),
    );
    if (response.statusCode == 201) {
      return Document.fromJson(json.decode(response.body)['Document']);
    } else {
      throw Exception('Failed to add document');
    }
  }

  Future<void> updateDocument(int id, Document document) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Documents/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(document.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update document');
    }
  }

  Future<void> deleteDocument(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Documents/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete document');
    }
  }
}
