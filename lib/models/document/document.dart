class Document {
  final int? documentID;
  final int projectID;
  final String documentName;
  final String documentType;
  final String documentPath;
  final DateTime uploadDate;

  Document({
    this.documentID,
    required this.projectID,
    required this.documentName,
    required this.documentType,
    required this.documentPath,
    required this.uploadDate,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentID: json['documentID'] as int?,
      projectID: json['projectID'] as int,
      documentName: json['documentName'] as String,
      documentType: json['documentType'] as String,
      documentPath: json['documentPath'] as String,
      uploadDate: DateTime.parse(json['uploadDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'documentID': documentID,
      'projectID': projectID,
      'documentName': documentName,
      'documentType': documentType,
      'documentPath': documentPath,
      'uploadDate': uploadDate.toIso8601String(),
    };
  }

  static List<Document> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Document.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Document> documents) {
    return documents.map((document) => document.toJson()).toList();
  }
}
