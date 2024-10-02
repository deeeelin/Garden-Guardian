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
    apiKey: 'AIzaSyDGbnxJZ4_vBFn0qoKP5C1tGFad06YUJKs',
    appId: '1:269215038220:web:83fe071399b1237fd22729',
    messagingSenderId: '269215038220',
    projectId: 'finaltest-c212e',
    authDomain: 'finaltest-c212e.firebaseapp.com',
    storageBucket: 'finaltest-c212e.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDOV5nUaZgjiIceLajTSR9xFK7orCCjhus',
    appId: '1:269215038220:android:c375a9f219df42b7d22729',
    messagingSenderId: '269215038220',
    projectId: 'finaltest-c212e',
    storageBucket: 'finaltest-c212e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCSrSyomfnp_Nqppa9Vkz8i5nUiZSj2Hgk',
    appId: '1:269215038220:ios:f61da2fd06940906d22729',
    messagingSenderId: '269215038220',
    projectId: 'finaltest-c212e',
    storageBucket: 'finaltest-c212e.appspot.com',
    androidClientId: '269215038220-rf3for30e3cbjo8skdcnvtuugm7a9l8k.apps.googleusercontent.com',
    iosClientId: '269215038220-2dfr8c48rpjin4vir9jdloc95qkhjo32.apps.googleusercontent.com',
    iosBundleId: 'com.example.finalProject',
  );

}