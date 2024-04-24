import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String email;
  final String username;

  const MyUserEntity(
      {required this.userId, required this.email, required this.username});

  Map<String, Object?> toDocument() {
    return {
      'userId': userId,
      'email': email,
      'name': username,
    };
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(
        userId: doc['userId'], email: doc['email'], username: doc['username']);
  }

  @override
  List<Object?> get props => [userId, email, username];
}
