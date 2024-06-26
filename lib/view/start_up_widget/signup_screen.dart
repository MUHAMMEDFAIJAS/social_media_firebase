// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:socialmedia/services/image_service.dart';
// import 'package:socialmedia/services/user_auth_services.dart';
// import 'package:socialmedia/view/home_screen.dart';
// import 'package:socialmedia/view/start_up_widget/login_screen.dart';

// class SignupScreen extends StatefulWidget {
//   const SignupScreen({super.key});

//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }

// class _SignupScreenState extends State<SignupScreen> {
//   // final ImageService imageService = ImageService();
//      TextEditingController emailController = TextEditingController();
//     TextEditingController passwordController = TextEditingController();
//     TextEditingController usernameController = TextEditingController();

//     File? pickedImage;
//     final ImagePicker imagePicker = ImagePicker();

//     Future<void> pickImage() async {
//       final PickedFile =
//           await imagePicker.pickImage(source: ImageSource.gallery);

//       if (PickedFile != null) {
//         setState(() {
//           pickedImage = File(PickedFile.path);
//         });
//       }
//     }

//     Future<void> signup() async {
//       String email = emailController.text;
//       String password = emailController.text;
//       String username = emailController.text;

//       if (pickedImage == null) {
//         log('no image selected');
//         return;
//       }

//       UserAuthServices authserve = UserAuthServices();

//       String? imageurl = await authserve.signupAuth(
//           email, password, username, pickedImage!, context);
//            if (imageurl != null) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => LoginScreen()),
//       );
//     }
//     }
//   @override
//   Widget build(BuildContext context) {
 

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(usernameController.text.toString()),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//          GestureDetector(
//             onTap: pickImage,
//             child: CircleAvatar(
//               radius: 50,
//               backgroundImage: pickedImage != null ? FileImage(pickedImage!) : null,
//               child: pickedImage == null ? Icon(Icons.camera_alt, size: 40) : null,
//             ),
//           ),
//           TextField(
//             controller: usernameController,
//             decoration: InputDecoration(
//                 hintText: 'name',
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20))),
//           ),
//           TextField(
//             controller: emailController,
//             decoration: InputDecoration(
//                 hintText: 'email',
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20))),
//           ),
//           TextField(
//             controller: passwordController,
//             decoration: InputDecoration(
//                 hintText: 'password',
//                 border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20))),
//           ),
//           TextButton(
//               onPressed: signup,
//               child: const Text('register '))
//         ],
//       ),
//     );
//   }
// }









import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socialmedia/services/user_auth_services.dart';
import 'package:socialmedia/view/start_up_widget/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  File? pickedImage;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> signup() async {
    String email = emailController.text;
    String password = passwordController.text;
    String username = usernameController.text;

    if (pickedImage == null) {
      log('No image selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    UserAuthServices authService = UserAuthServices();

    String? imageUrl = await authService.signupAuth(
        email, password, username, pickedImage!, context);
    if (imageUrl != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) =>  LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage:
                    pickedImage != null ? FileImage(pickedImage!) : null,
                child: pickedImage == null
                    ? const Icon(Icons.camera_alt, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: signup,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
