import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/model/post_model.dart';
import 'package:socialmedia/services/post_servicce.dart';

class HomePageProvider extends ChangeNotifier {
  PostimageService service = PostimageService();
  Map<String, bool> _likeStates = {};
  Map<String, int> _likeCounts = {};

  bool isLiked(String postId) => _likeStates[postId] ?? false;
  int likeCount(String postId) => _likeCounts[postId] ?? 0;

  void toggleLike(String postId) {
    _likeStates[postId] = !(_likeStates[postId] ?? false);
    _likeCounts[postId] =
        (_likeCounts[postId] ?? 0) + (_likeStates[postId]! ? 1 : -1);
    notifyListeners();
  }

  Stream<QuerySnapshot<PostModel>> getPosts() {
    return service.getPost();
  }
}
