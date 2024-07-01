// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:socialmedia/model/user_model.dart';
// import 'package:socialmedia/services/follow_service.dart';
// import 'package:socialmedia/view/profile_screens.dart';

// class UserFollowing extends StatefulWidget {
//   final String userId;
//   UserFollowing({Key? key, required this.userId}) : super(key: key);

//   @override
//   _UserFollowingState createState() => _UserFollowingState();
// }

// class _UserFollowingState extends State<UserFollowing> {
//   FollowService followService = FollowService();
//   late String currentUser;

//   @override
//   void initState() {
//     super.initState();
//     currentUser = FirebaseAuth.instance.currentUser!.uid;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       backgroundColor: Colors.lightBlue,
//       body: FutureBuilder<List<UserModel>>(
//         future: followService.getUserFollowing(widget.userId),
//         builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return const Center(
//               child: Text("Error"),
//             );
//           } else {
//             List<UserModel> users = snapshot.data!
//                 .where((user) => user.userid != currentUser)
//                 .toList();
//             return ListView.builder(
//               itemCount: users.length,
//               itemBuilder: (context, index) {
//                 final data = users[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: InkWell(
//                     onTap: () {
//                       Navigator.of(context).push(MaterialPageRoute(
//                           builder: (context) =>
//                               ProfileScreen(userId: data.userid!)));
//                     },
//                     child: Container(
//                       height: 70,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(20),
//                           color: Colors.white),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Row(
//                             children: [
//                               CircleAvatar(
//                                   // backgroundImage: getImageProvider(data.image),
//                                   ),
//                               const Gap(40),
//                               Text(
//                                 data.username!,
//                                 style: const TextStyle(
//                                     fontSize: 17, color: Colors.black),
//                               ),
//                             ],
//                           ),
//                           FutureBuilder<bool>(
//                             future: followService.isFollowing(data.userid!),
//                             builder: (context, snapshot) {
//                               if (!snapshot.hasData) {
//                                 return const CircularProgressIndicator();
//                               }
//                               bool isFollowing = snapshot.data!;
//                               return ElevatedButton(
//                                 onPressed: () async {
//                                   if (isFollowing) {
//                                     await followService
//                                         .unfollowUser(data.userid!);
//                                   } else {
//                                     await followService
//                                         .followUser(data.userid!);
//                                   }
//                                   setState(() {});
//                                 },
//                                 child: Text(
//                                   isFollowing ? 'Unfollow' : 'Follow',
//                                   style: TextStyle(
//                                       color: isFollowing
//                                           ? Colors.red
//                                           : Colors.blue,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/view/profile_screens.dart';

class UserFollowing extends StatefulWidget {
  final String userId;
  UserFollowing({Key? key, required this.userId}) : super(key: key);

  @override
  _UserFollowingState createState() => _UserFollowingState();
}

class _UserFollowingState extends State<UserFollowing> {
  FollowService followService = FollowService();
  late String currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.lightBlue,
      body: FutureBuilder<List<UserModel>>(
        future: followService.getUserFollowers(widget.userId),
        builder: (context, AsyncSnapshot<List<UserModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else if (snapshot.hasData) {
            List<UserModel> users = snapshot.data!
                .where((user) => user.userid != currentUser)
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
                              ProfileScreen(userId: data.userid.toString())));
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
                            future: followService
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
                                  setState(() {});
                                },
                                child: Text(
                                  isFollowing ? 'Unfollow' : 'Follow',
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
          } else {
            return const Center(
              child: Text("No data found"),
            );
          }
        },
      ),
    );
  }
}
