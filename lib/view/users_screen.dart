// import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
// import 'package:provider/provider.dart';
// import 'package:socialmedia/controller/follow_controller.dart';
// import 'package:socialmedia/controller/user_controller.dart';
// import 'package:socialmedia/model/user_model.dart';
// import 'package:socialmedia/services/follow_service.dart';
// import 'package:socialmedia/services/user_service.dart';
// import 'package:socialmedia/view/profile_screens.dart';

// class UsersScreen extends StatelessWidget {
//   final String? userId;

//   UsersScreen({Key? key, this.userId}) : super(key: key);

//   final currentuser = FirebaseAuth.instance.currentUser!.uid;
//   final FollowService followService = FollowService();

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<FollowController>(context, listen: false);
//     final pro = Provider.of<UserController>(context, listen: false);
//     log('reels screen');
//     return Scaffold(
//       body: StreamBuilder<List<UserModel>>(
//         stream: pro.getUsers(),
//         //  followService.getusers(),
//         builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(
//               child: Text('No users found.'),
//             );
//           } else {
//             List<UserModel> users = snapshot.data!
//                 .where((user) => user.userid != currentuser)
//                 .toList();

//             return Container(
//               decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                       colors: GradientColors.seaBlue,
//                       begin: Alignment.topLeft,
//                       end: Alignment.centerRight)),
//               child: ListView.builder(
//                 itemCount: users.length,
//                 itemBuilder: (context, index) {
//                   final data = users[index];

//                   return Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) => ProfileScreen(
//                             userId: data.userid!,
//                           ),
//                         ));
//                       },
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                 maxRadius: 30,
//                                 backgroundImage:
//                                     getImageProvider(data.userimage),
//                                 //  data.userimage != null &&
//                                 //         data.userimage!.isNotEmpty
//                                 //     ? NetworkImage(data.userimage!)
//                                 //     : null,
//                               ),
//                               SizedBox(width: 8),
//                               Text(
//                                 data.username.toString(),
//                                 style: TextStyle(fontSize: 18),
//                               ),
//                             ],
//                           ),
//                           FutureBuilder<bool>(
//                             future: followService.isFollowing(data.userid!),
//                             builder: (context, followSnapshot) {
//                               if (followSnapshot.connectionState ==
//                                   ConnectionState.waiting) {
//                                 return CircularProgressIndicator();
//                               } else if (followSnapshot.hasError) {
//                                 return Text('Error');
//                               }

//                               bool isFollowing = followSnapshot.data!;

//                               return ElevatedButton(
//                                 onPressed: () async {
//                                   // if (isFollowing) {
//                                   //   await followService
//                                   //       .unfollowUser(data.userid!);
//                                   // } else {
//                                   //   await followService
//                                   //       .followUser(data.userid!);
//                                   // }

//                                   if (isFollowing) {
//                                     await provider
//                                         .unfollowCount(data.userid.toString());
//                                   } else {
//                                     await provider.followUserCount(
//                                         data.userid.toString());
//                                   }
//                                 },
//                                 child:
//                                     Text(isFollowing ? 'Unfollow' : 'Follow'),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// ImageProvider getImageProvider(String? imageUrl) {
//   if (imageUrl != null &&
//       imageUrl.isNotEmpty &&
//       Uri.tryParse(imageUrl)?.hasAbsolutePath == true) {
//     return NetworkImage(imageUrl);
//   } else {
//     return const AssetImage('assets/images/1077114.png');
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
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
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GradientColors.seaBlue,
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: StreamBuilder<List<UserModel>>(
          stream: pro.getUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
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
                            BoxShadow(
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
                                  return CircularProgressIndicator();
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
                                        style: TextStyle(
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
