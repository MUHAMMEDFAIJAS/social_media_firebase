import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/controller/follow_controller.dart';
import 'package:socialmedia/controller/homepage_provider.dart';
import 'package:socialmedia/controller/image_controller.dart';
import 'package:socialmedia/controller/user_controller.dart';
import 'package:socialmedia/model/post_model.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/services/post_servicce.dart';
import 'package:socialmedia/services/user_auth_services.dart';
import 'package:socialmedia/view/widget/user_following.dart';
import 'package:socialmedia/view/widget/user_followerss.dart';

class ProfileScreen extends StatelessWidget {
  final String userId;
  const ProfileScreen({super.key, required this.userId});
  @override
  Widget build(BuildContext context) {
    final followService = FollowService();
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    final provider = Provider.of<FollowController>(context, listen: false);
    final pro = Provider.of<UserController>(context, listen: false);
    final imagepro = Provider.of<ImagesProvider>(context, listen: false);
    final homeProvider = Provider.of<HomePageProvider>(context, listen: false);

    return Scaffold(


      
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 101, 50, 109), 
        actions: [
          IconButton(
            onPressed: () {
              UserAuthServices().logoutAuth(context);
            },
            icon:const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<UserModel?>(
        future: provider.userDataGeting(context, userId),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userSnapshot.hasError) {
            return Center(child: Text("Error: ${userSnapshot.error}"));
          }

          if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text("User not found"));
          }

          UserModel user = userSnapshot.data!;

          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 245, 69, 98),
                  Color.fromARGB(255, 141, 34, 241),
                ],
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
                      backgroundColor: Colors.red,
                      maxRadius: 40,
                      backgroundImage: getImageProvider(user.userimage),
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
                  child: StreamBuilder<QuerySnapshot<PostModel>>(
                    stream: pro.fetchPostUser(
                        PostModel(userid: user.userid), user.userid ?? ''),
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
                        final posts = snapshot.data!.docs
                            .map((doc) => doc.data())
                            .toList();
                        List<QueryDocumentSnapshot<PostModel>> postRef =
                            snapshot.data?.docs ?? [];

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.95,
                          ),
                          itemCount: posts.length,
                          itemBuilder: (context, index) {
                            final post = posts[index];
                            final id = postRef[index].id;
                            return Card(
                              shadowColor: Colors.black,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              elevation: 100,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Image.network(
                                      post.image ?? '',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      post.description!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      
                                      PostimageService().deletePost(id);
                                    },
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  )
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
