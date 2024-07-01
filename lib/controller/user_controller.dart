import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/model/post_model.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/post_servicce.dart';
import 'package:socialmedia/services/user_service.dart';

class UserController extends ChangeNotifier {
  UserService service = UserService();
  PostimageService imgservice = PostimageService();

  Stream<List<UserModel>> getUsers() {
    return service.getUser();
  }

  Stream<QuerySnapshot<PostModel>> fetchPostUser(
      PostModel model, String currentUserId) {
    return imgservice.getUserPosts(currentUserId);
  }
}
