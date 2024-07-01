import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/model/user_model.dart';

class UserService {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection("users");

  Stream<List<UserModel>> getUser() {
    return firestore.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
