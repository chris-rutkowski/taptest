import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/setup_firebase.dart';
import 'demo_app.dart';

// Start the Firebase emulator before running the app:
// firebase emulators:start

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupFirebase();

  runApp(
    ProviderScope(
      child: const DemoApp(),
    ),
  );
}
