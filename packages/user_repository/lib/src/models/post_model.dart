import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String userName;
  final String name;
  final String audioUrl;
  final String profileImageUrl;
  final DateTime timeStamp;
  final String? coverImageUrl;
  final int voteCount;

  Post( {
    required this.id,
    required this.userName,
    required this.name,
    required this.profileImageUrl,
    required this.audioUrl,
    required this.timeStamp,
    required this.coverImageUrl,
    required this.voteCount,
  });

  Post copyWith({
    int? id,
    String? userName,
    String? profileImageUrl,
    String? audioUrl,
    String? name,
    DateTime? timeStamp,
    String? coverImageUrl,
  }) {
    return Post(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      name: name ?? this.name,
      timeStamp: timeStamp ?? this.timeStamp,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      voteCount: voteCount,
    );
  }

  // to json
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userName': userName,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'audioUrl': audioUrl,
      'timeStamp': timeStamp,
      'coverImageUrl': coverImageUrl,
      "likeCount": voteCount,
    };
  }

  // from json

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userName: json['userName'],
      name: json['name'],
      profileImageUrl: json['profileImageUrl'],
      audioUrl: json['audioUrl'],
      timeStamp: DateTime.parse(json['timestamp']),
      coverImageUrl: json['coverImageUrl'],
      voteCount: json['likeCount'],
    );
  }

  @override
  List<Object?> get props =>
      [id, userName, name, profileImageUrl, audioUrl, timeStamp, coverImageUrl];
}
