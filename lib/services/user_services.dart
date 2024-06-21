import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socialmedia/model/user_model.dart';

class UserServices {
  CollectionReference firestore =
      FirebaseFirestore.instance.collection('users');

  Stream<List<UserModel>> getusers() {
   return firestore.snapshots().map((snapshot) => snapshot.docs
        .map((docs) => UserModel.fromJson(docs.data() as Map<String, dynamic>))
        .toList());
  }
}
