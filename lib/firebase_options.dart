// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCUwh3a78qHpYhJRASVDQVZ1RFn4rOLbjA',
    appId: '1:1024151867643:web:f4aff3bf22475e304aa05e',
    messagingSenderId: '1024151867643',
    projectId: 'socialmedia-e35c9',
    authDomain: 'socialmedia-e35c9.firebaseapp.com',
    storageBucket: 'socialmedia-e35c9.appspot.com',
    measurementId: 'G-RDH28DQZW2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC-zXGjqh3nDa-zO1lchvM7SM-QsRJanNA',
    appId: '1:1024151867643:android:4cd891ce8bf8a7514aa05e',
    messagingSenderId: '1024151867643',
    projectId: 'socialmedia-e35c9',
    storageBucket: 'socialmedia-e35c9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCznCWpYH8mLlfO6546e-zSlLe3yRv6eQk',
    appId: '1:1024151867643:ios:d75105d34d5a6c284aa05e',
    messagingSenderId: '1024151867643',
    projectId: 'socialmedia-e35c9',
    storageBucket: 'socialmedia-e35c9.appspot.com',
    iosBundleId: 'com.example.socialmedia',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCznCWpYH8mLlfO6546e-zSlLe3yRv6eQk',
    appId: '1:1024151867643:ios:d75105d34d5a6c284aa05e',
    messagingSenderId: '1024151867643',
    projectId: 'socialmedia-e35c9',
    storageBucket: 'socialmedia-e35c9.appspot.com',
    iosBundleId: 'com.example.socialmedia',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCUwh3a78qHpYhJRASVDQVZ1RFn4rOLbjA',
    appId: '1:1024151867643:web:b665d4c64da3a8b94aa05e',
    messagingSenderId: '1024151867643',
    projectId: 'socialmedia-e35c9',
    authDomain: 'socialmedia-e35c9.firebaseapp.com',
    storageBucket: 'socialmedia-e35c9.appspot.com',
    measurementId: 'G-JR1F9LPFYM',
  );
}