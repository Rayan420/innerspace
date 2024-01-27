import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  // user object properties
  final String userId;
  final String email;

// user object constructor
  const MyUser({
    required this.userId,
    required this.email,
  });

  static const empty = MyUser(userId: '', email: '');

  MyUser copyWith({
    String? userId,
    String? email,
  }) {
    return MyUser(
      userId: userId ?? this.userId,
      email: email ?? this.email,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email,
    );
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
      userId: entity.userId,
      email: entity.email,
    );
  }

  @override
  List<Object?> get props => [userId, email];
}
