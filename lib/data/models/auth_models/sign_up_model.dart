// a model to hold signup data

class SignUpModel {
  final String username;
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  SignUpModel({
    required this.username,
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
