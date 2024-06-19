import 'package:equatable/equatable.dart';
import 'package:user_repository/data.dart'; // Ensure this import is correct based on your project structure

class User extends Equatable {
  int userId;
  String username;
  String email;
  String? firstName;
  String? lastName;
  String? dateOfBirth;
  final String dateJoined;
  final String? lastLogin;
  UserProfile userProfile;
  List<dynamic> authorities;
  List<LightweightUser> following; // Updated type for following
  List<LightweightUser> followers; // Updated type for followers
  bool enabled;
  bool accountNonLocked;
  bool credentialsNonExpired;
  bool accountNonExpired;

  User({
    required this.userId,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.dateJoined,
    required this.lastLogin,
    required this.userProfile,
    required this.authorities,
    required this.following,
    required this.followers,
    required this.enabled,
    required this.accountNonLocked,
    required this.credentialsNonExpired,
    required this.accountNonExpired,
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
      following: (json['following'] as List<dynamic>? ?? [])
          .map((e) => LightweightUser.fromJson(e))
          .toList(),
      followers: (json['followers'] as List<dynamic>? ?? [])
          .map((e) => LightweightUser.fromJson(e))
          .toList(),
      enabled: json['enabled'],
      accountNonLocked: json['accountNonLocked'],
      credentialsNonExpired: json['credentialsNonExpired'],
      accountNonExpired: json['accountNonExpired'],
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
      'following': following
          .map((e) => e.toJson())
          .toList(), // Convert following to JSON
      'followers': followers
          .map((e) => e.toJson())
          .toList(), // Convert followers to JSON
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
        following,
        followers,
        enabled,
        accountNonLocked,
        credentialsNonExpired,
        accountNonExpired,
      ];
}
