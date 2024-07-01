import 'dart:io';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagesProvider extends ChangeNotifier {
  File? pickedImage;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController descriptionCtrl = TextEditingController();
  bool isLoading = false;

  Future<void> pickImg() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> pickImgCam() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      pickedImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> uploadImage() async {
    if (pickedImage == null) return;

    isLoading = true;
    notifyListeners();

    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('posts')
          .child(userId)
          .child('$fileName.jpg');

      UploadTask uploadTask = storageRef.putFile(pickedImage!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('posts').add({
        'userid': userId,
        'imageUrl': downloadUrl,
        'caption': descriptionCtrl.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      pickedImage = null;
      descriptionCtrl.clear();
      isLoading = false;
      notifyListeners();

      log('Uploaded successfully');
    } catch (e) {
      isLoading = false;
      notifyListeners();
      log('Failed to upload: $e');
    }
  }

  void clearPickedImage() {
    pickedImage = null;
    notifyListeners();
  }
}
