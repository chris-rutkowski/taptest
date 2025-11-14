import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> setupFirebase() async {
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaFakeKeyForLocalEmulatorOnly',
      appId: '1:1234567890:ios:abc123',
      messagingSenderId: '1234567890',
      projectId: 'demo-taptest-firebase-riverpod',
    ),
  );

  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
}
