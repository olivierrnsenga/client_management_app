class Project {
  final int? projectID;
  final String projectName;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final int clientID;
  final int lawyerID;
  final int statusID;

  Project({
    this.projectID,
    required this.projectName,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.clientID,
    required this.lawyerID,
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
      clientID: json['clientID'] as int? ?? 0,
      lawyerID: json['lawyerID'] as int? ?? 0,
      statusID: json['statusID'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectID': projectID,
      'projectName': projectName,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'clientID': clientID,
      'lawyerID': lawyerID,
      'statusID': statusID,
    };
  }

  Project copyWith({
    int? projectID,
    String? projectName,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    int? clientID,
    int? lawyerID,
    int? statusID,
  }) {
    return Project(
      projectID: projectID ?? this.projectID,
      projectName: projectName ?? this.projectName,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      clientID: clientID ?? this.clientID,
      lawyerID: lawyerID ?? this.lawyerID,
      statusID: statusID ?? this.statusID,
    );
  }
}
