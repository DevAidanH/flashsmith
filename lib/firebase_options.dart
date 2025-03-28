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
    apiKey: 'AIzaSyBXzsEYkJoQ_DkWuy7Tex9uqZ1UbCbA13Y',
    appId: '1:620322343059:web:c382ba64fd15fa37d16566',
    messagingSenderId: '620322343059',
    projectId: 'flashsmith-ad0e4',
    authDomain: 'flashsmith-ad0e4.firebaseapp.com',
    storageBucket: 'flashsmith-ad0e4.firebasestorage.app',
    measurementId: 'G-VN1KGY9TD7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4d9g_AYS82QAAv7B2tkyR3JfpqLbrsnc',
    appId: '1:620322343059:android:958bd30fb6365b1dd16566',
    messagingSenderId: '620322343059',
    projectId: 'flashsmith-ad0e4',
    storageBucket: 'flashsmith-ad0e4.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBR3dXUlA1j9cfnkAhGkUt_Na-OgysEdJI',
    appId: '1:620322343059:ios:a08cfdb968410f97d16566',
    messagingSenderId: '620322343059',
    projectId: 'flashsmith-ad0e4',
    storageBucket: 'flashsmith-ad0e4.firebasestorage.app',
    iosBundleId: 'com.example.flashsmith',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBR3dXUlA1j9cfnkAhGkUt_Na-OgysEdJI',
    appId: '1:620322343059:ios:a08cfdb968410f97d16566',
    messagingSenderId: '620322343059',
    projectId: 'flashsmith-ad0e4',
    storageBucket: 'flashsmith-ad0e4.firebasestorage.app',
    iosBundleId: 'com.example.flashsmith',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBXzsEYkJoQ_DkWuy7Tex9uqZ1UbCbA13Y',
    appId: '1:620322343059:web:d8fd83df1ed3a2fbd16566',
    messagingSenderId: '620322343059',
    projectId: 'flashsmith-ad0e4',
    authDomain: 'flashsmith-ad0e4.firebaseapp.com',
    storageBucket: 'flashsmith-ad0e4.firebasestorage.app',
    measurementId: 'G-ZJL960BGWR',
  );
}
