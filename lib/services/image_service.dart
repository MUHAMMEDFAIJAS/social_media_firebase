import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  FirebaseAuth auth = FirebaseAuth.instance;

  String imagename = DateTime.now().microsecondsSinceEpoch.toString();
  String imageurl = '';
  Reference firebasestorage = FirebaseStorage.instance.ref();

  //   image functions

  File? pickedImage;
  ImagePicker imagepckr = ImagePicker();

  Future<String> useraddimage(File image) async {
    Reference imagefolder = firebasestorage.child('images');
    Reference uploadimage = imagefolder.child("$imagename.jpg");

    try {
      await uploadimage.putFile(image);
      String imageurl = await uploadimage.getDownloadURL();
      return imageurl;
    } catch (e) {
      throw Exception('failed to upload image');
    }
  }
}
