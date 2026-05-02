// This is a template for firebase_options.dart
// You should generate this file using: flutterfire configure
// To avoid compilation errors, I've created this placeholder.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // PLACEHOLDERS - Replace with your actual values or run 'flutterfire configure'
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA3CZvwFjp8F6YfDT81ThgM_MMlAgJ7GrM',
    appId: '1:1060101380830:web:d2e92e6e4d6fc6ff48c04f',
    messagingSenderId: '1060101380830',
    projectId: 'rappi-carlos',
    authDomain: 'rappi-carlos.firebaseapp.com',
    storageBucket: 'rappi-carlos.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA3CZvwFjp8F6YfDT81ThgM_MMlAgJ7GrM',
    appId: '1:1060101380830:android:07203e9217c8718848c04f',
    messagingSenderId: '1060101380830',
    projectId: 'rappi-carlos',
    storageBucket: 'rappi-carlos.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA3CZvwFjp8F6YfDT81ThgM_MMlAgJ7GrM',
    appId: '1:1060101380830:web:d2e92e6e4d6fc6ff48c04f',
    messagingSenderId: '1060101380830',
    projectId: 'rappi-carlos',
    authDomain: 'rappi-carlos.firebaseapp.com',
    storageBucket: 'rappi-carlos.appspot.com',
  );
}
