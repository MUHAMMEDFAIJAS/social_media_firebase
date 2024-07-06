// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Bottombar()),
      );
      return imageurl;
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ));
      return null;
    }
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

//  Future<void> signInWithGoogle() async {
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );

//   await FirebaseAuth.instance.signInWithCredential(credential);
// }
// final GoogleSignIn _googleSignIn = GoogleSignIn();
//  Future<User?> signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         // If the user cancels the sign-in process
//         return null;
//       }

//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       return null;
//     }
//   }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // If the user cancels the sign-in process, googleUser will be null
      if (googleUser == null) {
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);
      User? user = userCredential.user;

      // Check if user is not null
      if (user != null) {
        DocumentReference userDoc = firestore.collection('users').doc(user.uid);
        DocumentSnapshot docSnapshot = await userDoc.get();

        // If the user does not exist in Firestore, create a new user
        if (!docSnapshot.exists) {
          // Create a new user model
          UserModel newUser = UserModel(
            username: googleUser.displayName,
            useremail: user.email,
            userid: user.uid,
            userimage: user.photoURL,
            followers: 0,
            following: 0,
          );

          // Save the user to Firestore
          await userDoc.set(newUser.tojson());
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Bottombar()),
        );

        return userCredential;
      }

      // Print user details to console
      print('User Name: ${googleUser.displayName}');
      // print('User Email: ${user.email}');
      // print('User Photo URL: ${user.photoURL}');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error signing in with Google: $e')),
      );
      print('Error signing in with Google: $e');
      return null;
    }
  }
}
