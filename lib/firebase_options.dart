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
        return macos;
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
    apiKey: 'AIzaSyCMc_Cc4VucZqjqMWMjgmneX12Ad5bQxbw',
    appId: '1:468451852925:web:0de497e8896fcf90272714',
    messagingSenderId: '468451852925',
    projectId: 'care-utility',
    authDomain: 'care-utility.firebaseapp.com',
    storageBucket: 'care-utility.appspot.com',
    measurementId: 'G-0BY9CYV5BM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBuPvAeVbt4etvpX73eLR-05vhEFTgidCI',
    appId: '1:468451852925:android:231c0ee739aa977d272714',
    messagingSenderId: '468451852925',
    projectId: 'care-utility',
    storageBucket: 'care-utility.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDaOe-x6-V35BJAzhrmEcErJEiiG_W-318',
    appId: '1:468451852925:ios:7f2ae31080f1a9fd272714',
    messagingSenderId: '468451852925',
    projectId: 'care-utility',
    storageBucket: 'care-utility.appspot.com',
    iosBundleId: 'com.example.careUtility',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDaOe-x6-V35BJAzhrmEcErJEiiG_W-318',
    appId: '1:468451852925:ios:97df40e9db922602272714',
    messagingSenderId: '468451852925',
    projectId: 'care-utility',
    storageBucket: 'care-utility.appspot.com',
    iosBundleId: 'com.example.careUtility.RunnerTests',
  );
}