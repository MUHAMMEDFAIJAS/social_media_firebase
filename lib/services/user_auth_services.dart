// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/services/image_service.dart';
import 'package:socialmedia/view/start_up_widget/login_screen.dart';
import 'package:socialmedia/view/widget/bottombar.dart';

class UserAuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> signupAuth(
    String email,
    String password,
    String username,
    File image,
    BuildContext context,
  ) async {
    UserCredential credential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = credential.user;

    if (user != null) {
      ImageService imgService = ImageService();
      String imageurl = await imgService.useraddimage(image);

      UserModel usermodels = UserModel(
        username: username,
        useremail: email,
        userimage: imageurl,
        userid: user.uid,
        followers: 0,
        following: 0,
      );
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(usermodels.tojson());

      log('signup success');
      return imageurl;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
    return null;
  }

  Future<User?> loginAuth(
      String email, String password, BuildContext context) async {
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (firebaseAuth.currentUser!.emailVerified) {
      return credential.user;
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const Bottombar(),
    ));
  }

  Future<void> logoutAuth(BuildContext context) async {
    await firebaseAuth.signOut();
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => LoginScreen(),
    ));
    log('loged out');
  }
}
