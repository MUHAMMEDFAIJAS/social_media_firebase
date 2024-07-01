

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:gap/gap.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/services/post_servicce.dart';
import 'package:socialmedia/view/widget/user_following.dart';
import 'package:socialmedia/view/widget/user_followerss.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final followService = FollowService();
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<UserModel?>(
        future: followService.getUserData(context, userId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text("Error: ${userSnapshot.error}"));
          }

          if (!userSnapshot.hasData) {
            return const Center(child: Text("User not found"));
          }

          UserModel user = userSnapshot.data!;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: GradientColors.seaBlue,
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Column(
              children: [
                const Gap(30),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Row(
                    children: [
                      Text(
                        user.username?.toUpperCase() ?? '',
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      maxRadius: 40,
                      backgroundImage:
                          user.userimage != null && user.userimage!.isNotEmpty
                              ? NetworkImage(user.userimage!)
                              : null,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => userfollowers(
                            userId: user.userid ?? '',
                          ),
                        ));
                      },
                      child: Column(
                        children: [
                          Text(
                            user.followers.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const Text(
                            "Followers",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => UserFollowing(
                              userId: user.userid ?? '',
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          Text(
                            user.following.toString(),
                            style: const TextStyle(color: Colors.black),
                          ),
                          const Text(
                            "Following",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Gap(20),
                const Text(
                  'Posts',
                  style: TextStyle(fontSize: 28, color: Colors.black),
                ),
                const Gap(10),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: PostimageService().getUserPosts(currentUserId!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        log('StreamBuilder error: ${snapshot.error}');
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        log('No posts found for user: $userId');
                        return const Center(child: Text("No posts found"));
                      } else {
                        log('Posts found for user: $userId, count: ${snapshot.data!.docs.length}');
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot get = snapshot.data!.docs[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              child: Column(
                                children: [
                                  Image.network(get['imageUrl']),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      get['caption'],
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
