import 'dart:io';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:socialmedia/model/post_model.dart';
import 'package:image_picker/image_picker.dart';

class PostimageService {
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
      final url = await uploadedImage.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload image $e');
    }
  }

  Future<String?> updateImage(String imageUrl, File updateImage) async {
    try {
      final Reference editImageRef =
          FirebaseStorage.instance.refFromURL(imageUrl);
      await editImageRef.putFile(updateImage);
      final newUrl = await editImageRef.getDownloadURL();
      return newUrl;
    } catch (e) {
      throw Exception('Failed to update image $e');
    }
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      final Reference delete = FirebaseStorage.instance.refFromURL(imageUrl);
      await delete.delete();
    } catch (e) {
      throw Exception('Failed to delete $e');
    }
  }

  Future<void> postdata(PostModel model) async {
    try {
      await postimgref.add(model);
    } catch (e) {
      throw Exception('Failed to add data $e');
    }
  }

  Stream<QuerySnapshot<PostModel>> getAllPosts() {
    return postimgref.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> deletePost(String id) async {
    try {
      await postimgref.doc(id).delete();
    } catch (e) {
      print('Failed to delete data $e');
    }
  }

  Future<void> updatePost(PostModel model, String id) async {
    try {
      await postimgref.doc(id).update(model.tojson());
    } catch (e) {
      print('Failed to update data: ${e.toString()}');
    }
  }

Stream<QuerySnapshot<PostModel>> getUserPosts(String userId) {
  log('Fetching posts for user: $userId');
  return postimgref
      .where('userid', isEqualTo: userId)
      .orderBy('timestamp', descending: true)
      .snapshots()
      .handleError((error) {
        log('Error fetching posts: $error');
      });
}


  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<void> uploadImage(File image, String caption) async {
    final String userId = FirebaseAuth.instance.currentUser!.uid;
    final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('posts')
        .child(userId)
        .child('$fileName.jpg');

    try {
      final UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').add({
        'userid': userId,
        'image': downloadUrl,
        'description': caption,
        'timestamp': FieldValue.serverTimestamp(),
      });

      log('Uploaded successfully');
    } catch (e) {
      log('Failed to upload');
      throw Exception('Failed to upload image $e');
    }
  }
}
