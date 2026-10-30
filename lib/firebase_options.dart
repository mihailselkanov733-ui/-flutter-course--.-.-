// Generated manually from `firebase apps:sdkconfig` (аналог файла от flutterfire configure)
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
        // Симуляция веб-конфигурации для запуска под Windows (мобильных и web-платформ)
        return web;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAHr-f2rnJFA_xd3ADfcmv0tcyiCu5umIM',
    appId: '1:971490196624:android:b4d4befcc5ed635700ec15',
    messagingSenderId: '971490196624',
    projectId: 'catalog-43973',
    storageBucket: 'catalog-43973.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAxsvDsLt82YVtQ62oyEdGTSFVdobt6coo',
    appId: '1:971490196624:web:8b801572c7d9f91700ec15',
    messagingSenderId: '971490196624',
    projectId: 'catalog-43973',
    authDomain: 'catalog-43973.firebaseapp.com',
    storageBucket: 'catalog-43973.firebasestorage.app',
    measurementId: 'G-D478SL6JCX',
  );
}
