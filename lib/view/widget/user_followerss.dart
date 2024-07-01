import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/view/profile_screens.dart';

class userfollowers extends StatelessWidget {
  String? userId;
  userfollowers({super.key, this.userId});
  //  follows\\ folloservice = FollowService();
  FollowService folloservice = FollowService();

  @override
  Widget build(BuildContext context) {
    log('userfolowing');
    // final pro = Provider.of<FollowProvider>(context, listen: false);
    String currentuser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.lightBlue,
      body: FutureBuilder<List<UserModel>>(
        future:
        //  pro.getuserfollowers(userId!),
         FollowService().getUserFollowers(userId!),
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('error ${snapshot.hasError}'),
            );
          } else {
            List<UserModel> users = (snapshot.data)!
                .where((user) => user.userid != currentuser)
                .toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userId: data?.userid ?? " ")));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                  // maxRadius: 30,
                                  // backgroundImage: getImageProvider(data.image),
                                  ),
                              const Gap(40),
                              Text(
                                data.username.toString(),
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.black),
                              ),
                            ],
                          ),
                          FutureBuilder<bool>(
                            future:
                                //.................................
                                folloservice
                                    .isFollowing(data.userid.toString()),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              bool isFollowing = snapshot.data!;
                              return ElevatedButton(
                                onPressed: () async {
                                  if (isFollowing) {
                                    await
                                    //  pro.unfollowcount(
                                    //     data.userid.toString());
                                   folloservice. unfollowUser(data.userid.toString());
                                  } else {
                                    await
                                      // pro.followusercount(data.userid.toString());
                                    folloservice
                                        .followUser(data.userid.toString());
                                  }
                                
                                },
                                child: Text(
                                  isFollowing ? 'Unfollow ' : 'Follow',
                                  style: TextStyle(
                                      color: isFollowing
                                          ? Colors.red
                                          : Colors.blue,
                                      fontWeight: FontWeight.bold),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
