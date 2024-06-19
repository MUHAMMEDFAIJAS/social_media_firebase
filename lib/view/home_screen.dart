import 'package:flutter/material.dart';
import 'package:socialmedia/services/user_auth_services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
        actions: [
          IconButton(
              onPressed: () {
                UserAuthServices().logoutAuth(context);
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          Text('userss'),
        ],
      ),
    );
  }
}
