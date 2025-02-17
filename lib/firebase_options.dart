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
    apiKey: '',
    appId: '1:404395786341:web:4807e294fa3cd9741b468c',
    messagingSenderId: '404395786341',
    projectId: 'babylon-radio-leticia',
    authDomain: 'babylon-radio-leticia.firebaseapp.com',
    storageBucket: 'babylon-radio-leticia.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: '',
    appId: '1:404395786341:android:949c9c7eb8f51a641b468c',
    messagingSenderId: '404395786341',
    projectId: 'babylon-radio-leticia',
    storageBucket: 'babylon-radio-leticia.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: '',
    appId: '1:404395786341:ios:a6710a727118ccd71b468c',
    messagingSenderId: '404395786341',
    projectId: 'babylon-radio-leticia',
    storageBucket: 'babylon-radio-leticia.firebasestorage.app',
    iosBundleId: 'com.example.babylonRadioAssignment',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: '',
    appId: '1:404395786341:ios:a6710a727118ccd71b468c',
    messagingSenderId: '404395786341',
    projectId: 'babylon-radio-leticia',
    storageBucket: 'babylon-radio-leticia.firebasestorage.app',
    iosBundleId: 'com.example.babylonRadioAssignment',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: '',
    appId: '1:404395786341:web:c426474b05938c531b468c',
    messagingSenderId: '404395786341',
    projectId: 'babylon-radio-leticia',
    authDomain: 'babylon-radio-leticia.firebaseapp.com',
    storageBucket: 'babylon-radio-leticia.firebasestorage.app',
  );
}
