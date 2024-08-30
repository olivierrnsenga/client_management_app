import 'dart:convert';

import 'package:client_management_app/models/project/project.dart';

class ProjectResponse {
  final List<Project> projects;
  final int totalCount;
  final int pageSize;
  final int currentPage;
  final int totalPages;

  ProjectResponse({
    required this.projects,
    required this.totalCount,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
  });

  factory ProjectResponse.fromJson(
      Map<String, dynamic> json, String paginationJson) {
    var projectList = json['projects'] as List;
    List<Project> projects =
        projectList.map((i) => Project.fromJson(i)).toList();

    // Parse the pagination JSON string
    final pagination = jsonDecode(paginationJson) as Map<String, dynamic>;

    return ProjectResponse(
      projects: projects,
      totalCount: pagination['TotalCount'] ?? 0,
      pageSize: pagination['PageSize'] ?? 0,
      currentPage: pagination['CurrentPage'] ?? 0,
      totalPages: pagination['TotalPages'] ?? 0,
    );
  }
}
