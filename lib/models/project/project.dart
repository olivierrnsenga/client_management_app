class Project {
  final int? projectID;
  final String projectName;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final List<int> clientIDs; // List of client IDs
  final List<int> lawyerIDs; // List of lawyer IDs
  final int statusID;

  Project({
    this.projectID,
    required this.projectName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.clientIDs, // Updated to accept a list of IDs
    required this.lawyerIDs, // Updated to accept a list of IDs
    required this.statusID,
  });

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
      clientIDs: List<int>.from(json['clientIDs'] ?? []), // Parse list of IDs
      lawyerIDs: List<int>.from(json['lawyerIDs'] ?? []), // Parse list of IDs
      statusID: json['statusID'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectID': projectID ?? 0, // Provide a default value if null
      'projectName': projectName,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'clientIDs': clientIDs, // Convert list of client IDs to JSON
      'lawyerIDs': lawyerIDs, // Convert list of lawyer IDs to JSON
      'statusID': statusID,
    };
  }

  Project copyWith({
    int? projectID,
    String? projectName,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    List<int>? clientIDs, // Updated to accept a list of IDs
    List<int>? lawyerIDs, // Updated to accept a list of IDs
    int? statusID,
  }) {
    return Project(
      projectID: projectID ?? this.projectID,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      clientIDs: clientIDs ?? this.clientIDs, // Use new or existing list
      lawyerIDs: lawyerIDs ?? this.lawyerIDs, // Use new or existing list
      statusID: statusID ?? this.statusID,
    );
  }
}
