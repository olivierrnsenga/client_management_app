class Lawyer {
  final int lawyerID;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String specialization;

  Lawyer({
    required this.lawyerID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.specialization,
  });

  factory Lawyer.fromJson(Map<String, dynamic> json) {
    return Lawyer(
      lawyerID: json['lawyerID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      specialization: json['specialization'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lawyerID': lawyerID,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'specialization': specialization,
    };
  }

  Lawyer copyWith({
    int? lawyerID,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? specialization,
  }) {
    return Lawyer(
      lawyerID: lawyerID ?? this.lawyerID,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
    );
  }
}
