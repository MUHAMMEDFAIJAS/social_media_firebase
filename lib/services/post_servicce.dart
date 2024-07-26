import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialmedia/model/post_model.dart';

class PostimageService {
  String url = '';
  final String imagename = DateTime.now().microsecondsSinceEpoch.toString();
  final Reference firebasestorage = FirebaseStorage.instance.ref();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  late final CollectionReference<PostModel> postimgref =
      firestore.collection('posts').withConverter<PostModel>(
            fromFirestore: (snapshot, options) =>
                PostModel.fromjson(snapshot.data() ?? {}),
            toFirestore: (post, options) => post.tojson(),
          );

  Future<void> addImage(File image) async {
    final Reference imageFolder = firebasestorage.child("images");
    final Reference uploadedImage = imageFolder.child("$imagename.jpg");
    try {
      await uploadedImage.putFile(image);
      url = await uploadedImage.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<String?> updateImage(String imageUrl, File updateImage) async {
    try {
      final Reference editImageRef =
          FirebaseStorage.instance.refFromURL(imageUrl);
      await editImageRef.putFile(updateImage);
      return await editImageRef.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to update image: $e');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference deleteRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await deleteRef.delete();
    } catch (e) {
      throw Exception('Failed to delete image: $e');
    }
  }



  Future<void> addPost(PostModel model) async {
    await postimgref.add(model);
  }

  Stream<QuerySnapshot<PostModel>> getPost() {
    return postimgref.orderBy("time", descending: true).snapshots();
  }

  Future<void> deletePost(String id) async {
    log('deleted image');
    await postimgref.doc(id).delete();
  }

  Stream<QuerySnapshot<PostModel>> getPostUser(
      PostModel model, String currentUserId) {
    try {
      if (model.userid == currentUserId) {
        return postimgref.where('userid', isEqualTo: currentUserId).snapshots();
      } else {
        return Stream<QuerySnapshot<PostModel>>.empty();
      }
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch user posts: $e');
    }
  }
}
