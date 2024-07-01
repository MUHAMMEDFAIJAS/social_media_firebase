import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/services/user_auth_services.dart';
import 'package:socialmedia/view/start_up_widget/signup_screen.dart';
import 'package:socialmedia/view/widget/bottombar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'enter email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)))),
          TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'enter password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)))),
          TextButton(
              onPressed: () {
                login(context);
                // UserAuthServices()
                //     .loginAuth(emailController.text, passwordController.text);

                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => HomeScreen(),
                // ));
              },
              child: const Text('Login')),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('click  here to register'),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignupScreen(),
                    ));
                  },
                  child: const Text(
                    'Sign up',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void login(BuildContext context) async {
    UserAuthServices auth = UserAuthServices();
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await auth.loginAuth(email, password, context);

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Bottombar(),
    ));
  }
}
