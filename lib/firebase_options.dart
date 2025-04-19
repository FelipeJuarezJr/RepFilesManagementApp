import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'firebase_config.dart';

// Create a .env file in the root of your project and add these values
const String API_KEY = String.fromEnvironment('FIREBASE_API_KEY');
const String AUTH_DOMAIN = String.fromEnvironment('FIREBASE_AUTH_DOMAIN');
const String PROJECT_ID = String.fromEnvironment('FIREBASE_PROJECT_ID');
const String STORAGE_BUCKET = String.fromEnvironment('FIREBASE_STORAGE_BUCKET');
const String MESSAGING_SENDER_ID = String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID');
const String APP_ID = String.fromEnvironment('FIREBASE_APP_ID');
const String MEASUREMENT_ID = String.fromEnvironment('FIREBASE_MEASUREMENT_ID');

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError(
      'DefaultFirebaseOptions are not configured for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: FirebaseConfig.apiKey,
    authDomain: FirebaseConfig.authDomain,
    projectId: FirebaseConfig.projectId,
    storageBucket: FirebaseConfig.storageBucket,
    messagingSenderId: FirebaseConfig.messagingSenderId,
    appId: FirebaseConfig.appId,
    measurementId: FirebaseConfig.measurementId,
  );
} 