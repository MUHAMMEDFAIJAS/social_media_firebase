import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/controller/homepage_provider.dart';
import 'package:socialmedia/model/post_model.dart';
import 'package:socialmedia/services/post_servicce.dart';
import 'package:socialmedia/services/user_auth_services.dart';
import 'package:socialmedia/view/comment_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomePageProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 101, 50, 109), // Deep violet color
        automaticallyImplyLeading: false,
        title: const Text('Home Screen'),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       UserAuthServices().logoutAuth(context);
        //     },
        //     icon: Icon(Icons.logout),
        //   ),
        // ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 245, 69, 98),
              Color.fromARGB(255, 141, 34, 241)
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<PostModel>>(
                stream: provider.getPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No posts found'));
                  } else {
                    List<QueryDocumentSnapshot<PostModel>> postRef =
                        snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: postRef.length,
                      itemBuilder: (context, index) {
                        final data = postRef[index].data();
                        final postId = postRef[index].id;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 206, 133, 190),
                            borderRadius: BorderRadius.circular(15),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.1),
                            //     blurRadius: 10,
                            //     spreadRadius: 5,
                            //   ),
                            // ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(data.image!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Consumer<HomePageProvider>(
                                        builder: (context, homecontrl, _) {
                                      final isliked =
                                          homecontrl.isLiked(postId);

                                      final likecount =
                                          homecontrl.likeCount(postId);
                                      return Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                homecontrl.toggleLike(postId);
                                              },
                                              icon: Icon(
                                                isliked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: isliked
                                                    ? Colors.red
                                                    : Colors.black,
                                              )),
                                          Text('$likecount likes'),
                                          IconButton(
                                              onPressed: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return CommentPage(
                                                        postId: postId);
                                                  },
                                                );
                                              },
                                              icon: Icon(Icons.comment))
                                        ],
                                      );
                                    }),
                                    Text(
                                      data.description!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
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
      ),
    );
  }
}
