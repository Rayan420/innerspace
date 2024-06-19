class LightweightUser {
  final int userId;
  final String username;
  final String firstName;
  final String lastName;

  LightweightUser({
    required this.userId,
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory LightweightUser.fromJson(Map<String, dynamic> json) {
    return LightweightUser(
      userId: json['userId'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
