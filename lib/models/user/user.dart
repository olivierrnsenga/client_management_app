class User {
  final int userID;
  final String username;
  final String password;
  final String role;

  User({
    required this.userID,
    required this.username,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userID: json['userID'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'username': username,
      'password': password,
      'role': role,
    };
  }

  User copyWith({
    int? userID,
    String? username,
    String? password,
    String? role,
  }) {
    return User(
      userID: userID ?? this.userID,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
    );
  }
}
