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
    apiKey: 'AIzaSyCNYEkP6SdFiwPpUL54D8lJOJkpoZJ-RsI',
    appId: '1:185602181801:web:cc37cb579fe587f0a237b8',
    messagingSenderId: '185602181801',
    projectId: 'trabajofinal-d36b3',
    authDomain: 'trabajofinal-d36b3.firebaseapp.com',
    storageBucket: 'trabajofinal-d36b3.appspot.com',
    measurementId: 'G-7J7PWG7DD0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAe7HoejOUlEk2r-p3sAH9Oi0wgAgCfS90',
    appId: '1:185602181801:android:29f4d686edf25179a237b8',
    messagingSenderId: '185602181801',
    projectId: 'trabajofinal-d36b3',
    storageBucket: 'trabajofinal-d36b3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDZF2EDACDHLR9LOOmsEvcL0n_ag_CpG2w',
    appId: '1:185602181801:ios:c30ca87db04b3320a237b8',
    messagingSenderId: '185602181801',
    projectId: 'trabajofinal-d36b3',
    storageBucket: 'trabajofinal-d36b3.appspot.com',
    iosBundleId: 'com.example.trabajofinal',
  );
}
