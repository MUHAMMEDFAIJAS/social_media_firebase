import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  String? image;
  String? description;
  String? userid;
  bool? isLiked;
  String? username;
  String? userImage;
  // Timestamp? timestamp;
  String? time;

  PostModel({
    this.image,
    this.description,
    this.isLiked,
    this.userid,
    this.username,
    this.userImage,
    // this.timestamp,
    this.time,
  });

  PostModel.fromjson(Map<String, dynamic> json) {
    image = json['image'];
    description = json['description'];
    isLiked = json['isliked'];
    userid = json['userid'];
    username = json['username'];
    userImage = json['userimage'];
    // timestamp = json['timestamp'];
    time = json['time'];
  }
  Map<String, dynamic> tojson() {
    return {
      'image': image,
      'description': description,
      'isliked': isLiked,
      'userid': userid,
      'username': username,
      'userimage': userImage,
      // 'timestamp': timestamp,
      'time':time,
    };
  }
}
