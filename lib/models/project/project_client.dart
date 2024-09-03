// models/project/project_client.dart

import '../client/client.dart';

class ProjectClient {
  final int projectID;
  final int clientID;
  final Client client;

  ProjectClient({
    required this.projectID,
    required this.clientID,
    required this.client,
  });

  factory ProjectClient.fromJson(Map<String, dynamic> json) {
    return ProjectClient(
      projectID: json['projectID'] as int,
      clientID: json['clientID'] as int,
      client: Client.fromJson(json['client']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectID': projectID,
      'clientID': clientID,
      'client': client.toJson(),
    };
  }
}
