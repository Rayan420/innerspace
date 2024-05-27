import 'package:equatable/equatable.dart';
import 'package:user_repository/data.dart';

class User extends Equatable {
  final int userId;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String dateJoined;
  final String? lastLogin;
  final UserProfile userProfile;
  final List<dynamic> authorities;
  final List<dynamic>? following;
  final List<dynamic>? followers;
  final bool enabled;
  final bool accountNonLocked;
  final bool credentialsNonExpired;
  final bool accountNonExpired;

  const User({
    required this.userId,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    required this.dateJoined,
    required this.lastLogin,
    required this.userProfile,
    required this.authorities,
    required this.enabled,
    required this.accountNonLocked,
    required this.credentialsNonExpired,
    required this.accountNonExpired,
    required this.following,
    required this.followers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: json['dateOfBirth'] ?? '',
      dateJoined: json['dateJoined'],
      lastLogin: json['lastLogin'] ?? '',
      userProfile: UserProfile.fromJson(json['userProfile']),
      authorities: json['authorities'],
      enabled: json['enabled'],
      accountNonLocked: json['accountNonLocked'],
      credentialsNonExpired: json['credentialsNonExpired'],
      accountNonExpired: json['accountNonExpired'],
      following: json['following'] ?? [],
      followers: json['followers'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth,
      'dateJoined': dateJoined,
      'lastLogin': lastLogin,
      'userProfile': userProfile.toJson(),
      'authorities': authorities,
      'enabled': enabled,
      'accountNonLocked': accountNonLocked,
      'credentialsNonExpired': credentialsNonExpired,
      'accountNonExpired': accountNonExpired,
    };
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        email,
        firstName,
        lastName,
        dateOfBirth,
        dateJoined,
        lastLogin,
        userProfile,
        authorities,
        enabled,
        accountNonLocked,
        credentialsNonExpired,
        accountNonExpired,
      ];
}
