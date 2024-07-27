import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/controller/follow_controller.dart';
import 'package:socialmedia/controller/user_controller.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/view/profile_screens.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentuser = FirebaseAuth.instance.currentUser?.uid ?? "";
    final followService = FollowService();
    final provider = Provider.of<FollowController>(context, listen: false);
    final pro = Provider.of<UserController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
        backgroundColor: const Color.fromARGB(255, 101, 50, 109), 
      ),
      body: Container(
       
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 245, 69, 98),
              Color.fromARGB(255, 141, 34, 241)
            ],
          ),
        ),
        child: StreamBuilder<List<UserModel>>(
          stream: pro.getUsers(),
          builder: (context, snapshot) {
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

              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final data = users[index];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(userId: data.userid!),
                        ));
                      },
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            const BoxShadow(
                              color: Colors.black26,
                              blurRadius: 5,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    maxRadius: 30,
                                    backgroundImage:
                                        getImageProvider(data.userimage),
                                  ),
                                ),
                                const Gap(20),
                                Text(
                                  data.username.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            FutureBuilder<bool>(
                              future: followService
                                  .isFollowing(data.userid.toString()),
                              builder: (context, followSnapshot) {
                                if (!followSnapshot.hasData) {
                                  return const CircularProgressIndicator();
                                }

                                bool isFollowing = followSnapshot.data!;

                                return InkWell(
                                  onTap: () async {
                                    if (isFollowing) {
                                      await provider.unfollowCount(
                                          data.userid.toString());
                                    } else {
                                      await provider.followUserCount(
                                          data.userid.toString());
                                    }
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: isFollowing
                                          ? Colors.red
                                          : Colors.blue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        isFollowing ? 'Unfollow' : 'Follow',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
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
      ),
    );
  }

  ImageProvider getImageProvider(String? imageUrl) {
    if (imageUrl != null &&
        imageUrl.isNotEmpty &&
        Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
      return NetworkImage(imageUrl);
    } else {
      return const AssetImage('assets/images/1077114.png');
    }
  }
}
