import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/view/profile_screens.dart';

class UserFollowersPage extends StatelessWidget {
  String? userId;
  UserFollowersPage({super.key, this.userId});
  FollowService followService = FollowService();
  @override
  Widget build(BuildContext context) {
    // final provider =
    //     Provider.of<FollowServiceController>(context, listen: false);

    final currentuser = FirebaseAuth.instance.currentUser!.uid;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 40, 40),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 45, 40, 40),
      ),
      body: FutureBuilder<List<UserModel>>(
        future: FollowService().getUserFollowers(userId!),
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("error"),
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
                            ProfileScreen(userId: data.userid ?? ""),
                      ));
                    },
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromARGB(255, 34, 30, 27)),
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
                                    fontSize: 17, color: Colors.white),
                              ),
                            ],
                          ),
                          FutureBuilder<bool>(
                            future:
                                //.................................
                                followService
                                    .isFollowing(data.userid.toString()),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }
                              bool isFollowing = snapshot.data!;
                              return ElevatedButton(
                                onPressed: () async {
                                  if (isFollowing) {
                                    await followService
                                        .unfollowUser(data.userid.toString());
                                  } else {
                                    await followService
                                        .followUser(data.userid.toString());
                                  }
                                  // // Refresh the state to update the button text
                                  // (context as Element).reassemble();
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

  // ImageProvider getImageProvider(String? imageUrl) {
  //   if (imageUrl != null &&
  //       imageUrl.isNotEmpty &&
  //       Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
  //     return NetworkImage(imageUrl);
  //   } else {
  //     return const AssetImage('assets/images/1077114.png');
  //   }
  // }
}
