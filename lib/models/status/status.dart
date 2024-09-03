class Status {
  final int statusID;
  final String statusName;

  Status({
    required this.statusID,
    required this.statusName,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      statusID: json['statusID'] as int,
      statusName: json['statusName'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statusID': statusID,
      'statusName': statusName,
    };
  }
}
