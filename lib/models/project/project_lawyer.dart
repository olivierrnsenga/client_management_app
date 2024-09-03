// models/project/project_lawyer.dart

import '../lawyer/lawyer.dart';

class ProjectLawyer {
  final int projectID;
  final int lawyerID;
  final Lawyer lawyer;

  ProjectLawyer({
    required this.projectID,
    required this.lawyerID,
    required this.lawyer,
  });

  factory ProjectLawyer.fromJson(Map<String, dynamic> json) {
    return ProjectLawyer(
      projectID: json['projectID'] as int,
      lawyerID: json['lawyerID'] as int,
      lawyer: Lawyer.fromJson(json['lawyer']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectID': projectID,
      'lawyerID': lawyerID,
      'lawyer': lawyer.toJson(),
    };
  }
}
