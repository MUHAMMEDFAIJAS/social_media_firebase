import 'package:flutter/material.dart';
import 'package:socialmedia/model/comment_model.dart';
import 'package:socialmedia/services/commentservice.dart';

class CommentProvider extends ChangeNotifier {
  final CommentService _service = CommentService();

  Stream<List<CommentModel>> getComments(String postId) {
    return _service.getComments(postId);
  }

  Future<void> addComment(CommentModel comment) async {
    await _service.addComment(comment);
    notifyListeners(); 
  }
}
