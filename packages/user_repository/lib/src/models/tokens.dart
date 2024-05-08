import 'package:equatable/equatable.dart';

class Token extends Equatable {
  final String access;
  final String refresh;

  const Token({
    required this.access,
    required this.refresh,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      access: json['access'],
      refresh: json['refresh'],
    );
  }

  // Define toJson method to convert Token object to JSON
  Map<String, dynamic> toJson() {
    return {
      'access': access,
      'refresh': refresh,
    };
  }

  @override
  List<Object?> get props => [access, refresh];
}
