// a model to hold signup data

class SignUpModel {
  final String username;
  final String email;
  final String password;

  SignUpModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}
