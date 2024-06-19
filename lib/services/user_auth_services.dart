// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/model/user_model.dart';
import 'package:socialmedia/view/home_screen.dart';
import 'package:socialmedia/view/login_screen.dart';

class UserAuthServices {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> signupAuth(
    String email,
    String password,
    String username,
    BuildContext context,
  ) async {
    UserCredential credential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    User? user = credential.user;

    if (user != null) {
      UserModel usermodels = UserModel(
        username: username,
        useremail: email,
        userimage: '',
        userid: user.uid,
        followers: 0,
        following: 0,
      );
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(usermodels.tojson());

      log('success');
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => HomeScreen(),
    ));
    return user;
  }

  Future<User?> loginAuth(
      String email, String password, BuildContext context) async {
    UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    if (firebaseAuth.currentUser!.emailVerified) {
      return credential.user;
    } else {
      log('email not verified');
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>const HomeScreen(),
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
