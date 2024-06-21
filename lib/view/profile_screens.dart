import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/view/widget/user_profile.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final followService = FollowService();

    return SafeArea(
      child: Scaffold(
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

            return Column(
              children: [
                const Gap(30),
                Padding(
                  padding: const EdgeInsets.only(left: 45),
                  child: Row(
                    children: [
                      Text(
                        user.username.toString().toUpperCase() ?? "No Username",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.blue,
                      // maxRadius: 40,
                      // backgroundImage: getImageProvider(user.image),
                    ),
                    Column(
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
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserFollowersPage(
                            userId: user.userid!,
                          ),
                        ));
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
                FutureBuilder<bool>(
                  future: followService.isFollowing(userId),
                  builder: (context, followSnapshot) {
                    if (followSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }

                    if (followSnapshot.hasError) {
                      return Text("Error: ${followSnapshot.error}");
                    }

                    bool isFollowing = followSnapshot.data ?? false;

                    return ElevatedButton(
                      onPressed: () async {
                        if (isFollowing) {
                          await followService.unfollowUser(userId);
                        } else {
                          await followService.followUser(userId);
                        }
                        // Refresh the state to update the button text
                        (context as Element).reassemble();
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isFollowing ? Colors.red : Colors.blue,
                        elevation: 7,
                        fixedSize: Size.fromWidth(width),
                      ),
                      child: Text(isFollowing ? 'Unfollow' : 'Follow'),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
