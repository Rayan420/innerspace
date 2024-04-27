import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String accessToken;
  final String refreshToken;

  const Token({
    required this.accessToken,
    required this.refreshToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access'],
      refreshToken: json['refresh'],
    );
  }

  // Define toJson method to convert Token object to JSON
  Map<String, dynamic> toJson() {
    return {
      'access': accessToken,
      'refresh': refreshToken,
    };
  }

  @override
  List<Object?> get props => [accessToken, refreshToken];
}
