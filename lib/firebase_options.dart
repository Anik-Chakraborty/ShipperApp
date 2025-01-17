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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
      apiKey: "AIzaSyBCsvWBlCbKF4x-wrEPtpnHao6E7PbABTQ",
      authDomain: "shipperprod.firebaseapp.com",
      databaseURL: "https://shipperprod-default-rtdb.firebaseio.com",
      projectId: "shipperprod",
      storageBucket: "shipperprod.appspot.com",
      messagingSenderId: "747833665493",
      appId: "1:747833665493:web:676cf9a80e410a3fe37f5c",
      measurementId: "G-BFRY06DBFK");

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBCsvWBlCbKF4x-wrEPtpnHao6E7PbABTQ',
    appId: '1:747833665493:android:1e94d85143356ef3e37f5c',
    messagingSenderId: '747833665493',
    projectId: 'shipperprod',
    databaseURL: 'https://shipperprod-default-rtdb.firebaseio.com',
    storageBucket: 'shipperprod.appspot.com',
  );
}
