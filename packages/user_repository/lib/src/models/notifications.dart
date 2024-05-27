// ignore: file_names
import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

class Notifications extends Equatable {
  final int id;
  final String message;
  final int ownerId;
  final int senderId;
  final bool read;
  final bool deleted;
  final String? senderImage;
  final String senderName;
  final String senderUsername;
  final String type;
  final DateTime createdAt; // New property for storing the creation time

  Notifications({
    required this.id,
    required this.message,
    required this.ownerId,
    required this.senderId,
    required this.read,
    required this.deleted,
    this.senderImage,
    required this.senderName,
    required this.senderUsername,
    required this.type,
    required this.createdAt, // Initialize the new property
  });

  factory Notifications.fromJson(Map<String, dynamic> json) {
    return Notifications(
      id: json['id'],
      message: json['message'],
      ownerId: json['ownerId'],
      senderId: json['senderId'],
      read: json['read'],
      deleted: json['deleted'],
      senderImage: json['senderImage'],
      senderName: json['senderName'],
      senderUsername: json['senderUsername'],
      type: json['notificationType'],
      createdAt: DateTime.parse(json['createdAt']), // Parse and assign the createdAt value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'ownerId': ownerId,
      'senderId': senderId,
      'read': read,
      'deleted': deleted,
      'senderImage': senderImage,
      'senderName': senderName,
      'senderUsername': senderUsername,
      'type': type,
      'createdAt': createdAt.toIso8601String(), // Serialize DateTime to ISO 8601 string
    };
  }

  @override
  List<Object?> get props => [id, message, ownerId, senderId, read, deleted, senderImage, senderName, senderUsername, type, createdAt];
}


class FollowNotification extends Notifications {
  final String? senderBio;
  final int followerCount;
  final int followingCount;

  FollowNotification({
    required super.id,
    required super.message,
    required super.ownerId,
    required super.senderId,
    required super.read,
    required super.deleted,
    super.senderImage,
    required super.senderName,
    required super.senderUsername,
    required super.type,
    this.senderBio,
    required this.followerCount,
    required this.followingCount,
    required super.createdAt,
  });

  factory FollowNotification.fromJson(Map<String, dynamic> json) {
    return FollowNotification(
      id: json['id'],
      message: json['message'],
      ownerId: json['ownerId'],
      senderId: json['senderId'],
      read: json['read'],
      deleted: json['deleted'],
      senderImage: json['senderImage'],
      senderName: json['senderName'],
      senderUsername: json['senderUsername'],
      type: json['notificationType'],
      senderBio: json['senderBio'],
      followerCount: json['followerCount'],
      followingCount: json['followingCount'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'senderBio': senderBio,
      'followerCount': followerCount,
      'followingCount': followingCount,
    });
    return data;
  }
}

class LikeNotification extends Notifications {
  LikeNotification({
    required super.id,
    required super.message,
    required super.ownerId,
    required super.senderId,
    required super.read,
    required super.deleted,
    super.senderImage,
    required super.senderName,
    required super.senderUsername,
    required super.type,
    required super.createdAt,
  });

  factory LikeNotification.fromJson(Map<String, dynamic> json) {
    return LikeNotification(
      id: json['id'],
      message: json['message'],
      ownerId: json['ownerId'],
      senderId: json['senderId'],
      read: json['read'],
      deleted: json['deleted'],
      senderImage: json['senderImage'],
      senderName: json['senderName'],
      senderUsername: json['senderUsername'],
      type: json['notificationType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
