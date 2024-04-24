import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable  {
  final String userId;
  final String email;
  final String username;


  const MyUser({
    required this.userId,
    required this.email,
    required this.username
  });

  static const empty = MyUser(
      userId: '',
      email: '',
      username: ''
  );

  MyUser copyWith({
    String? userId,
    String? email,
    String? username
  }) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        username: username ?? this.username
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
        userId: userId,
        email: email,
        username: username
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId,
        email: entity.email,
        username: entity.username
    );
  }

  @override
  List<Object?> get props => [userId, email, username];
}