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
    apiKey: 'AIzaSyAksOdXMZ-ZRwUgsyaAP8yM8rIxpDToy5g',
    appId: '1:102843868967:web:41098a68a52d7a10322b02',
    messagingSenderId: '102843868967',
    projectId: 'heybaby-d341f',
    authDomain: 'heybaby-d341f.firebaseapp.com',
    storageBucket: 'heybaby-d341f.appspot.com',
    measurementId: 'G-RN61XNWSVH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGhWR7Wn_SpSlCr3MIdE6FsuoQTkH5rnU',
    appId: '1:102843868967:android:33b53c12148a2bc6322b02',
    messagingSenderId: '102843868967',
    projectId: 'heybaby-d341f',
    storageBucket: 'heybaby-d341f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAwtvSmkcBrfal8tXe_cYEQnL7upmTg94U',
    appId: '1:102843868967:ios:8e50ab3b3436dd35322b02',
    messagingSenderId: '102843868967',
    projectId: 'heybaby-d341f',
    storageBucket: 'heybaby-d341f.appspot.com',
    iosBundleId: 'com.example.heybaby',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAwtvSmkcBrfal8tXe_cYEQnL7upmTg94U',
    appId: '1:102843868967:ios:03a15c3407ee69ba322b02',
    messagingSenderId: '102843868967',
    projectId: 'heybaby-d341f',
    storageBucket: 'heybaby-d341f.appspot.com',
    iosBundleId: 'com.example.heybaby.RunnerTests',
  );
}
