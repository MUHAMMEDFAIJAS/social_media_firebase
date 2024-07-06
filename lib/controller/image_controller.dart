import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:socialmedia/model/post_model.dart';
import 'package:socialmedia/services/follow_service.dart';
import 'package:socialmedia/services/post_servicce.dart';
import 'package:socialmedia/view/widget/bottombar.dart';

class ImagesProvider extends ChangeNotifier {
  final TextEditingController descriptionCtrl = TextEditingController();
  PostimageService imgservice = PostimageService();

  File? pickedImage;

  bool isLoading = false;

  ImagePicker picker = ImagePicker();

  Future<void> pickImage({required ImageSource source}) async {
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  void clearPickedImage() {
    pickedImage = null;
    descriptionCtrl.clear();
    notifyListeners();
  }

  Future<void> addPost(BuildContext context, bool isLiked) async {
    if (pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      return;
    }

    isLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser!.uid;
    final userData = await FollowService().getUserData(context, user);

    if (userData != null) {
      await imgservice.addImage(File(pickedImage!.path));
      String currentTime =
          DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      PostModel postModel = PostModel(
        username: userData.username,
        userImage: userData.userimage,
        image: imgservice.url,
        description: descriptionCtrl.text,
        userid: user,
        isLiked: isLiked,
        time: currentTime,
      );

      await imgservice.addPost(postModel);
      clearPickedImage();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const Bottombar(),
        ),
        (route) => false,
      );
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deletepost(BuildContext context, String postId, String imageUrl,
      String description) async {
    try {
      isLoading = true;
      notifyListeners();

      await imgservice.deletePost(postId);
      await imgservice.deleteImage(imageUrl);
      await imgservice.deletedescription(description);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post deleted successfully.")),
      );
      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('failed to delete post: $e')),
      );
    }
    notifyListeners();
  }
}
