import 'dart:convert';
import 'dart:typed_data';
import 'package:user_repository/src/utils/backend_urls.dart';

import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class UserProfile extends Equatable {
  final int profileId;
  String? profilePicture;
  String? bio;
  String lastUpdated;
  int followerCount;
  int followingCount;
  final int ownedSpaceCount;
  final int followedSpaceCount;
  final bool private;

  UserProfile({
    required this.profileId,
    this.profilePicture,
    this.bio,
    required this.lastUpdated,
    required this.ownedSpaceCount,
    required this.followedSpaceCount,
    required this.private,
    required this.followerCount,
    required this.followingCount,
  }) {
    profilePicture = BackendUrls.replaceLocalhost(profilePicture ?? '');
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profileId: json['profileId'],
      profilePicture:
          BackendUrls.replaceLocalhost(json['profileImageUrl'] ?? ''),
      bio: json['bio'] ?? '',
      lastUpdated: json['lastUpdated'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      ownedSpaceCount: json['ownedSpaceCount'],
      followedSpaceCount: json['followedSpaceCount'],
      private: json['private'],
    );
  }

  static Uint8List? _decodeProfilePicture(String? base64String) {
    if (base64String != null) {
      return base64Decode(base64String);
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'profileImageUrl': profilePicture,
      'bio': bio,
      'lastUpdated': lastUpdated,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'ownedSpaceCount': ownedSpaceCount,
      'followedSpaceCount': followedSpaceCount,
      'private': private,
    };
  }

  // static String? _encodeProfilePicture(Uint8List? profilePicture) {
  //   if (profilePicture != null) {
  //     return base64Encode(profilePicture);
  //   }
  //   return null;
  // }

  @override
  List<Object?> get props => [
        profileId,
        profilePicture,
        bio,
        lastUpdated,
        followerCount,
        followingCount,
        ownedSpaceCount,
        followedSpaceCount,
        private,
      ];
}
