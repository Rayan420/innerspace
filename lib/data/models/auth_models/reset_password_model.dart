class ResetPasswordModel {
  String? token;
  String? message;
  String? email;

  ResetPasswordModel({this.token, this.message, this.email});

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      token: json['token'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'message': message,
      'email': email, // Add email field to toJson method
    };
  }
}
