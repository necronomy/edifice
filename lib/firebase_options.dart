// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDVoAAcZH27AYtT7oYAcmbiO3rRNfayE3Q',
    appId: '1:543575124755:web:4fd3cc72d52fd7425348e6',
    messagingSenderId: '543575124755',
    projectId: 'necro-mybuilding',
    authDomain: 'necro-mybuilding.firebaseapp.com',
    storageBucket: 'necro-mybuilding.appspot.com',
    measurementId: 'G-55DM8TWVR2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxl-ZY4sKu-K-VNnTfRg515FJpQE7ao5g',
    appId: '1:543575124755:android:0f6a5fec9fd25a325348e6',
    messagingSenderId: '543575124755',
    projectId: 'necro-mybuilding',
    storageBucket: 'necro-mybuilding.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUHOe5968lYWvLNpExdzn7uUANr6q7KKo',
    appId: '1:543575124755:ios:b9adef708eeff80f5348e6',
    messagingSenderId: '543575124755',
    projectId: 'necro-mybuilding',
    storageBucket: 'necro-mybuilding.appspot.com',
    iosBundleId: 'necro.mybuilding',
  );
}