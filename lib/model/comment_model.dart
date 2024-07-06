import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userid;
  final String postid;
  final String commenttext;
  final String image;
  final String username;
  final Timestamp timestamp;

  CommentModel({
    required this.image,
    required this.userid,
    required this.commenttext,
    required this.postid,
    required this.username,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      userid: json['userId'],
      postid: json['postId'],
      commenttext: json['commentText'],
      timestamp: json['timestamp'],
      image: json['image'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userid,
      'postId': postid,
      'commentText': commenttext,
      'timestamp': timestamp,
      'username': username,
      'image': image,
    };
  }
}
