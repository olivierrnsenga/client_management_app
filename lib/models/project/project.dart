import 'package:client_management_app/models/status/status.dart';
import 'package:client_management_app/models/project/project_client.dart';
import 'package:client_management_app/models/project/project_lawyer.dart';

class Project {
  final int? projectID;
  final String projectName;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<ProjectClient> projectClients;
  final List<ProjectLawyer> projectLawyers;
  final Status status;

  Project({
    this.projectID,
    required this.projectName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.projectClients,
    required this.projectLawyers,
    required this.status,
  });

  Project copyWith({
    int? projectID,
    String? projectName,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<ProjectClient>? projectClients,
    List<ProjectLawyer>? projectLawyers,
    Status? status,
  }) {
    return Project(
      projectID: projectID ?? this.projectID,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      projectClients: projectClients ?? this.projectClients,
      projectLawyers: projectLawyers ?? this.projectLawyers,
      status: status ?? this.status,
    );
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectID: json['projectID'] as int?,
      projectName: json['projectName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.parse(json['endDate'])
          : DateTime.now(),
      projectClients: (json['projectClients'] as List<dynamic>?)
              ?.map((client) =>
                  ProjectClient.fromJson(client as Map<String, dynamic>))
              .toList() ??
          [],
      projectLawyers: (json['projectLawyers'] as List<dynamic>?)
              ?.map((lawyer) =>
                  ProjectLawyer.fromJson(lawyer as Map<String, dynamic>))
              .toList() ??
          [],
      // Ensure `status` is correctly deserialized as a Map, not a List
      status: json['status'] is Map<String, dynamic>
          ? Status.fromJson(json['status'] as Map<String, dynamic>)
          : Status(
              statusID: 0,
              statusName: 'Unknown'), // Handle null or incorrect status
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectID': projectID ?? 0,
      'projectName': projectName,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'projectClients':
          projectClients.map((client) => client.toJson()).toList(),
      'projectLawyers':
          projectLawyers.map((lawyer) => lawyer.toJson()).toList(),
      'status': status.toJson(),
    };
  }
}
