import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Firebase config for the `legacy-table-push` project — used ONLY for FCM
/// push delivery (no Firestore/Auth/Analytics). Values transcribed from the
/// console-generated google-services.json / GoogleService-Info.plist; these
/// are publishable client identifiers, same class as the PostHog token.
///
/// Hand-written instead of `flutterfire configure` output so the iOS build
/// needs no GoogleService-Info.plist in the Xcode project and Android needs
/// no google-services Gradle plugin.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (Platform.isIOS) return ios;
    return android;
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD1_GOpT2hPdUcawQncxgfJzjDNiBH9nZs',
    appId: '1:866238416793:android:74f5e81db7fabc4252b508',
    messagingSenderId: '866238416793',
    projectId: 'legacy-table-push',
    storageBucket: 'legacy-table-push.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBhQvXu1h4Q5Yr6lDKsUUgDE6RrmfogPok',
    appId: '1:866238416793:ios:6cda74d299fcda6352b508',
    messagingSenderId: '866238416793',
    projectId: 'legacy-table-push',
    storageBucket: 'legacy-table-push.firebasestorage.app',
    iosBundleId: 'com.htrecipes.familyRecipeApp',
  );
}
