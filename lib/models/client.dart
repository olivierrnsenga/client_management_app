// lib/models/client.dart
class Client {
  final int clientID;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final String dateOfBirth;

  Client({
    required this.clientID,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.dateOfBirth,
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      clientID: json['clientID'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      dateOfBirth: json['dateOfBirth'],
    );
  }
}
