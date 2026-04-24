import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
    appId: '1:123456789012:android:abcdefghijklmnopqrst',
    messagingSenderId: '123456789012',
    projectId: 'linguify-prod',
    storageBucket: 'linguify-prod.appspot.com',
  );
}
