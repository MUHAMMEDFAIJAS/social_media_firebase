import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/view/home_screen.dart';
import 'package:socialmedia/view/post_screen.dart';
import 'package:socialmedia/view/users_screen.dart';
import 'package:socialmedia/view/profile_screens.dart';

class Bottombar extends StatefulWidget {
  const Bottombar({super.key});

  @override
  State<Bottombar> createState() => _BottombarState();
}

class _BottombarState extends State<Bottombar> {
  int currentindex = 0;

  final List<Widget> screens = [
    const HomeScreen(),
    PostScreen(),
    UsersScreen(),
    ProfileScreen(
      userId: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    log('bottom bar');
    return Scaffold(
      body: screens[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentindex,
        onTap: (newindex) {
          setState(() {
            currentindex = newindex;
          });
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        backgroundColor: Colors.amber,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'post'),
          BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle_sharp), label: 'users'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
