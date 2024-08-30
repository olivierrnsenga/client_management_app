import 'dart:convert';
import 'package:client_management_app/models/project/project.dart';
import 'package:client_management_app/models/project/project_response.dart';
import 'package:http/http.dart' as http;

class ProjectRepository {
  final String baseUrl;

  ProjectRepository({required this.baseUrl});

  Future<ProjectResponse> fetchProjects(int pageNumber, int pageSize) async {
    final response = await http.get(
      Uri.parse('$baseUrl/Projects?pageNumber=$pageNumber&pageSize=$pageSize'),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return ProjectResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<Project> getProject(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/Projects/$id'));
    if (response.statusCode == 200) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load project');
    }
  }

  Future<Project> addProject(Project project) async {
    final response = await http.post(
      Uri.parse('$baseUrl/Projects'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(project.toJson()),
    );
    if (response.statusCode == 201) {
      return Project.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add project');
    }
  }

  Future<void> updateProject(int id, Project project) async {
    final response = await http.put(
      Uri.parse('$baseUrl/Projects/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(project.toJson()),
    );
    if (response.statusCode != 204) {
      throw Exception('Failed to update project');
    }
  }

  Future<void> deleteProject(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/Projects/$id'));
    if (response.statusCode != 204) {
      throw Exception('Failed to delete project');
    }
  }

  Future<ProjectResponse> searchProjects(
      String searchTerm, int pageNumber, int pageSize) async {
    final uri = Uri.parse(
      '$baseUrl/Projects/search?searchTerm=$searchTerm&pageNumber=$pageNumber&pageSize=$pageSize',
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final paginationHeader = response.headers['x-pagination'] ?? '{}';

      return ProjectResponse.fromJson(jsonResponse, paginationHeader);
    } else {
      throw Exception('Failed to search projects');
    }
  }
}
