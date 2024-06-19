import 'package:flutter/material.dart';
import 'package:socialmedia/services/user_auth_services.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController usernameController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(usernameController.text.toString()),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: usernameController,
            decoration: InputDecoration(
                hintText: 'name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: 'email',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
                hintText: 'password',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20))),
          ),
          TextButton(
              onPressed: () {
                UserAuthServices().signupAuth(
                  emailController.text,
                  passwordController.text,
                  usernameController.text,
                 context,
                );
              },
              child: const Text('register '))
        ],
      ),
    );
  }
}
