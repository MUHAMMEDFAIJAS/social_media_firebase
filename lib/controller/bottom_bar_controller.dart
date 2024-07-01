import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/view/home_screen.dart';
import 'package:socialmedia/view/post_screen.dart';
import 'package:socialmedia/view/profile_screens.dart';
import 'package:socialmedia/view/users_screen.dart';

class BottomBarProvider extends ChangeNotifier {
  int currentindex = 0;

  final List screens = [
    const HomeScreen(),
    PostScreen(),
    UsersScreen(),
    ProfileScreen(
      userId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  changevalue(newindex) {
    currentindex = newindex;
    notifyListeners();
  }
}
