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
/// 
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
    apiKey: 'AIzaSyCiP3cSS3RjjFPNoS9Kfc7tBn64iE1TatQ',
    appId: '1:318133730107:web:dbe7167919edd253ecd51e',
    messagingSenderId: '318133730107',
    projectId: 'banco-f9b51',
    authDomain: 'banco-f9b51.firebaseapp.com',
    storageBucket: 'banco-f9b51.appspot.com',
    measurementId: 'G-PFDTFJSJWN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA6hAGhnHIOGGyo8MVotrbd9zi89eJjieE',
    appId: '1:318133730107:android:325e8b3ab7599259ecd51e',
    messagingSenderId: '318133730107',
    projectId: 'banco-f9b51',
    storageBucket: 'banco-f9b51.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByMd49CzWIvcb3yvG0uX3wQKBY_d7frgE',
    appId: '1:318133730107:ios:97b756bec9af76d1ecd51e',
    messagingSenderId: '318133730107',
    projectId: 'banco-f9b51',
    storageBucket: 'banco-f9b51.appspot.com',
    iosBundleId: 'com.example.cesarpay',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByMd49CzWIvcb3yvG0uX3wQKBY_d7frgE',
    appId: '1:318133730107:ios:97b756bec9af76d1ecd51e',
    messagingSenderId: '318133730107',
    projectId: 'banco-f9b51',
    storageBucket: 'banco-f9b51.appspot.com',
    iosBundleId: 'com.example.cesarpay',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCiP3cSS3RjjFPNoS9Kfc7tBn64iE1TatQ',
    appId: '1:318133730107:web:4b544444f85c98eaecd51e',
    messagingSenderId: '318133730107',
    projectId: 'banco-f9b51',
    authDomain: 'banco-f9b51.firebaseapp.com',
    storageBucket: 'banco-f9b51.appspot.com',
    measurementId: 'G-S81LPPCS2M',
  );
}
