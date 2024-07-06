import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/controller/comment_provider.dart';
import 'package:socialmedia/model/comment_model.dart';
import 'package:socialmedia/services/follow_service.dart';

class CommentPage extends StatelessWidget {
  final String postId;
  CommentPage({Key? key, required this.postId}) : super(key: key);
  final String currentUser = FirebaseAuth.instance.currentUser!.uid;
  final TextEditingController commentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentProvider>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Comments'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<CommentModel>>(
        stream: provider.getComments(postId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Something went wrong: ${snapshot.error}',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No comments",
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: getImageProvider(data.image),
                          ),
                          const Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.username,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data.commenttext,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        formatTimestamp(data.timestamp),
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: commentCtrl,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: () => addComment(context),
              icon: const Icon(Icons.send),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }

  void addComment(BuildContext context) async {
    final provider = Provider.of<CommentProvider>(context, listen: false);
    final username = await FollowService().getUserData(context, currentUser);

    if (username == null) {
      print('Error: User data not found');
      return;
    }

    CommentModel ctModel = CommentModel(
      postid: postId,
      userid: currentUser,
      commenttext: commentCtrl.text,
      timestamp: Timestamp.now(),
      username: username.username ?? "",
      image: username.userimage ?? "",
    );

    commentCtrl.clear();
    await provider.addComment(ctModel);
  }

  String formatTimestamp(Timestamp timestamp) {
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MM-dd - kk:mm').format(dateTime);
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
