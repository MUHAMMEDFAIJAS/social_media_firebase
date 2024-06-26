import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/view/profile_screens.dart';

class UsersScreen extends StatelessWidget {
  final String? userId;

  UsersScreen({Key? key, this.userId}) : super(key: key);

  final FollowService followService = FollowService();

  final currentuser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    log('reels screen');
    return Scaffold(
      body: StreamBuilder<List<UserModel>>(
        stream: followService.getusers(),
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No users found.'),
            );
          } else {
            List<UserModel> users = snapshot.data!
                .where((user) => user.userid != currentuser)
                .toList();

            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: GradientColors.seaBlue,
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight)),
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final data = users[index];

                  return Padding(
                    padding: EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            userId: data.userid!,
                          ),
                        ));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                maxRadius: 30,
                                backgroundImage: data.userimage != null &&
                                        data.userimage!.isNotEmpty
                                    ? NetworkImage(data.userimage!)
                                    : null,
                              ),
                              SizedBox(width: 8),
                              Text(
                                data.username.toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          FutureBuilder<bool>(
                            future: followService.isFollowing(data.userid!),
                            builder: (context, followSnapshot) {
                              if (followSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (followSnapshot.hasError) {
                                return Text('Error');
                              }

                              bool isFollowing = followSnapshot.data ?? false;

                              return ElevatedButton(
                                onPressed: () async {
                                  if (isFollowing) {
                                    await followService
                                        .unfollowUser(data.userid!);
                                  } else {
                                    await followService
                                        .followUser(data.userid!);
                                  }
                                },
                                child:
                                    Text(isFollowing ? 'Unfollow' : 'Follow'),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
