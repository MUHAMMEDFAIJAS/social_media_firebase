import 'package:flutter/material.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';

class FollowController extends ChangeNotifier {
  FollowService follwserv = FollowService();

  List<UserModel> followers = [];




    Future<List<UserModel>> getuserfollwer(String id) async {
    try {
      followers = await follwserv.getUserFollowers(id);
    } catch (e) {
      print("Error fetching followers: $e");
      followers = [];
    }

    notifyListeners();
    return followers;
  }
     followUserCount(String followUserId) async {
    await follwserv.followUser(followUserId);
    notifyListeners();
  }
   unfollowCount(String unfollowUserId) async {
    await follwserv.unfollowUser(unfollowUserId);
    notifyListeners();
  }
    Future<bool> isFollowing(String userId) async {
    notifyListeners();

    return await follwserv.isFollowing(userId);
  }

   Future<UserModel?> getAlluser(BuildContext context, String userId) async {
    return await follwserv.getUserData(context, userId);
  }
}
