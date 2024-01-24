import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;

// user entity object constructor
  const MyUserEntity({
    required this.userId,
    required this.email,

  });

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
      userId: doc['userId'],
      email: doc['email'],
    );
  }

  @override
  List<Object?> get props => [userId, email];
}
