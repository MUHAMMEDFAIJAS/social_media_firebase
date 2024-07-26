import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/controller/bottom_bar_controller.dart';

class Bottombar extends StatelessWidget {
  const Bottombar({super.key});

  @override
  Widget build(BuildContext context) {
    final pro = Provider.of<BottomBarProvider>(context);
    log('bottom bar');
    return Scaffold(
      body: pro.screens[pro.currentindex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pro.currentindex,
        onTap: (newindex) {
          pro.changevalue(newindex);
        },
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.blue,
        backgroundColor: Colors.red,
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
