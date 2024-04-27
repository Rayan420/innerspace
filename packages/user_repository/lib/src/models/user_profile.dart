import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int profileId;
  final String? profilePictureUrl;
  final String? bio;
  final String lastUpdated;
  final int followerCount;
  final int followingCount;
  final int ownedSpaceCount;
  final int followedSpaceCount;
  final bool private;

  const UserProfile({
    required this.profileId,
    this.profilePictureUrl,
    this.bio,
    required this.lastUpdated,
    required this.followerCount,
    required this.followingCount,
    required this.ownedSpaceCount,
    required this.followedSpaceCount,
    required this.private,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      profileId: json['profileId'],
      profilePictureUrl: json['profilePictureUrl'],
      bio: json['bio'],
      lastUpdated: json['lastUpdated'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      ownedSpaceCount: json['ownedSpaceCount'],
      followedSpaceCount: json['followedSpaceCount'],
      private: json['private'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'profileId': profileId,
      'profilePictureUrl': profilePictureUrl,
      'bio': bio,
      'lastUpdated': lastUpdated,
      'followerCount': followerCount,
      'followingCount': followingCount,
      'ownedSpaceCount': ownedSpaceCount,
      'followedSpaceCount': followedSpaceCount,
      'private': private,
    };
  }

  @override
  List<Object?> get props => [
        profileId,
        profilePictureUrl,
        bio,
        lastUpdated,
        followerCount,
        followingCount,
        ownedSpaceCount,
        followedSpaceCount,
        private,
      ];
}
