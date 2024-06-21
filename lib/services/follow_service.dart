
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/model/user_model.dart';

class FollowService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<List<UserModel>> getUserFollowers(String userId) async {
    try {
      QuerySnapshot snapshot = await firestore
          .collection('followers')
          .doc(userId)
          .collection('userFollowers')
          .get();

      List<String> followerIds = snapshot.docs.map((doc) => doc.id).toList();
      List<UserModel> followers = [];
      for (int i = 0; i < followerIds.length; i++) {
        String id = followerIds[i];
        DocumentSnapshot userDoc =
            await firestore.collection('users').doc(id).get();
        if (userDoc.exists) {
          followers
              .add(UserModel.fromJson(userDoc.data() as Map<String, dynamic>));
        }
      }

      return followers;
    } catch (e) {
      print("Error fetching followers: $e");
      return [];
    }
  }

  Future<void> followUser(String followUserId) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      await firestore
          .collection('followers')
          .doc(currentUserId)
          .collection('userFollowers')
          .doc(followUserId)
          .set({'followed': true});

      await firestore.collection('users').doc(followUserId).update({
        'followers': FieldValue.increment(1),
      });

      await firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.increment(1),
      });
    } catch (e) {}
  }

  Future<void> unfollowUser(String unfollowUserId) async {
    try {
      String currentUserId = _auth.currentUser!.uid;

      await firestore
          .collection('followers')
          .doc(currentUserId)
          .collection('userFollowers')
          .doc(unfollowUserId)
          .delete();

      await firestore.collection('users').doc(unfollowUserId).update({
        'followers': FieldValue.increment(-1),
      });

      await firestore.collection('users').doc(currentUserId).update({
        'following': FieldValue.increment(-1),
      });
    } catch (e) {
      throw Exception('failed to follow $e');
    }
  }

  Future<bool> isFollowing(String userId) async {
    String currentUserId = _auth.currentUser!.uid;
    DocumentSnapshot doc = await firestore
        .collection('followers')
        .doc(currentUserId)
        .collection('userFollowers')
        .doc(userId)
        .get();
    return doc.exists;
  }

  Future<UserModel?> getUserData(BuildContext context, String userId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('users').doc(userId).get();
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception("gett data is error $e");
    }
  }
}
