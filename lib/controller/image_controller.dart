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

  Future<void> pickImggallery() async {
    var img = await picker.pickImage(source: ImageSource.gallery);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  Future<void> pickImgCam() async {
    var img = await picker.pickImage(source: ImageSource.camera);
    pickedImage = File(img!.path);
    notifyListeners();
  }

  void clearPickedImage() {
    pickedImage = null;
    descriptionCtrl.clear();
    notifyListeners();
  }

  Future<void> addPost(BuildContext context, bool isLiked) async {
    isLoading = true;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser!.uid;
    final userData = await FollowService().getUserData(context, user);

    if (pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image.")),
      );
      isLoading = false;
      notifyListeners();
      return;
    }

    await imgservice.addImage(File(pickedImage!.path));
    String currentTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    PostModel postModel = PostModel(
      username: userData!.username,
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

    isLoading = false;
    notifyListeners();
  }

  Future<void> deletePost(BuildContext context, String postId, String imageUrl) async {
    try {
      isLoading = true;
      notifyListeners();

      

      isLoading = false;
      notifyListeners();
    } catch (e) {
      isLoading = false;
      notifyListeners();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }
  Future DeletePostDis(String id,context)async{
await imgservice.deletePost(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Post deleted successfully.")),
      );
  }
}
