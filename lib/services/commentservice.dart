import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/model/comment_model.dart';

class CommentService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<CommentModel>> getComments(String postId) {
    return firestore
        .collection('comments')
        .where('postId', isEqualTo: postId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => CommentModel.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  Future<void> addComment(CommentModel comment) async {
    await firestore.collection('comments').add(comment.toJson());
  }
}
