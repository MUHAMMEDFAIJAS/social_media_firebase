import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socialmedia/controller/image_controller.dart';
import 'package:flutter_gradient_colors/flutter_gradient_colors.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ImagesProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Post Create'),
        actions: [
          IconButton(
            onPressed: () {
              provider.clearPickedImage();
            },
            icon: const Icon(Icons.clear),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: GradientColors.seaBlue,
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Consumer<ImagesProvider>(builder: (context, provider, _) {
                return FutureBuilder<File?>(
                  future: Future.value(provider.pickedImage),
                  builder: (context, snapshot) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color.fromARGB(255, 62, 60, 60),
                          width: 1,
                        ),
                        image: snapshot.data != null
                            ? DecorationImage(
                                image: FileImage(snapshot.data!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: snapshot.data == null
                          ? Center(
                              child: Text(
                                "No image selected",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : null,
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              Text(
                "Pick image",
                style: TextStyle(color: Colors.white),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      provider.pickImg();
                    },
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      provider.pickImgCam();
                    },
                    icon: const Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: provider.descriptionCtrl,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: "Description",
                  labelStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await provider.uploadImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 19, 30, 55),
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: provider.isLoading
                    ? CircularProgressIndicator()
                    : Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
