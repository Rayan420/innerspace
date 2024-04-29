import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

class User extends Equatable {
  final int userId;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final String dateJoined;
  final String lastLogin;
  final UserProfile userProfile;
  final List<dynamic> sentFollowRequests;
  final List<dynamic> receivedFollowRequests;
  final List<dynamic> authorities;
  final List<dynamic> followers;
  final List<dynamic> following;
  final String name;
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
    required this.sentFollowRequests,
    required this.receivedFollowRequests,
    required this.authorities,
    required this.followers,
    required this.following,
    required this.name,
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
      dateOfBirth: json['dateOfBirth'],
      dateJoined: json['dateJoined'],
      lastLogin: json['lastLogin'],
      userProfile: UserProfile.fromJson(json['userProfile']),
      sentFollowRequests: json['sentFollowRequests'],
      receivedFollowRequests: json['receivedFollowRequests'],
      authorities: json['authorities'],
      followers: json['followers'],
      following: json['following'],
      name: json['name'],
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
      'sentFollowRequests': sentFollowRequests,
      'receivedFollowRequests': receivedFollowRequests,
      'authorities': authorities,
      'followers': followers,
      'following': following,
      'name': name,
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
        sentFollowRequests,
        receivedFollowRequests,
        authorities,
        followers,
        following,
        name,
        enabled,
        accountNonLocked,
        credentialsNonExpired,
        accountNonExpired,
      ];
}
